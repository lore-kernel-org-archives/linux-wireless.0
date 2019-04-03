Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDE0C10F0B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67DF20830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfDCJWk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:22:40 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49734 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726549AbfDCJWj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:22:39 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6N-0007aR-Rq; Wed, 03 Apr 2019 12:22:36 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:17 +0300
Message-Id: <20190403092224.815-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/13] iwlwifi: dbg_ini: add debug prints to the ini flows
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add debug prints to the ini flow and rewrite existing prints to provide
more information

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 102 ++++++++++++++----
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   2 +
 3 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index ad8a5411212e..ba01e8f5e2e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1685,6 +1685,9 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 		    !ops->fill_mem_hdr || !ops->fill_range))
 		return;
 
+	IWL_DEBUG_FW(fwrt, "WRT: collecting region: id=%d, type=%d\n",
+		     le32_to_cpu(reg->region_id), type);
+
 	num_of_ranges = ops->get_num_of_ranges(fwrt, reg);
 
 	(*data)->type = cpu_to_le32(type | INI_DUMP_BIT);
@@ -1698,7 +1701,8 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 
 	range = ops->fill_mem_hdr(fwrt, reg, header);
 	if (!range) {
-		IWL_ERR(fwrt, "Failed to fill region header: id=%d, type=%d\n",
+		IWL_ERR(fwrt,
+			"WRT: failed to fill region header: id=%d, type=%d\n",
 			le32_to_cpu(reg->region_id), type);
 		return;
 	}
@@ -1707,7 +1711,8 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 		int range_size = ops->fill_range(fwrt, reg, range, i);
 
 		if (range_size < 0) {
-			IWL_ERR(fwrt, "Failed to dump region: id=%d, type=%d\n",
+			IWL_ERR(fwrt,
+				"WRT: failed to dump region: id=%d, type=%d\n",
 				le32_to_cpu(reg->region_id), type);
 			return;
 		}
@@ -1732,8 +1737,12 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			continue;
 
 		reg = fwrt->dump.active_regs[reg_id];
-		if (WARN(!reg, "Unassigned region %d\n", reg_id))
+		if (!reg) {
+			IWL_WARN(fwrt,
+				 "WRT: unassigned region id %d, skipping\n",
+				 reg_id);
 			continue;
+		}
 
 		switch (le32_to_cpu(reg->region_type)) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
@@ -2110,6 +2119,12 @@ int _iwl_fw_dbg_ini_collect(struct iwl_fw_runtime *fwrt,
 	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
 		return -EBUSY;
 
+	if (!iwl_fw_ini_trigger_on(fwrt, id)) {
+		IWL_WARN(fwrt, "WRT: Trigger %d is not active, aborting dump\n",
+			 id);
+		return -EINVAL;
+	}
+
 	active = &fwrt->dump.active_trigs[id];
 	delay = le32_to_cpu(active->trig->dump_delay);
 	occur = le32_to_cpu(active->trig->occurrences);
@@ -2119,14 +2134,14 @@ int _iwl_fw_dbg_ini_collect(struct iwl_fw_runtime *fwrt,
 	active->trig->occurrences = cpu_to_le32(--occur);
 
 	if (le32_to_cpu(active->trig->force_restart)) {
-		IWL_WARN(fwrt, "Force restart: trigger %d fired.\n", id);
+		IWL_WARN(fwrt, "WRT: force restart: trigger %d fired.\n", id);
 		iwl_force_nmi(fwrt->trans);
 		return 0;
 	}
 
 	fwrt->dump.ini_trig_id = id;
 
-	IWL_WARN(fwrt, "Collecting data: ini trigger %d fired.\n", id);
+	IWL_WARN(fwrt, "WRT: collecting data: ini trigger %d fired.\n", id);
 
 	schedule_delayed_work(&fwrt->dump.wk, usecs_to_jiffies(delay));
 
@@ -2264,12 +2279,12 @@ void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt)
 
 	iwl_fw_dbg_stop_recording(fwrt, &params);
 
-	IWL_DEBUG_INFO(fwrt, "WRT dump start\n");
+	IWL_DEBUG_FW_INFO(fwrt, "WRT: data collection start\n");
 	if (fwrt->trans->ini_valid)
 		iwl_fw_error_ini_dump(fwrt);
 	else
 		iwl_fw_error_dump(fwrt);
-	IWL_DEBUG_INFO(fwrt, "WRT dump done\n");
+	IWL_DEBUG_FW_INFO(fwrt, "WRT: data collection done\n");
 
 	/* start recording again if the firmware is not crashed */
 	if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
@@ -2339,12 +2354,14 @@ iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt, u32 size)
 	if (!virtual_addr)
 		IWL_ERR(fwrt, "Failed to allocate debug memory\n");
 
+	IWL_DEBUG_FW(trans,
+		     "Allocated DRAM buffer[%d], address=0x%llx, size=0x%x\n",
+		     trans->num_blocks, phys_addr, size);
+
 	trans->fw_mon[trans->num_blocks].block = virtual_addr;
 	trans->fw_mon[trans->num_blocks].physical = phys_addr;
 	trans->fw_mon[trans->num_blocks].size = size;
 	trans->num_blocks++;
-
-	IWL_DEBUG_FW(trans, "Allocated debug block of size %d\n", size);
 }
 
 static void iwl_fw_dbg_buffer_apply(struct iwl_fw_runtime *fwrt,
@@ -2367,11 +2384,15 @@ static void iwl_fw_dbg_buffer_apply(struct iwl_fw_runtime *fwrt,
 
 	if (buf_location == IWL_FW_INI_LOCATION_SRAM_PATH) {
 		if (!WARN(pnt != IWL_FW_INI_APPLY_EARLY,
-			  "Invalid apply point %d for SMEM buffer allocation",
-			  pnt))
+			  "WRT: Invalid apply point %d for SMEM buffer allocation, aborting\n",
+			  pnt)) {
+			IWL_DEBUG_FW(trans,
+				     "WRT: applying SMEM buffer destination\n");
+
 			/* set sram monitor by enabling bit 7 */
 			iwl_set_bit(fwrt->trans, CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_BIT_MONITOR_SRAM);
+		}
 		return;
 	}
 
@@ -2390,6 +2411,9 @@ static void iwl_fw_dbg_buffer_apply(struct iwl_fw_runtime *fwrt,
 	if (trans->num_blocks == 1)
 		return;
 
+	IWL_DEBUG_FW(trans,
+		     "WRT: applying DRAM buffer[%d] destination\n", block_idx);
+
 	cmd->num_frags = cpu_to_le32(1);
 	cmd->fragments[0].address =
 		cpu_to_le64(trans->fw_mon[block_idx].physical);
@@ -2401,7 +2425,8 @@ static void iwl_fw_dbg_buffer_apply(struct iwl_fw_runtime *fwrt,
 }
 
 static void iwl_fw_dbg_send_hcmd(struct iwl_fw_runtime *fwrt,
-				 struct iwl_ucode_tlv *tlv)
+				 struct iwl_ucode_tlv *tlv,
+				 bool ext)
 {
 	struct iwl_fw_ini_hcmd_tlv *hcmd_tlv = (void *)&tlv->data[0];
 	struct iwl_fw_ini_hcmd *data = &hcmd_tlv->hcmd;
@@ -2417,6 +2442,10 @@ static void iwl_fw_dbg_send_hcmd(struct iwl_fw_runtime *fwrt,
 	if (le32_to_cpu(hcmd_tlv->domain) != IWL_FW_INI_DBG_DOMAIN_ALWAYS_ON)
 		return;
 
+	IWL_DEBUG_FW(fwrt,
+		     "WRT: ext=%d. Sending host command id=0x%x, group=0x%x\n",
+		     ext, data->id, data->group);
+
 	iwl_trans_send_cmd(fwrt->trans, &hcmd);
 }
 
@@ -2433,17 +2462,20 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 		u32 type = le32_to_cpu(reg->region_type);
 
 		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs),
-			 "Invalid region id %d for apply point %d\n", id, pnt))
+			 "WRT: ext=%d. Invalid region id %d for apply point %d\n",
+			 ext, id, pnt))
 			break;
 
 		active = &fwrt->dump.active_regs[id];
 
 		if (*active)
-			IWL_WARN(fwrt->trans, "region TLV %d override\n", id);
+			IWL_WARN(fwrt->trans,
+				 "WRT: ext=%d. Region id %d override\n",
+				 ext, id);
 
 		IWL_DEBUG_FW(fwrt,
-			     "%s: apply point %d, activating region ID %d\n",
-			     __func__, pnt, id);
+			     "WRT: ext=%d. Activating region id %d\n",
+			     ext, id);
 
 		*active = reg;
 
@@ -2476,7 +2508,8 @@ static int iwl_fw_dbg_trig_realloc(struct iwl_fw_runtime *fwrt,
 
 	ptr = krealloc(active->trig, size, GFP_KERNEL);
 	if (!ptr) {
-		IWL_ERR(fwrt, "Failed to allocate memory for trigger %d\n", id);
+		IWL_ERR(fwrt, "WRT: Failed to allocate memory for trigger %d\n",
+			id);
 		return -ENOMEM;
 	}
 	active->trig = ptr;
@@ -2500,7 +2533,9 @@ static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 		u32 trig_regs_size = le32_to_cpu(trig->num_regions) *
 			sizeof(__le32);
 
-		if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)))
+		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_trigs),
+			 "WRT: ext=%d. Invalid trigger id %d for apply point %d\n",
+			 ext, id, apply_point))
 			break;
 
 		active = &fwrt->dump.active_trigs[id];
@@ -2508,6 +2543,10 @@ static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 		if (!active->active) {
 			size_t trig_size = sizeof(*trig) + trig_regs_size;
 
+			IWL_DEBUG_FW(fwrt,
+				     "WRT: ext=%d. Activating trigger %d\n",
+				     ext, id);
+
 			if (iwl_fw_dbg_trig_realloc(fwrt, active, id,
 						    trig_size))
 				goto next;
@@ -2526,8 +2565,16 @@ static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 			int mem_to_add = trig_regs_size;
 
 			if (region_override) {
+				IWL_DEBUG_FW(fwrt,
+					     "WRT: ext=%d. Trigger %d regions override\n",
+					     ext, id);
+
 				mem_to_add -= active_regs * sizeof(__le32);
 			} else {
+				IWL_DEBUG_FW(fwrt,
+					     "WRT: ext=%d. Trigger %d regions appending\n",
+					     ext, id);
+
 				offset += active_regs;
 				new_regs += active_regs;
 			}
@@ -2536,8 +2583,13 @@ static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 						    active->size + mem_to_add))
 				goto next;
 
-			if (conf_override)
+			if (conf_override) {
+				IWL_DEBUG_FW(fwrt,
+					     "WRT: ext=%d. Trigger %d configuration override\n",
+					     ext, id);
+
 				memcpy(active->trig, trig, sizeof(*trig));
+			}
 
 			memcpy(active->trig->data + offset, trig->data,
 			       trig_regs_size);
@@ -2578,11 +2630,11 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		case IWL_UCODE_TLV_TYPE_HCMD:
 			if (pnt < IWL_FW_INI_APPLY_AFTER_ALIVE) {
 				IWL_ERR(fwrt,
-					"Invalid apply point %x for host command\n",
-					pnt);
+					"WRT: ext=%d. Invalid apply point %d for host command\n",
+					ext, pnt);
 				goto next;
 			}
-			iwl_fw_dbg_send_hcmd(fwrt, tlv);
+			iwl_fw_dbg_send_hcmd(fwrt, tlv, ext);
 			break;
 		case IWL_UCODE_TLV_TYPE_REGIONS:
 			iwl_fw_dbg_update_regions(fwrt, ini_tlv, ext, pnt);
@@ -2593,7 +2645,9 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
 			break;
 		default:
-			WARN_ONCE(1, "Invalid TLV %x for apply point\n", type);
+			WARN_ONCE(1,
+				  "WRT: ext=%d. Invalid TLV 0x%x for apply point\n",
+				  ext, type);
 			break;
 		}
 next:
@@ -2607,6 +2661,8 @@ void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 	void *data = &fwrt->trans->apply_points[apply_point];
 	int i;
 
+	IWL_DEBUG_FW(fwrt, "WRT: enabling apply point %d\n", apply_point);
+
 	if (apply_point == IWL_FW_INI_APPLY_EARLY) {
 		for (i = 0; i < IWL_FW_INI_MAX_REGION_ID; i++)
 			fwrt->dump.active_regs[i] = NULL;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 9107302cc444..08e40a8f9f6b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -138,7 +138,7 @@ void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
 		if (le32_to_cpu(hdr->tlv_version) != 1)
 			continue;
 
-		IWL_DEBUG_FW(trans, "Read TLV %x, apply point %d\n",
+		IWL_DEBUG_FW(trans, "WRT: read TLV 0x%x, apply point %d\n",
 			     le32_to_cpu(tlv->type), apply);
 
 		if (WARN_ON(apply >= IWL_FW_INI_APPLY_NUM))
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index cfaad360c823..ce71ac662ad0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -896,6 +896,8 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 		if (!trans->num_blocks)
 			return;
 
+		IWL_DEBUG_FW(trans,
+			     "WRT: applying DRAM buffer[0] destination\n");
 		iwl_write_umac_prph(trans, MON_BUFF_BASE_ADDR_VER2,
 				    trans->fw_mon[0].physical >>
 				    MON_BUFF_SHIFT_VER2);
-- 
2.20.1

