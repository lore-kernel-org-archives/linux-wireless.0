Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C78C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F14EE2080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F14EE2080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbeKLF5P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:15 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35968 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731152AbeKLF5O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:14 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1I-0000JG-6e; Sun, 11 Nov 2018 22:07:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:24 +0200
Message-Id: <20181111200732.8159-9-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/16] iwlwifi: trans: parse and store debug ini TLVs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

The new debug ini TLVs can be either packed into firmware
binary or written in external file. Support loading them
from both. Store the data per apply point. Apply point is
a point during driver runtime, where the TLV becomes active.
For example, a trigger of hardware error may be configured
to collect a subset of data pre-alive, as a opposed to HW
error that occurs after alive.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile   |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   7 +
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 154 ++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.h  |  84 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  17 ++
 .../wireless/intel/iwlwifi/iwl-modparams.h    |   2 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   4 +
 7 files changed, 269 insertions(+)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 04e376cc898c..ff41987a7e35 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -11,6 +11,7 @@ iwlwifi-objs		+= pcie/ctxt-info.o pcie/ctxt-info-gen3.o
 iwlwifi-objs		+= pcie/trans-gen2.o pcie/tx-gen2.o
 iwlwifi-$(CONFIG_IWLDVM) += cfg/1000.o cfg/2000.o cfg/5000.o cfg/6000.o
 iwlwifi-$(CONFIG_IWLMVM) += cfg/7000.o cfg/8000.o cfg/9000.o cfg/22000.o
+iwlwifi-objs		+= iwl-dbg-tlv.o
 iwlwifi-objs		+= iwl-trans.o
 iwlwifi-objs		+= fw/notif-wait.o
 iwlwifi-$(CONFIG_IWLMVM) += fw/paging.o fw/smem.o fw/init.o fw/dbg.o
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 6005a41c53d1..81f557c0b58d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -91,6 +91,8 @@ struct iwl_ucode_header {
 	} u;
 };
 
+#define IWL_UCODE_INI_TLV_GROUP	BIT(24)
+
 /*
  * new TLV uCode file layout
  *
@@ -141,6 +143,11 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_FW_GSCAN_CAPA	= 50,
 	IWL_UCODE_TLV_FW_MEM_SEG	= 51,
 	IWL_UCODE_TLV_IML		= 52,
+	IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION	= IWL_UCODE_INI_TLV_GROUP | 0x1,
+	IWL_UCODE_TLV_TYPE_HCMD			= IWL_UCODE_INI_TLV_GROUP | 0x2,
+	IWL_UCODE_TLV_TYPE_REGIONS		= IWL_UCODE_INI_TLV_GROUP | 0x3,
+	IWL_UCODE_TLV_TYPE_TRIGGERS		= IWL_UCODE_INI_TLV_GROUP | 0x4,
+	IWL_UCODE_TLV_TYPE_DEBUG_FLOW		= IWL_UCODE_INI_TLV_GROUP | 0x5,
 
 	/* TLVs 0x1000-0x2000 are for internal driver usage */
 	IWL_UCODE_TLV_FW_DBG_DUMP_LST	= 0x1000,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
new file mode 100644
index 000000000000..acefd7d5d099
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -0,0 +1,154 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright (C) 2018 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <linuxwifi@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright (C) 2018 Intel Corporation
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include <linux/firmware.h>
+#include "iwl-trans.h"
+#include "iwl-dbg-tlv.h"
+
+void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv)
+{
+	struct iwl_apply_point_data *data;
+	struct iwl_fw_ini_header *header = (void *)&tlv->data[0];
+	u32 apply_point = le32_to_cpu(header->apply_point);
+
+	int copy_size = le32_to_cpu(tlv->length) + sizeof(*tlv);
+
+	if (WARN_ONCE(apply_point >= IWL_FW_INI_APPLY_NUM,
+		      "Invalid apply point id %d\n", apply_point))
+		return;
+
+	data = &trans->apply_points[apply_point];
+
+	/*
+	 * Make sure we still have room to copy this TLV. Offset points to the
+	 * location the last copy ended.
+	 */
+	if (WARN_ONCE(data->offset + copy_size > data->size,
+		      "Not enough memory for apply point %d\n",
+		      apply_point))
+		return;
+
+	memcpy(data->data + data->offset, (void *)tlv, copy_size);
+	data->offset += copy_size;
+}
+
+void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data)
+{
+	struct iwl_ucode_tlv *tlv;
+	u32 size[IWL_FW_INI_APPLY_NUM] = {0};
+	int i;
+
+	while (len >= sizeof(*tlv)) {
+		u32 tlv_len, tlv_type, apply;
+		struct iwl_fw_ini_header *hdr;
+
+		len -= sizeof(*tlv);
+		tlv = (void *)data;
+
+		tlv_len = le32_to_cpu(tlv->length);
+		tlv_type = le32_to_cpu(tlv->type);
+
+		if (len < tlv_len)
+			return;
+
+		len -= ALIGN(tlv_len, 4);
+		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+
+		if (!(tlv_type & IWL_UCODE_INI_TLV_GROUP))
+			continue;
+
+		hdr = (void *)&tlv->data[0];
+		apply = le32_to_cpu(hdr->apply_point);
+
+		if (WARN_ON(apply >= IWL_FW_INI_APPLY_NUM))
+			continue;
+
+		size[apply] += sizeof(*tlv) + tlv_len;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(size); i++) {
+		void *mem;
+
+		if (!size[i])
+			continue;
+
+		mem = kzalloc(size[i], GFP_KERNEL);
+
+		if (!mem) {
+			IWL_ERR(trans, "No memory for apply point %d\n", i);
+			return;
+		}
+
+		trans->apply_points[i].data = mem;
+		trans->apply_points[i].size = size[i];
+	}
+}
+
+void iwl_fw_dbg_free(struct iwl_trans *trans)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(trans->apply_points); i++) {
+		kfree(trans->apply_points[i].data);
+		trans->apply_points[i].size = 0;
+		trans->apply_points[i].offset = 0;
+	}
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
new file mode 100644
index 000000000000..a368017af089
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
@@ -0,0 +1,84 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright (C) 2018 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <linuxwifi@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright (C) 2018 Intel Corporation
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __iwl_dbg_tlv_h__
+#define __iwl_dbg_tlv_h__
+
+#include <linux/device.h>
+#include <linux/types.h>
+
+/**
+ * struct iwl_apply_point_data
+ * @data: start address of this apply point data
+ * @size total size of the data
+ * @offset: current offset of the copied data
+ */
+struct iwl_apply_point_data {
+	void *data;
+	int size;
+	int offset;
+};
+
+struct iwl_trans;
+void iwl_fw_dbg_free(struct iwl_trans *trans);
+void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv);
+void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data);
+
+#endif /* __iwl_dbg_tlv_h__*/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ba41d23b4211..a986e5795831 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -72,6 +72,7 @@
 #include "iwl-op-mode.h"
 #include "iwl-agn-hw.h"
 #include "fw/img.h"
+#include "iwl-dbg-tlv.h"
 #include "iwl-config.h"
 #include "iwl-modparams.h"
 
@@ -645,6 +646,9 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 	len -= sizeof(*ucode);
 
+	if (iwlwifi_mod_params.enable_ini)
+		iwl_alloc_dbg_tlv(drv->trans, len, data);
+
 	while (len >= sizeof(*tlv)) {
 		len -= sizeof(*tlv);
 		tlv = (void *)data;
@@ -1086,6 +1090,13 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				return -ENOMEM;
 			break;
 			}
+		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION:
+		case IWL_UCODE_TLV_TYPE_HCMD:
+		case IWL_UCODE_TLV_TYPE_REGIONS:
+		case IWL_UCODE_TLV_TYPE_TRIGGERS:
+		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
+			if (iwlwifi_mod_params.enable_ini)
+				iwl_fw_dbg_copy_tlv(drv->trans, tlv);
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -1619,6 +1630,8 @@ void iwl_drv_stop(struct iwl_drv *drv)
 	debugfs_remove_recursive(drv->dbgfs_drv);
 #endif
 
+	iwl_fw_dbg_free(drv->trans);
+
 	kfree(drv);
 }
 
@@ -1749,6 +1762,10 @@ MODULE_PARM_DESC(lar_disable, "disable LAR functionality (default: N)");
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable, uint, 0644);
 MODULE_PARM_DESC(uapsd_disable,
 		 "disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3)");
+module_param_named(enable_ini, iwlwifi_mod_params.enable_ini,
+		   bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(enable_ini,
+		 "Enable debug INI TLV FW debug infrastructure (default: 0");
 
 /*
  * set bt_coex_active to true, uCode will do kill/defer
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 6fc8dac4aab7..73b1c46f1158 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -122,6 +122,7 @@ enum iwl_uapsd_disable {
  * @fw_monitor: allow to use firmware monitor
  * @disable_11ac: disable VHT capabilities, default = false.
  * @remove_when_gone: remove an inaccessible device from the PCIe bus.
+ * @enable_ini: enable new FW debug infratructure (INI TLVs)
  */
 struct iwl_mod_params {
 	int swcrypto;
@@ -148,6 +149,7 @@ struct iwl_mod_params {
 	 */
 	bool disable_11ax;
 	bool remove_when_gone;
+	bool enable_ini;
 };
 
 #endif /* #__iwl_modparams_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index b0300e824815..08512305c5ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -73,6 +73,8 @@
 #include "iwl-op-mode.h"
 #include "fw/api/cmdhdr.h"
 #include "fw/api/txq.h"
+#include "fw/api/dbg-tlv.h"
+#include "iwl-dbg-tlv.h"
 
 /**
  * DOC: Transport layer - what is it ?
@@ -773,6 +775,8 @@ struct iwl_trans {
 	struct lockdep_map sync_cmd_lockdep_map;
 #endif
 
+	struct iwl_apply_point_data apply_points[IWL_FW_INI_APPLY_NUM];
+
 	const struct iwl_fw_dbg_dest_tlv_v1 *dbg_dest_tlv;
 	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
 	struct iwl_fw_dbg_trigger_tlv * const *dbg_trigger_tlv;
-- 
2.19.1

