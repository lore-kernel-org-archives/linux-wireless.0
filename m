Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33827 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaKWT5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 14:57:32 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so10577823wgh.6
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2014 11:57:30 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: mvm: check TLV flag before trying to use hotspot firmware commands
Date: Sun, 23 Nov 2014 21:57:19 +0200
Message-Id: <1416772640-22908-1-git-send-email-egrumbach@gmail.com> (sfid-20141123_205736_107723_858689F6)
In-Reply-To: <54723BE7.6040607@gmail.com>
References: <54723BE7.6040607@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Older firmwares do not provide support for the HOT_SPOT_CMD command.
Check for the appropriate TLV flag that declares hotspot support in
the firmware to prevent a firmware assertion failure that can be
triggered from the userspace,

Cc: stable@vger.kernel.org [3.17+]
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |  2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 4f6e668..b894a84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -155,6 +155,7 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
  * @IWL_UCODE_TLV_CAPA_DQA_SUPPORT: supports dynamic queue allocation (DQA),
  *	which also implies support for the scheduler configuration command
+ * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
@@ -163,6 +164,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
 	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
 	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= BIT(12),
+	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b624058..b6d2683 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2448,9 +2448,15 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		/* Use aux roc framework (HS20) */
-		ret = iwl_mvm_send_aux_roc_cmd(mvm, channel,
-					       vif, duration);
+		if (mvm->fw->ucode_capa.capa[0] &
+		    IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT) {
+			/* Use aux roc framework (HS20) */
+			ret = iwl_mvm_send_aux_roc_cmd(mvm, channel,
+						       vif, duration);
+			goto out_unlock;
+		}
+		IWL_ERR(mvm, "hotspot not supported\n");
+		ret = -EINVAL;
 		goto out_unlock;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* handle below */
-- 
1.9.1

