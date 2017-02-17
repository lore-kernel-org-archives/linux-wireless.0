Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932202AbdBQCJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 21:09:36 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com, tj@kernel.org, arjan@linux.intel.com,
        ming.lei@canonical.com, zajec5@gmail.com
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, pmladek@suse.com,
        gregkh@linuxfoundation.org, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 2/5] iwlwifi: fix request_module() use
Date: Thu, 16 Feb 2017 18:09:00 -0800
Message-Id: <20170217020903.6370-3-mcgrof@kernel.org> (sfid-20170217_031049_897382_9AA076C8)
In-Reply-To: <20170217020903.6370-1-mcgrof@kernel.org>
References: <20170217020903.6370-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of request_module() being 0 does not mean that the
driver which was requested has loaded. To properly check that the driver
was loaded each driver can use internal mechanisms to vet the driver is
now present. The helper try_then_request_module() was added to help with
this, allowing drivers to specify their own validation as the first
argument.

On iwlwifi the use case is a bit more complicated given that the value
we need to check for is protected with a mutex later used on the
module_init() of the module we are asking for. If we were to lock and
request_module() we'd deadlock. iwlwifi needs its own wrapper then so
it can handle its special locking requirements.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 34 ++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index e198d6f5fcea..6beb92d19ea7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1231,6 +1231,29 @@ static void _iwl_op_mode_stop(struct iwl_drv *drv)
 	}
 }
 
+static void iwlwifi_try_load_op(struct iwlwifi_opmode_table *op,
+				struct iwl_drv *drv)
+{
+	int ret = 0;
+
+	ret = request_module("%s", op->name);
+	if (ret)
+		goto out;
+
+	mutex_lock(&iwlwifi_opmode_table_mtx);
+	if (!op->ops)
+		ret = -ENOENT;
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
+
+out:
+#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
+	if (ret)
+		IWL_ERR(drv,
+			"failed to load module %s (error %d), is dynamic loading enabled?\n",
+			op->name, ret);
+#endif
+}
+
 /**
  * iwl_req_fw_callback - callback when firmware was loaded
  *
@@ -1471,15 +1494,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * else from proceeding if the module fails to load
 	 * or hangs loading.
 	 */
-	if (load_module) {
-		err = request_module("%s", op->name);
-#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
-		if (err)
-			IWL_ERR(drv,
-				"failed to load module %s (error %d), is dynamic loading enabled?\n",
-				op->name, err);
-#endif
-	}
+	if (load_module)
+		iwlwifi_try_load_op(op, drv);
 	goto free;
 
  try_again:
-- 
2.11.0
