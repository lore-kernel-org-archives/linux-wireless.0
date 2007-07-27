Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50879 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762418AbXG0J3A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 08/17] iwlwifi: QoS control endianity fixes
Date: Fri, 27 Jul 2007 17:26:32 +0800
Message-Id: <11855284161716-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284142478-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes endianity issues in accessing QoS control field

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c    |    4 ++--
 drivers/net/wireless/iwl-base.c    |    4 ++--
 drivers/net/wireless/iwl-helpers.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 03e3708..5586b4c 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -3236,7 +3236,7 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	int rate_index = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
 #ifdef CONFIG_IWLWIFI_HT
 #ifdef CONFIG_IWLWIFI_HT_AGG
-	u16 *qc;
+	__le16 *qc;
 #endif /*CONFIG_IWLWIFI_HT_AGG */
 #endif /* CONFIG_IWLWIFI_HT */
 
@@ -3308,7 +3308,7 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	if (qc &&
 	    (priv->iw_mode != IEEE80211_IF_TYPE_IBSS)) {
 		u8 tid = 0;
-		tid = (u8) (*qc & 0xF);
+		tid = (u8) (le16_to_cpu(*qc) & 0xF);
 		if (tid < TID_MAX_LOAD_COUNT)
 			iwl4965_tl_add_packet(priv, tid);
 	}
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 95e8ead..1adcdbe 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -2650,7 +2650,7 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 {
 	u32 tx_flags;
 	u16 fc = le16_to_cpu(hdr->frame_control);
-	u16 *qc;
+	__le16 *qc;
 
 	tx_flags = cmd->cmd.tx.tx_flags;
 
@@ -2673,7 +2673,7 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 
 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc) {
-		cmd->cmd.tx.tid_tspec = (u8) (*qc & 0xf);
+		cmd->cmd.tx.tid_tspec = (u8) (le16_to_cpu(*qc) & 0xf);
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
diff --git a/drivers/net/wireless/iwl-helpers.h b/drivers/net/wireless/iwl-helpers.h
index c9ceff6..94dbb38 100644
--- a/drivers/net/wireless/iwl-helpers.h
+++ b/drivers/net/wireless/iwl-helpers.h
@@ -181,7 +181,7 @@ static inline __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	int hdr_len = ieee80211_get_hdrlen(fc);
 	if ( (fc & 0x00cc) == (IEEE80211_STYPE_QOS_DATA|IEEE80211_FTYPE_DATA))
-		return (u16 *) ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
+		return (__le16 *) ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
 	return NULL;
 }
 
-- 
1.5.2
