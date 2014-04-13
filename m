Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33593 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbaDMTUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:54 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so3135261wiv.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:53 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_NEWBT_COEX TLV flag
Date: Sun, 13 Apr 2014 22:19:44 +0300
Message-Id: <1397416802-32403-29-git-send-email-egrumbach@gmail.com> (sfid-20140413_213517_614065_B137E9D1)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h   | 1 -
 drivers/net/wireless/iwlwifi/mvm/coex.c | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index f7ea9c0..9cb4ad9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -107,7 +107,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_MFP			= BIT(2),
 	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
-	IWL_UCODE_TLV_FLAGS_NEWBT_COEX		= BIT(5),
 	IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT	= BIT(6),
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
 	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 4bd47c9..92a005c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -106,9 +106,6 @@ static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 
 int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
 {
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
-		return 0;
-
 	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, CMD_SYNC,
 				    sizeof(struct iwl_bt_coex_prio_tbl_cmd),
 				    &iwl_bt_prio_tbl);
@@ -573,9 +570,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	int ret;
 	u32 flags;
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
-		return 0;
-
 	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
 	if (!bt_cmd)
 		return -ENOMEM;
@@ -1260,9 +1254,6 @@ u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 
 void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
 {
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
-		return;
-
 	iwl_mvm_bt_coex_notif_handle(mvm);
 }
 
-- 
1.8.3.2

