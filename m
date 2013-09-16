Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46496 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3IPMtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 08:49:42 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 3/4] ath10k: cleanup RX decap handling
Date: Mon, 16 Sep 2013 14:49:16 +0200
Message-ID: <1379335757-15180-4-git-send-email-michal.kazior@tieto.com> (sfid-20130916_144946_694084_2BCB4F05)
In-Reply-To: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Native Wifi frames are always decapped as non-QoS
data frames meaning mac80211 couldn't set sk_buff
priority properly. The patch fixes this by using
the original 802.11 header.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   70 +++++++++++++++++-------------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index dad584f..083dd9a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -618,7 +618,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 	enum rx_msdu_decap_format fmt;
 	enum htt_rx_mpdu_encrypt_type enctype;
 	struct ieee80211_hdr *hdr;
-	u8 hdr_buf[64];
+	u8 hdr_buf[64], addr[ETH_ALEN], *qos;
 	unsigned int hdr_len;
 
 	rxd = (void *)skb->data - sizeof(*rxd);
@@ -652,6 +652,19 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			skb_trim(skb, skb->len - FCS_LEN);
 			break;
 		case RX_MSDU_DECAP_NATIVE_WIFI:
+			hdr = (struct ieee80211_hdr *)skb->data;
+			hdr_len = ieee80211_hdrlen(hdr->frame_control);
+			memcpy(addr, ieee80211_get_DA(hdr), ETH_ALEN);
+			skb_pull(skb, hdr_len);
+
+			hdr = (struct ieee80211_hdr *)hdr_buf;
+			hdr_len = ieee80211_hdrlen(hdr->frame_control);
+			memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
+
+			hdr = (struct ieee80211_hdr *)skb->data;
+			qos = ieee80211_get_qos_ctl(hdr);
+			qos[0] &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+			memcpy(ieee80211_get_DA(hdr), addr, ETH_ALEN);
 			break;
 		case RX_MSDU_DECAP_ETHERNET2_DIX:
 			decap_len = 0;
@@ -687,6 +700,9 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 	struct ieee80211_hdr *hdr;
 	enum rx_msdu_decap_format fmt;
 	enum htt_rx_mpdu_encrypt_type enctype;
+	u8 addr[ETH_ALEN];
+	int hdr_len;
+	void *rfc1042;
 
 	/* This shouldn't happen. If it does than it may be a FW bug. */
 	if (skb->next) {
@@ -700,48 +716,44 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 			RX_MSDU_START_INFO1_DECAP_FORMAT);
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
 			RX_MPDU_START_INFO0_ENCRYPT_TYPE);
-	hdr = (void *)skb->data - RX_HTT_HDR_STATUS_LEN;
+	hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
 	skb->ip_summed = ath10k_htt_rx_get_csum_state(skb);
 
 	switch (fmt) {
 	case RX_MSDU_DECAP_RAW:
-		/* remove trailing FCS */
-		skb_trim(skb, skb->len - 4);
+		skb_trim(skb, skb->len - FCS_LEN);
 		break;
 	case RX_MSDU_DECAP_NATIVE_WIFI:
-		/* nothing to do here */
+		hdr = (struct ieee80211_hdr *)skb->data;
+		hdr_len = ieee80211_hdrlen(hdr->frame_control);
+		memcpy(addr, ieee80211_get_DA(hdr), ETH_ALEN);
+		skb_pull(skb, hdr_len);
+
+		hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
+		hdr_len = ieee80211_hdrlen(hdr->frame_control);
+		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
+
+		hdr = (struct ieee80211_hdr *)skb->data;
+		memcpy(ieee80211_get_DA(hdr), addr, ETH_ALEN);
 		break;
 	case RX_MSDU_DECAP_ETHERNET2_DIX:
-		/* macaddr[6] + macaddr[6] + ethertype[2] */
-		skb_pull(skb, 6 + 6 + 2);
+		rfc1042 = hdr;
+		rfc1042 += roundup(hdr_len, 4);
+		rfc1042 += roundup(ath10k_htt_rx_crypto_param_len(enctype), 4);
+
+		skb_pull(skb, sizeof(struct ethhdr));
+		memcpy(skb_push(skb, sizeof(struct rfc1042_hdr)),
+		       rfc1042, sizeof(struct rfc1042_hdr));
+		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
 		break;
 	case RX_MSDU_DECAP_8023_SNAP_LLC:
-		/* macaddr[6] + macaddr[6] + len[2] */
-		/* we don't need this for non-A-MSDU */
-		skb_pull(skb, 6 + 6 + 2);
+		skb_pull(skb, sizeof(struct amsdu_subframe_hdr));
+		memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
 		break;
 	}
 
-	if (fmt == RX_MSDU_DECAP_ETHERNET2_DIX) {
-		void *llc;
-		int llclen;
-
-		llclen = 8;
-		llc  = hdr;
-		llc += roundup(ieee80211_hdrlen(hdr->frame_control), 4);
-		llc += roundup(ath10k_htt_rx_crypto_param_len(enctype), 4);
-
-		skb_push(skb, llclen);
-		memcpy(skb->data, llc, llclen);
-	}
-
-	if (fmt >= RX_MSDU_DECAP_ETHERNET2_DIX) {
-		int len = ieee80211_hdrlen(hdr->frame_control);
-		skb_push(skb, len);
-		memcpy(skb->data, hdr, len);
-	}
-
 	info->skb = skb;
 	info->encrypt_type = enctype;
 
-- 
1.7.9.5

