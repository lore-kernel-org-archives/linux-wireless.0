Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 10/26] rtl8xxxu: byteswap the entire RX descriptor for 24 byte RX descriptors
Date: Thu, 14 Apr 2016 14:58:51 -0400
Message-Id: <1460660347-26299-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212530_008773_C5225C2A)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This shouldn't affect little endian system, but may have prevented the
driver working on big endian systems for devices with the larger 24
byte RX descriptors.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8b0b6c9..6545012 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8832,7 +8832,13 @@ static int rtl8723au_parse_rx_desc(struct rtl8xxxu_priv *priv,
 {
 	struct rtl8xxxu_rx_desc *rx_desc = (struct rtl8xxxu_rx_desc *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
+	__le32 *_rx_desc_le = (__le32 *)skb->data;
+	u32 *_rx_desc = (u32 *)skb->data;
 	int drvinfo_sz, desc_shift;
+	int i;
+
+	for (i = 0; i < (sizeof(struct rtl8xxxu_rx_desc) / sizeof(u32)); i++)
+		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
 	skb_pull(skb, sizeof(struct rtl8xxxu_rx_desc));
 
@@ -8873,7 +8879,13 @@ static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
 	struct rtl8723bu_rx_desc *rx_desc =
 		(struct rtl8723bu_rx_desc *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
+	__le32 *_rx_desc_le = (__le32 *)skb->data;
+	u32 *_rx_desc = (u32 *)skb->data;
 	int drvinfo_sz, desc_shift;
+	int i;
+
+	for (i = 0; i < (sizeof(struct rtl8723bu_rx_desc) / sizeof(u32)); i++)
+		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
 	skb_pull(skb, sizeof(struct rtl8723bu_rx_desc));
 
@@ -8967,12 +8979,7 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct device *dev = &priv->udev->dev;
-	__le32 *_rx_desc_le = (__le32 *)skb->data;
-	u32 *_rx_desc = (u32 *)skb->data;
-	int rx_type, i;
-
-	for (i = 0; i < (sizeof(struct rtl8xxxu_rx_desc) / sizeof(u32)); i++)
-		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
+	int rx_type;
 
 	skb_put(skb, urb->actual_length);
 
-- 
2.5.5

