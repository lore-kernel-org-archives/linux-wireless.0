Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A3EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA602192D
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403796AbfBOLtu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60512 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727790AbfBOLtu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:50 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzv-0008TN-2m; Fri, 15 Feb 2019 13:49:40 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:16 +0200
Message-Id: <20190215114924.2545-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/20] iwlwifi: mvm: add read debugfs for he_sniffer_params
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

Return the AID currently set when reading this debugfs entry.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 25 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 +
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 05a6db2db478..776b24f54200 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1789,6 +1789,7 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
 
 struct iwl_mvm_sniffer_apply {
 	struct iwl_mvm *mvm;
+	u8 *bssid;
 	u16 aid;
 };
 
@@ -1798,6 +1799,8 @@ static bool iwl_mvm_sniffer_apply(struct iwl_notif_wait_data *notif_data,
 	struct iwl_mvm_sniffer_apply *apply = data;
 
 	apply->mvm->cur_aid = cpu_to_le16(apply->aid);
+	memcpy(apply->mvm->cur_bssid, apply->bssid,
+	       sizeof(apply->mvm->cur_bssid));
 
 	return true;
 }
@@ -1830,6 +1833,7 @@ iwl_dbgfs_he_sniffer_params_write(struct iwl_mvm *mvm, char *buf,
 	he_mon_cmd.aid = cpu_to_le16(aid);
 
 	apply.aid = aid;
+	apply.bssid = (void *)he_mon_cmd.bssid;
 
 	mutex_lock(&mvm->mutex);
 
@@ -1858,6 +1862,23 @@ iwl_dbgfs_he_sniffer_params_write(struct iwl_mvm *mvm, char *buf,
 	return ret ?: count;
 }
 
+static ssize_t
+iwl_dbgfs_he_sniffer_params_read(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	u8 buf[32];
+	int len;
+
+	len = scnprintf(buf, sizeof(buf),
+			"%d %02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx\n",
+			le16_to_cpu(mvm->cur_aid), mvm->cur_bssid[0],
+			mvm->cur_bssid[1], mvm->cur_bssid[2], mvm->cur_bssid[3],
+			mvm->cur_bssid[4], mvm->cur_bssid[5]);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
 static ssize_t
 iwl_dbgfs_uapsd_noagg_bssids_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -1928,7 +1949,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
 MVM_DEBUGFS_READ_FILE_OPS(sar_geo_profile);
 #endif
 
-MVM_DEBUGFS_WRITE_FILE_OPS(he_sniffer_params, 32);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(he_sniffer_params, 32);
 
 static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -2119,7 +2140,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 #ifdef CONFIG_ACPI
 	MVM_DEBUGFS_ADD_FILE(sar_geo_profile, dbgfs_dir, 0400);
 #endif
-	MVM_DEBUGFS_ADD_FILE(he_sniffer_params, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(he_sniffer_params, mvm->debugfs_dir, 0600);
 
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 0600,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b6d5a87dbae0..c90dd98bdd99 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1176,6 +1176,7 @@ struct iwl_mvm {
 
 	/* sniffer data to include in radiotap */
 	__le16 cur_aid;
+	u8 cur_bssid[ETH_ALEN];
 
 #ifdef CONFIG_ACPI
 	struct iwl_mvm_sar_profile sar_profiles[ACPI_SAR_PROFILE_NUM];
-- 
2.20.1

