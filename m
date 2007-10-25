Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXJYNWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:38 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fS-0000d2-9b
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:35 +0100
Message-Id: <20071025093716.172679000@sipsolutions.net> (sfid-20071025_142249_031878_572BB839)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 5/9] mac80211: add beacon configuration via cfg80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements the cfg80211 hooks for configuring beaconing
on an access point interface in mac80211. While doing so, it fixes
a number of races that could badly crash the machine when the
beacon is changed while being requested by the driver.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
The dtim_count field should possibly also be part of the beacon
structure, but the possible race there doesn't really matter,
worst thing is that one beacon will be sent with a wrong dtim
count if (and only if) userspace changes the dtim period during
operation.

 net/mac80211/cfg.c             |  108 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c  |   27 ----------
 net/mac80211/ieee80211_i.h     |   14 +++--
 net/mac80211/ieee80211_iface.c |    4 -
 net/mac80211/tx.c              |   63 ++++++++++++++---------
 5 files changed, 156 insertions(+), 60 deletions(-)

--- linux-2.6.orig/net/mac80211/cfg.c	2007-10-24 11:35:49.722690568 +0200
+++ linux-2.6/net/mac80211/cfg.c	2007-10-25 10:46:56.070256998 +0200
@@ -10,6 +10,7 @@
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
 #include <net/net_namespace.h>
+#include <linux/rcupdate.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "cfg.h"
@@ -269,6 +270,112 @@ static int ieee80211_config_default_key(
 	return 0;
 }
 
+static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
+				struct beacon_parameters *beacon)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct beacon_data *new, *old;
+	int new_head_len, new_tail_len;
+	int size;
+	int err = -EINVAL;
+
+	if (sdata->type != IEEE80211_IF_TYPE_AP)
+		return -EINVAL;
+
+	old = sdata->u.ap.beacon;
+
+	/* catch disabling beacons early */
+	if (!beacon) {
+		new = NULL;
+		goto done;
+	}
+
+	/* head must be set */
+	if (beacon->head && !beacon->head_len)
+		return -EINVAL;
+
+	/*
+	 * This is a kludge. beacon interval should really be part
+	 * of the beacon information.
+	 */
+	if (beacon->interval) {
+		sdata->local->hw.conf.beacon_int = beacon->interval;
+		if (ieee80211_hw_config(sdata->local))
+			return -EINVAL;
+		/*
+		 * We updated some parameter so if below bails out
+		 * it's not an error.
+		 */
+		err = 0;
+	}
+
+	/* Need to have a beacon head if we don't have one yet */
+	if (!beacon->head && !old)
+		return err;
+
+	/* sorry, no way to start beaconing without dtim period */
+	if (!beacon->dtim_period && !old)
+		return err;
+
+	/* new or old head? */
+	if (beacon->head)
+		new_head_len = beacon->head_len;
+	else
+		new_head_len = old->head_len;
+
+	/* new or old tail? */
+	if (beacon->tail || !old)
+		/* beacon->tail_len will be zero for !beacon->tail */
+		new_tail_len = beacon->tail_len;
+	else
+		new_tail_len = old->tail_len;
+
+	size = sizeof(*new) + new_head_len + new_tail_len;
+
+	new = kzalloc(size, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	/* start filling the new info now */
+
+	/* new or old dtim period? */
+	if (beacon->dtim_period)
+		new->dtim_period = beacon->dtim_period;
+	else
+		new->dtim_period = old->dtim_period;
+
+	/*
+	 * pointers go into the block we allocated,
+	 * memory is | beacon_data | head | tail |
+	 */
+	new->head = ((u8 *) new) + sizeof(*new);
+	new->tail = new->head + new_head_len;
+	new->head_len = new_head_len;
+	new->tail_len = new_tail_len;
+
+	/* copy in head */
+	if (beacon->head)
+		memcpy(new->head, beacon->head, new_head_len);
+	else
+		memcpy(new->head, old->head, new_head_len);
+
+	/* copy in optional tail */
+	if (beacon->tail)
+		memcpy(new->tail, beacon->tail, new_tail_len);
+	else
+		if (old)
+			memcpy(new->tail, old->tail, new_tail_len);
+
+ done:
+	rcu_assign_pointer(sdata->u.ap.beacon, new);
+
+	synchronize_rcu();
+
+	kfree(old);
+
+	return ieee80211_if_config_beacon(dev);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -277,4 +384,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.del_key = ieee80211_del_key,
 	.get_key = ieee80211_get_key,
 	.set_default_key = ieee80211_config_default_key,
+	.set_beacon = ieee80211_set_beacon,
 };
--- linux-2.6.orig/net/mac80211/debugfs_netdev.c	2007-10-24 11:32:35.142690568 +0200
+++ linux-2.6/net/mac80211/debugfs_netdev.c	2007-10-24 11:35:51.082690568 +0200
@@ -125,7 +125,6 @@ __IEEE80211_IF_FILE(flags);
 
 /* AP attributes */
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
-IEEE80211_IF_FILE(dtim_period, u.ap.dtim_period, DEC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
 IEEE80211_IF_FILE(num_beacons, u.ap.num_beacons, DEC);
 IEEE80211_IF_FILE(force_unicast_rateidx, u.ap.force_unicast_rateidx, DEC);
@@ -139,26 +138,6 @@ static ssize_t ieee80211_if_fmt_num_buff
 }
 __IEEE80211_IF_FILE(num_buffered_multicast);
 
-static ssize_t ieee80211_if_fmt_beacon_head_len(
-	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
-{
-	if (sdata->u.ap.beacon_head)
-		return scnprintf(buf, buflen, "%d\n",
-				 sdata->u.ap.beacon_head_len);
-	return scnprintf(buf, buflen, "\n");
-}
-__IEEE80211_IF_FILE(beacon_head_len);
-
-static ssize_t ieee80211_if_fmt_beacon_tail_len(
-	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
-{
-	if (sdata->u.ap.beacon_tail)
-		return scnprintf(buf, buflen, "%d\n",
-				 sdata->u.ap.beacon_tail_len);
-	return scnprintf(buf, buflen, "\n");
-}
-__IEEE80211_IF_FILE(beacon_tail_len);
-
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
@@ -195,14 +174,11 @@ static void add_ap_files(struct ieee8021
 	DEBUGFS_ADD(eapol, ap);
 	DEBUGFS_ADD(ieee8021_x, ap);
 	DEBUGFS_ADD(num_sta_ps, ap);
-	DEBUGFS_ADD(dtim_period, ap);
 	DEBUGFS_ADD(dtim_count, ap);
 	DEBUGFS_ADD(num_beacons, ap);
 	DEBUGFS_ADD(force_unicast_rateidx, ap);
 	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
 	DEBUGFS_ADD(num_buffered_multicast, ap);
-	DEBUGFS_ADD(beacon_head_len, ap);
-	DEBUGFS_ADD(beacon_tail_len, ap);
 }
 
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
@@ -288,14 +264,11 @@ static void del_ap_files(struct ieee8021
 	DEBUGFS_DEL(eapol, ap);
 	DEBUGFS_DEL(ieee8021_x, ap);
 	DEBUGFS_DEL(num_sta_ps, ap);
-	DEBUGFS_DEL(dtim_period, ap);
 	DEBUGFS_DEL(dtim_count, ap);
 	DEBUGFS_DEL(num_beacons, ap);
 	DEBUGFS_DEL(force_unicast_rateidx, ap);
 	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
 	DEBUGFS_DEL(num_buffered_multicast, ap);
-	DEBUGFS_DEL(beacon_head_len, ap);
-	DEBUGFS_DEL(beacon_tail_len, ap);
 }
 
 static void del_wds_files(struct ieee80211_sub_if_data *sdata)
--- linux-2.6.orig/net/mac80211/ieee80211_i.h	2007-10-24 11:32:35.192690568 +0200
+++ linux-2.6/net/mac80211/ieee80211_i.h	2007-10-25 10:46:56.610258735 +0200
@@ -186,9 +186,14 @@ typedef ieee80211_txrx_result (*ieee8021
 typedef ieee80211_txrx_result (*ieee80211_rx_handler)
 (struct ieee80211_txrx_data *rx);
 
+struct beacon_data {
+	u8 *head, *tail;
+	int head_len, tail_len;
+	int dtim_period;
+};
+
 struct ieee80211_if_ap {
-	u8 *beacon_head, *beacon_tail;
-	int beacon_head_len, beacon_tail_len;
+	struct beacon_data *beacon;
 
 	struct list_head vlans;
 
@@ -201,7 +206,7 @@ struct ieee80211_if_ap {
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)];
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	struct sk_buff_head ps_bc_buf;
-	int dtim_period, dtim_count;
+	int dtim_count;
 	int force_unicast_rateidx; /* forced TX rateidx for unicast frames */
 	int max_ratectrl_rateidx; /* max TX rateidx for rate control */
 	int num_beacons; /* number of TXed beacon frames for this BSS */
@@ -357,14 +362,11 @@ struct ieee80211_sub_if_data {
 			struct dentry *eapol;
 			struct dentry *ieee8021_x;
 			struct dentry *num_sta_ps;
-			struct dentry *dtim_period;
 			struct dentry *dtim_count;
 			struct dentry *num_beacons;
 			struct dentry *force_unicast_rateidx;
 			struct dentry *max_ratectrl_rateidx;
 			struct dentry *num_buffered_multicast;
-			struct dentry *beacon_head_len;
-			struct dentry *beacon_tail_len;
 		} ap;
 		struct {
 			struct dentry *channel_use;
--- linux-2.6.orig/net/mac80211/ieee80211_iface.c	2007-10-24 11:32:35.222690568 +0200
+++ linux-2.6/net/mac80211/ieee80211_iface.c	2007-10-25 10:46:56.630258572 +0200
@@ -127,7 +127,6 @@ void ieee80211_if_set_type(struct net_de
 		sdata->u.vlan.ap = NULL;
 		break;
 	case IEEE80211_IF_TYPE_AP:
-		sdata->u.ap.dtim_period = 2;
 		sdata->u.ap.force_unicast_rateidx = -1;
 		sdata->u.ap.max_ratectrl_rateidx = -1;
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
@@ -208,8 +207,7 @@ void ieee80211_if_reinit(struct net_devi
 			}
 		}
 
-		kfree(sdata->u.ap.beacon_head);
-		kfree(sdata->u.ap.beacon_tail);
+		kfree(sdata->u.ap.beacon);
 
 		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
 			local->total_ps_buffered--;
--- linux-2.6.orig/net/mac80211/tx.c	2007-10-24 11:32:35.272690568 +0200
+++ linux-2.6/net/mac80211/tx.c	2007-10-25 10:47:44.370254503 +0200
@@ -1653,7 +1653,8 @@ void ieee80211_tx_pending(unsigned long 
 
 static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
 				     struct ieee80211_if_ap *bss,
-				     struct sk_buff *skb)
+				     struct sk_buff *skb,
+				     struct beacon_data *beacon)
 {
 	u8 *pos, *tim;
 	int aid0 = 0;
@@ -1669,7 +1670,7 @@ static void ieee80211_beacon_add_tim(str
 					  IEEE80211_MAX_AID+1);
 
 	if (bss->dtim_count == 0)
-		bss->dtim_count = bss->dtim_period - 1;
+		bss->dtim_count = beacon->dtim_period - 1;
 	else
 		bss->dtim_count--;
 
@@ -1677,7 +1678,7 @@ static void ieee80211_beacon_add_tim(str
 	*pos++ = WLAN_EID_TIM;
 	*pos++ = 4;
 	*pos++ = bss->dtim_count;
-	*pos++ = bss->dtim_period;
+	*pos++ = beacon->dtim_period;
 
 	if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
 		aid0 = 1;
@@ -1725,8 +1726,9 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct ieee80211_if_ap *ap = NULL;
 	struct ieee80211_rate *rate;
 	struct rate_control_extra extra;
-	u8 *b_head, *b_tail;
-	int bh_len, bt_len;
+	struct beacon_data *beacon;
+
+	rcu_read_lock();
 
 	bdev = dev_get_by_index(&init_net, if_id);
 	if (bdev) {
@@ -1735,37 +1737,35 @@ struct sk_buff *ieee80211_beacon_get(str
 		dev_put(bdev);
 	}
 
-	if (!ap || sdata->type != IEEE80211_IF_TYPE_AP ||
-	    !ap->beacon_head) {
+	beacon = rcu_dereference(ap->beacon);
+
+	if (!ap || sdata->type != IEEE80211_IF_TYPE_AP || !beacon) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "no beacon data avail for idx=%d "
 			       "(%s)\n", if_id, bdev ? bdev->name : "N/A");
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-		return NULL;
+		skb = NULL;
+		goto out;
 	}
 
-	/* Assume we are generating the normal beacon locally */
-	b_head = ap->beacon_head;
-	b_tail = ap->beacon_tail;
-	bh_len = ap->beacon_head_len;
-	bt_len = ap->beacon_tail_len;
-
-	skb = dev_alloc_skb(local->tx_headroom +
-		bh_len + bt_len + 256 /* maximum TIM len */);
+	/* headroom, head length, tail length and maximum TIM length */
+	skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
+			    beacon->tail_len + 256);
 	if (!skb)
-		return NULL;
+		goto out;
 
 	skb_reserve(skb, local->tx_headroom);
-	memcpy(skb_put(skb, bh_len), b_head, bh_len);
+	memcpy(skb_put(skb, beacon->head_len), beacon->head,
+	       beacon->head_len);
 
 	ieee80211_include_sequence(sdata, (struct ieee80211_hdr *)skb->data);
 
-	ieee80211_beacon_add_tim(local, ap, skb);
+	ieee80211_beacon_add_tim(local, ap, skb, beacon);
 
-	if (b_tail) {
-		memcpy(skb_put(skb, bt_len), b_tail, bt_len);
-	}
+	if (beacon->tail)
+		memcpy(skb_put(skb, beacon->tail_len), beacon->tail,
+		       beacon->tail_len);
 
 	if (control) {
 		memset(&extra, 0, sizeof(extra));
@@ -1778,7 +1778,8 @@ struct sk_buff *ieee80211_beacon_get(str
 				       "found\n", wiphy_name(local->hw.wiphy));
 			}
 			dev_kfree_skb(skb);
-			return NULL;
+			skb = NULL;
+			goto out;
 		}
 
 		control->tx_rate =
@@ -1793,6 +1794,9 @@ struct sk_buff *ieee80211_beacon_get(str
 	}
 
 	ap->num_beacons++;
+
+ out:
+	rcu_read_unlock();
 	return skb;
 }
 EXPORT_SYMBOL(ieee80211_beacon_get);
@@ -1841,6 +1845,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
+	struct beacon_data *beacon;
 
 	bdev = dev_get_by_index(&init_net, if_id);
 	if (bdev) {
@@ -1848,9 +1853,19 @@ ieee80211_get_buffered_bc(struct ieee802
 		bss = &sdata->u.ap;
 		dev_put(bdev);
 	}
-	if (!bss || sdata->type != IEEE80211_IF_TYPE_AP || !bss->beacon_head)
+
+	if (!bss)
 		return NULL;
 
+	rcu_read_lock();
+	beacon = rcu_dereference(bss->beacon);
+
+	if (sdata->type != IEEE80211_IF_TYPE_AP || !beacon || !beacon->head) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	rcu_read_unlock();
+
 	if (bss->dtim_count != 0)
 		return NULL; /* send buffered bc/mc only after DTIM beacon */
 	memset(control, 0, sizeof(*control));

-- 

