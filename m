Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.199.79]:43742 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbcHBKTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 06:19:44 -0400
From: Pavel Andrianov <andrianov@ispras.ru>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Pavel Andrianov <andrianov@ispras.ru>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
	vaishali.thakkar@oracle.com
Subject: [PATCH] wl3501_cs: Add spinlock to wl3501_reset
Date: Tue,  2 Aug 2016 12:41:53 +0300
Message-Id: <1470130913-5218-1-git-send-email-andrianov@ispras.ru> (sfid-20160802_122036_177239_2213073A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Likely wl3501_reset should acquire spinlock as wl3501_{open, close}.
One of calls of wl3501_reset has been already protected.
The others were unprotected and might lead to a race condition.
The patch adds spinlock into the wl3501_reset and removes it from 
wl3501_tx_timeout.

Found by Linux Driver Verification project (linuxtesting.org)

Signed-off-by: Pavel Andrianov <andrianov@ispras.ru>
---
 drivers/net/wireless/wl3501_cs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 13fd734..196f13c 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1247,7 +1247,9 @@ static int wl3501_reset(struct net_device *dev)
 {
 	struct wl3501_card *this = netdev_priv(dev);
 	int rc = -ENODEV;
+	unsigned long flags;
 
+	spin_lock_irqsave(&this->lock, flags);
 	wl3501_block_interrupt(this);
 
 	if (wl3501_init_firmware(this)) {
@@ -1269,20 +1271,17 @@ static int wl3501_reset(struct net_device *dev)
 	pr_debug("%s: device reset", dev->name);
 	rc = 0;
 out:
+	spin_unlock_irqrestore(&this->lock, flags);
 	return rc;
 }
 
 static void wl3501_tx_timeout(struct net_device *dev)
 {
-	struct wl3501_card *this = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
-	unsigned long flags;
 	int rc;
 
 	stats->tx_errors++;
-	spin_lock_irqsave(&this->lock, flags);
 	rc = wl3501_reset(dev);
-	spin_unlock_irqrestore(&this->lock, flags);
 	if (rc)
 		printk(KERN_ERR "%s: Error %d resetting card on Tx timeout!\n",
 		       dev->name, rc);
-- 
2.7.4

