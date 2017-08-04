Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:35297 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751811AbdHDCEK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 22:04:10 -0400
Date: Fri, 4 Aug 2017 12:04:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with
 Linus' tree
Message-ID: <20170804120408.0d147e86@canb.auug.org.au> (sfid-20170804_040431_126531_1CB429C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/mvm/ops.c

between commit:

  bf8b286f86fc ("iwlwifi: mvm: defer setting IWL_MVM_STATUS_IN_HW_RESTART")

from Linus' tree and commit:

  7174beb60c53 ("iwlwifi: refactor firmware debug code")

from the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 9c175d5e9d67,c387d5095bfe..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@@ -1234,9 -1190,10 +1190,9 @@@ void iwl_mvm_nic_restart(struct iwl_mv
  	 * can't recover this since we're already half suspended.
  	 */
  	if (!mvm->fw_restart && fw_error) {
- 		iwl_mvm_fw_dbg_collect_desc(mvm, &iwl_mvm_dump_desc_assert,
+ 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
  					NULL);
 -	} else if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART,
 -				    &mvm->status)) {
 +	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
  		struct iwl_mvm_reprobe *reprobe;
  
  		IWL_ERR(mvm,
