Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33198 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242AbcGFKlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:00 +0300
Message-Id: <1467801651-1816-5-git-send-email-luca@coelho.fi> (sfid-20160706_124130_723831_99983661)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 05/56] iwlwifi: mvm: fix possible division by zero
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Theoretically we may get only one IRQ from OS, in which
case we will have only 1 queue even in MSIx mode.
This will cause division by zero in the indirection table
calculation.
We do not need send the command in that case, as there is
only one queue so all RX traffic will be directed to it
anyway. Bail out early if there is only one queue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 7057f35..0a5490c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -122,6 +122,9 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
 	};
 
+	if (mvm->trans->num_rx_queues == 1)
+		return 0;
+
 	/* Do not direct RSS traffic to Q 0 which is our fallback queue */
 	for (i = 0; i < ARRAY_SIZE(cmd.indirection_table); i++)
 		cmd.indirection_table[i] =
-- 
2.8.1

