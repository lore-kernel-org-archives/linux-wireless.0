Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35146 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbKRF7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 00:59:35 -0500
Received: by lfdo63 with SMTP id o63so19573307lfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 21:59:34 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 4/9] ath10k: remove is_offchan
Date: Wed, 18 Nov 2015 06:59:18 +0100
Message-Id: <1447826363-16818-5-git-send-email-michal.kazior@tieto.com> (sfid-20151118_065951_970246_352A94CC)
In-Reply-To: <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
References: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
 <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was wasteful to keep it in the struct.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 2 --
 drivers/net/wireless/ath/ath10k/txrx.c | 7 ++++++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0228000ecf50..89a83e3c5cb6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -89,7 +89,6 @@ struct ath10k_skb_cb {
 	struct {
 		u8 tid;
 		u16 freq;
-		bool is_offchan;
 		bool nohwcrypt;
 		struct ath10k_htt_txbuf *txbuf;
 		u32 txbuf_paddr;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4d3b8dc8e5de..164a3e5ae6da 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3683,7 +3683,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 
-	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.freq = 0;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
 	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
@@ -3715,7 +3714,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 		if (!ath10k_mac_tx_frm_has_freq(ar)) {
 			ATH10K_SKB_CB(skb)->htt.freq = 0;
-			ATH10K_SKB_CB(skb)->htt.is_offchan = true;
 
 			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
 				   skb);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 6d1105ab4592..9e14c04ac89f 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -23,7 +23,12 @@
 
 static void ath10k_report_offchan_tx(struct ath10k *ar, struct sk_buff *skb)
 {
-	if (!ATH10K_SKB_CB(skb)->htt.is_offchan)
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	if (likely(!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)))
+		return;
+
+	if (ath10k_mac_tx_frm_has_freq(ar))
 		return;
 
 	/* If the original wait_for_completion() timed out before
-- 
2.1.4

