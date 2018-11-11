Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D622AC43610
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5BA32080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5BA32080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbeKLF5p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:45 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:36022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726471AbeKLF5o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:44 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1K-0000JG-6W; Sun, 11 Nov 2018 22:07:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:26 +0200
Message-Id: <20181111200732.8159-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/16] iwlwifi: dbg: disable triggers for ini
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When ini is loaded, disable all legacy trigger
configuration.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      | 3 +++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h      | 3 +++
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h   | 1 +
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index efd4ac5bba73..6460b937d331 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1117,6 +1117,9 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 	int ret, len = 0;
 	char buf[64];
 
+	if (fwrt->trans->ini_valid)
+		return 0;
+
 	if (fmt) {
 		va_list ap;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 544b42f9fb19..07403aa29793 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -192,6 +192,9 @@ _iwl_fw_dbg_trigger_on(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_dbg_trigger_tlv *trig;
 
+	if (fwrt->trans->ini_valid)
+		return NULL;
+
 	if (!iwl_fw_dbg_trigger_enabled(fwrt->fw, id))
 		return NULL;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 7b2951521c77..0160662a1749 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -149,6 +149,8 @@ void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
 			trans->apply_points[i].data = mem;
 			trans->apply_points[i].size = size[i];
 		}
+
+		trans->ini_valid = true;
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0c0cd7dccde8..3d455cf5822b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -779,6 +779,7 @@ struct iwl_trans {
 	struct iwl_apply_point_data apply_points_ext[IWL_FW_INI_APPLY_NUM];
 
 	bool external_ini_loaded;
+	bool ini_valid;
 
 	const struct iwl_fw_dbg_dest_tlv_v1 *dbg_dest_tlv;
 	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
-- 
2.19.1

