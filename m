Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20203 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3IZHVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 03:21:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/5] ath10k: improve RX performance
References: <1380028158-861-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 26 Sep 2013 10:21:02 +0300
In-Reply-To: <1380028158-861-1-git-send-email-michal.kazior@tieto.com> (Michal
	Kazior's message of "Tue, 24 Sep 2013 15:09:13 +0200")
Message-ID: <87a9j0t5ep.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_092128_860233_137BF695)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patchset gives clear RX performance
> improvement on AP135. Throughput is at least
> doubled (300mbps -> 600mbps, UDP RX, 2x2).
>
> This contains a workaround for
> retransmission/duplication recovery.
>
> There's a pending patch for mac80211 that will
> allow proper individiual A-MSDU subframe
> reporting.
>
> Changes since RFC:
>  * comments fixes (Kalle)
>  * one patch extracted/split (Kalle)
>  * commit message adjustments
>
>
> Michal Kazior (5):
>   ath10k: report A-MSDU subframes individually
>   ath10k: document decap modes
>   ath10k: cleanup RX decap handling
>   ath10k: fix Native Wifi decap mode RX
>   ath10k: align RX frames properly

All five applies, thanks.

There were few long lines, I fixed those myself. Can you please double
check that I didn't break anything?

Kalle

For patch 1 I did:

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index e30b95c..c5f1800 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -650,7 +650,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 	first = skb;
 	while (skb) {
 		void *decap_hdr;
-		int decap_len;
+		int len;
 
 		rxd = (void *)skb->data - sizeof(*rxd);
 		fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
@@ -661,8 +661,10 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 
 		/* First frame in an A-MSDU chain has more decapped data. */
 		if (skb == first) {
-			decap_hdr += round_up(ieee80211_hdrlen(hdr->frame_control), 4);
-			decap_hdr += round_up(ath10k_htt_rx_crypto_param_len(enctype), 4);
+			len = round_up(ieee80211_hdrlen(hdr->frame_control), 4);
+			len += round_up(ath10k_htt_rx_crypto_param_len(enctype),
+					4);
+			decap_hdr += len;
 		}
 
 		switch (fmt) {
@@ -672,12 +674,12 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 		case RX_MSDU_DECAP_NATIVE_WIFI:
 			break;
 		case RX_MSDU_DECAP_ETHERNET2_DIX:
-			decap_len = 0;
-			decap_len += sizeof(struct rfc1042_hdr);
-			decap_len += sizeof(struct amsdu_subframe_hdr);
+			len = 0;
+			len += sizeof(struct rfc1042_hdr);
+			len += sizeof(struct amsdu_subframe_hdr);
 
 			skb_pull(skb, sizeof(struct ethhdr));
-			memcpy(skb_push(skb, decap_len), decap_hdr, decap_len);
+			memcpy(skb_push(skb, len), decap_hdr, len);
 			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
 			break;
 		case RX_MSDU_DECAP_8023_SNAP_LLC:

And for patch 3:

diff --cc drivers/net/wireless/ath/ath10k/htt_rx.c
index c5f1800,c94ced8..0000000
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@@ -672,14 -671,18 +673,18 @@@ static void ath10k_htt_rx_amsdu(struct 
  			skb_trim(skb, skb->len - FCS_LEN);
  			break;
  		case RX_MSDU_DECAP_NATIVE_WIFI:
+ 			/* nothing to do */
  			break;
  		case RX_MSDU_DECAP_ETHERNET2_DIX:
+ 			/* strip ethernet header and insert decapped 802.11
+ 			 * header, amsdu subframe header and rfc1042 header */
+ 
 -			decap_len = 0;
 -			decap_len += sizeof(struct rfc1042_hdr);
 -			decap_len += sizeof(struct amsdu_subframe_hdr);
 +			len = 0;
 +			len += sizeof(struct rfc1042_hdr);
 +			len += sizeof(struct amsdu_subframe_hdr);
  
  			skb_pull(skb, sizeof(struct ethhdr));
 -			memcpy(skb_push(skb, decap_len), decap_hdr, decap_len);
 +			memcpy(skb_push(skb, len), decap_hdr, len);
  			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
  			break;
  		case RX_MSDU_DECAP_8023_SNAP_LLC:
