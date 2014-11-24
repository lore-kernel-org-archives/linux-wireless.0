Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40855 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaKXOgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:05 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so6002808wiw.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:04 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/75] iwlwifi: mvm: declare TDLS support
Date: Mon, 24 Nov 2014 16:34:17 +0200
Message-Id: <1416839691-28533-41-git-send-email-egrumbach@gmail.com> (sfid-20141124_153623_783839_B8208BEA)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The driver/FW combination now support TDLS.
Check the FW support with the TLV bit.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h    | 3 ++-
 drivers/net/wireless/iwlwifi/iwl-fw.h       | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 0a70bcd..6842545 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -143,7 +143,7 @@ do {                                            			\
 #define IWL_DL_INFO		0x00000001
 #define IWL_DL_MAC80211		0x00000002
 #define IWL_DL_HCMD		0x00000004
-#define IWL_DL_STATE		0x00000008
+#define IWL_DL_TDLS		0x00000008
 /* 0x000000F0 - 0x00000010 */
 #define IWL_DL_QUOTA		0x00000010
 #define IWL_DL_TE		0x00000020
@@ -180,6 +180,7 @@ do {                                            			\
 #define IWL_DL_TX_QUEUES	0x80000000
 
 #define IWL_DEBUG_INFO(p, f, a...)	IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_TDLS(p, f, a...)	IWL_DEBUG(p, IWL_DL_TDLS, f, ## a)
 #define IWL_DEBUG_MAC80211(p, f, a...)	IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
 #define IWL_DEBUG_EXTERNAL(p, f, a...)	IWL_DEBUG(p, IWL_DL_EXTERNAL, f, ## a)
 #define IWL_DEBUG_TEMP(p, f, a...)	IWL_DEBUG(p, IWL_DL_TEMP, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 133022a..78d3e5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -146,6 +146,7 @@ enum iwl_ucode_tlv_api {
  * enum iwl_ucode_tlv_capa - ucode capabilities
  * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
  * @IWL_UCODE_TLV_CAPA_UMAC_SCAN: supports UMAC scan.
+ * @IWL_UCODE_TLV_CAPA_TDLS_SUPPORT: support basic TDLS functionality
  * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
  *	tx power value into TPC Report action frame and Link Measurement Report
  *	action frame
@@ -160,6 +161,7 @@ enum iwl_ucode_tlv_api {
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
 	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= BIT(2),
+	IWL_UCODE_TLV_CAPA_TDLS_SUPPORT			= BIT(6),
 	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
 	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
 	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 08976c3..801abcf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -490,6 +490,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (ret)
 		return ret;
 
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_TDLS_SUPPORT) {
+		IWL_DEBUG_TDLS(mvm, "TDLS supported\n");
+		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+	}
+
 	ret = ieee80211_register_hw(mvm->hw);
 	if (ret)
 		iwl_mvm_leds_exit(mvm);
-- 
1.9.1

