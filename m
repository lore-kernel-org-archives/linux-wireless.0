Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:38334 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0AQXHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 18:07:46 -0500
Received: by fg-out-1718.google.com with SMTP id 22so385765fge.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 15:07:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54pci: rx frame length check
Date: Mon, 18 Jan 2010 00:07:38 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201001180007.38948.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A long time ago, a user reported several crashes due to
data corruptions which are likely the result of a
not-100%-supported, or faulty? PCI bridge.
( http://patchwork.kernel.org/patch/53004/ )

This patch fixes entry #1. 
"1.  p54p_check_rx_ring - skb_over_panic: Under a ping flood 
or just left running for a bit would panic with a skb_over_panic." 
As described in the mail: The invalid frame length causes
skb_put to bailout and trigger a crash.

Reported-by: Quintin Pitts <geek4linux@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Note:
Simply dropping the frame is problematic, because if its content
contains a tx feedback we would lose some portion of the device
memory space.... And the driver/mac80211 should handle all other
invalid data.
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index a227c3d..48cae48 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -205,6 +205,14 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
 			i %= ring_limit;
 			continue;
 		}
+
+		if (unlikely(len > priv->common.rx_mtu)) {
+			if (net_ratelimit())
+				dev_err(&priv->pdev->dev, "rx'd frame size "
+					"exceeds length threshold.\n");
+
+			len = priv->common.rx_mtu;
+		}
 		skb_put(skb, len);
 
 		if (p54_rx(dev, skb)) {
