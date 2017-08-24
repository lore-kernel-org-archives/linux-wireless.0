Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:48941 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdHXBYW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 21:24:22 -0400
Date: Thu, 24 Aug 2017 11:24:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with
 Linus' tree
Message-ID: <20170824112419.40149e36@canb.auug.org.au> (sfid-20170824_032436_552326_97AFB62A)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/mvm/rs.c

between commit:

  87f55616f81b ("iwlwifi: mvm: rs: fix TLC statistics collection")

from Linus' tree and commit:

  482e48440a0e ("iwlwifi: mvm: change open and close criteria of a BA session")

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

diff --cc drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 8999a1199d60,44c873082a31..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@@ -1312,7 -1357,8 +1357,8 @@@ void iwl_mvm_rs_tx_status(struct iwl_mv
  		if (info->status.ampdu_ack_len == 0)
  			info->status.ampdu_len = 1;
  
- 		rs_collect_tlc_data(mvm, lq_sta, curr_tbl, tx_resp_rate.index,
+ 		rs_collect_tlc_data(mvm, mvmsta, tid, curr_tbl,
 -				    lq_rate.index,
++				    tx_resp_rate.index,
  				    info->status.ampdu_len,
  				    info->status.ampdu_ack_len);
  
@@@ -1348,11 -1394,11 +1394,11 @@@
  				continue;
  
  			rs_collect_tpc_data(mvm, lq_sta, tmp_tbl,
 -					    lq_rate.index, 1,
 +					    tx_resp_rate.index, 1,
  					    i < retries ? 0 : legacy_success,
  					    reduced_txp);
- 			rs_collect_tlc_data(mvm, lq_sta, tmp_tbl,
+ 			rs_collect_tlc_data(mvm, mvmsta, tid, tmp_tbl,
 -					    lq_rate.index, 1,
 +					    tx_resp_rate.index, 1,
  					    i < retries ? 0 : legacy_success);
  		}
  
