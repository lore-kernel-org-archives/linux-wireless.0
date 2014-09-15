Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65071 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:10 -0400
Received: by mail-wg0-f42.google.com with SMTP id x12so3188678wgg.13
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/28] iwlwifi: mvm: allow preventing dummy notifications
Date: Mon, 15 Sep 2014 08:12:35 +0300
Message-Id: <1410757980-2138-3-git-send-email-egrumbach@gmail.com> (sfid-20140915_071316_972590_314EF9E8)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The firwmare now allows the driver to disable dummy
notifications. These notifications sent by the firmware
are an overhead for slow buses. They are still useful for
fast buses.
Add a hardware switch to prevent these notifications only
on devices that work on slow buses.

Signed-off-by: Eran <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 1 +
 drivers/net/wireless/iwlwifi/iwl-config.h | 1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h     | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/sf.c     | 4 ++++
 5 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 3c576ee..c1ef165 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -144,6 +144,7 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
+	.disable_dummy_notification = true,
 };
 
 MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 1b9c77d..687e9e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -282,6 +282,7 @@ struct iwl_cfg {
 	bool no_power_up_nic_in_init;
 	const char *default_nvm_file;
 	unsigned int max_rx_agg_size;
+	bool disable_dummy_notification;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index f68cba4..62c46eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -127,6 +127,7 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
  * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
  * @IWL_UCODE_TLV_API_LMAC_SCAN: This ucode uses LMAC unified scan API.
+ * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
  */
@@ -137,6 +138,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
 	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
 	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
+	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 541b844..b599b52 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1601,6 +1601,8 @@ enum iwl_sf_scenario {
 
 #define SF_LONG_DELAY_AGING_TIMER 1000000	/* 1 Sec */
 
+#define SF_CFG_DUMMY_NOTIF_OFF	BIT(16)
+
 /**
  * Smart Fifo configuration command.
  * @state: smart fifo state, types listed in enum %iwl_sf_sate.
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index f88410c..7eb78e2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -179,6 +179,10 @@ static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 	struct ieee80211_sta *sta;
 	int ret = 0;
 
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF &&
+	    mvm->cfg->disable_dummy_notification)
+		sf_cmd.state |= cpu_to_le32(SF_CFG_DUMMY_NOTIF_OFF);
+
 	/*
 	 * If an associated AP sta changed its antenna configuration, the state
 	 * will remain FULL_ON but SF parameters need to be reconsidered.
-- 
1.9.1

