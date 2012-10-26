Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55709 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966544Ab2JZVRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 17:17:13 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless: Allow registering more than one beacon listener.
Date: Fri, 26 Oct 2012 14:16:58 -0700
Message-Id: <1351286218-24838-1-git-send-email-greearb@candelatech.com> (sfid-20121026_231718_180820_DA67353D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The commit:

commit 5e760230e42cf759bd923457ca2753aacf2e656e
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Nov 4 11:18:17 2011 +0100

    cfg80211: allow registering to beacons

allowed only a single process to register for beacon events
per wiphy.  This breaks cases where a user may want two or
more VIFs on a wiphy and run a seperate hostapd process on
each vif.

This patch allows multiple beacon listeners, fixing the
regression.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/core.c    |    7 ++++
 net/wireless/core.h    |    7 +++-
 net/wireless/nl80211.c |   86 +++++++++++++++++++++++++++++++++--------------
 3 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f280f48..19f789f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -326,6 +326,8 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	mutex_init(&rdev->devlist_mtx);
 	mutex_init(&rdev->sched_scan_mtx);
 	INIT_LIST_HEAD(&rdev->wdev_list);
+	INIT_LIST_HEAD(&rdev->beacon_registrations);
+	spin_lock_init(&rdev->beacon_registrations_lock);
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
@@ -699,10 +701,15 @@ EXPORT_SYMBOL(wiphy_unregister);
 void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 {
 	struct cfg80211_internal_bss *scan, *tmp;
+	struct cfg80211_beacon_registration *reg, *treg;
 	rfkill_destroy(rdev->rfkill);
 	mutex_destroy(&rdev->mtx);
 	mutex_destroy(&rdev->devlist_mtx);
 	mutex_destroy(&rdev->sched_scan_mtx);
+	list_for_each_entry_safe(reg, treg, &rdev->beacon_registrations, list) {
+		list_del(&reg->list);
+		kfree(reg);
+	}
 	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
 		cfg80211_put_bss(&scan->pub);
 	kfree(rdev);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b8eb743..e53831c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -55,7 +55,8 @@ struct cfg80211_registered_device {
 	int opencount; /* also protected by devlist_mtx */
 	wait_queue_head_t dev_wait;
 
-	u32 ap_beacons_nlportid;
+	struct list_head beacon_registrations;
+	spinlock_t beacon_registrations_lock;
 
 	/* protected by RTNL only */
 	int num_running_ifaces;
@@ -260,6 +261,10 @@ enum cfg80211_chan_mode {
 	CHAN_MODE_EXCLUSIVE,
 };
 
+struct cfg80211_beacon_registration {
+	struct list_head list;
+	u32 nlportid;
+};
 
 /* free object */
 extern void cfg80211_dev_free(struct cfg80211_registered_device *rdev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 565b5a8..174cf3b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6914,16 +6914,36 @@ static int nl80211_probe_client(struct sk_buff *skb,
 static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_beacon_registration *reg, *nreg;
+	int rv;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_REPORTS_OBSS))
 		return -EOPNOTSUPP;
 
-	if (rdev->ap_beacons_nlportid)
-		return -EBUSY;
+	nreg = kzalloc(sizeof(*nreg), GFP_KERNEL);
+	if (!nreg)
+		return -ENOMEM;
+
+	/* First, check if already registered. */
+	spin_lock_bh(&rdev->beacon_registrations_lock);
+	list_for_each_entry(reg, &rdev->beacon_registrations, list) {
+		if (reg->nlportid == info->snd_portid) {
+			rv = -EALREADY;
+			goto out_err;
+		}
+	}
+	/* Add it to the list */
+	memset(nreg, 0, sizeof(*nreg));
+	nreg->nlportid = info->snd_portid;
+	list_add(&nreg->list, &rdev->beacon_registrations);
 
-	rdev->ap_beacons_nlportid = info->snd_portid;
+	spin_unlock_bh(&rdev->beacon_registrations_lock);
 
 	return 0;
+out_err:
+	spin_unlock_bh(&rdev->beacon_registrations_lock);
+	kfree(nreg);
+	return rv;
 }
 
 static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
@@ -8934,37 +8954,42 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
-	u32 nlportid = ACCESS_ONCE(rdev->ap_beacons_nlportid);
+	struct cfg80211_beacon_registration *reg;
 
 	trace_cfg80211_report_obss_beacon(wiphy, frame, len, freq, sig_dbm);
 
-	if (!nlportid)
-		return;
-
-	msg = nlmsg_new(len + 100, gfp);
-	if (!msg)
-		return;
+	spin_lock_bh(&rdev->beacon_registrations_lock);
+	list_for_each_entry(reg, &rdev->beacon_registrations, list) {
+		msg = nlmsg_new(len + 100, gfp);
+		if (!msg) {
+			spin_unlock_bh(&rdev->beacon_registrations_lock);
+			return;
+		}
 
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FRAME);
-	if (!hdr) {
-		nlmsg_free(msg);
-		return;
-	}
+		hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FRAME);
+		if (!hdr) {
+			spin_unlock_bh(&rdev->beacon_registrations_lock);
+			nlmsg_free(msg);
+			return;
+		}
 
-	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    (freq &&
-	     nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, freq)) ||
-	    (sig_dbm &&
-	     nla_put_u32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm)) ||
-	    nla_put(msg, NL80211_ATTR_FRAME, len, frame))
-		goto nla_put_failure;
+		if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+		    (freq &&
+		     nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, freq)) ||
+		    (sig_dbm &&
+		     nla_put_u32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm)) ||
+		    nla_put(msg, NL80211_ATTR_FRAME, len, frame))
+			goto nla_put_failure;
 
-	genlmsg_end(msg, hdr);
+		genlmsg_end(msg, hdr);
 
-	genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);
+		genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, reg->nlportid);
+	}
+	spin_unlock_bh(&rdev->beacon_registrations_lock);
 	return;
 
  nla_put_failure:
+	spin_unlock_bh(&rdev->beacon_registrations_lock);
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
@@ -8977,6 +9002,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 	struct netlink_notify *notify = _notify;
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
+	struct cfg80211_beacon_registration *reg, *tmp;
 
 	if (state != NETLINK_URELEASE)
 		return NOTIFY_DONE;
@@ -8986,8 +9012,16 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
 		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
 			cfg80211_mlme_unregister_socket(wdev, notify->portid);
-		if (rdev->ap_beacons_nlportid == notify->portid)
-			rdev->ap_beacons_nlportid = 0;
+
+		spin_lock_bh(&rdev->beacon_registrations_lock);
+		list_for_each_entry_safe(reg, tmp, &rdev->beacon_registrations,
+					 list) {
+			if (reg->nlportid == notify->portid) {
+				list_del(&reg->list);
+				kfree(reg);
+			}
+		}
+		spin_unlock_bh(&rdev->beacon_registrations_lock);
 	}
 
 	rcu_read_unlock();
-- 
1.7.3.4

