Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:53246
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932109AbaJVP5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 11:57:42 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: add support for driver tx power reporting
Date: Wed, 22 Oct 2014 17:57:38 +0200
Message-Id: <1413993458-62517-1-git-send-email-nbd@openwrt.org> (sfid-20141022_175749_370256_2C27B844)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configured tx power is often limited by hardware capabilities,
channel settings, antenna configuration, etc.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 5 +++++
 net/mac80211/cfg.c     | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ad1f47..41b0e60 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2838,6 +2838,9 @@ enum ieee80211_roc_type {
  * @get_expected_throughput: extract the expected throughput towards the
  *	specified station. The returned value is expressed in Kbps. It returns 0
  *	if the RC algorithm does not have proper data to provide.
+ *
+ * @get_txpower: get current maximum tx power (in dBm) based on configuration
+ *	and hardware limits.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3039,6 +3042,8 @@ struct ieee80211_ops {
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
+	int (*get_txpower)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   int *dbm);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fb6a150..7cb31a8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2081,6 +2081,9 @@ static int ieee80211_get_tx_power(struct wiphy *wiphy,
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
+	if (local->ops->get_txpower)
+		return local->ops->get_txpower(&local->hw, &sdata->vif, dbm);
+
 	if (!local->use_chanctx)
 		*dbm = local->hw.conf.power_level;
 	else
-- 
2.0.4

