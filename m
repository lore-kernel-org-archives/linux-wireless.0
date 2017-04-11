Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50560 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753677AbdDKMiC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:23 +0300
Message-Id: <20170411123742.12214-7-luca@coelho.fi> (sfid-20170411_143808_132473_A02C06BE)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: adjust new API of compressed BA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Final API has a reserved field - adjust accordingly.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index b38cc073adcc..85744fa3bd4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -635,6 +635,10 @@ enum iwl_mvm_ba_resp_flags {
  * @tx_rate: the rate the aggregation was sent at
  * @tfd_cnt: number of TFD-Q elements
  * @ra_tid_cnt: number of RATID-Q elements
+ * @ba_tfd: array of TFD queue status updates. See &iwl_mvm_compressed_ba_tfd
+ *	for details.
+ * @ra_tid: array of RA-TID queue status updates. For debug purposes only. See
+ *	&iwl_mvm_compressed_ba_ratid for more details.
  */
 struct iwl_mvm_compressed_ba_notif {
 	__le32 flags;
@@ -646,6 +650,7 @@ struct iwl_mvm_compressed_ba_notif {
 	__le16 query_frame_cnt;
 	__le16 txed;
 	__le16 done;
+	__le16 reserved;
 	__le32 wireless_time;
 	__le32 tx_rate;
 	__le16 tfd_cnt;
-- 
2.11.0
