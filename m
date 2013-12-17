Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56083 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3LQUpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:15 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so3132060eae.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:14 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/36] iwlwifi: mvm: check iwl_nvm_init return value
Date: Tue, 17 Dec 2013 22:44:24 +0200
Message-Id: <1387313079-28123-21-git-send-email-egrumbach@gmail.com> (sfid-20131217_214529_794105_981A6FD7)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

iwl_nvm_init() return value wasn't checked in some
path, which resulted in the following panic (if
there was some issue with the nvm):

Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = d0460000
[00000004] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP
Modules linked in: iwlmvm(+) iwlwifi mac80211 cfg80211 compat [last unloaded: compat]
PC is at iwl_mvm_mac_setup_register+0x12c/0x460 [iwlmvm]
LR is at 0x2710
pc : [<bf50dd4c>]    lr : [<00002710>]    psr: 20800013
sp : d00cfe18  ip : 0000081e  fp : d006b908
r10: d0711408  r9 : bf532e64  r8 : d006b5bc
r7 : d01af000  r6 : bf39cefc  r5 : d006ab00  r4 : d006b5a4
r3 : 00000001  r2 : 00000000  r1 : d006a120  r0 : d006b860

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index ef3fdcf..a362430 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -427,7 +427,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	 * there is no need to unnecessarily power up the NIC at driver load
 	 */
 	if (iwlwifi_mod_params.nvm_file) {
-			iwl_nvm_init(mvm);
+		err = iwl_nvm_init(mvm);
+		if (err)
+			goto out_free;
 	} else {
 		err = iwl_trans_start_hw(mvm->trans);
 		if (err)
-- 
1.7.9.5

