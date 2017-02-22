Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753710AbdBVCJu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 21:09:50 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com
Cc: ming.lei@canonical.com, zajec5@gmail.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 1/2] iwlwifi: fix drv cleanup on opmode registration failure
Date: Tue, 21 Feb 2017 18:09:38 -0800
Message-Id: <20170222020939.28140-2-mcgrof@kernel.org> (sfid-20170222_031002_058718_E477DBAA)
In-Reply-To: <20170222020939.28140-1-mcgrof@kernel.org>
References: <20170222001822.GE31264@wotan.suse.de>
 <20170222020939.28140-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware async callback handles the device's opmode start
call, but optionally also allows opmode registration to take
care of its opmode start. If the firmware callback handles it
its error path in case of opmode start failure has a few pieces
of code missing from the opmode registration. The opmode
registration hanlder has no cleanup at all. Sync both error
paths.

This should in theory fix a detangled drv from the drv list should
either of the opmode modules loaded and handled registration for the
drv.

The path of having the opmode registration deal with the drv
opmode start is actually the more common path. The other path,
from the async callback is rathe rare (1/8 or so times for me) --
it happens when the the opmode driver's init routine completed
prior to the driver's async callback opmode start call.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index be466a074c1d..e198d6f5fcea 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1611,8 +1611,13 @@ int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
 			continue;
 		op->ops = ops;
 		/* TODO: need to handle exceptional case */
-		list_for_each_entry(drv, &op->drv, list)
+		list_for_each_entry(drv, &op->drv, list) {
 			drv->op_mode = _iwl_op_mode_start(drv, op);
+			if (!drv->op_mode) {
+				complete(&drv->request_firmware_complete);
+				device_release_driver(drv->trans->dev);
+			}
+		}
 
 		mutex_unlock(&iwlwifi_opmode_table_mtx);
 		return 0;
-- 
2.11.0
