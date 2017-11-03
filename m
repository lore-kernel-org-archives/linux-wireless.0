Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56664 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756003AbdKCNpa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 09:45:30 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] orinoco_usb: remove redundant pointer dev
Date: Fri,  3 Nov 2017 13:45:28 +0000
Message-Id: <20171103134528.8415-1-colin.king@canonical.com> (sfid-20171103_144548_841423_3DDECC7A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The pointer dev is assigned but never read, hence it is redundant
and can be removed. Cleans up clang warning:

drivers/net/wireless/intersil/orinoco/orinoco_usb.c:1468:2: warning:
Value stored to 'dev' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 56f6e3b71f48..501180584b4b 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1457,7 +1457,6 @@ static void ezusb_bulk_in_callback(struct urb *urb)
 
 static inline void ezusb_delete(struct ezusb_priv *upriv)
 {
-	struct net_device *dev;
 	struct list_head *item;
 	struct list_head *tmp_item;
 	unsigned long flags;
@@ -1465,7 +1464,6 @@ static inline void ezusb_delete(struct ezusb_priv *upriv)
 	BUG_ON(in_interrupt());
 	BUG_ON(!upriv);
 
-	dev = upriv->dev;
 	mutex_lock(&upriv->mtx);
 
 	upriv->udev = NULL;	/* No timer will be rearmed from here */
-- 
2.14.1
