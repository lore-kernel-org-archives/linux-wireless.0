Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbcF0QcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 07/12] rtl8xxxu: Adjust RX skb size to include space for phystats
Date: Mon, 27 Jun 2016 12:32:05 -0400
Message-Id: <1467045130-18874-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_183224_593910_B2DF5811)
In-Reply-To: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The old allocation didn't leave space for phystats in the buffer,
allowing the packet to be rejected if a frame size of size
IEEE80211_MAX_FRAME_LEN was received.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 393ae3b3..f77dae8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5276,11 +5276,12 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 
 	rx_desc_sz = fops->rx_desc_size;
 
-	if (priv->rx_buf_aggregation && fops->rx_agg_buf_size)
+	if (priv->rx_buf_aggregation && fops->rx_agg_buf_size) {
 		skb_size = fops->rx_agg_buf_size;
-	else
+		skb_size += (rx_desc_sz + sizeof(struct rtl8723au_phy_stats));
+	} else {
 		skb_size = IEEE80211_MAX_FRAME_LEN;
-	skb_size += rx_desc_sz;
+	}
 
 	skb = __netdev_alloc_skb(NULL, skb_size, GFP_KERNEL);
 	if (!skb)
-- 
2.7.4

