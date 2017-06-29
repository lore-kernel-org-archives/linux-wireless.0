Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36272 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752584AbdF2San (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:21 +0300
Message-Id: <20170629183027.15408-10-luca@coelho.fi> (sfid-20170629_203055_110693_6A894688)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 09/15] iwlwifi: mvm: don't mess the SNAP header in TSO for non-QoS packets
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we get large sends on non-QoS association, we had a
bug that mangled the SNAP header. Fix that.

Fixes: a6d5e32f247c ("iwlwifi: mvm: send large SKBs to the transport")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 172f0aa8d019..584ddc39d5f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -849,11 +849,13 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 		if (tcp_payload_len > mss) {
 			skb_shinfo(tmp)->gso_size = mss;
 		} else {
-			qc = ieee80211_get_qos_ctl((void *)tmp->data);
+			if (ieee80211_is_data_qos(hdr->frame_control)) {
+				qc = ieee80211_get_qos_ctl((void *)tmp->data);
 
-			if (ipv4)
-				ip_send_check(ip_hdr(tmp));
-			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+				if (ipv4)
+					ip_send_check(ip_hdr(tmp));
+				*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+			}
 			skb_shinfo(tmp)->gso_size = 0;
 		}
 
-- 
2.11.0
