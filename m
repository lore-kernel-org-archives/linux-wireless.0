Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37332 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752290AbdGEGFv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:37 +0300
Message-Id: <20170705060539.20737-6-luca@coelho.fi> (sfid-20170705_080555_881484_629ECF10)
In-Reply-To: <20170705060539.20737-1-luca@coelho.fi>
References: <20170705060539.20737-1-luca@coelho.fi>
Subject: [PATCH 5/7] iwlwifi: fix tracing when tx only is enabled
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_trace_data is somewhat confusing. It returns a bool
that tells if the payload of the skb should be added to
the tx_data event. If it returns false, then the payload
of the skb is added to the tx event.

The purpose is to be able to start tracing with
-e iwlwifi
and record non-data packets only which saves bandwidth.

Since EAPOLs are important, seldom and not real data
packet (despite being WiFi data packets), they are
included in tx event and thus iwl_trace_data returns false
on those. This last part was buggy, and because of that,
all the data packets were included in the tx event.

Fix that.

Fixes: 0c4cb7314d15 ("iwlwifi: tracing: decouple from mac80211")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
index 545d14b0bc92..f5c1127253cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
@@ -55,8 +55,8 @@ static inline bool iwl_trace_data(struct sk_buff *skb)
 	/* also account for the RFC 1042 header, of course */
 	offs += 6;
 
-	return skb->len > offs + 2 &&
-	       *(__be16 *)(skb->data + offs) == cpu_to_be16(ETH_P_PAE);
+	return skb->len <= offs + 2 ||
+		*(__be16 *)(skb->data + offs) != cpu_to_be16(ETH_P_PAE);
 }
 
 static inline size_t iwl_rx_trace_len(const struct iwl_trans *trans,
-- 
2.11.0
