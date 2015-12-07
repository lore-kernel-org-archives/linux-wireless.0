Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34800 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbbLGVFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 16:05:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>,
	Anatol Pomozov <anatol.pomozov@gmail.com>,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 4/4] mac80211: add FTM request/response/abort
Date: Mon,  7 Dec 2015 22:04:53 +0100
Message-Id: <1449522293-13710-5-git-send-email-johannes@sipsolutions.net> (sfid-20151207_220515_083376_6EA91767)
In-Reply-To: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
References: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Add support for requesting an FTM (Fine Timing Measurement),
receiving a notification with its results, and aborting it.
There's no actual implementation as it depends entirely on
low-level device/driver support.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 10 +++++++++
 net/mac80211/cfg.c         | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  4 +++-
 net/mac80211/main.c        |  3 +++
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7c30faff245f..52c6ea752a4a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3269,6 +3269,11 @@ enum ieee80211_reconfig_type {
  *	the function call.
  *
  * @wake_tx_queue: Called when new packets have been added to the queue.
+ *
+ * @perform_ftm: Perform a Fine Timing Measurement with the given request
+ *	parameters. The given request can only be used within the function call.
+ * @abort_ftm: Abort a Fine Timing Measurement request. The given cookie must
+ *	match that of the active FTM request.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3508,6 +3513,11 @@ struct ieee80211_ops {
 
 	void (*wake_tx_queue)(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
+
+	int (*perform_ftm)(struct ieee80211_hw *hw, u64 cookie,
+			   struct ieee80211_vif *vif,
+			   struct cfg80211_ftm_request *ftm_req);
+	int (*abort_ftm)(struct ieee80211_hw *hw, u64 cookie);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2d1c4c35186d..2afaa761cb16 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3322,6 +3322,60 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 	return -ENOENT;
 }
 
+static u64 ieee80211_msrment_cookie(struct ieee80211_local *local,
+				    enum nl80211_msrment_type type)
+{
+	ASSERT_RTNL();
+
+	local->msrment_cookie_counter++;
+	if (local->msrment_cookie_counter == (1ULL << 48))
+		local->msrment_cookie_counter = 1;
+
+	return ((u64)type << 48) | local->msrment_cookie_counter;
+}
+
+static int ieee80211_perform_msrment(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     struct cfg80211_msrment_request *request,
+				     u64 *cookie)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_vif *vif = wdev_to_ieee80211_vif(wdev);
+
+	*cookie = ieee80211_msrment_cookie(local, request->type);
+
+	switch (request->type) {
+	case NL80211_MSRMENT_TYPE_FTM:
+		if (!local->ops->perform_ftm)
+			return -EOPNOTSUPP;
+		return local->ops->perform_ftm(&local->hw, *cookie, vif,
+					       &request->u.ftm);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int ieee80211_abort_msrment(struct wiphy *wiphy,
+				   struct wireless_dev *wdev, u64 cookie)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	enum nl80211_msrment_type type = cookie >> 48;
+
+	switch (type) {
+	case NL80211_MSRMENT_TYPE_FTM:
+		if (!local->ops->abort_ftm)
+			return -EOPNOTSUPP;
+		return local->ops->abort_ftm(&local->hw, cookie);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3342,6 +3396,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.get_station = ieee80211_get_station,
 	.dump_station = ieee80211_dump_station,
 	.dump_survey = ieee80211_dump_survey,
+	.perform_msrment = ieee80211_perform_msrment,
+	.abort_msrment = ieee80211_abort_msrment,
 #ifdef CONFIG_MAC80211_MESH
 	.add_mpath = ieee80211_add_mpath,
 	.del_mpath = ieee80211_del_mpath,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c30b6842ed9f..294aec41fca7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1347,11 +1347,13 @@ struct ieee80211_local {
 	struct cfg80211_chan_def monitor_chandef;
 
 	/* extended capabilities provided by mac80211 */
-	u8 ext_capa[8];
+	u8 ext_capa[9];
 
 	/* TDLS channel switch */
 	struct work_struct tdls_chsw_work;
 	struct sk_buff_head skb_queue_tdls_chsw;
+
+	u64 msrment_cookie_counter;
 };
 
 static inline struct ieee80211_sub_if_data *
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6bcf0faa4a89..b7fbcecd40ef 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1006,6 +1006,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA))
 		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
 
+	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_FTM_INITIATOR)
+		local->ext_capa[8] |= WLAN_EXT_CAPA9_FTM_INITIATOR;
+
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
 	result = wiphy_register(local->hw.wiphy);
-- 
2.6.2

