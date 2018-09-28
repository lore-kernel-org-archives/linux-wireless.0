Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86821C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 05:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44B782170E
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 05:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44B782170E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbeI1Lpc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 07:45:32 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53256 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726068AbeI1Lpc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 07:45:32 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5lFU-0004mE-PK; Fri, 28 Sep 2018 08:23:33 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Ido Yariv <idox.yariv@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 08:23:28 +0300
Message-Id: <20180928052328.5965-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <f2e1d9b93487a74bccdbb680a1f43bae6271657f.camel@coelho.fi>
References: <f2e1d9b93487a74bccdbb680a1f43bae6271657f.camel@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2] iwlwifi: mvm: enable sending HE_AIR_SNIFFER command via debugfs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

In order to receive TB (Trigger Based) PPDU in monitor mode,
the Driver must send the HE_AIR_SNIFFER_CONFIG_CMD host command.
Enable that via debugfs.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

In v2:

* renamed set_aid to he_sniffer_params as suggested by Arend;
* removed duplicate debugfs file creation;

.../wireless/intel/iwlwifi/fw/api/datapath.h  |  5 +++
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 14 ++++++++
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 32 +++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index 59b3c6e8f37b..eff3249af48a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -99,6 +99,11 @@ enum iwl_data_path_subcmd_ids {
 	 */
 	TLC_MNG_CONFIG_CMD = 0xF,
 
+	/**
+	 * @HE_AIR_SNIFFER_CONFIG_CMD: &struct iwl_he_monitor_cmd
+	 */
+	HE_AIR_SNIFFER_CONFIG_CMD = 0x13,
+
 	/**
 	 * @TLC_MNG_UPDATE_NOTIF: &struct iwl_tlc_update_notif
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index 55594c93b014..1dd23f846fb9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -578,4 +578,18 @@ struct iwl_he_sta_context_cmd {
 	struct iwl_he_backoff_conf trig_based_txf[AC_NUM];
 } __packed; /* STA_CONTEXT_DOT11AX_API_S */
 
+/**
+ * struct iwl_he_monitor_cmd - configure air sniffer for HE
+ * @bssid: the BSSID to sniff for
+ * @reserved1: reserved for dword alignment
+ * @aid: the AID to track on for HE MU
+ * @reserved2: reserved for future use
+ */
+struct iwl_he_monitor_cmd {
+	u8 bssid[6];
+	__le16 reserved1;
+	__le16 aid;
+	u8 reserved2[6];
+} __packed; /* HE_AIR_SNIFFER_CONFIG_CMD_API_S_VER_1 */
+
 #endif /* __iwl_fw_api_mac_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 202158d03d36..de40752aa67e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1727,6 +1727,35 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
 	return ret ?: count;
 }
 
+static ssize_t
+iwl_dbgfs_he_sniffer_params_write(struct iwl_mvm *mvm, char *buf,
+			size_t count, loff_t *ppos)
+{
+	struct iwl_he_monitor_cmd he_mon_cmd = {};
+	u32 aid;
+	int ret;
+
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
+	ret = sscanf(buf, "%x %2hhx:%2hhx:%2hhx:%2hhx:%2hhx:%2hhx", &aid,
+		     &he_mon_cmd.bssid[0], &he_mon_cmd.bssid[1],
+		     &he_mon_cmd.bssid[2], &he_mon_cmd.bssid[3],
+		     &he_mon_cmd.bssid[4], &he_mon_cmd.bssid[5]);
+	if (ret != 7)
+		return -EINVAL;
+
+	he_mon_cmd.aid = cpu_to_le16(aid);
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(HE_AIR_SNIFFER_CONFIG_CMD,
+						   DATA_PATH_GROUP, 0), 0,
+				   sizeof(he_mon_cmd), &he_mon_cmd);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
 static ssize_t
 iwl_dbgfs_uapsd_noagg_bssids_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -1796,6 +1825,8 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
 MVM_DEBUGFS_READ_FILE_OPS(sar_geo_profile);
 #endif
 
+MVM_DEBUGFS_WRITE_FILE_OPS(he_sniffer_params, 32);
+
 static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
 {
@@ -1984,6 +2015,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 #ifdef CONFIG_ACPI
 	MVM_DEBUGFS_ADD_FILE(sar_geo_profile, dbgfs_dir, 0400);
 #endif
+	MVM_DEBUGFS_ADD_FILE(he_sniffer_params, mvm->debugfs_dir, 0200);
 
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 0600,
-- 
2.19.0

