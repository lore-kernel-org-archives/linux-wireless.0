Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54499 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbbKEGFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 01:05:13 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V3 2/3] ath10k: Rename the helper which is used for off-channel tx
Date: Thu, 5 Nov 2015 11:33:59 +0530
Message-ID: <1446703440-13880-3-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20151105_070517_151167_37688224)
In-Reply-To: <1446703440-13880-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1446703440-13880-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename ath10k_mac_need_offchan_tx_work() to ath10k_mac_tx_frm_has_freq()
to make it more meaningful. This helper will be used in the future
change. No functionality change.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a53e213..363a99c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3287,7 +3287,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 	}
 }
 
-static bool ath10k_mac_need_offchan_tx_work(struct ath10k *ar)
+static bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
 {
 	/* FIXME: Not really sure since when the behaviour changed. At some
 	 * point new firmware stopped requiring creation of peer entries for
@@ -3295,8 +3295,8 @@ static bool ath10k_mac_need_offchan_tx_work(struct ath10k *ar)
 	 * tx credit replenishment and reliability). Assuming it's at least 3.4
 	 * because that's when the `freq` was introduced to TX_FRM HTT command.
 	 */
-	return !(ar->htt.target_version_major >= 3 &&
-		 ar->htt.target_version_minor >= 4);
+	return (ar->htt.target_version_major >= 3 &&
+		ar->htt.target_version_minor >= 4);
 }
 
 static int ath10k_mac_tx_wmi_mgmt(struct ath10k *ar, struct sk_buff *skb)
@@ -3680,7 +3680,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		ATH10K_SKB_CB(skb)->vdev_id = ar->scan.vdev_id;
 		spin_unlock_bh(&ar->data_lock);
 
-		if (ath10k_mac_need_offchan_tx_work(ar)) {
+		if (!ath10k_mac_tx_frm_has_freq(ar)) {
 			ATH10K_SKB_CB(skb)->htt.freq = 0;
 			ATH10K_SKB_CB(skb)->htt.is_offchan = true;
 
-- 
1.9.1

