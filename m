Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbbLAJ7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:21 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/41] iwlwifi: mvm: check FW's response for nvm access write cmd
Date: Tue,  1 Dec 2015 11:58:35 +0200
Message-Id: <1448963947-24302-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105928_030084_C608020F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

In case of using an external NVM file, the driver sends to the
FW the different nvm sections. In the response of the cmd, the
FW states the status of the writing of the chunk.

Currently the value is not checked by the driver.

Check FW's response for writing the nvm chunk in the NVM_ACCESS_CMD.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 1edcfcc..a9fcb15 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -104,13 +104,35 @@ static int iwl_nvm_write_chunk(struct iwl_mvm *mvm, u16 section,
 	struct iwl_host_cmd cmd = {
 		.id = NVM_ACCESS_CMD,
 		.len = { sizeof(struct iwl_nvm_access_cmd), length },
-		.flags = CMD_SEND_IN_RFKILL,
+		.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
 		.data = { &nvm_access_cmd, data },
 		/* data may come from vmalloc, so use _DUP */
 		.dataflags = { 0, IWL_HCMD_DFL_DUP },
 	};
+	struct iwl_rx_packet *pkt;
+	struct iwl_nvm_access_resp *nvm_resp;
+	int ret;
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret)
+		return ret;
 
-	return iwl_mvm_send_cmd(mvm, &cmd);
+	pkt = cmd.resp_pkt;
+	if (!pkt) {
+		IWL_ERR(mvm, "Error in NVM_ACCESS response\n");
+		return -EINVAL;
+	}
+	/* Extract & check NVM write response */
+	nvm_resp = (void *)pkt->data;
+	if (le16_to_cpu(nvm_resp->status) != READ_NVM_CHUNK_SUCCEED) {
+		IWL_ERR(mvm,
+			"NVM access write command failed for section %u (status = 0x%x)\n",
+			section, le16_to_cpu(nvm_resp->status));
+		ret = -EIO;
+	}
+
+	iwl_free_resp(&cmd);
+	return ret;
 }
 
 static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
-- 
2.5.0

