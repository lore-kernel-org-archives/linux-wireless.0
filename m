Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48624 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752546AbdLBQ3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:21 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:58 +0200
Message-Id: <20171202162858.4167-16-luca@coelho.fi> (sfid-20171202_172925_138632_CD486A6A)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 15/15] iwlwifi: mvm: request statistics when reading debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When statistics are read from debugfs, make sure that they
are actually updated from the firmware.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 834c798f728c..270781e13e89 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -759,6 +759,9 @@ static ssize_t iwl_dbgfs_fw_rx_stats_read(struct file *file,
 
 	mutex_lock(&mvm->mutex);
 
+	if (iwl_mvm_firmware_running(mvm))
+		iwl_mvm_request_statistics(mvm, false);
+
 	pos += scnprintf(buf + pos, bufsz - pos, fmt_header,
 			 "Statistics_Rx - OFDM");
 	if (!iwl_mvm_has_new_rx_stats_api(mvm)) {
-- 
2.15.0
