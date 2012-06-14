Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:32079 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2FNSfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 14:35:52 -0400
Date: Thu, 14 Jun 2012 21:35:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] iwlwifi: unlock on error path
Message-ID: <20120614183526.GD6383@elgon.mountain> (sfid-20120614_203557_447921_E8796EB4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We introduced a lock here in ff1ffb850b ("iwlwifi: fix dynamic
loading").  But we missed an error path which needs an unlock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 095547b..a175997 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -911,8 +911,10 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		const struct iwl_op_mode_ops *ops = op->ops;
 		drv->op_mode = ops->start(drv->trans, drv->cfg, &drv->fw);
 
-		if (!drv->op_mode)
+		if (!drv->op_mode) {
+			mutex_unlock(&iwlwifi_opmode_table_mtx);
 			goto out_unbind;
+		}
 	} else {
 		load_module = true;
 	}
