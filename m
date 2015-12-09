Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25517 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbbLIK0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:26:24 -0500
Date: Wed, 9 Dec 2015 13:26:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Golan Ben-Ami <golan.ben.ami@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: mvm: remove an extra tab
Message-ID: <20151209102608.GF3173@mwanda> (sfid-20151209_112631_985246_0F4FF2B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch prints a static checker warning here:

    drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c:386 iwl_dump_prph()
    warn: curly braces intended?

Curly braces are NOT intended, the extra tab was added by mistake in
commit 1a616dd2f171 ('iwlwifi: dump prph registers in a common place
for all transports').

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 9fcabc5..a6985da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -383,7 +383,7 @@ static u32 iwl_dump_prph(struct iwl_trans *trans,
 			*val++ = cpu_to_le32(iwl_read_prph_no_grab(trans,
 								   reg));
 
-			*data = iwl_fw_error_next_data(*data);
+		*data = iwl_fw_error_next_data(*data);
 	}
 
 	iwl_trans_release_nic_access(trans, &flags);
