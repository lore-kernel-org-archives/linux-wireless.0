Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38042 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753318AbdBCOkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:40:55 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:57 +0200
Message-Id: <20170203143812.7525-11-luca@coelho.fi> (sfid-20170203_154124_523963_7446186E)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: mvm: support new alive notification
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Support getting alive from two LMACs and dumping debug
data from both.
Deprecate older alive notifications no one is using.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  72 ++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 104 +++++++++---------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c  |  12 ++-
 5 files changed, 67 insertions(+), 125 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 207d8ae1e116..b02d7fc5116f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1741,7 +1741,7 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 static struct iwl_wowlan_status *
 iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
-	u32 base = mvm->error_event_table;
+	u32 base = mvm->error_event_table[0];
 	struct error_table_start {
 		/* cf. struct iwl_error_event_table */
 		u32 valid;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 91f53596130b..cf2b836f3888 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -598,60 +598,7 @@ enum {
 
 #define IWL_ALIVE_FLG_RFKILL	BIT(0)
 
-struct mvm_alive_resp_ver1 {
-	__le16 status;
-	__le16 flags;
-	u8 ucode_minor;
-	u8 ucode_major;
-	__le16 id;
-	u8 api_minor;
-	u8 api_major;
-	u8 ver_subtype;
-	u8 ver_type;
-	u8 mac;
-	u8 opt;
-	__le16 reserved2;
-	__le32 timestamp;
-	__le32 error_event_table_ptr;	/* SRAM address for error log */
-	__le32 log_event_table_ptr;	/* SRAM address for event log */
-	__le32 cpu_register_ptr;
-	__le32 dbgm_config_ptr;
-	__le32 alive_counter_ptr;
-	__le32 scd_base_ptr;		/* SRAM address for SCD */
-} __packed; /* ALIVE_RES_API_S_VER_1 */
-
-struct mvm_alive_resp_ver2 {
-	__le16 status;
-	__le16 flags;
-	u8 ucode_minor;
-	u8 ucode_major;
-	__le16 id;
-	u8 api_minor;
-	u8 api_major;
-	u8 ver_subtype;
-	u8 ver_type;
-	u8 mac;
-	u8 opt;
-	__le16 reserved2;
-	__le32 timestamp;
-	__le32 error_event_table_ptr;	/* SRAM address for error log */
-	__le32 log_event_table_ptr;	/* SRAM address for LMAC event log */
-	__le32 cpu_register_ptr;
-	__le32 dbgm_config_ptr;
-	__le32 alive_counter_ptr;
-	__le32 scd_base_ptr;		/* SRAM address for SCD */
-	__le32 st_fwrd_addr;		/* pointer to Store and forward */
-	__le32 st_fwrd_size;
-	u8 umac_minor;			/* UMAC version: minor */
-	u8 umac_major;			/* UMAC version: major */
-	__le16 umac_id;			/* UMAC version: id */
-	__le32 error_info_addr;		/* SRAM address for UMAC error log */
-	__le32 dbg_print_buff_addr;
-} __packed; /* ALIVE_RES_API_S_VER_2 */
-
-struct mvm_alive_resp {
-	__le16 status;
-	__le16 flags;
+struct iwl_lmac_alive {
 	__le32 ucode_minor;
 	__le32 ucode_major;
 	u8 ver_subtype;
@@ -667,12 +614,29 @@ struct mvm_alive_resp {
 	__le32 scd_base_ptr;		/* SRAM address for SCD */
 	__le32 st_fwrd_addr;		/* pointer to Store and forward */
 	__le32 st_fwrd_size;
+} __packed; /* UCODE_ALIVE_NTFY_API_S_VER_3 */
+
+struct iwl_umac_alive {
 	__le32 umac_minor;		/* UMAC version: minor */
 	__le32 umac_major;		/* UMAC version: major */
 	__le32 error_info_addr;		/* SRAM address for UMAC error log */
 	__le32 dbg_print_buff_addr;
+} __packed; /* UMAC_ALIVE_DATA_API_S_VER_2 */
+
+struct mvm_alive_resp_v3 {
+	__le16 status;
+	__le16 flags;
+	struct iwl_lmac_alive lmac_data;
+	struct iwl_umac_alive umac_data;
 } __packed; /* ALIVE_RES_API_S_VER_3 */
 
+struct mvm_alive_resp {
+	__le16 status;
+	__le16 flags;
+	struct iwl_lmac_alive lmac_data[2];
+	struct iwl_umac_alive umac_data;
+} __packed; /* ALIVE_RES_API_S_VER_4 */
+
 /* Error response/notification */
 enum {
 	FW_ERR_UNKNOWN_CMD = 0x0,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 3c70fb1199d7..8fd3c2b12ea2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -444,80 +444,52 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_mvm *mvm =
 		container_of(notif_wait, struct iwl_mvm, notif_wait);
 	struct iwl_mvm_alive_data *alive_data = data;
-	struct mvm_alive_resp_ver1 *palive1;
-	struct mvm_alive_resp_ver2 *palive2;
+	struct mvm_alive_resp_v3 *palive3;
 	struct mvm_alive_resp *palive;
+	struct iwl_umac_alive *umac;
+	struct iwl_lmac_alive *lmac1;
+	struct iwl_lmac_alive *lmac2 = NULL;
+	u16 status;
 
-	if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive1)) {
-		palive1 = (void *)pkt->data;
+	if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive)) {
+		palive = (void *)pkt->data;
+		umac = &palive->umac_data;
+		lmac1 = &palive->lmac_data[0];
+		lmac2 = &palive->lmac_data[1];
+		status = le16_to_cpu(palive->status);
+	} else {
+		palive3 = (void *)pkt->data;
+		umac = &palive3->umac_data;
+		lmac1 = &palive3->lmac_data;
+		status = le16_to_cpu(palive3->status);
+	}
 
-		mvm->support_umac_log = false;
-		mvm->error_event_table =
-			le32_to_cpu(palive1->error_event_table_ptr);
-		mvm->log_event_table =
-			le32_to_cpu(palive1->log_event_table_ptr);
-		alive_data->scd_base_addr = le32_to_cpu(palive1->scd_base_ptr);
+	mvm->error_event_table[0] = le32_to_cpu(lmac1->error_event_table_ptr);
+	if (lmac2)
+		mvm->error_event_table[1] =
+			le32_to_cpu(lmac2->error_event_table_ptr);
+	mvm->log_event_table = le32_to_cpu(lmac1->log_event_table_ptr);
+	mvm->sf_space.addr = le32_to_cpu(lmac1->st_fwrd_addr);
+	mvm->sf_space.size = le32_to_cpu(lmac1->st_fwrd_size);
 
-		alive_data->valid = le16_to_cpu(palive1->status) ==
-				    IWL_ALIVE_STATUS_OK;
-		IWL_DEBUG_FW(mvm,
-			     "Alive VER1 ucode status 0x%04x revision 0x%01X 0x%01X flags 0x%01X\n",
-			     le16_to_cpu(palive1->status), palive1->ver_type,
-			     palive1->ver_subtype, palive1->flags);
-	} else if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive2)) {
-		palive2 = (void *)pkt->data;
-
-		mvm->error_event_table =
-			le32_to_cpu(palive2->error_event_table_ptr);
-		mvm->log_event_table =
-			le32_to_cpu(palive2->log_event_table_ptr);
-		alive_data->scd_base_addr = le32_to_cpu(palive2->scd_base_ptr);
-		mvm->umac_error_event_table =
-			le32_to_cpu(palive2->error_info_addr);
-		mvm->sf_space.addr = le32_to_cpu(palive2->st_fwrd_addr);
-		mvm->sf_space.size = le32_to_cpu(palive2->st_fwrd_size);
-
-		alive_data->valid = le16_to_cpu(palive2->status) ==
-				    IWL_ALIVE_STATUS_OK;
-		if (mvm->umac_error_event_table)
-			mvm->support_umac_log = true;
+	mvm->umac_error_event_table = le32_to_cpu(umac->error_info_addr);
 
-		IWL_DEBUG_FW(mvm,
-			     "Alive VER2 ucode status 0x%04x revision 0x%01X 0x%01X flags 0x%01X\n",
-			     le16_to_cpu(palive2->status), palive2->ver_type,
-			     palive2->ver_subtype, palive2->flags);
+	alive_data->scd_base_addr = le32_to_cpu(lmac1->scd_base_ptr);
+	alive_data->valid = status == IWL_ALIVE_STATUS_OK;
+	if (mvm->umac_error_event_table)
+		mvm->support_umac_log = true;
 
-		IWL_DEBUG_FW(mvm,
-			     "UMAC version: Major - 0x%x, Minor - 0x%x\n",
-			     palive2->umac_major, palive2->umac_minor);
-	} else if (iwl_rx_packet_payload_len(pkt) == sizeof(*palive)) {
-		palive = (void *)pkt->data;
-
-		mvm->error_event_table =
-			le32_to_cpu(palive->error_event_table_ptr);
-		mvm->log_event_table =
-			le32_to_cpu(palive->log_event_table_ptr);
-		alive_data->scd_base_addr = le32_to_cpu(palive->scd_base_ptr);
-		mvm->umac_error_event_table =
-			le32_to_cpu(palive->error_info_addr);
-		mvm->sf_space.addr = le32_to_cpu(palive->st_fwrd_addr);
-		mvm->sf_space.size = le32_to_cpu(palive->st_fwrd_size);
-
-		alive_data->valid = le16_to_cpu(palive->status) ==
-				    IWL_ALIVE_STATUS_OK;
-		if (mvm->umac_error_event_table)
-			mvm->support_umac_log = true;
+	IWL_DEBUG_FW(mvm,
+		     "Alive ucode status 0x%04x revision 0x%01X 0x%01X\n",
+		     status, lmac1->ver_type, lmac1->ver_subtype);
 
-		IWL_DEBUG_FW(mvm,
-			     "Alive VER3 ucode status 0x%04x revision 0x%01X 0x%01X flags 0x%01X\n",
-			     le16_to_cpu(palive->status), palive->ver_type,
-			     palive->ver_subtype, palive->flags);
+	if (lmac2)
+		IWL_DEBUG_FW(mvm, "Alive ucode CDB\n");
 
-		IWL_DEBUG_FW(mvm,
-			     "UMAC version: Major - 0x%x, Minor - 0x%x\n",
-			     le32_to_cpu(palive->umac_major),
-			     le32_to_cpu(palive->umac_minor));
-	}
+	IWL_DEBUG_FW(mvm,
+		     "UMAC version: Major - 0x%x, Minor - 0x%x\n",
+		     le32_to_cpu(umac->umac_major),
+		     le32_to_cpu(umac->umac_minor));
 
 	return true;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 37a4a980beee..73a216524af2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -741,7 +741,7 @@ struct iwl_mvm {
 	bool ucode_loaded;
 	bool hw_registered;
 	bool calibrating;
-	u32 error_event_table;
+	u32 error_event_table[2];
 	u32 log_event_table;
 	u32 umac_error_event_table;
 	bool support_umac_log;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 26b853ef195f..eb3434c0d148 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -497,13 +497,11 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 	IWL_ERR(mvm, "0x%08X | isr status reg\n", table.nic_isr_pref);
 }
 
-void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
+static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 {
 	struct iwl_trans *trans = mvm->trans;
 	struct iwl_error_event_table table;
-	u32 base;
 
-	base = mvm->error_event_table;
 	if (mvm->cur_ucode == IWL_UCODE_INIT) {
 		if (!base)
 			base = mvm->fw->init_errlog_ptr;
@@ -574,6 +572,14 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 	IWL_ERR(mvm, "0x%08X | lmpm_pmg_sel\n", table.lmpm_pmg_sel);
 	IWL_ERR(mvm, "0x%08X | timestamp\n", table.u_timestamp);
 	IWL_ERR(mvm, "0x%08X | flow_handler\n", table.flow_handler);
+}
+
+void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
+{
+	iwl_mvm_dump_lmac_error_log(mvm, mvm->error_event_table[0]);
+
+	if (mvm->error_event_table[1])
+		iwl_mvm_dump_lmac_error_log(mvm, mvm->error_event_table[1]);
 
 	if (mvm->support_umac_log)
 		iwl_mvm_dump_umac_error_log(mvm);
-- 
2.11.0
