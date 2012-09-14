Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2INMgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:36:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/10] mac80211: track whether to use channel contexts
Date: Fri, 14 Sep 2012 14:37:09 +0200
Message-Id: <1347626233-21916-7-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143657_327410_3D036D7C)
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on the driver, channel contexts may be used or
not. If they are used, the driver must have support for
hardware scan and remain-on-channel; otherwise the driver
must not advertise support for multiple channels.

Also prohibit WDS type interfaces when channel contexts
are to be used as there's no clear definition of which
channel they use.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |    3 +++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/main.c        |   22 ++++++++++++++++++++++
 net/mac80211/offchannel.c  |    6 ++++++
 net/mac80211/scan.c        |    4 ++++
 5 files changed, 37 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9bd56a7..7e9b5d4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2188,6 +2188,9 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 	lockdep_assert_held(&local->mtx);
 
+	if (local->use_chanctx && !local->ops->remain_on_channel)
+		return -EOPNOTSUPP;
+
 	roc = kzalloc(sizeof(*roc), GFP_KERNEL);
 	if (!roc)
 		return -ENOMEM;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9a058e5..8fa00ad 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -882,6 +882,8 @@ struct ieee80211_local {
 
 	bool wiphy_ciphers_allocated;
 
+	bool use_chanctx;
+
 	/* protects the aggregated multicast list and filter calls */
 	spinlock_t filter_lock;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d709a5d..0dd1ea2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -540,6 +540,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	struct ieee80211_local *local;
 	int priv_size, i;
 	struct wiphy *wiphy;
+	bool use_chanctx;
 
 	if (WARN_ON(!ops->tx || !ops->start || !ops->stop || !ops->config ||
 		    !ops->add_interface || !ops->remove_interface ||
@@ -555,6 +556,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	    !!ops->unassign_vif_chanctx;
 	if (WARN_ON(i != 0 && i != 5))
 		return NULL;
+	use_chanctx = i == 5;
 
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
@@ -606,6 +608,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.priv = (char *)local + ALIGN(sizeof(*local), NETDEV_ALIGN);
 
 	local->ops = ops;
+	local->use_chanctx = use_chanctx;
 
 	/* set up some defaults */
 	local->hw.queues = 1;
@@ -729,6 +732,25 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
+
+		/*
+		 * WDS is currently prohibited when channel contexts are used
+		 * because there's no clear definition of which channel WDS
+		 * type interfaces use
+		 */
+		if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS))
+			return -EINVAL;
+	}
+
 	/* Only HW csum features are currently compatible with mac80211 */
 	feature_whitelist = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_HW_CSUM;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 83608ac..9c52fc4 100644
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
index c4cdbde..fdaa505 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -336,6 +336,10 @@ EXPORT_SYMBOL(ieee80211_scan_completed);
 
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

