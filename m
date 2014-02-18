Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46230 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaBRBKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:40 -0500
Received: by mail-ee0-f41.google.com with SMTP id e51so6884699eek.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:39 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 4/7] rtl818x: make dev_alloc_skb() null pointer check to really work
Date: Tue, 18 Feb 2014 02:10:43 +0100
Message-Id: <1392685846-10116-5-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021045_963253_CAA7C98E)
In-Reply-To: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

During driver initialization, some skbs are preallocated for RX.
Currenly if the allocation fails, the driver's allocation routine
exits immediatly but it will return zero (success) anyway.

In this way the driver will continue initialization with buggy
pointers around.

This patch makes the driver's allocation routine to return
an error value and to print a complaint message when skb allocation
fails.
In this way its caller will not go further, avoinding the driver to
successfully load, and preventing dereferencing buggy pointers.

An hint is thus printed about why the driver failed.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 848ea59..cb97380 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -477,9 +477,10 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 		struct sk_buff *skb = dev_alloc_skb(MAX_RX_SIZE);
 		dma_addr_t *mapping;
 		entry = &priv->rx_ring[i];
-		if (!skb)
-			return 0;
-
+		if (!skb) {
+			wiphy_err(dev->wiphy, "Cannot allocate RX skb\n");
+			return -ENOMEM;
+		}
 		priv->rx_buf[i] = skb;
 		mapping = (dma_addr_t *)skb->cb;
 		*mapping = pci_map_single(priv->pdev, skb_tail_pointer(skb),
-- 
1.8.3.2

