Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44264 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab3IXNJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 09:09:42 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: cleanup RX decap handling
Date: Tue, 24 Sep 2013 15:09:16 +0200
Message-ID: <1380028158-861-4-git-send-email-michal.kazior@tieto.com> (sfid-20130924_150948_084255_3690FA10)
In-Reply-To: <1380028158-861-1-git-send-email-michal.kazior@tieto.com>
References: <1380028158-861-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify decapping code and make it easier to
understand.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   53 +++++++++++++++---------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f79f815..f8620b0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -667,11 +667,16 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 
 		switch (fmt) {
 		case RX_MSDU_DECAP_RAW:
+			/* remove trailing FCS */
 			skb_trim(skb, skb->len - FCS_LEN);
 			break;
 		case RX_MSDU_DECAP_NATIVE_WIFI:
+			/* nothing to do */
 			break;
 		case RX_MSDU_DECAP_ETHERNET2_DIX:
+			/* strip ethernet header and insert decapped 802.11
+			 * header, amsdu subframe header and rfc1042 header */
+
 			decap_len = 0;
 			decap_len += sizeof(struct rfc1042_hdr);
 			decap_len += sizeof(struct amsdu_subframe_hdr);
@@ -681,6 +686,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
 			break;
 		case RX_MSDU_DECAP_8023_SNAP_LLC:
+			/* insert decapped 802.11 header making a singly A-MSDU */
 			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
 			break;
 		}
@@ -704,6 +710,8 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 	struct ieee80211_hdr *hdr;
 	enum rx_msdu_decap_format fmt;
 	enum htt_rx_mpdu_encrypt_type enctype;
+	int hdr_len;
+	void *rfc1042;
 
 	/* This shouldn't happen. If it does than it may be a FW bug. */
 	if (skb->next) {
@@ -717,46 +725,39 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 			RX_MSDU_START_INFO1_DECAP_FORMAT);
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 			RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	hdr = (void *)skb->data - RX_HTT_HDR_STATUS_LEN;
+	hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
 	skb->ip_summed = ath10k_htt_rx_get_csum_state(skb);
 
 	switch (fmt) {
 	case RX_MSDU_DECAP_RAW:
 		/* remove trailing FCS */
-		skb_trim(skb, skb->len - 4);
+		skb_trim(skb, skb->len - FCS_LEN);
 		break;
 	case RX_MSDU_DECAP_NATIVE_WIFI:
 		/* nothing to do here */
 		break;
 	case RX_MSDU_DECAP_ETHERNET2_DIX:
-		/* macaddr[6] + macaddr[6] + ethertype[2] */
-		skb_pull(skb, 6 + 6 + 2);
-		break;
-	case RX_MSDU_DECAP_8023_SNAP_LLC:
-		/* macaddr[6] + macaddr[6] + len[2] */
-		/* we don't need this for non-A-MSDU */
-		skb_pull(skb, 6 + 6 + 2);
-		break;
-	}
-
-	if (fmt == RX_MSDU_DECAP_ETHERNET2_DIX) {
-		void *llc;
-		int llclen;
+		/* strip ethernet header and insert decapped 802.11 header and
+		 * rfc1042 header */
 
-		llclen = 8;
-		llc  = hdr;
-		llc += roundup(ieee80211_hdrlen(hdr->frame_control), 4);
-		llc += roundup(ath10k_htt_rx_crypto_param_len(enctype), 4);
+		rfc1042 = hdr;
+		rfc1042 += roundup(hdr_len, 4);
+		rfc1042 += roundup(ath10k_htt_rx_crypto_param_len(enctype), 4);
 
-		skb_push(skb, llclen);
-		memcpy(skb->data, llc, llclen);
-	}
+		skb_pull(skb, sizeof(struct ethhdr));
+		memcpy(skb_push(skb, sizeof(struct rfc1042_hdr)),
+		       rfc1042, sizeof(struct rfc1042_hdr));
+		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
+		break;
+	case RX_MSDU_DECAP_8023_SNAP_LLC:
+		/* remove A-MSDU subframe header and insert
+		 * decapped 802.11 header. rfc1042 header is already there */
 
-	if (fmt >= RX_MSDU_DECAP_ETHERNET2_DIX) {
-		int len = ieee80211_hdrlen(hdr->frame_control);
-		skb_push(skb, len);
-		memcpy(skb->data, hdr, len);
+		skb_pull(skb, sizeof(struct amsdu_subframe_hdr));
+		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
+		break;
 	}
 
 	info->skb = skb;
-- 
1.7.9.5

