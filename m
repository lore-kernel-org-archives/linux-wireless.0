Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45686 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728084AbeHaODO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:07 +0300
Message-Id: <20180831095614.14099-10-luca@coelho.fi> (sfid-20180831_115637_952613_AF175401)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 09/16] iwlwifi: dbg: don't crash if the firmware crashes in the middle of a debug dump
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We can dump data from the firmware either when it crashes,
or when the firmware is alive.
Not all the data is available if the firmware is running
(like the Tx / Rx FIFOs which are available only when the
firmware is halted), so we first check that the firmware
is alive to compute the required size for the dump and then
fill the buffer with the data.

When we allocate the buffer, we test the STATUS_FW_ERROR
bit to check if the firmware is alive or not. This bit
can be changed during the course of the dump since it is
modified in the interrupt handler.

We hit a case where we allocate the buffer while the
firmware is sill working, and while we start to fill the
buffer, the firmware crashes. Then we test STATUS_FW_ERROR
again and decide to fill the buffer with data like the
FIFOs even if no room was allocated for this data in the
buffer. This means that we overflow the buffer that was
allocated leading to memory corruption.

To fix this, test the STATUS_FW_ERROR bit only once and
rely on local variables to check if we should dump fifos
or other firmware components.

Fixes: 04fd2c28226f ("iwlwifi: mvm: add rxf and txf to dump data")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5029fd91f0bb..0dcf1a673478 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -882,7 +882,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	/* We only dump the FIFOs if the FW is in error state */
-	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
+	if (fifo_data_len) {
 		iwl_fw_dump_fifos(fwrt, &dump_data);
 		if (radio_len)
 			iwl_read_radio_regs(fwrt, &dump_data);
-- 
2.18.0
