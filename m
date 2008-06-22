Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:55685 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYFVCdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 22:33:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1505512wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2008 19:33:22 -0700 (PDT)
Subject: [PATCH] adm8211: remove unnecessary protected bit mask/check
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200806212221.54814.flamingice@sourmilk.net>
References: <1213932851.6591.8.camel@brick>
	 <200806212221.54814.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 19:33:20 -0700
Message-Id: <1214102000.21092.1.camel@brick> (sfid-20080622_043351_078817_038C3AA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes now unused fc local var and uses the new ieee80211_hdrlen
which directly uses the le16 frame control value.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/adm8211.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 0ba55ba..3333d45 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1685,7 +1685,6 @@ static void adm8211_tx_raw(struct ieee80211_hw *dev, struct sk_buff *skb,
 static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct adm8211_tx_hdr *txhdr;
-	u16 fc;
 	size_t payload_len, hdrlen;
 	int plcp, dur, len, plcp_signal, short_preamble;
 	struct ieee80211_hdr *hdr;
@@ -1696,8 +1695,7 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	plcp_signal = txrate->bitrate;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = le16_to_cpu(hdr->frame_control) & ~IEEE80211_FCTL_PROTECTED;
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	memcpy(skb->cb, skb->data, hdrlen);
 	hdr = (struct ieee80211_hdr *)skb->cb;
 	skb_pull(skb, hdrlen);
@@ -1711,8 +1709,6 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	txhdr->frame_control = hdr->frame_control;
 
 	len = hdrlen + payload_len + FCS_LEN;
-	if (fc & IEEE80211_FCTL_PROTECTED)
-		len += 8;
 
 	txhdr->frag = cpu_to_le16(0x0FFF);
 	adm8211_calc_durations(&dur, &plcp, payload_len,
@@ -1730,9 +1726,6 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		txhdr->header_control |= cpu_to_le16(ADM8211_TXHDRCTL_ENABLE_RTS);
 
-	if (fc & IEEE80211_FCTL_PROTECTED)
-		txhdr->header_control |= cpu_to_le16(ADM8211_TXHDRCTL_ENABLE_WEP_ENGINE);
-
 	txhdr->retry_limit = info->control.retry_limit;
 
 	adm8211_tx_raw(dev, skb, plcp_signal, hdrlen);
-- 
1.5.6.290.gc4e15



