Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54278 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1948886AbdDYUY3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:24:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:34 +0300
Message-Id: <20170425202243.7844-17-luca@coelho.fi> (sfid-20170425_222433_399304_C1B21CA9)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: don't leak memory on allocation failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we fail to allocate the small chunk of memory for the
pieces of the firmware file, we leak the whole firmware
image instead...

Since the allocation failure is really unlikely, just bail
out at that point instead.

Remove the error message at the label since we now (and
actually have been) use it for various reasons.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 212fb8d5c064..98a03a4615d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1282,7 +1282,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 
 	pieces = kzalloc(sizeof(*pieces), GFP_KERNEL);
 	if (!pieces)
-		return;
+		goto out_free_fw;
 
 	if (!ucode_raw)
 		goto try_again;
@@ -1512,17 +1512,18 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	goto free;
 
  out_free_fw:
-	IWL_ERR(drv, "failed to allocate pci memory\n");
 	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
  free:
-	for (i = 0; i < ARRAY_SIZE(pieces->img); i++)
-		kfree(pieces->img[i].sec);
-	kfree(pieces->dbg_mem_tlv);
-	kfree(pieces);
+	if (pieces) {
+		for (i = 0; i < ARRAY_SIZE(pieces->img); i++)
+			kfree(pieces->img[i].sec);
+		kfree(pieces->dbg_mem_tlv);
+		kfree(pieces);
+	}
 }
 
 struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
-- 
2.11.0
