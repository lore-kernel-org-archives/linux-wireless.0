Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40804 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbcEJUab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:16 +0300
Message-Id: <1462910797-20303-20-git-send-email-luca@coelho.fi> (sfid-20160510_223037_065413_EBD40614)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 20/41] iwlwifi: mvm: pass station to mac80211 RX where known
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we've already looked up the transmitter station, we can just
pass it to mac80211 using the new ieee80211_rx_napi(). This saves
the overhead of looking it up in mac80211 again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 11 ++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 263e8a8..58e7e4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -97,6 +97,7 @@ void iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
  * Adds the rxb to a new skb and give it to mac80211
  */
 static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
+					    struct ieee80211_sta *sta,
 					    struct napi_struct *napi,
 					    struct sk_buff *skb,
 					    struct ieee80211_hdr *hdr, u16 len,
@@ -131,7 +132,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 				fraglen, rxb->truesize);
 	}
 
-	ieee80211_rx_napi(mvm->hw, NULL, skb, napi);
+	ieee80211_rx_napi(mvm->hw, sta, skb, napi);
 }
 
 /*
@@ -453,8 +454,12 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		     mvm->sched_scan_pass_all == SCHED_SCAN_PASS_ALL_ENABLED))
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_FOUND;
 
-	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, hdr, len, ampdu_status,
-					crypt_len, rxb);
+	if (unlikely(ieee80211_is_beacon(hdr->frame_control) ||
+		     ieee80211_is_probe_resp(hdr->frame_control)))
+		rx_status->boottime_ns = ktime_get_boot_ns();
+
+	iwl_mvm_pass_packet_to_mac80211(mvm, sta, napi, skb, hdr, len,
+					ampdu_status, crypt_len, rxb);
 }
 
 static void iwl_mvm_update_rx_statistics(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 0da93b5..5fe7a0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -210,7 +210,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	if (iwl_mvm_check_pn(mvm, skb, queue, sta))
 		kfree_skb(skb);
 	else
-		ieee80211_rx_napi(mvm->hw, NULL, skb, napi);
+		ieee80211_rx_napi(mvm->hw, sta, skb, napi);
 }
 
 static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
-- 
2.8.1

