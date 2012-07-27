Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2G0LRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 17/20] mac80211: track whether to use channel contexts
Date: Fri, 27 Jul 2012 13:16:53 +0200
Message-Id: <1343387816-9414-18-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131821_656337_6980A0AF)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on the driver, channel contexts may be used or
not. If they are used, the driver must have support for
hardware scan and remain-on-channel; otherwise the driver
must not advertise support for multiple channels.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |    3 +++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/main.c        |   14 ++++++++++++++
 net/mac80211/offchannel.c  |    6 ++++++
 net/mac80211/scan.c        |    4 ++++
 5 files changed, 29 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1910517..7422ebc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2159,6 +2159,9 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 	lockdep_assert_held(&local->mtx);
 
+	if (local->use_chanctx && !local->ops->remain_on_channel)
+		return -EOPNOTSUPP;
+
 	roc = kzalloc(sizeof(*roc), GFP_KERNEL);
 	if (!roc)
 		return -ENOMEM;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4ad715d..c52db65 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -873,6 +873,8 @@ struct ieee80211_local {
 
 	bool wiphy_ciphers_allocated;
 
+	bool use_chanctx;
+
 	/* protects the aggregated multicast list and filter calls */
 	spinlock_t filter_lock;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 96abcf2..c58b339 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -544,6 +544,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	struct ieee80211_local *local;
 	int priv_size, i;
 	struct wiphy *wiphy;
+	bool use_chanctx;
 
 	if (WARN_ON(!ops->tx || !ops->start || !ops->stop || !ops->config ||
 		    !ops->add_interface || !ops->remove_interface ||
@@ -559,6 +560,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	    !!ops->unassign_vif_chanctx;
 	if (WARN_ON(i != 0 && i != 5))
 		return NULL;
+	use_chanctx = i == 5;
 
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
@@ -610,6 +612,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.priv = (char *)local + ALIGN(sizeof(*local), NETDEV_ALIGN);
 
 	local->ops = ops;
+	local->use_chanctx = use_chanctx;
 
 	/* set up some defaults */
 	local->hw.queues = 1;
@@ -733,6 +736,17 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if ((hw->flags & IEEE80211_HW_SCAN_WHILE_IDLE) && !local->ops->hw_scan)
 		return -EINVAL;
 
+	if (!local->use_chanctx) {
+		for (i = 0; i < local->hw.wiphy->n_iface_combinations; i++) {
+			const struct ieee80211_iface_combination *comb;
+
+			comb = &local->hw.wiphy->iface_combinations[i];
+
+			if (comb->num_different_channels > 1)
+				return -EINVAL;
+		}
+	}
+
 	/* Only HW csum features are currently compatible with mac80211 */
 	feature_whitelist = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_HW_CSUM;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 507121d..4970660 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -107,6 +107,9 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 {
 	struct ieee80211_sub_if_data *sdata;
 
+	if (WARN_ON(local->use_chanctx))
+		return;
+
 	/*
 	 * notify the AP about us leaving the channel and stop all
 	 * STA interfaces.
@@ -145,6 +148,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 {
 	struct ieee80211_sub_if_data *sdata;
 
+	if (WARN_ON(local->use_chanctx))
+		return;
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 0045869..7ca3441 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -337,6 +337,10 @@ EXPORT_SYMBOL(ieee80211_scan_completed);
 
 static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 {
+	/* Software scan is not supported in multi-channel cases */
+	if (local->use_chanctx)
+		return -EOPNOTSUPP;
+
 	/*
 	 * Hardware/driver doesn't support hw_scan, so use software
 	 * scanning instead. First send a nullfunc frame with power save
-- 
1.7.10.4

