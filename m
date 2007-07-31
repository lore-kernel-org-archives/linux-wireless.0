Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934642AbXGaC7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 22:59:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/7] iwlwifi: Endian fix for rate setting in 3945
Date: Tue, 31 Jul 2007 10:56:36 +0800
Message-Id: <11858506081731-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11858506062806-git-send-email-yi.zhu@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com>
 <118585059814-git-send-email-yi.zhu@intel.com>
 <11858505994113-git-send-email-yi.zhu@intel.com>
 <11858506013260-git-send-email-yi.zhu@intel.com>
 <11858506033857-git-send-email-yi.zhu@intel.com>
 <11858506051195-git-send-email-yi.zhu@intel.com>
 <11858506062806-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issue in rate setting in 3945.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945-hw.h |    4 ++++
 drivers/net/wireless/iwl-base.c    |   13 ++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945-hw.h b/drivers/net/wireless/iwl-3945-hw.h
index 81c7263..8fdf9e0 100644
--- a/drivers/net/wireless/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwl-3945-hw.h
@@ -97,4 +97,8 @@ static inline u16 iwl_hw_get_rate_n_flags(__le16 rate_n_flags)
 	return le16_to_cpu(rate_n_flags);
 }
 
+static inline __le16 iwl_hw_set_rate_n_flags(u8 rate, u16 flags)
+{
+	return cpu_to_le16((u16)rate|flags);
+}
 #endif
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 683f07d..44fc2cb 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -382,7 +382,9 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 * bssid, int is_ap, u8 flags)
 	int index = IWL_INVALID_STATION;
 	struct iwl_station_entry *station;
 	unsigned long flags_spin;
-
+#if IWL == 3945
+	u8 rate;
+#endif
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	if (is_ap) {
 		index = IWL_AP_ID;
@@ -426,14 +428,15 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 * bssid, int is_ap, u8 flags)
 	station->sta.sta.sta_id = i;
 	station->sta.station_flags = 0;
 #if IWL == 3945
-	station->sta.rate_n_flags = cpu_to_le16(
-		(priv->phymode == MODE_IEEE80211A) ? IWL_RATE_6M_PLCP :
-			IWL_RATE_1M_PLCP | priv->hw_setting.cck_flag);
+	rate = (priv->phymode == MODE_IEEE80211A) ? IWL_RATE_6M_PLCP :
+			IWL_RATE_1M_PLCP | priv->hw_setting.cck_flag;
 
 	/* Turn on both antennas for the station... */
-	station->sta.rate_n_flags |= RATE_MCS_ANT_AB_MSK;
+	station->sta.rate_n_flags =
+			iwl_hw_set_rate_n_flags(rate, RATE_MCS_ANT_AB_MSK);
 
 	station->sta.station_flags |= STA_FLG_TX_RATE_MSK;
+
 	station->current_rate.rate_n_flags = le16_to_cpu(
 		station->sta.rate_n_flags);
 #endif
-- 
1.5.2
