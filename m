Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbXLSPsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:48:12 -0500
Message-Id: <20071219010341.472761000@sipsolutions.net> (sfid-20071219_154818_423640_32A3FB2F)
References: <20071219010328.762470000@sipsolutions.net>
Date: Wed, 19 Dec 2007 02:03:33 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] mac80211: add beacon configuration via cfg80211
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

 net/mac80211/cfg.c             |  156 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c  |   27 -------
 net/mac80211/ieee80211.c       |    9 ++
 net/mac80211/ieee80211_i.h     |   14 ++-
 net/mac80211/ieee80211_iface.c |    4 -
 net/mac80211/tx.c              |   65 ++++++++++-------
 6 files changed, 213 insertions(+), 62 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2007-12-19 00:50:17.133022895 +0100
+++ everything/net/mac80211/cfg.c	2007-12-19 00:50:19.363027235 +0100
@@ -10,6 +10,7 @@
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
 #include <net/net_namespace.h>
+#include <linux/rcupdate.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "cfg.h"
@@ -269,6 +270,158 @@ static int ieee80211_config_default_key(
 	return 0;
 }
 
+/*
+ * This handles both adding a beacon and setting new beacon info
+ */
+static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
+				   struct beacon_parameters *params)
+{
+	struct beacon_data *new, *old;
+	int new_head_len, new_tail_len;
+	int size;
+	int err = -EINVAL;
+
+	old = sdata->u.ap.beacon;
+
+	/* head must not be zero-length */
+	if (params->head && !params->head_len)
+		return -EINVAL;
+
+	/*
+	 * This is a kludge. beacon interval should really be part
+	 * of the beacon information.
+	 */
+	if (params->interval) {
+		sdata->local->hw.conf.beacon_int = params->interval;
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
+	if (!params->head && !old)
+		return err;
+
+	/* sorry, no way to start beaconing without dtim period */
+	if (!params->dtim_period && !old)
+		return err;
+
+	/* new or old head? */
+	if (params->head)
+		new_head_len = params->head_len;
+	else
+		new_head_len = old->head_len;
+
+	/* new or old tail? */
+	if (params->tail || !old)
+		/* params->tail_len will be zero for !params->tail */
+		new_tail_len = params->tail_len;
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
+	if (params->dtim_period)
+		new->dtim_period = params->dtim_period;
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
+	if (params->head)
+		memcpy(new->head, params->head, new_head_len);
+	else
+		memcpy(new->head, old->head, new_head_len);
+
+	/* copy in optional tail */
+	if (params->tail)
+		memcpy(new->tail, params->tail, new_tail_len);
+	else
+		if (old)
+			memcpy(new->tail, old->tail, new_tail_len);
+
+	rcu_assign_pointer(sdata->u.ap.beacon, new);
+
+	synchronize_rcu();
+
+	kfree(old);
+
+	return ieee80211_if_config_beacon(sdata->dev);
+}
+
+static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
+				struct beacon_parameters *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct beacon_data *old;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+		return -EINVAL;
+
+	old = sdata->u.ap.beacon;
+
+	if (old)
+		return -EALREADY;
+
+	return ieee80211_config_beacon(sdata, params);
+}
+
+static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
+				struct beacon_parameters *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct beacon_data *old;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+		return -EINVAL;
+
+	old = sdata->u.ap.beacon;
+
+	if (!old)
+		return -ENOENT;
+
+	return ieee80211_config_beacon(sdata, params);
+}
+
+static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct beacon_data *old;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+		return -EINVAL;
+
+	old = sdata->u.ap.beacon;
+
+	if (!old)
+		return -ENOENT;
+
+	rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+	synchronize_rcu();
+	kfree(old);
+
+	return ieee80211_if_config_beacon(dev);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -277,4 +430,7 @@ struct cfg80211_ops mac80211_config_ops 
 	.del_key = ieee80211_del_key,
 	.get_key = ieee80211_get_key,
 	.set_default_key = ieee80211_config_default_key,
+	.add_beacon = ieee80211_add_beacon,
+	.set_beacon = ieee80211_set_beacon,
+	.del_beacon = ieee80211_del_beacon,
 };
--- everything.orig/net/mac80211/debugfs_netdev.c	2007-12-19 00:50:13.963022840 +0100
+++ everything/net/mac80211/debugfs_netdev.c	2007-12-19 00:50:19.363027235 +0100
@@ -124,7 +124,6 @@ __IEEE80211_IF_FILE(flags);
 
 /* AP attributes */
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
-IEEE80211_IF_FILE(dtim_period, u.ap.dtim_period, DEC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
 IEEE80211_IF_FILE(num_beacons, u.ap.num_beacons, DEC);
 IEEE80211_IF_FILE(force_unicast_rateidx, u.ap.force_unicast_rateidx, DEC);
@@ -138,26 +137,6 @@ static ssize_t ieee80211_if_fmt_num_buff
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
 
@@ -192,14 +171,11 @@ static void add_ap_files(struct ieee8021
 	DEBUGFS_ADD(drop_unencrypted, ap);
 	DEBUGFS_ADD(ieee802_1x_pac, ap);
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
@@ -281,14 +257,11 @@ static void del_ap_files(struct ieee8021
 	DEBUGFS_DEL(drop_unencrypted, ap);
 	DEBUGFS_DEL(ieee802_1x_pac, ap);
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
--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-19 00:50:14.003022188 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-19 00:50:19.373022352 +0100
@@ -190,9 +190,14 @@ typedef ieee80211_txrx_result (*ieee8021
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
 
@@ -205,7 +210,7 @@ struct ieee80211_if_ap {
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)];
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	struct sk_buff_head ps_bc_buf;
-	int dtim_period, dtim_count;
+	int dtim_count;
 	int force_unicast_rateidx; /* forced TX rateidx for unicast frames */
 	int max_ratectrl_rateidx; /* max TX rateidx for rate control */
 	int num_beacons; /* number of TXed beacon frames for this BSS */
@@ -360,14 +365,11 @@ struct ieee80211_sub_if_data {
 			struct dentry *drop_unencrypted;
 			struct dentry *ieee802_1x_pac;
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
--- everything.orig/net/mac80211/ieee80211_iface.c	2007-12-19 00:50:13.973022461 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2007-12-19 00:50:19.373022352 +0100
@@ -126,7 +126,6 @@ void ieee80211_if_set_type(struct net_de
 		sdata->u.vlan.ap = NULL;
 		break;
 	case IEEE80211_IF_TYPE_AP:
-		sdata->u.ap.dtim_period = 2;
 		sdata->u.ap.force_unicast_rateidx = -1;
 		sdata->u.ap.max_ratectrl_rateidx = -1;
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
@@ -207,8 +206,7 @@ void ieee80211_if_reinit(struct net_devi
 			}
 		}
 
-		kfree(sdata->u.ap.beacon_head);
-		kfree(sdata->u.ap.beacon_tail);
+		kfree(sdata->u.ap.beacon);
 
 		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
 			local->total_ps_buffered--;
--- everything.orig/net/mac80211/tx.c	2007-12-19 00:50:13.993023057 +0100
+++ everything/net/mac80211/tx.c	2007-12-19 00:50:19.373022352 +0100
@@ -1633,7 +1633,8 @@ void ieee80211_tx_pending(unsigned long 
 
 static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
 				     struct ieee80211_if_ap *bss,
-				     struct sk_buff *skb)
+				     struct sk_buff *skb,
+				     struct beacon_data *beacon)
 {
 	u8 *pos, *tim;
 	int aid0 = 0;
@@ -1649,7 +1650,7 @@ static void ieee80211_beacon_add_tim(str
 					  IEEE80211_MAX_AID+1);
 
 	if (bss->dtim_count == 0)
-		bss->dtim_count = bss->dtim_period - 1;
+		bss->dtim_count = beacon->dtim_period - 1;
 	else
 		bss->dtim_count--;
 
@@ -1657,7 +1658,7 @@ static void ieee80211_beacon_add_tim(str
 	*pos++ = WLAN_EID_TIM;
 	*pos++ = 4;
 	*pos++ = bss->dtim_count;
-	*pos++ = bss->dtim_period;
+	*pos++ = beacon->dtim_period;
 
 	if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
 		aid0 = 1;
@@ -1706,44 +1707,43 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct ieee80211_if_ap *ap = NULL;
 	struct ieee80211_rate *rate;
 	struct rate_control_extra extra;
-	u8 *b_head, *b_tail;
-	int bh_len, bt_len;
+	struct beacon_data *beacon;
+
+	rcu_read_lock();
 
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
 	ap = &sdata->u.ap;
 
-	if (!ap || sdata->vif.type != IEEE80211_IF_TYPE_AP ||
-	    !ap->beacon_head) {
+	beacon = rcu_dereference(ap->beacon);
+
+	if (!ap || sdata->vif.type != IEEE80211_IF_TYPE_AP || !beacon) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "no beacon data avail for %s\n",
 			       bdev->name);
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
@@ -1756,7 +1756,8 @@ struct sk_buff *ieee80211_beacon_get(str
 				       "found\n", wiphy_name(local->hw.wiphy));
 			}
 			dev_kfree_skb(skb);
-			return NULL;
+			skb = NULL;
+			goto out;
 		}
 
 		control->tx_rate =
@@ -1771,6 +1772,9 @@ struct sk_buff *ieee80211_beacon_get(str
 	}
 
 	ap->num_beacons++;
+
+ out:
+	rcu_read_unlock();
 	return skb;
 }
 EXPORT_SYMBOL(ieee80211_beacon_get);
@@ -1822,14 +1826,25 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
+	struct beacon_data *beacon;
 
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
 
-	if (!bss || sdata->vif.type != IEEE80211_IF_TYPE_AP ||
-	    !bss->beacon_head)
+
+	if (!bss)
 		return NULL;
 
+	rcu_read_lock();
+	beacon = rcu_dereference(bss->beacon);
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_AP || !beacon ||
+	    !beacon->head) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	rcu_read_unlock();
+
 	if (bss->dtim_count != 0)
 		return NULL; /* send buffered bc/mc only after DTIM beacon */
 	memset(control, 0, sizeof(*control));
--- everything.orig/net/mac80211/ieee80211.c	2007-12-19 00:50:13.963022840 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-19 00:50:19.383025662 +0100
@@ -311,10 +311,17 @@ static int ieee80211_stop(struct net_dev
 
 	dev_mc_unsync(local->mdev, dev);
 
-	/* down all dependent devices, that is VLANs */
+	/* APs need special treatment */
 	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmp;
+		struct beacon_data *old_beacon = sdata->u.ap.beacon;
 
+		/* remove beacon */
+		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+		synchronize_rcu();
+		kfree(old_beacon);
+
+		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmp, &sdata->u.ap.vlans,
 					 u.vlan.list)
 			dev_close(vlan->dev);

-- 

