Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36580 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752522AbdI2QqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:46:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:22 +0300
Message-Id: <20170929164423.23666-18-luca@coelho.fi> (sfid-20170929_200836_276237_5DFA5E1F)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 17/18] iwlwifi: mvm: warn on invalid statistics size
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Getting the wrong statistics size is a problem, having a warning
will help us catch it quicker during firmware/driver development.
In released firmware/driver versions, we obviously make sure this
won't happen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 184c749766f2..185a1d8414b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -661,11 +661,10 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		expected_size = sizeof(struct iwl_notif_statistics_cdb);
 	}
 
-	if (iwl_rx_packet_payload_len(pkt) != expected_size) {
-		IWL_ERR(mvm, "received invalid statistics size (%d)!\n",
-			iwl_rx_packet_payload_len(pkt));
+	if (WARN_ONCE(iwl_rx_packet_payload_len(pkt) != expected_size,
+		      "received invalid statistics size (%d)!\n",
+		      iwl_rx_packet_payload_len(pkt)))
 		return;
-	}
 
 	if (!iwl_mvm_has_new_rx_stats_api(mvm)) {
 		struct iwl_notif_statistics_v11 *stats = (void *)&pkt->data;
-- 
2.14.1
