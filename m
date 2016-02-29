Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 098/113] rtl8xxxu: Do not parse RX descriptor info for C2H packets
Date: Mon, 29 Feb 2016 17:05:36 -0500
Message-Id: <1456783551-28315-99-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232954_045406_158A4A4B)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

C2H events are delivered as RX packets on 8723bu/8192eu. When
receiving a C2H event, do not parse the rest of the RX descriptor as
the info isn't valid.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index f4842aa..924b8cc 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7324,7 +7324,6 @@ static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
 		(struct rtl8723bu_rx_desc *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
 	int drvinfo_sz, desc_shift;
-	int rx_type;
 
 	skb_pull(skb, sizeof(struct rtl8723bu_rx_desc));
 
@@ -7334,6 +7333,12 @@ static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
 	desc_shift = rx_desc->shift;
 	skb_pull(skb, drvinfo_sz + desc_shift);
 
+	if (rx_desc->rpt_sel) {
+		struct device *dev = &priv->udev->dev;
+		dev_dbg(dev, "%s: C2H packet\n", __func__);
+		return RX_TYPE_C2H;
+	}
+
 	rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
@@ -7351,15 +7356,7 @@ static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
 		rx_status->rate_idx = rx_desc->rxmcs;
 	}
 
-	if (rx_desc->rpt_sel) {
-		struct device *dev = &priv->udev->dev;
-		dev_dbg(dev, "%s: C2H packet\n", __func__);
-		rx_type = RX_TYPE_C2H;
-	} else {
-		rx_type = RX_TYPE_DATA_PKT;
-	}
-
-	return rx_type;
+	return RX_TYPE_DATA_PKT;
 }
 
 static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
-- 
2.5.0

