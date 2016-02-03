Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933818AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 24/28] rtl8xxxu: Remove unused mgmt variable from rtl8xxxu_rx_complete()
Date: Wed,  3 Feb 2016 13:39:58 -0500
Message-Id: <1454524802-26763-25-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194750_809355_FCE9A879)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 460145c..1201836 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5031,7 +5031,6 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 	struct rtl8xxxu_rx_desc *rx_desc = (struct rtl8xxxu_rx_desc *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_mgmt *mgmt;
 	struct device *dev = &priv->udev->dev;
 	__le32 *_rx_desc_le = (__le32 *)skb->data;
 	u32 *_rx_desc = (u32 *)skb->data;
@@ -5052,8 +5051,6 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 
 		skb_pull(skb, drvinfo_sz + desc_shift);
 
-		mgmt = (struct ieee80211_mgmt *)skb->data;
-
 		memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
 		if (rx_desc->phy_stats)
-- 
2.5.0

