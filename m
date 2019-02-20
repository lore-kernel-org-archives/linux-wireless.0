Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C48C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61BB9206DD
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfBTMEM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:12 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34522 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726953AbfBTMEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:11 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbh-000411-Nz; Wed, 20 Feb 2019 14:04:10 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:03:56 +0200
Message-Id: <20190220120400.8814-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220120400.8814-1-luca@coelho.fi>
References: <20190220120400.8814-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/8] iwlwifi: dbg_ini: add region to fill_header handler
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add iwl_fw_ini_region_cfg region struct to fill_header handler of
iwl_dump_ini_mem_ops. it is needed for future support in fifos dumping.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index b86691fdacb3..c9a63b2c6c9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1161,16 +1161,19 @@ iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
 	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
-static struct iwl_fw_ini_error_dump_range
-*iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt, void *data)
+static void *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt,
+					  struct iwl_fw_ini_region_cfg *reg,
+					  void *data)
 {
 	struct iwl_fw_ini_error_dump *dump = data;
 
 	return dump->ranges;
 }
 
-static struct iwl_fw_ini_error_dump_range
-*iwl_dump_ini_mon_dram_fill_header(struct iwl_fw_runtime *fwrt, void *data)
+static void
+*iwl_dump_ini_mon_dram_fill_header(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_region_cfg *reg,
+				   void *data)
 {
 	struct iwl_fw_ini_monitor_dram_dump *mon_dump = (void *)data;
 	u32 write_ptr, cycle_cnt;
@@ -1267,8 +1270,8 @@ static u32 iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
  * struct iwl_dump_ini_mem_ops - ini memory dump operations
  * @get_num_of_ranges: returns the number of memory ranges in the region.
  * @get_size: returns the total size of the region.
- * @fill_mem_hdr: fills region type specific headers and returns the first
- *	range or NULL if failed to fill headers.
+ * @fill_mem_hdr: fills region type specific headers and returns pointer to
+ *	the first range or NULL if failed to fill headers.
  * @fill_range: copies a given memory range into the dump.
  *	Returns the size of the range or -1 otherwise.
  */
@@ -1277,8 +1280,8 @@ struct iwl_dump_ini_mem_ops {
 				 struct iwl_fw_ini_region_cfg *reg);
 	u32 (*get_size)(struct iwl_fw_runtime *fwrt,
 			struct iwl_fw_ini_region_cfg *reg);
-	struct iwl_fw_ini_error_dump_range *
-		(*fill_mem_hdr)(struct iwl_fw_runtime *fwrt, void *data);
+	void *(*fill_mem_hdr)(struct iwl_fw_runtime *fwrt,
+			      struct iwl_fw_ini_region_cfg *reg, void *data);
 	int (*fill_range)(struct iwl_fw_runtime *fwrt,
 			  struct iwl_fw_ini_region_cfg *reg, void *range,
 			  int idx);
@@ -1315,7 +1318,7 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 					     le32_to_cpu(reg->name_len)));
 	memcpy(header->name, reg->name, le32_to_cpu(header->name_len));
 
-	range = ops->fill_mem_hdr(fwrt, header);
+	range = ops->fill_mem_hdr(fwrt, reg, header);
 	if (!range) {
 		IWL_ERR(fwrt, "Failed to fill region header: id=%d, type=%d\n",
 			le32_to_cpu(reg->region_id), type);
-- 
2.20.1

