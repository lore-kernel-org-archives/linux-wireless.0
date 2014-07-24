Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52202 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbaGXMpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 08:45:23 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so9078026wiv.2
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 05:45:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Vu Hai NGUYEN <vh.nguyen@actiasodielec.fr>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix aggregated 4addr Rx
Date: Thu, 24 Jul 2014 14:36:14 +0200
Message-Id: <1406205374-24858-1-git-send-email-michal.kazior@tieto.com> (sfid-20140724_144527_875274_20AFF05B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A-MSDU 4addr frames weren't reconstructed properly
and in some cases this resulted in a warning:

 br0: received packet on wlan0.sta1 with own address as source address

Since this was only related to A-MSDU it would
trigger when more intense traffic was generated.

Reported-by: Vu Hai NGUYEN <vh.nguyen@actiasodielec.fr>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 318efc3..a8328f9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -859,7 +859,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 	enum rx_msdu_decap_format fmt;
 	enum htt_rx_mpdu_encrypt_type enctype;
 	struct ieee80211_hdr *hdr;
-	u8 hdr_buf[64], addr[ETH_ALEN], *qos;
+	u8 hdr_buf[64], da[ETH_ALEN], sa[ETH_ALEN], *qos;
 	unsigned int hdr_len;
 
 	rxd = (void *)skb->data - sizeof(*rxd);
@@ -897,10 +897,11 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			skb_trim(skb, skb->len - FCS_LEN);
 			break;
 		case RX_MSDU_DECAP_NATIVE_WIFI:
-			/* pull decapped header and copy DA */
+			/* pull decapped header and copy SA & DA */
 			hdr = (struct ieee80211_hdr *)skb->data;
 			hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
-			memcpy(addr, ieee80211_get_DA(hdr), ETH_ALEN);
+			memcpy(da, ieee80211_get_DA(hdr), ETH_ALEN);
+			memcpy(sa, ieee80211_get_SA(hdr), ETH_ALEN);
 			skb_pull(skb, hdr_len);
 
 			/* push original 802.11 header */
@@ -914,8 +915,11 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			qos = ieee80211_get_qos_ctl(hdr);
 			qos[0] &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
-			/* original 802.11 header has a different DA */
-			memcpy(ieee80211_get_DA(hdr), addr, ETH_ALEN);
+			/* original 802.11 header has a different DA and in
+			 * case of 4addr it may also have different SA
+			 */
+			memcpy(ieee80211_get_DA(hdr), da, ETH_ALEN);
+			memcpy(ieee80211_get_SA(hdr), sa, ETH_ALEN);
 			break;
 		case RX_MSDU_DECAP_ETHERNET2_DIX:
 			/* strip ethernet header and insert decapped 802.11
-- 
1.8.5.3

