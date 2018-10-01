Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128CBC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D919C2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D919C2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbeJASsi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:48:38 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54442 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729111AbeJASsi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:48:38 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1u-0006wq-Of; Mon, 01 Oct 2018 15:10:27 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:04 +0300
Message-Id: <20181001121010.29684-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/16] iwlwifi: add debugfs to send host command
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add debugfs to send host command in mvm and fmac op modes.
Allows to send host command at runtime via send_hcmd debugfs file.
The command is received as a string that represents hex values.

The struct of the command is as follows:
[cmd_id][flags][length][data]
cmd_id and flags are 8 chars long each.
length is 4 chars long.
data is length * 2 chars long.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 1049bdfe1e69..3e120dd47305 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -258,11 +258,75 @@ static ssize_t iwl_dbgfs_timestamp_marker_read(struct iwl_fw_runtime *fwrt,
 
 FWRT_DEBUGFS_READ_WRITE_FILE_OPS(timestamp_marker, 16);
 
+struct hcmd_write_data {
+	__be32 cmd_id;
+	__be32 flags;
+	__be16 length;
+	u8 data[0];
+} __packed;
+
+static ssize_t iwl_dbgfs_send_hcmd_write(struct iwl_fw_runtime *fwrt, char *buf,
+					 size_t count)
+{
+	size_t header_size = (sizeof(u32) * 2 + sizeof(u16)) * 2;
+	size_t data_size = (count - 1) / 2;
+	int ret;
+	struct hcmd_write_data *data;
+	struct iwl_host_cmd hcmd = {
+		.len = { 0, },
+		.data = { NULL, },
+	};
+
+	if (fwrt->ops && fwrt->ops->fw_running &&
+	    !fwrt->ops->fw_running(fwrt->ops_ctx))
+		return -EIO;
+
+	if (count < header_size + 1 || count > 1024 * 4)
+		return -EINVAL;
+
+	data = kmalloc(data_size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = hex2bin((u8 *)data, buf, data_size);
+	if (ret)
+		goto out;
+
+	hcmd.id = be32_to_cpu(data->cmd_id);
+	hcmd.flags = be32_to_cpu(data->flags);
+	hcmd.len[0] = be16_to_cpu(data->length);
+	hcmd.data[0] = data->data;
+
+	if (count != header_size + hcmd.len[0] * 2 + 1) {
+		IWL_ERR(fwrt,
+			"host command data size does not match header length\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (fwrt->ops && fwrt->ops->send_hcmd)
+		ret = fwrt->ops->send_hcmd(fwrt->ops_ctx, &hcmd);
+	else
+		ret = -EPERM;
+
+	if (ret < 0)
+		goto out;
+
+	if (hcmd.flags & CMD_WANT_SKB)
+		iwl_free_resp(&hcmd);
+out:
+	kfree(data);
+	return ret ?: count;
+}
+
+FWRT_DEBUGFS_WRITE_FILE_OPS(send_hcmd, 512);
+
 int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 			    struct dentry *dbgfs_dir)
 {
 	INIT_DELAYED_WORK(&fwrt->timestamp.wk, iwl_fw_timestamp_marker_wk);
 	FWRT_DEBUGFS_ADD_FILE(timestamp_marker, dbgfs_dir, 0200);
+	FWRT_DEBUGFS_ADD_FILE(send_hcmd, dbgfs_dir, 0200);
 	return 0;
 err:
 	IWL_ERR(fwrt, "Can't create the fwrt debugfs directory\n");
-- 
2.19.0

