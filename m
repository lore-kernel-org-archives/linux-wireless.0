Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14701 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932509AbcL0Ngr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 08:36:47 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Remove passing unused argument for ath10k_mac_tx
Date: Tue, 27 Dec 2016 19:02:35 +0530
Message-ID: <1482845555-6076-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161227_143652_262142_44EA4F1D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

'ath10k_mac_tx' does not seems to use the per station table
entry pointer 'sta' (struct ieee80211_sta), hence remove passing
this unused argument

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7d2f0ae..d0d3059 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3493,7 +3493,6 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
  */
 static int ath10k_mac_tx(struct ath10k *ar,
 			 struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta,
 			 enum ath10k_hw_txrx_mode txmode,
 			 enum ath10k_mac_tx_path txpath,
 			 struct sk_buff *skb)
@@ -3635,7 +3634,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 		txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
 
-		ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
+		ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
 		if (ret) {
 			ath10k_warn(ar, "failed to transmit offchannel frame: %d\n",
 				    ret);
@@ -3822,7 +3821,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
 	if (unlikely(ret)) {
 		ath10k_warn(ar, "failed to push frame: %d\n", ret);
 
@@ -4103,7 +4102,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
 	if (ret) {
 		ath10k_warn(ar, "failed to transmit frame: %d\n", ret);
 		if (is_htt) {
-- 
1.9.1
