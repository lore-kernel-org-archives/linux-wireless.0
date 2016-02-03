Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933799AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 25/28] rtl8xxxu: Remove unused len/cnt variables from rtl8xxxu_rx_complete()
Date: Wed,  3 Feb 2016 13:39:59 -0500
Message-Id: <1454524802-26763-26-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194134_738154_1D537DF6)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 1201836..a6c8dab 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5034,13 +5034,11 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 	struct device *dev = &priv->udev->dev;
 	__le32 *_rx_desc_le = (__le32 *)skb->data;
 	u32 *_rx_desc = (u32 *)skb->data;
-	int cnt, len, drvinfo_sz, desc_shift, i;
+	int drvinfo_sz, desc_shift, i;
 
 	for (i = 0; i < (sizeof(struct rtl8xxxu_rx_desc) / sizeof(u32)); i++)
 		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
-	cnt = rx_desc->frag;
-	len = rx_desc->pktlen;
 	drvinfo_sz = rx_desc->drvinfo_sz * 8;
 	desc_shift = rx_desc->shift;
 	skb_put(skb, urb->actual_length);
-- 
2.5.0

