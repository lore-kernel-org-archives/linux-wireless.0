Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53182 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaKXOfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:06 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so12518082wgg.15
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:05 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/75] iwlwifi: mvm: fix init_dbg flow to work as expected
Date: Mon, 24 Nov 2014 16:33:42 +0200
Message-Id: <1416839691-28533-6-git-send-email-egrumbach@gmail.com> (sfid-20141124_153513_313723_221785D3)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Even if running the driver with param init_dbg=1 - on INIT
image error - iwl_trans_stop_device() was still called. This
patch fixes that and calls iwl_trans_stop_device() on INIT
image failure only if init_dbg=0.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index bd52ecfa..8c5bdf9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -524,7 +524,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 		mutex_lock(&mvm->mutex);
 		err = iwl_run_init_mvm_ucode(mvm, true);
-		iwl_trans_stop_device(trans);
+		if (!err || !iwlmvm_mod_params.init_dbg)
+			iwl_trans_stop_device(trans);
 		mutex_unlock(&mvm->mutex);
 		/* returns 0 if successful, 1 if success but in rfkill */
 		if (err < 0 && !iwlmvm_mod_params.init_dbg) {
-- 
1.9.1

