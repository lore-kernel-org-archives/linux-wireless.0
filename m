Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52832 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754250AbdDRWVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:21:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:23 +0300
Message-Id: <20170418221729.28372-20-luca@coelho.fi> (sfid-20170419_002141_034506_C6822EF3)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: mvm: dump frames early on invalid rate
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently when rate isn't found (invalid rate or CCK rate in high
band) driver is assigning rate -1, which causes mac80211 to dump
it later with the cryptic rate value of 0xFF.
Instead, warn early and dump the frame in mvm.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 13 ++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 18 +++++++++++++-----
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index eab6e2ad62e1..d4c0ca7ccb34 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -460,9 +460,16 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		if (rate_n_flags & RATE_MCS_BF_MSK)
 			rx_status->vht_flag |= RX_VHT_FLAG_BF;
 	} else {
-		rx_status->rate_idx =
-			iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
-							    rx_status->band);
+		int rate = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
+							       rx_status->band);
+
+		if (WARN(rate < 0 || rate > 0xFF,
+			 "Invalid rate flags 0x%x, band %d,\n",
+			 rate_n_flags, rx_status->band)) {
+			kfree_skb(skb);
+			return;
+		}
+		rx_status->rate_idx = rate;
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 8601d25407b3..0f74a200e812 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -918,8 +918,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 		if (iwl_mvm_is_nonagg_dup(sta, queue, rx_status, hdr, desc)) {
 			kfree_skb(skb);
-			rcu_read_unlock();
-			return;
+			goto out;
 		}
 
 		/*
@@ -985,9 +984,17 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		if (rate_n_flags & RATE_MCS_BF_MSK)
 			rx_status->vht_flag |= RX_VHT_FLAG_BF;
 	} else {
-		rx_status->rate_idx =
-			iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
-							    rx_status->band);
+		int rate = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
+							       rx_status->band);
+
+		if (WARN(rate < 0 || rate > 0xFF,
+			 "Invalid rate flags 0x%x, band %d,\n",
+			 rate_n_flags, rx_status->band)) {
+			kfree_skb(skb);
+			goto out;
+		}
+		rx_status->rate_idx = rate;
+
 	}
 
 	/* management stuff on default queue */
@@ -1006,6 +1013,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	iwl_mvm_create_skb(skb, hdr, len, crypt_len, rxb);
 	if (!iwl_mvm_reorder(mvm, napi, queue, sta, skb, desc))
 		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
+out:
 	rcu_read_unlock();
 }
 
-- 
2.11.0
