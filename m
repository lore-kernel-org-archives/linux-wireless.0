Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbbAVUdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/38] iwlwifi: remove unused TLV capability flags
Date: Thu, 22 Jan 2015 22:33:02 +0200
Message-Id: <1421958809-3371-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213405_270879_6829C83B)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver doesn't support the firmwares that don't have
these capabilities. The code that actually used these
flags has been removed already, but the flags were left
for an unclear reason. Remove them.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 752c72b..731f1db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -235,10 +235,7 @@ enum iwl_ucode_tlv_flag {
 
 /**
  * enum iwl_ucode_tlv_api - ucode api
- * @IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID: wowlan config includes tid field.
- * @IWL_UCODE_TLV_CAPA_EXTENDED_BEACON: Support Extended beacon notification
  * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
- * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
  * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
  * @IWL_UCODE_TLV_API_LMAC_SCAN: This ucode uses LMAC unified scan API.
  * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
@@ -246,10 +243,7 @@ enum iwl_ucode_tlv_flag {
  *	longer than the passive one, which is essential for fragmented scan.
  */
 enum iwl_ucode_tlv_api {
-	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
-	IWL_UCODE_TLV_CAPA_EXTENDED_BEACON	= BIT(1),
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
-	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
 	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
 	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
-- 
1.9.1

