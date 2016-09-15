Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54608 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751085AbcIOQOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 12:14:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Sep 2016 19:13:53 +0300
Message-Id: <20160915161353.9516-1-luca@coelho.fi> (sfid-20160915_181404_764670_7772B949)
In-Reply-To: <1473955833.5664.38.camel@coelho.fi>
References: <1473955833.5664.38.camel@coelho.fi>
Subject: [PATCH] iwlwifi: mvm: update TX queue before making a copy of the skb
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Off-channel action frames (such as ANQP frames) must be sent either on
the AUX queue or on the offchannel queue, otherwise the firmware will
cause a SYSASSERT.

In the current implementation, the queue to be used is correctly set in
the original skb, but this is done after it is copied.  Thus the copy
remains with the original, incorrect queue.

Fix this by setting the queue in the original skb before copying it.

Fixes: commit 5c08b0f5026f ("iwlwifi: mvm: don't override the rate with the AMSDU len")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c6585ab..b3a87a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -513,6 +513,15 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	int queue;
 
+	/* IWL_MVM_OFFCHANNEL_QUEUE is used for ROC packets that can be used
+	 * in 2 different types of vifs, P2P & STATION. P2P uses the offchannel
+	 * queue. STATION (HS2.0) uses the auxiliary context of the FW,
+	 * and hence needs to be sent on the aux queue
+	 */
+	if (IEEE80211_SKB_CB(skb)->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
+	    skb_info->control.vif->type == NL80211_IFTYPE_STATION)
+		IEEE80211_SKB_CB(skb)->hw_queue = mvm->aux_queue;
+
 	memcpy(&info, skb->cb, sizeof(info));
 
 	if (WARN_ON_ONCE(info.flags & IEEE80211_TX_CTL_AMPDU))
@@ -526,16 +535,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	/* This holds the amsdu headers length */
 	skb_info->driver_data[0] = (void *)(uintptr_t)0;
 
-	/*
-	 * IWL_MVM_OFFCHANNEL_QUEUE is used for ROC packets that can be used
-	 * in 2 different types of vifs, P2P & STATION. P2P uses the offchannel
-	 * queue. STATION (HS2.0) uses the auxiliary context of the FW,
-	 * and hence needs to be sent on the aux queue
-	 */
-	if (IEEE80211_SKB_CB(skb)->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
-	    info.control.vif->type == NL80211_IFTYPE_STATION)
-		IEEE80211_SKB_CB(skb)->hw_queue = mvm->aux_queue;
-
 	queue = info.hw_queue;
 
 	/*
-- 
2.9.3
