Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49447 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaBSH5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 02:57:30 -0500
Received: by mail-ea0-f181.google.com with SMTP id k10so154372eaj.12
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 23:57:29 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix 4addr rx
Date: Wed, 19 Feb 2014 08:52:25 +0100
Message-Id: <1392796345-14272-1-git-send-email-michal.kazior@tieto.com> (sfid-20140219_085734_275182_921DE568)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nwifi header is padded to 4 bytes. This wasn't
a problem until one tried to (at least) rx 4addr
frames.

This finally allows managed iface to be used in a
bridge.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 371bed6..fcd00f6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -632,6 +632,12 @@ struct amsdu_subframe_hdr {
 	__be16 len;
 } __packed;
 
+static int ath10k_htt_rx_nwifi_hdrlen(struct ieee80211_hdr *hdr)
+{
+	/* nwifi header is padded to 4 bytes. this fixes 4addr rx */
+	return round_up(ieee80211_hdrlen(hdr->frame_control), 4);
+}
+
 static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 				struct htt_rx_info *info)
 {
@@ -681,7 +687,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 		case RX_MSDU_DECAP_NATIVE_WIFI:
 			/* pull decapped header and copy DA */
 			hdr = (struct ieee80211_hdr *)skb->data;
-			hdr_len = ieee80211_hdrlen(hdr->frame_control);
+			hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
 			memcpy(addr, ieee80211_get_DA(hdr), ETH_ALEN);
 			skb_pull(skb, hdr_len);
 
@@ -768,7 +774,7 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt, struct htt_rx_info *info)
 	case RX_MSDU_DECAP_NATIVE_WIFI:
 		/* Pull decapped header */
 		hdr = (struct ieee80211_hdr *)skb->data;
-		hdr_len = ieee80211_hdrlen(hdr->frame_control);
+		hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
 		skb_pull(skb, hdr_len);
 
 		/* Push original header */
-- 
1.8.5.3

