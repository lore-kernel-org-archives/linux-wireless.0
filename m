Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbcKRVoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 16:44:30 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/7] rtl8xxxu: Fix memory leak in handling rxdesc16 packets
Date: Fri, 18 Nov 2016 16:44:22 -0500
Message-Id: <1479505468-29383-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20161118_224442_662023_DE872AFE)
In-Reply-To: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

A device running without RX package aggregation could return more data
in the USB packet than the actual network packet. In this case the
could would clone the skb but then determine that that there was no
packet to handle and exit without freeing the cloned skb first.

This has so far only been observed with 8188eu devices, but could
affect others.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index b2d7f6e..a96ff17 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5197,7 +5197,12 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 		pkt_offset = roundup(pkt_len + drvinfo_sz + desc_shift +
 				     sizeof(struct rtl8xxxu_rxdesc16), 128);
 
-		if (pkt_cnt > 1)
+		/*
+		 * Only clone the skb if there's enough data at the end to
+		 * at least cover the rx descriptor
+		 */
+		if (pkt_cnt > 1 &&
+		    urb_len > (pkt_offset + sizeof(struct rtl8xxxu_rxdesc16)))
 			next_skb = skb_clone(skb, GFP_ATOMIC);
 
 		rx_status = IEEE80211_SKB_RXCB(skb);
-- 
2.7.4
