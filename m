Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57496 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945938AbcHRKAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2016 06:00:32 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <arnagara@codeaurora.org>,
	"Ashok Raj Nagarajan" <arnagara@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix sending frame in management path in push txq logic
Date: Thu, 18 Aug 2016 15:30:04 +0530
Message-ID: <1471514404-24098-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160818_120038_145656_D6F41470)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the wake tx queue path, we are not checking if the frame to be sent
takes management path or not. For eg. QOS null func frame coming here will
take the management path. Since we are not incrementing the descriptor
counter (num_pending_mgmt_tx) w.r.t tx management, on tx completion it is
possible to see negative values.

When the above counter reaches a negative value, we will not be sending a
probe response out.

    if (is_presp &&
	ar->hw_params.max_probe_resp_desc_thres < htt->num_pending_mgmt_tx)

For IPQ4019, max_probe_resp_desc_thres (u32) is 24 is compared against
num_pending_mgmt_tx (int) and the above condtions comes true if the counter
is negative and we drop the probe response.

To avoid this, check on the wake tx queue path as well for the tx path of
the frame and increment the appropriate counters

Fixes: cac085524cf1 "ath10k: move mgmt descriptor limit handle under mgmt_tx"
Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fb8e38d..0d6afe2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3777,7 +3777,9 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	enum ath10k_hw_txrx_mode txmode;
 	enum ath10k_mac_tx_path txpath;
 	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
 	size_t skb_len;
+	bool is_mgmt, is_presp;
 	int ret;
 
 	spin_lock_bh(&ar->htt.tx_lock);
@@ -3801,6 +3803,22 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	skb_len = skb->len;
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
+	is_mgmt = (txpath == ATH10K_MAC_TX_HTT_MGMT);
+
+	if (is_mgmt) {
+		hdr = (struct ieee80211_hdr *)skb->data;
+		is_presp = ieee80211_is_probe_resp(hdr->frame_control);
+
+		spin_lock_bh(&ar->htt.tx_lock);
+		ret = ath10k_htt_tx_mgmt_inc_pending(htt, is_mgmt, is_presp);
+
+		if (ret) {
+			ath10k_htt_tx_dec_pending(htt);
+			spin_unlock_bh(&ar->htt.tx_lock);
+			return ret;
+		}
+		spin_unlock_bh(&ar->htt.tx_lock);
+	}
 
 	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
 	if (unlikely(ret)) {
@@ -3808,6 +3826,8 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 
 		spin_lock_bh(&ar->htt.tx_lock);
 		ath10k_htt_tx_dec_pending(htt);
+		if (is_mgmt)
+			ath10k_htt_tx_mgmt_dec_pending(htt);
 		spin_unlock_bh(&ar->htt.tx_lock);
 
 		return ret;
-- 
1.9.1
