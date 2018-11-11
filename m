Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7BEC0044C
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8992148E
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E8992148E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbeKLF6V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:58:21 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35976 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730910AbeKLF5P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:15 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1J-0000JG-Ah; Sun, 11 Nov 2018 22:07:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:25 +0200
Message-Id: <20181111200732.8159-10-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/16] iwlwifi: trans: support loading ini TLVs from external file
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Support loading and storing ini TLVs from external
file. Those TLVs are appended to the default TLVs,
so store them separately.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 81 +++++++++++++++++--
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.h  |  7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  9 ++-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  3 +
 4 files changed, 89 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index acefd7d5d099..7b2951521c77 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -63,7 +63,8 @@
 #include "iwl-trans.h"
 #include "iwl-dbg-tlv.h"
 
-void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv)
+void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv,
+			 bool ext)
 {
 	struct iwl_apply_point_data *data;
 	struct iwl_fw_ini_header *header = (void *)&tlv->data[0];
@@ -75,7 +76,10 @@ void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv)
 		      "Invalid apply point id %d\n", apply_point))
 		return;
 
-	data = &trans->apply_points[apply_point];
+	if (ext)
+		data = &trans->apply_points_ext[apply_point];
+	else
+		data = &trans->apply_points[apply_point];
 
 	/*
 	 * Make sure we still have room to copy this TLV. Offset points to the
@@ -90,7 +94,8 @@ void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv)
 	data->offset += copy_size;
 }
 
-void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data)
+void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
+		       bool ext)
 {
 	struct iwl_ucode_tlv *tlv;
 	u32 size[IWL_FW_INI_APPLY_NUM] = {0};
@@ -137,8 +142,13 @@ void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data)
 			return;
 		}
 
-		trans->apply_points[i].data = mem;
-		trans->apply_points[i].size = size[i];
+		if (ext) {
+			trans->apply_points_ext[i].data = mem;
+			trans->apply_points_ext[i].size = size[i];
+		} else {
+			trans->apply_points[i].data = mem;
+			trans->apply_points[i].size = size[i];
+		}
 	}
 }
 
@@ -150,5 +160,66 @@ void iwl_fw_dbg_free(struct iwl_trans *trans)
 		kfree(trans->apply_points[i].data);
 		trans->apply_points[i].size = 0;
 		trans->apply_points[i].offset = 0;
+
+		kfree(trans->apply_points_ext[i].data);
+		trans->apply_points_ext[i].size = 0;
+		trans->apply_points_ext[i].offset = 0;
+	}
+}
+
+static int iwl_parse_fw_dbg_tlv(struct iwl_trans *trans, const u8 *data,
+				size_t len)
+{
+	struct iwl_ucode_tlv *tlv;
+	enum iwl_ucode_tlv_type tlv_type;
+	u32 tlv_len;
+
+	while (len >= sizeof(*tlv)) {
+		len -= sizeof(*tlv);
+		tlv = (void *)data;
+
+		tlv_len = le32_to_cpu(tlv->length);
+		tlv_type = le32_to_cpu(tlv->type);
+
+		if (len < tlv_len) {
+			IWL_ERR(trans, "invalid TLV len: %zd/%u\n",
+				len, tlv_len);
+			return -EINVAL;
+		}
+		len -= ALIGN(tlv_len, 4);
+		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+
+		switch (tlv_type) {
+		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION:
+		case IWL_UCODE_TLV_TYPE_HCMD:
+		case IWL_UCODE_TLV_TYPE_REGIONS:
+		case IWL_UCODE_TLV_TYPE_TRIGGERS:
+		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
+			iwl_fw_dbg_copy_tlv(trans, tlv, true);
+		default:
+			WARN_ONCE(1, "Invalid TLV %x\n", tlv_type);
+			break;
+		}
 	}
+
+	return 0;
+}
+
+void iwl_load_fw_dbg_tlv(struct device *dev, struct iwl_trans *trans)
+{
+	const struct firmware *fw;
+	int res;
+
+	if (trans->external_ini_loaded || !iwlwifi_mod_params.enable_ini)
+		return;
+
+	res = request_firmware(&fw, "iwl-dbg-tlv.ini", dev);
+	if (res)
+		return;
+
+	iwl_alloc_dbg_tlv(trans, fw->size, fw->data, true);
+	iwl_parse_fw_dbg_tlv(trans, fw->data, fw->size);
+
+	trans->external_ini_loaded = true;
+	release_firmware(fw);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
index a368017af089..222cd789e07a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
@@ -77,8 +77,11 @@ struct iwl_apply_point_data {
 };
 
 struct iwl_trans;
+void iwl_load_fw_dbg_tlv(struct device *dev, struct iwl_trans *trans);
 void iwl_fw_dbg_free(struct iwl_trans *trans);
-void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv);
-void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data);
+void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv,
+			 bool ext);
+void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
+		       bool ext);
 
 #endif /* __iwl_dbg_tlv_h__*/
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a986e5795831..7b98125e4eb9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -647,7 +647,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	len -= sizeof(*ucode);
 
 	if (iwlwifi_mod_params.enable_ini)
-		iwl_alloc_dbg_tlv(drv->trans, len, data);
+		iwl_alloc_dbg_tlv(drv->trans, len, data, false);
 
 	while (len >= sizeof(*tlv)) {
 		len -= sizeof(*tlv);
@@ -1096,7 +1096,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		case IWL_UCODE_TLV_TYPE_TRIGGERS:
 		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
 			if (iwlwifi_mod_params.enable_ini)
-				iwl_fw_dbg_copy_tlv(drv->trans, tlv);
+				iwl_fw_dbg_copy_tlv(drv->trans, tlv, false);
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -1576,7 +1576,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 	if (!drv->dbgfs_drv) {
 		IWL_ERR(drv, "failed to create debugfs directory\n");
 		ret = -ENOMEM;
-		goto err_free_drv;
+		goto err_free_tlv;
 	}
 
 	/* Create transport layer debugfs dir */
@@ -1601,7 +1601,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 err_free_dbgfs:
 	debugfs_remove_recursive(drv->dbgfs_drv);
-err_free_drv:
+err_free_tlv:
+	iwl_fw_dbg_free(drv->trans);
 #endif
 	kfree(drv);
 err:
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 08512305c5ac..0c0cd7dccde8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -776,6 +776,9 @@ struct iwl_trans {
 #endif
 
 	struct iwl_apply_point_data apply_points[IWL_FW_INI_APPLY_NUM];
+	struct iwl_apply_point_data apply_points_ext[IWL_FW_INI_APPLY_NUM];
+
+	bool external_ini_loaded;
 
 	const struct iwl_fw_dbg_dest_tlv_v1 *dbg_dest_tlv;
 	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
-- 
2.19.1

