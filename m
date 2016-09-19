Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55882 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759339AbcISHar (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:13 +0300
Message-Id: <20160919073028.22065-10-luca@coelho.fi> (sfid-20160919_093059_778609_56AF220F)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: mvm: support packet injection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For automatic testing packet injection can be useful.
Support injection through debugfs.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 55 ++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index b344898..540b7c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -917,6 +917,59 @@ static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
 	return ret ?: count;
 }
 
+static ssize_t iwl_dbgfs_inject_packet_write(struct iwl_mvm *mvm,
+					     char *buf, size_t count,
+					     loff_t *ppos)
+{
+	struct iwl_rx_cmd_buffer rxb = {
+		._rx_page_order = 0,
+		.truesize = 0, /* not used */
+		._offset = 0,
+	};
+	struct iwl_rx_packet *pkt;
+	struct iwl_rx_mpdu_desc *desc;
+	int bin_len = count / 2;
+	int ret = -EINVAL;
+
+	/* supporting only 9000 descriptor */
+	if (!mvm->trans->cfg->mq_rx_supported)
+		return -ENOTSUPP;
+
+	rxb._page = alloc_pages(GFP_ATOMIC, 0);
+	if (!rxb._page)
+		return -ENOMEM;
+	pkt = rxb_addr(&rxb);
+
+	ret = hex2bin(page_address(rxb._page), buf, bin_len);
+	if (ret)
+		goto out;
+
+	/* avoid invalid memory access */
+	if (bin_len < sizeof(*pkt) + sizeof(*desc))
+		goto out;
+
+	/* check this is RX packet */
+	if (WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd) !=
+	    WIDE_ID(LEGACY_GROUP, REPLY_RX_MPDU_CMD))
+		goto out;
+
+	/* check the length in metadata matches actual received length */
+	desc = (void *)pkt->data;
+	if (le16_to_cpu(desc->mpdu_len) !=
+	    (bin_len - sizeof(*desc) - sizeof(*pkt)))
+		goto out;
+
+	local_bh_disable();
+	iwl_mvm_rx_mpdu_mq(mvm, NULL, &rxb, 0);
+	local_bh_enable();
+	ret = 0;
+
+out:
+	iwl_free_rxb(&rxb);
+
+	return ret ?: count;
+}
+
 static ssize_t iwl_dbgfs_fw_dbg_conf_read(struct file *file,
 					  char __user *user_buf,
 					  size_t count, loff_t *ppos)
@@ -1454,6 +1507,7 @@ MVM_DEBUGFS_WRITE_FILE_OPS(cont_recording, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(max_amsdu_len, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(indirection_tbl,
 			   (IWL_RSS_INDIRECTION_TABLE_SIZE * 2));
+MVM_DEBUGFS_WRITE_FILE_OPS(inject_packet, 512);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -1502,6 +1556,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(inject_packet, mvm->debugfs_dir, S_IWUSR);
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir,
-- 
2.9.3
