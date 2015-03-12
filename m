Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbbCLNFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:52 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/49] iwlwifi: mvm: remove IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF
Date: Thu, 12 Mar 2015 15:04:07 +0200
Message-Id: <1426165474-25586-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_340396_12EE6DE8)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the supported firmwares support this API.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 2 --
 drivers/net/wireless/iwlwifi/mvm/sf.c      | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 489bda4..e5fd19d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -240,7 +240,6 @@ enum iwl_ucode_tlv_flag {
 /**
  * enum iwl_ucode_tlv_api - ucode api
  * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
- * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
@@ -258,7 +257,6 @@ enum iwl_ucode_tlv_flag {
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
-	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= BIT(9),
 	IWL_UCODE_TLV_API_HDC_PHASE_0		= BIT(10),
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index 7eb78e2..4b9f6c6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -179,8 +179,7 @@ static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 	struct ieee80211_sta *sta;
 	int ret = 0;
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF &&
-	    mvm->cfg->disable_dummy_notification)
+	if (mvm->cfg->disable_dummy_notification)
 		sf_cmd.state |= cpu_to_le32(SF_CFG_DUMMY_NOTIF_OFF);
 
 	/*
-- 
1.9.1

