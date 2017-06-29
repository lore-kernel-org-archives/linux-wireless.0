Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36254 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753211AbdF2Sal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:19 +0300
Message-Id: <20170629183027.15408-8-luca@coelho.fi> (sfid-20170629_203052_514880_1BD94EAA)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 07/15] iwlwifi: mvm: don't send fetch the TID from a non-QoS packet in TSO
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Getting the TID of a packet before we know it is a QoS data
packet isn't a good idea. Delay the TID retrieval until
we know the packet is a QoS data packet.

Fixes: bb81bb68f472 ("iwlwifi: mvm: add Tx A-MSDU inside A-MPDU")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 12a35af66918..172f0aa8d019 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -715,11 +715,6 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
 
-	qc = ieee80211_get_qos_ctl(hdr);
-	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
-	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
-		return -EINVAL;
-
 	dbg_max_amsdu_len = ACCESS_ONCE(mvm->max_amsdu_len);
 
 	if (!sta->max_amsdu_len ||
@@ -730,6 +725,11 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 		goto segment;
 	}
 
+	qc = ieee80211_get_qos_ctl(hdr);
+	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+		return -EINVAL;
+
 	/*
 	 * Do not build AMSDU for IPv6 with extension headers.
 	 * ask stack to segment and checkum the generated MPDUs for us.
-- 
2.11.0
