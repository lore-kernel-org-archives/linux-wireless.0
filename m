Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46614 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaESLWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 07:22:20 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so3515847eei.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 04:22:18 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, yeohchunyeow@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix protected flag stripping
Date: Mon, 19 May 2014 13:15:10 +0200
Message-Id: <1400498110-12879-1-git-send-email-michal.kazior@tieto.com> (sfid-20140519_132226_269873_2C54E9D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents protected flag being stripped from
undecrypted raw sniffed frames when monitor
interface is active.

Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 33 +++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ac6a5fe..ac54d6e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -778,17 +778,30 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 static void ath10k_htt_rx_h_protected(struct ath10k_htt *htt,
 				      struct ieee80211_rx_status *rx_status,
 				      struct sk_buff *skb,
-				      enum htt_rx_mpdu_encrypt_type enctype)
+				      enum htt_rx_mpdu_encrypt_type enctype,
+				      enum rx_msdu_decap_format fmt,
+				      bool dot11frag)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
+	rx_status->flag &= ~(RX_FLAG_DECRYPTED |
+			     RX_FLAG_IV_STRIPPED |
+			     RX_FLAG_MMIC_STRIPPED);
 
-	if (enctype == HTT_RX_MPDU_ENCRYPT_NONE) {
-		rx_status->flag &= ~(RX_FLAG_DECRYPTED |
-				     RX_FLAG_IV_STRIPPED |
-				     RX_FLAG_MMIC_STRIPPED);
+	if (enctype == HTT_RX_MPDU_ENCRYPT_NONE)
+		return;
+
+	/*
+	 * There's no explicit rx descriptor flag to indicate whether a given
+	 * frame has been decrypted or not. We're forced to use the decap
+	 * format as an implicit indication. However fragmentation rx is always
+	 * raw and it probably never reports undecrypted raws.
+	 *
+	 * This makes sure sniffed frames are reported as-is without stripping
+	 * the protected flag.
+	 */
+	if (fmt == RX_MSDU_DECAP_RAW && !dot11frag)
 		return;
-	}
 
 	rx_status->flag |= RX_FLAG_DECRYPTED |
 			   RX_FLAG_IV_STRIPPED |
@@ -942,7 +955,8 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 		}
 
 		skb_in = skb;
-		ath10k_htt_rx_h_protected(htt, rx_status, skb_in, enctype);
+		ath10k_htt_rx_h_protected(htt, rx_status, skb_in, enctype, fmt,
+					  false);
 		skb = skb->next;
 		skb_in->next = NULL;
 
@@ -1024,7 +1038,7 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
 		break;
 	}
 
-	ath10k_htt_rx_h_protected(htt, rx_status, skb, enctype);
+	ath10k_htt_rx_h_protected(htt, rx_status, skb, enctype, fmt, false);
 
 	ath10k_process_rx(htt->ar, rx_status, skb);
 }
@@ -1330,7 +1344,8 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	ath10k_htt_rx_h_protected(htt, rx_status, msdu_head, enctype);
+	ath10k_htt_rx_h_protected(htt, rx_status, msdu_head, enctype, fmt,
+				  true);
 	msdu_head->ip_summed = ath10k_htt_rx_get_csum_state(msdu_head);
 
 	if (tkip_mic_err)
-- 
1.8.5.3

