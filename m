Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46314 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaKXOfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:24 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so12193111wgh.24
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/75] iwlwifi: mvm: wake up d0i3_exit_waitq when aborting d0i3
Date: Mon, 24 Nov 2014 16:33:52 +0200
Message-Id: <1416839691-28533-16-git-send-email-egrumbach@gmail.com> (sfid-20141124_154431_519213_F9F53ED9)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

When aborting d0i3 due to taken refs, other threads might
already wait on d0i3_exit_waitq for IWL_MVM_STATUS_IN_D0I3
to get cleared (it's somewhat likely, as synchronize_rcu()
might take a while), so make sure to wake them up.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 737aac3..8664f61 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1052,6 +1052,7 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	if (iwl_mvm_ref_taken(mvm)) {
 		IWL_DEBUG_RPM(mvm->trans, "abort d0i3 due to taken ref\n");
 		clear_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
+		wake_up(&mvm->d0i3_exit_waitq);
 		return 1;
 	}
 
-- 
1.9.1

