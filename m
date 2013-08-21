Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62703 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab3HUGEj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:04:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 5/8] iwlwifi: mvm: take the seqno from packet if transmit failed
Date: Wed, 21 Aug 2013 09:04:23 +0300
Message-Id: <1377065066-13030-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130821_080444_375217_AC9447D1)
In-Reply-To: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit ebea2f32e814445f94f9e087b646f1cf4d55fa5a upstream.

The fw is unreliable in all the cases in which the packet
wasn't sent.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index b9ba4e7..a2e6112e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -610,8 +610,8 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		    !(info->flags & IEEE80211_TX_STAT_ACK))
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
-		/* W/A FW bug: seq_ctl is wrong when the queue is flushed */
-		if (status == TX_STATUS_FAIL_FIFO_FLUSHED) {
+		/* W/A FW bug: seq_ctl is wrong when the status isn't success */
+		if (status != TX_STATUS_SUCCESS) {
 			struct ieee80211_hdr *hdr = (void *)skb->data;
 			seq_ctl = le16_to_cpu(hdr->seq_ctrl);
 		}
-- 
1.7.10.4

