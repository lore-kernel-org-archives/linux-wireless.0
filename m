Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19799 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbZHGKfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:35:18 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 19/23] wl1251: use workqueue provided by mac80211
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:35:04 +0300
Message-ID: <20090807103504.31717.20634.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl1251 should use workqueue created by mac80211 to not block the events
workqueue too long.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    2 +-
 drivers/net/wireless/wl12xx/wl1251_sdio.c |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 568b640..c5f2d9d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -375,7 +375,7 @@ static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * before that, the tx_work will not be initialized!
 	 */
 
-	schedule_work(&wl->tx_work);
+	ieee80211_queue_work(wl->hw, &wl->tx_work);
 
 	/*
 	 * The workqueue is slow to process the tx_queue and we need stop
diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index f7e451f..20668e2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -55,7 +55,7 @@ static void wl1251_sdio_interrupt(struct sdio_func *func)
 	wl1251_debug(DEBUG_IRQ, "IRQ");
 
 	/* FIXME should be synchronous for sdio */
-	schedule_work(&wl->irq_work);
+	ieee80211_queue_work(wl->hw, &wl->irq_work);
 }
 
 static const struct sdio_device_id wl1251_devices[] = {
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 7d1031b..e088334 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -39,7 +39,7 @@ static irqreturn_t wl1251_irq(int irq, void *cookie)
 
 	wl = cookie;
 
-	schedule_work(&wl->irq_work);
+	ieee80211_queue_work(wl->hw, &wl->irq_work);
 
 	return IRQ_HANDLED;
 }

