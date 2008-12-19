Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYLSCo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:44:56 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/43] iwlwifi: 3945 remove current_rate from station entry.
Date: Fri, 19 Dec 2008 10:37:03 +0800
Message-Id: <1229654263-21454-4-git-send-email-yi.zhu@intel.com> (sfid-20081219_034501_738860_A257920E)
In-Reply-To: <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes current_rate from station_entry it was write only
variable

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   13 -------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    7 -------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 --
 3 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4690b93..1874422 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -832,7 +832,6 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 			      struct ieee80211_tx_info *info,
 			      struct ieee80211_hdr *hdr, int sta_id, int tx_id)
 {
-	unsigned long flags;
 	u16 hw_value = ieee80211_get_tx_rate(priv->hw, info)->hw_value;
 	u16 rate_index = min(hw_value & 0xffff, IWL_RATE_COUNT - 1);
 	u16 rate_mask;
@@ -849,17 +848,6 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 	 * in this running context */
 	rate_mask = IWL_RATES_MASK;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].current_rate.rate_n_flags = rate;
-
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
-	    (sta_id != priv->hw_setting.bcast_sta_id) &&
-		(sta_id != IWL_MULTICAST_ID))
-		priv->stations[IWL_STA_ID].current_rate.rate_n_flags = rate;
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
 	if (tx_id >= IWL_CMD_QUEUE_NUM)
 		rts_retry_limit = 3;
 	else
@@ -922,7 +910,6 @@ u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id, u16 tx_rate, u8 flags
 
 	station->sta.sta.modify_mask = STA_MODIFY_TX_RATE_MSK;
 	station->sta.rate_n_flags = cpu_to_le16(tx_rate);
-	station->current_rate.rate_n_flags = tx_rate;
 	station->sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index d8f40bd..d07aafe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -481,13 +481,6 @@ struct iwl3945_qos_info {
 struct iwl3945_station_entry {
 	struct iwl3945_addsta_cmd sta;
 	struct iwl3945_tid_data tid[MAX_TID_COUNT];
-	union {
-		struct {
-			u8 rate;
-			u8 flags;
-		} s;
-		u16 rate_n_flags;
-	} current_rate;
 	u8 used;
 	u8 ps_status;
 	struct iwl3945_hw_key keyinfo;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 17b8f52..5c09995 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -463,8 +463,6 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
 	/* Turn on both antennas for the station... */
 	station->sta.rate_n_flags =
 			iwl3945_hw_set_rate_n_flags(rate, RATE_MCS_ANT_AB_MSK);
-	station->current_rate.rate_n_flags =
-			le16_to_cpu(station->sta.rate_n_flags);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
-- 
1.5.3.6

