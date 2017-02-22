Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754019AbdBVCJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 21:09:51 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com
Cc: ming.lei@canonical.com, zajec5@gmail.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 2/2] iwlwifi: simplify requesting ops module
Date: Tue, 21 Feb 2017 18:09:39 -0800
Message-Id: <20170222020939.28140-3-mcgrof@kernel.org> (sfid-20170222_031113_199630_8447E631)
In-Reply-To: <20170222020939.28140-1-mcgrof@kernel.org>
References: <20170222001822.GE31264@wotan.suse.de>
 <20170222020939.28140-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of request_module() being 0 does not mean that the
driver which was requested has loaded. To properly check that the driver
was loaded each driver can use internal mechanisms to vet the driver is
now present. The helper try_then_request_module() was added to help with
this, allowing drivers to specify their own validation as the first
argument for synchronous requests.

On iwlwifi the use case is a bit more complicated given that the value
we need to check for is protected with a mutex later used on the
module_init() of the module we are asking for. If we were to lock and
request_module() we'd deadlock. iwlwifi could use its own wrapper for
requesting its ops module synchronously so it can handle its special
locking requirements on its own but the given code has been in the
kernel for a long time and the preference is to keep its simplicity.

We can do two more things to simplify this even further:

a) just use the async request, request_module_nowait(), to acknowledge
   we are using best effort -- we are not verifying the module is loaded

b) we can unconditionally call request_module_nowait() whether or not
   we were built-in or not, if built-in this will return immediately
   without failure.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index e198d6f5fcea..e96095c1824a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1250,7 +1250,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	size_t trigger_tlv_sz[FW_DBG_TRIGGER_MAX];
 	u32 api_ver;
 	int i;
-	bool load_module = false;
 	bool usniffer_images = false;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
@@ -1454,8 +1453,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 			mutex_unlock(&iwlwifi_opmode_table_mtx);
 			goto out_unbind;
 		}
-	} else {
-		load_module = true;
 	}
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
@@ -1466,20 +1463,10 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 */
 	complete(&drv->request_firmware_complete);
 
-	/*
-	 * Load the module last so we don't block anything
-	 * else from proceeding if the module fails to load
-	 * or hangs loading.
-	 */
-	if (load_module) {
-		err = request_module("%s", op->name);
-#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
-		if (err)
-			IWL_ERR(drv,
-				"failed to load module %s (error %d), is dynamic loading enabled?\n",
-				op->name, err);
-#endif
-	}
+	err = request_module_nowait("%s", op->name);
+	if (err)
+		goto out_unbind;
+
 	goto free;
 
  try_again:
-- 
2.11.0
