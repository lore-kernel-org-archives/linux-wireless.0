Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901AbZKXDaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:22 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 8/8] iwmc3200wifi: Remove tx concatenation option
Date: Tue, 24 Nov 2009 11:33:33 +0800
Message-Id: <1259033613-25600-9-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-8-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-4-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-5-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-6-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-7-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

The tx concatenation option works fine now, we no longer need the debugging
option of disabling concatenation.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/tx.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/tx.c b/drivers/net/wireless/iwmc3200wifi/tx.c
index 01cc210..55905f0 100644
--- a/drivers/net/wireless/iwmc3200wifi/tx.c
+++ b/drivers/net/wireless/iwmc3200wifi/tx.c
@@ -354,8 +354,6 @@ static int iwm_tx_send_concat_packets(struct iwm_priv *iwm,
 	return ret;
 }
 
-#define CONFIG_IWM_TX_CONCATENATED 1
-
 void iwm_tx_worker(struct work_struct *work)
 {
 	struct iwm_priv *iwm;
@@ -414,11 +412,6 @@ void iwm_tx_worker(struct work_struct *work)
 			   "%d, color: %d\n", txq->id, skb, tx_info->sta,
 			   tx_info->color);
 
-#if !CONFIG_IWM_TX_CONCATENATED
-		/* temporarily keep this to comparing the performance */
-		ret = iwm_send_packet(iwm, skb, pool_id);
-#else
-
 		if (txq->concat_count + cmdlen > IWM_HAL_CONCATENATE_BUF_SIZE)
 			iwm_tx_send_concat_packets(iwm, txq);
 
@@ -440,7 +433,7 @@ void iwm_tx_worker(struct work_struct *work)
 		txq->concat_count += ALIGN(cmdlen, 16);
 
 		mutex_unlock(&tid_info->mutex);
-#endif
+
 		kfree_skb(skb);
 	}
 
-- 
1.6.0.4

