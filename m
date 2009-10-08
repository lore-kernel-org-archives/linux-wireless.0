Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56640 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759684AbZJHS6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:41 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 13/20] wl1271: use workqueue provided by mac80211 instead of the default
Date: Thu,  8 Oct 2009 21:56:29 +0300
Message-Id: <1255028196-6565-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Use the workqueue provided by the mac80211 stack instead of the system
default queue.

Modified to use new ieee_queue_work() as required by changes in the
stack.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 1a0491a..d104230 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -107,7 +107,7 @@ static void wl1271_fw_status(struct wl1271 *wl, struct wl1271_fw_status *status)
 
 	/* if more blocks are available now, schedule some tx work */
 	if (total && !skb_queue_empty(&wl->tx_queue))
-		schedule_work(&wl->tx_work);
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
 
 	/* update the host-chipset time offset */
 	wl->time_offset = jiffies_to_usecs(jiffies) - status->fw_localtime;
@@ -205,7 +205,7 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		wl->elp_compl = NULL;
 	}
 
-	schedule_work(&wl->irq_work);
+	ieee80211_queue_work(wl->hw, &wl->irq_work);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	return IRQ_HANDLED;
@@ -480,7 +480,7 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * before that, the tx_work will not be initialized!
 	 */
 
-	schedule_work(&wl->tx_work);
+	ieee80211_queue_work(wl->hw, &wl->tx_work);
 
 	/*
 	 * The workqueue is slow to process the tx_queue and we need stop
-- 
1.5.6.5

