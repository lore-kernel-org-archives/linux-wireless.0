Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:22973 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYFTDeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 23:34:12 -0400
Received: by wa-out-1112.google.com with SMTP id j37so782632waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 20:34:12 -0700 (PDT)
Subject: [PATCH] adm8211: remove masking of protected bit
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 20:34:10 -0700
Message-Id: <1213932851.6591.8.camel@brick> (sfid-20080620_053429_400940_138640D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the ieee80211_hdrlen helper to avoid byteshifting.

The masking of the protected bit made the two tests below never trigger.

Possibly a bugfix.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I'm not sure if this was intentional, please review.  If it was intentional
the two if-blocks should probably be deleted.

 drivers/net/wireless/adm8211.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 0ba55ba..ed650d7 100644
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
@@ -1711,7 +1709,7 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	txhdr->frame_control = hdr->frame_control;
 
 	len = hdrlen + payload_len + FCS_LEN;
-	if (fc & IEEE80211_FCTL_PROTECTED)
+	if (ieee80211_has_protected(hdr->frame_control))
 		len += 8;
 
 	txhdr->frag = cpu_to_le16(0x0FFF);
@@ -1730,7 +1728,7 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
 		txhdr->header_control |= cpu_to_le16(ADM8211_TXHDRCTL_ENABLE_RTS);
 
-	if (fc & IEEE80211_FCTL_PROTECTED)
+	if (ieee80211_has_protected(hdr->frame_control))
 		txhdr->header_control |= cpu_to_le16(ADM8211_TXHDRCTL_ENABLE_WEP_ENGINE);
 
 	txhdr->retry_limit = info->control.retry_limit;
-- 
1.5.6.290.gc4e15



