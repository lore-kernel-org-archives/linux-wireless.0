Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69BFC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2E062077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfCOQhP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:37:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44344 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729541AbfCOQhO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:37:14 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ppC-0004qp-Ri; Fri, 15 Mar 2019 18:36:51 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:30 +0200
Message-Id: <20190315163634.17315-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/16] iwlwifi: dbg: add DRAM monitor support for AX210 device family
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Allows to perform monitor dumping on AX210 device family

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  6 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  6 ++++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 29 +++++++++++++------
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 9b5077bd46c3..ea5513050b56 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -211,6 +211,9 @@ struct iwl_fw_error_dump_info {
  * @fw_mon_wr_ptr: the position of the write pointer in the cyclic buffer
  * @fw_mon_base_ptr: base pointer of the data
  * @fw_mon_cycle_cnt: number of wraparounds
+ * @fw_mon_base_high_ptr: used in AX210 devices, the base adderss is 64 bit
+ *	so fw_mon_base_ptr holds LSB 32 bits and fw_mon_base_high_ptr hold
+ *	MSB 32 bits
  * @reserved: for future use
  * @data: captured data
  */
@@ -218,7 +221,8 @@ struct iwl_fw_error_dump_fw_mon {
 	__le32 fw_mon_wr_ptr;
 	__le32 fw_mon_base_ptr;
 	__le32 fw_mon_cycle_cnt;
-	__le32 reserved[3];
+	__le32 fw_mon_base_high_ptr;
+	__le32 reserved[2];
 	u8 data[];
 } __packed;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 1af9f9e1ecd4..8e6a0c363c0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -368,6 +368,12 @@
 #define MON_BUFF_WRPTR_VER2		(0xa03c24)
 #define MON_BUFF_CYCLE_CNT_VER2		(0xa03c28)
 #define MON_BUFF_SHIFT_VER2		(0x8)
+/* FW monitor familiy AX210 and on */
+#define DBGC_CUR_DBGBUF_BASE_ADDR_LSB		(0xd03c20)
+#define DBGC_CUR_DBGBUF_BASE_ADDR_MSB		(0xd03c24)
+#define DBGC_CUR_DBGBUF_STATUS			(0xd03c1c)
+#define DBGC_DBGBUF_WRAP_AROUND			(0xd03c2c)
+#define DBGC_CUR_DBGBUF_STATUS_OFFSET_MSK	(0x00ffffff)
 
 #define MON_DMARB_RD_CTL_ADDR		(0xa03c60)
 #define MON_DMARB_RD_DATA_ADDR		(0xa03c5c)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index cd4fc7b4ccd8..2915840c8b95 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3012,10 +3012,14 @@ static void
 iwl_trans_pcie_dump_pointers(struct iwl_trans *trans,
 			     struct iwl_fw_error_dump_fw_mon *fw_mon_data)
 {
-	u32 base, write_ptr, wrap_cnt;
-
-	/* If there was a dest TLV - use the values from there */
-	if (trans->ini_valid) {
+	u32 base, base_high, write_ptr, write_ptr_val, wrap_cnt;
+
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
+		base = DBGC_CUR_DBGBUF_BASE_ADDR_LSB;
+		base_high = DBGC_CUR_DBGBUF_BASE_ADDR_MSB;
+		write_ptr = DBGC_CUR_DBGBUF_STATUS;
+		wrap_cnt = DBGC_DBGBUF_WRAP_AROUND;
+	} else if (trans->ini_valid) {
 		base = iwl_umac_prph(trans, MON_BUFF_BASE_ADDR_VER2);
 		write_ptr = iwl_umac_prph(trans, MON_BUFF_WRPTR_VER2);
 		wrap_cnt = iwl_umac_prph(trans, MON_BUFF_CYCLE_CNT_VER2);
@@ -3028,12 +3032,18 @@ iwl_trans_pcie_dump_pointers(struct iwl_trans *trans,
 		write_ptr = MON_BUFF_WRPTR;
 		wrap_cnt = MON_BUFF_CYCLE_CNT;
 	}
-	fw_mon_data->fw_mon_wr_ptr =
-		cpu_to_le32(iwl_read_prph(trans, write_ptr));
+
+	write_ptr_val = iwl_read_prph(trans, write_ptr);
 	fw_mon_data->fw_mon_cycle_cnt =
 		cpu_to_le32(iwl_read_prph(trans, wrap_cnt));
 	fw_mon_data->fw_mon_base_ptr =
 		cpu_to_le32(iwl_read_prph(trans, base));
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
+		fw_mon_data->fw_mon_base_high_ptr =
+			cpu_to_le32(iwl_read_prph(trans, base_high));
+		write_ptr_val &= DBGC_CUR_DBGBUF_STATUS_OFFSET_MSK;
+	}
+	fw_mon_data->fw_mon_wr_ptr = cpu_to_le32(write_ptr_val);
 }
 
 static u32
@@ -3044,9 +3054,10 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 	u32 len = 0;
 
 	if ((trans->num_blocks &&
-	     trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) ||
-	     (trans->dbg_dest_tlv && !trans->ini_valid) ||
-	     (trans->ini_valid && trans->num_blocks)) {
+	     (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000 ||
+	      trans->cfg->device_family >= IWL_DEVICE_FAMILY_AX210 ||
+	      trans->ini_valid)) ||
+	    (trans->dbg_dest_tlv && !trans->ini_valid)) {
 		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
 
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FW_MONITOR);
-- 
2.20.1

