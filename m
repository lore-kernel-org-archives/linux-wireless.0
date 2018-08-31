Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45744 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeHaOF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:05:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:13 +0300
Message-Id: <20180831095614.14099-16-luca@coelho.fi> (sfid-20180831_115849_494066_8D4D532F)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 15/16] iwlwifi: api: annotate compressed BA notif array sizes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Annotate the compressed BA notification array sizes and
make both of them 0-length since the length of 1 is just
confusing - it may be different than that and the offset
to the second one needs to be calculated in the C code
anyhow.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 135135d80d4d..358bdf051e83 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -747,9 +747,9 @@ enum iwl_mvm_ba_resp_flags {
  * @tfd_cnt: number of TFD-Q elements
  * @ra_tid_cnt: number of RATID-Q elements
  * @tfd: array of TFD queue status updates. See &iwl_mvm_compressed_ba_tfd
- *	for details.
+ *	for details. Length in @tfd_cnt.
  * @ra_tid: array of RA-TID queue status updates. For debug purposes only. See
- *	&iwl_mvm_compressed_ba_ratid for more details.
+ *	&iwl_mvm_compressed_ba_ratid for more details. Length in @ra_tid_cnt.
  */
 struct iwl_mvm_compressed_ba_notif {
 	__le32 flags;
@@ -766,7 +766,7 @@ struct iwl_mvm_compressed_ba_notif {
 	__le32 tx_rate;
 	__le16 tfd_cnt;
 	__le16 ra_tid_cnt;
-	struct iwl_mvm_compressed_ba_tfd tfd[1];
+	struct iwl_mvm_compressed_ba_tfd tfd[0];
 	struct iwl_mvm_compressed_ba_ratid ra_tid[0];
 } __packed; /* COMPRESSED_BA_RES_API_S_VER_4 */
 
-- 
2.18.0
