Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53192 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758179AbdJMNZT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:24:59 +0300
Message-Id: <20171013132502.10473-7-luca@coelho.fi> (sfid-20171013_152606_493539_E8C66335)
In-Reply-To: <20171013132502.10473-1-luca@coelho.fi>
References: <20171013132502.10473-1-luca@coelho.fi>
Subject: [PATCH 6/9] iwlwifi: define minimum valid address for umac_error_event_table in cfg
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We now have two different minimum valid values for
umac_error_event_table.  To avoid hardcoding the minimum value in the
driver, add a value to cfg where it can be read from.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c   |  3 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c   |  3 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c   |  3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 17 +++++++++++------
 5 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index 2e6c52664cee..32d6aa25b9a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -165,7 +165,8 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.thermal_params = &iwl8000_tt_params,				\
 	.apmg_not_supported = true,					\
 	.ext_nvm = true,						\
-	.dbgc_supported = true
+	.dbgc_supported = true,						\
+	.min_umac_error_event_table = 0x800000
 
 #define IWL_DEVICE_8000							\
 	IWL_DEVICE_8000_COMMON,						\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 2babe0a1f18b..94d717bffbbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -149,7 +149,8 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.mac_addr_from_csr = true,					\
 	.rf_id = true,							\
 	.ext_nvm = true,						\
-	.dbgc_supported = true
+	.dbgc_supported = true,						\
+	.min_umac_error_event_table = 0x800000
 
 const struct iwl_cfg iwl9160_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9160",
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index 076f8d6d1124..f27eeba3c87c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
@@ -135,7 +135,8 @@ static const struct iwl_ht_params iwl_a000_ht_params = {
 	.gen2 = true,							\
 	.ext_nvm = true,						\
 	.dbgc_supported = true,						\
-	.tx_cmd_queue_size = 32
+	.tx_cmd_queue_size = 32,					\
+	.min_umac_error_event_table = 0x400000
 
 const struct iwl_cfg iwla000_2ac_cfg_hr = {
 	.name = "Intel(R) Dual Band Wireless AC a000",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index b9f3b350fe34..175bab54df7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -384,6 +384,7 @@ struct iwl_cfg {
 	u8 max_vht_ampdu_exponent;
 	u8 ucode_api_max;
 	u8 ucode_api_min;
+	u32 min_umac_error_event_table;
 };
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 70d0505a176e..0296df625cd5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -176,6 +176,7 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_lmac_alive *lmac1;
 	struct iwl_lmac_alive *lmac2 = NULL;
 	u16 status;
+	u32 umac_error_event_table;
 
 	if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive)) {
 		palive = (void *)pkt->data;
@@ -198,18 +199,22 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	mvm->sf_space.addr = le32_to_cpu(lmac1->st_fwrd_addr);
 	mvm->sf_space.size = le32_to_cpu(lmac1->st_fwrd_size);
 
-	mvm->umac_error_event_table = le32_to_cpu(umac->error_info_addr);
+	umac_error_event_table = le32_to_cpu(umac->error_info_addr);
 
-	if (mvm->umac_error_event_table <
-	    (mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_A000 ?
-	     0x400000 : 0x800000))
+	if (!umac_error_event_table) {
+		mvm->support_umac_log = false;
+	} else if (umac_error_event_table >=
+		   mvm->trans->cfg->min_umac_error_event_table) {
+		mvm->support_umac_log = true;
+		mvm->umac_error_event_table = umac_error_event_table;
+	} else {
 		IWL_ERR(mvm,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			mvm->umac_error_event_table,
 			(mvm->fwrt.cur_fw_img == IWL_UCODE_INIT) ?
 			"Init" : "RT");
-	else
-		mvm->support_umac_log = true;
+		mvm->support_umac_log = false;
+	}
 
 	alive_data->scd_base_addr = le32_to_cpu(lmac1->scd_base_ptr);
 	alive_data->valid = status == IWL_ALIVE_STATUS_OK;
-- 
2.14.2
