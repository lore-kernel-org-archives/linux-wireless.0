Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56248 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZGaAkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 20:40:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 17:40:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 3/4] cfg80211: decouple regulatory variables from cfg80211_mutex
Date: Thu, 30 Jul 2009 17:38:08 -0700
Message-ID: <1249000689-14970-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249000689-14970-1-git-send-email-lrodriguez@atheros.com>
References: <1249000689-14970-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We change regulatory code to be protected by its own regulatory
mutex and alleviate cfg80211_mutex to only be used to protect
cfg80211_rdev_list, the registered device list.

By doing this we will be able to work on regulatory core components
without having to have hog up the cfg80211_mutex. An example here is
we no longer need to use the cfg80211_mutex during driver specific
wiphy_apply_custom_regulatory(). We also no longer need it for the
the country IE regulatory hint; by doing so we end up curing this
new lockdep warning:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-rc4-wl #12
-------------------------------------------------------
phy1/1709 is trying to acquire lock:
 (cfg80211_mutex){+.+.+.}, at: [<ffffffffa00af852>] regulatory_hint_11d+0x32/0x3f0 [cfg80211]

but task is already holding lock:
 (&ifmgd->mtx){+.+.+.}, at: [<ffffffffa0144228>] ieee80211_sta_work+0x108/0x10f0 [mac80211]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&ifmgd->mtx){+.+.+.}:
       [<ffffffff810857b6>] __lock_acquire+0xd76/0x12b0
       [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
       [<ffffffff814eeae4>] mutex_lock_nested+0x44/0x350
       [<ffffffffa0141bb8>] ieee80211_mgd_auth+0x108/0x1f0 [mac80211]
       [<ffffffffa0148563>] ieee80211_auth+0x13/0x20 [mac80211]
       [<ffffffffa00bc3a1>] __cfg80211_mlme_auth+0x1b1/0x2a0 [cfg80211]
       [<ffffffffa00bc516>] cfg80211_mlme_auth+0x86/0xc0 [cfg80211]
       [<ffffffffa00b368d>] nl80211_authenticate+0x21d/0x230 [cfg80211]
       [<ffffffff81416ba6>] genl_rcv_msg+0x1b6/0x1f0
       [<ffffffff81415c39>] netlink_rcv_skb+0x89/0xb0
       [<ffffffff814169d9>] genl_rcv+0x29/0x40
       [<ffffffff8141591d>] netlink_unicast+0x29d/0x2b0
       [<ffffffff81416514>] netlink_sendmsg+0x214/0x300
       [<ffffffff813e4407>] sock_sendmsg+0x107/0x130
       [<ffffffff813e45b9>] sys_sendmsg+0x189/0x320
       [<ffffffff81011f82>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&wdev->mtx){+.+.+.}:
       [<ffffffff810857b6>] __lock_acquire+0xd76/0x12b0
       [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
       [<ffffffff814eeae4>] mutex_lock_nested+0x44/0x350
       [<ffffffffa00ab304>] cfg80211_netdev_notifier_call+0x1a4/0x390 [cfg80211]
       [<ffffffff814f3dff>] notifier_call_chain+0x3f/0x80
       [<ffffffff81075a91>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff813f665a>] dev_open+0x10a/0x120
       [<ffffffff813f59bd>] dev_change_flags+0x9d/0x1e0
       [<ffffffff8144eb6e>] devinet_ioctl+0x6fe/0x760
       [<ffffffff81450204>] inet_ioctl+0x94/0xc0
       [<ffffffff813e25fa>] sock_ioctl+0x6a/0x290
       [<ffffffff8111e911>] vfs_ioctl+0x31/0xa0
       [<ffffffff8111ea9a>] do_vfs_ioctl+0x8a/0x5c0
       [<ffffffff8111f069>] sys_ioctl+0x99/0xa0
       [<ffffffff81011f82>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&rdev->mtx){+.+.+.}:
       [<ffffffff810857b6>] __lock_acquire+0xd76/0x12b0
       [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
       [<ffffffff814eeae4>] mutex_lock_nested+0x44/0x350
       [<ffffffffa00ac4d0>] cfg80211_get_dev_from_ifindex+0x60/0x90 [cfg80211]
       [<ffffffffa00b21ff>] get_rdev_dev_by_info_ifindex+0x6f/0xa0 [cfg80211]
       [<ffffffffa00b51eb>] nl80211_set_interface+0x3b/0x260 [cfg80211]
       [<ffffffff81416ba6>] genl_rcv_msg+0x1b6/0x1f0
       [<ffffffff81415c39>] netlink_rcv_skb+0x89/0xb0
       [<ffffffff814169d9>] genl_rcv+0x29/0x40
       [<ffffffff8141591d>] netlink_unicast+0x29d/0x2b0
       [<ffffffff81416514>] netlink_sendmsg+0x214/0x300
       [<ffffffff813e4407>] sock_sendmsg+0x107/0x130
       [<ffffffff813e45b9>] sys_sendmsg+0x189/0x320
       [<ffffffff81011f82>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

3 locks held by phy1/1709:
 #0:  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<ffffffff8106b45d>] worker_thread+0x19d/0x340
 #1:  (&ifmgd->work){+.+.+.}, at: [<ffffffff8106b45d>] worker_thread+0x19d/0x340
 #2:  (&ifmgd->mtx){+.+.+.}, at: [<ffffffffa0144228>] ieee80211_sta_work+0x108/0x10f0 [mac80211]

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/core.c |    4 +---
 net/wireless/reg.c  |   46 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 755cdf1..d8dbd7f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -34,9 +34,7 @@ MODULE_DESCRIPTION("wireless configuration support");
 LIST_HEAD(cfg80211_rdev_list);
 
 /*
- * This is used to protect the cfg80211_rdev_list, cfg80211_regdomain,
- * country_ie_regdomain, the reg_beacon_list and the the last regulatory
- * request receipt (last_request).
+ * This is used to protect the cfg80211_rdev_list
  */
 DEFINE_MUTEX(cfg80211_mutex);
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f386981..6ab56f0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -62,6 +62,16 @@ const struct ieee80211_regdomain *cfg80211_regdomain;
  */
 static const struct ieee80211_regdomain *country_ie_regdomain;
 
+/*
+ * Protects static reg.c components:
+ *     - cfg80211_world_regdom
+ *     - cfg80211_regdom
+ *     - country_ie_regdomain
+ *     - last_request
+ */
+DEFINE_MUTEX(reg_mutex);
+#define assert_reg_lock() WARN_ON(!mutex_is_locked(&reg_mutex))
+
 /* Used to queue up regulatory hints */
 static LIST_HEAD(reg_requests_list);
 static spinlock_t reg_requests_lock;
@@ -1293,7 +1303,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 
-	assert_cfg80211_lock();
+	assert_reg_lock();
 
 	sband = wiphy->bands[band];
 	BUG_ON(chan_idx >= sband->n_channels);
@@ -1342,14 +1352,14 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	enum ieee80211_band band;
 	unsigned int bands_set = 0;
 
-	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
 		handle_band_custom(wiphy, band, regd);
 		bands_set++;
 	}
-	mutex_unlock(&cfg80211_mutex);
+	mutex_unlock(&reg_mutex);
 
 	/*
 	 * no point in calling this if it won't have any effect
@@ -1495,7 +1505,7 @@ static int ignore_request(struct wiphy *wiphy,
  * Returns zero if all went fine, %-EALREADY if a regulatory domain had
  * already been set or other standard error codes.
  *
- * Caller must hold &cfg80211_mutex
+ * Caller must hold &cfg80211_mutex and &reg_mutex
  */
 static int __regulatory_hint(struct wiphy *wiphy,
 			     struct regulatory_request *pending_request)
@@ -1570,6 +1580,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	BUG_ON(!reg_request->alpha2);
 
 	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
 
 	if (wiphy_idx_valid(reg_request->wiphy_idx))
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
@@ -1585,6 +1596,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	if (r == -EALREADY && wiphy && wiphy->strict_regulatory)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
 out:
+	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 }
 
@@ -1613,6 +1625,10 @@ static void reg_process_pending_beacon_hints(void)
 	struct cfg80211_registered_device *rdev;
 	struct reg_beacon *pending_beacon, *tmp;
 
+	/*
+	 * No need to hold the reg_mutex here as we just touch wiphys
+	 * and do not read or access regulatory variables.
+	 */
 	mutex_lock(&cfg80211_mutex);
 
 	/* This goes through the _pending_ beacon list */
@@ -1734,12 +1750,13 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
+/* Caller must hold reg_mutex */
 static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 			u32 country_ie_checksum)
 {
 	struct wiphy *request_wiphy;
 
-	assert_cfg80211_lock();
+	assert_reg_lock();
 
 	if (unlikely(last_request->initiator !=
 	    NL80211_REGDOM_SET_BY_COUNTRY_IE))
@@ -1776,7 +1793,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	enum environment_cap env = ENVIRON_ANY;
 	struct regulatory_request *request;
 
-	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
 
 	if (unlikely(!last_request))
 		goto out;
@@ -1850,7 +1867,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	request->country_ie_checksum = checksum;
 	request->country_ie_env = env;
 
-	mutex_unlock(&cfg80211_mutex);
+	mutex_unlock(&reg_mutex);
 
 	queue_regulatory_request(request);
 
@@ -1859,7 +1876,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 free_rd_out:
 	kfree(rd);
 out:
-	mutex_unlock(&cfg80211_mutex);
+	mutex_unlock(&reg_mutex);
 }
 EXPORT_SYMBOL(regulatory_hint_11d);
 
@@ -2192,10 +2209,13 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	assert_cfg80211_lock();
 
+	mutex_lock(&reg_mutex);
+
 	/* Note that this doesn't update the wiphys, this is done below */
 	r = __set_regdom(rd);
 	if (r) {
 		kfree(rd);
+		mutex_unlock(&reg_mutex);
 		return r;
 	}
 
@@ -2210,6 +2230,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	nl80211_send_reg_change_event(last_request);
 
+	mutex_unlock(&reg_mutex);
+
 	return r;
 }
 
@@ -2220,16 +2242,20 @@ void reg_device_remove(struct wiphy *wiphy)
 
 	assert_cfg80211_lock();
 
+	mutex_lock(&reg_mutex);
+
 	kfree(wiphy->regd);
 
 	if (last_request)
 		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
 	if (!request_wiphy || request_wiphy != wiphy)
-		return;
+		goto out;
 
 	last_request->wiphy_idx = WIPHY_IDX_STALE;
 	last_request->country_ie_env = ENVIRON_ANY;
+out:
+	mutex_unlock(&reg_mutex);
 }
 
 int regulatory_init(void)
@@ -2290,6 +2316,7 @@ void regulatory_exit(void)
 	cancel_work_sync(&reg_work);
 
 	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
 
 	reset_regdomains();
 
@@ -2328,5 +2355,6 @@ void regulatory_exit(void)
 	}
 	spin_unlock(&reg_requests_lock);
 
+	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 }
-- 
1.6.3.3

