Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35440 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbbKJNNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 08:13:07 -0500
Received: by lbces9 with SMTP id es9so49795928lbc.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2015 05:13:05 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/9] ath10k: remove is_offchan
Date: Tue, 10 Nov 2015 14:10:50 +0100
Message-Id: <1447161055-2283-5-git-send-email-michal.kazior@tieto.com> (sfid-20151110_141352_587354_B0053AE6)
In-Reply-To: <1447161055-2283-1-git-send-email-michal.kazior@tieto.com>
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
 <1447161055-2283-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was wasteful to keep it in the struct.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 4 +---
 drivers/net/wireless/ath/ath10k/mac.h  | 1 +
 drivers/net/wireless/ath/ath10k/txrx.c | 7 ++++++-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2f48772418ec..344849dd93c8 100644
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
index dd4770ec7ecc..f7e4fba63b44 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3297,7 +3297,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 	}
 }
 
-static bool ath10k_mac_need_offchan_tx_work(struct ath10k *ar)
+bool ath10k_mac_need_offchan_tx_work(struct ath10k *ar)
 {
 	/* FIXME: Not really sure since when the behaviour changed. At some
 	 * point new firmware stopped requiring creation of peer entries for
@@ -3679,7 +3679,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 
-	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.freq = 0;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
 	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
@@ -3711,7 +3710,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 		if (ath10k_mac_need_offchan_tx_work(ar)) {
 			ATH10K_SKB_CB(skb)->htt.freq = 0;
-			ATH10K_SKB_CB(skb)->htt.is_offchan = true;
 
 			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
 				   skb);
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index e3cefe4c7cfd..ff09d6986fae 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -58,6 +58,7 @@ bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
 				    u8 keyidx);
 int ath10k_mac_vif_chan(struct ieee80211_vif *vif,
 			struct cfg80211_chan_def *def);
+bool ath10k_mac_need_offchan_tx_work(struct ath10k *ar);
 
 void ath10k_mac_handle_beacon(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_mac_handle_beacon_miss(struct ath10k *ar, u32 vdev_id);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 6d1105ab4592..655947bef6cc 100644
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
+	if (!ath10k_mac_need_offchan_tx_work(ar))
 		return;
 
 	/* If the original wait_for_completion() timed out before
-- 
2.1.4

