Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbHRH6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/26] iwlwifi: mvm: set different pm_timeout for action frames
Date: Tue, 18 Aug 2015 10:57:22 +0300
Message-Id: <1439884656-18146-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095815_344116_A237AC77)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

When building a Tx Command for management frames, we are lacking
a check for action frames, for which we should set a different
pm_timeout.  This cause the fw to stay awake for 100TU after each
such frame is transmitted, resulting an excessive power consumption.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h | 12 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/tx.c        | 10 ++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index 81c4ea3..853698a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -124,6 +124,18 @@ enum iwl_tx_flags {
 	TX_CMD_FLG_HCCA_CHUNK		= BIT(31)
 }; /* TX_FLAGS_BITS_API_S_VER_1 */
 
+/**
+ * enum iwl_tx_pm_timeouts - pm timeout values in TX command
+ * @PM_FRAME_NONE: no need to suspend sleep mode
+ * @PM_FRAME_MGMT: fw suspend sleep mode for 100TU
+ * @PM_FRAME_ASSOC: fw suspend sleep mode for 10sec
+ */
+enum iwl_tx_pm_timeouts {
+	PM_FRAME_NONE		= 0,
+	PM_FRAME_MGMT		= 2,
+	PM_FRAME_ASSOC		= 3,
+};
+
 /*
  * TX command security control
  */
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 15bf36a..6df5aad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -153,18 +153,20 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	if (ieee80211_is_mgmt(fc)) {
 		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
-			tx_cmd->pm_frame_timeout = cpu_to_le16(3);
+			tx_cmd->pm_frame_timeout = cpu_to_le16(PM_FRAME_ASSOC);
+		else if (ieee80211_is_action(fc))
+			tx_cmd->pm_frame_timeout = cpu_to_le16(PM_FRAME_NONE);
 		else
-			tx_cmd->pm_frame_timeout = cpu_to_le16(2);
+			tx_cmd->pm_frame_timeout = cpu_to_le16(PM_FRAME_MGMT);
 
 		/* The spec allows Action frames in A-MPDU, we don't support
 		 * it
 		 */
 		WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_AMPDU);
 	} else if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO) {
-		tx_cmd->pm_frame_timeout = cpu_to_le16(2);
+		tx_cmd->pm_frame_timeout = cpu_to_le16(PM_FRAME_MGMT);
 	} else {
-		tx_cmd->pm_frame_timeout = 0;
+		tx_cmd->pm_frame_timeout = cpu_to_le16(PM_FRAME_NONE);
 	}
 
 	if (ieee80211_is_data(fc) && len > mvm->rts_threshold &&
-- 
2.1.4

