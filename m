Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53710 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2FPTb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:31:56 -0400
Received: by weyu7 with SMTP id u7so2780503wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:31:55 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/3] wl1251: remove unused filter_work
Date: Sat, 16 Jun 2012 22:31:48 +0300
Message-Id: <1339875110-10260-2-git-send-email-notasas@gmail.com> (sfid-20120616_213159_558794_4E869FE9)
In-Reply-To: <1339875110-10260-1-git-send-email-notasas@gmail.com>
References: <1339875110-10260-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

filter_work is never used, remove it.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c   |   36 -------------------------------
 drivers/net/wireless/ti/wl1251/wl1251.h |    1 -
 2 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index d1afb8e..ff60a7a 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -348,33 +348,6 @@ out:
 	return ret;
 }
 
-static void wl1251_filter_work(struct work_struct *work)
-{
-	struct wl1251 *wl =
-		container_of(work, struct wl1251, filter_work);
-	int ret;
-
-	mutex_lock(&wl->mutex);
-
-	if (wl->state == WL1251_STATE_OFF)
-		goto out;
-
-	ret = wl1251_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl1251_join(wl, wl->bss_type, wl->channel, wl->beacon_int,
-			  wl->dtim_period);
-	if (ret < 0)
-		goto out_sleep;
-
-out_sleep:
-	wl1251_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-}
-
 static void wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1251 *wl = hw->priv;
@@ -478,7 +451,6 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
-	cancel_work_sync(&wl->filter_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 
 	mutex_lock(&wl->mutex);
@@ -723,13 +695,6 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 		wl->rx_filter |= CFG_RX_CTL_EN;
 	if (*total & FIF_OTHER_BSS)
 		wl->rx_filter &= ~CFG_BSSID_FILTER_EN;
-
-	/*
-	 * FIXME: workqueues need to be properly cancelled on stop(), for
-	 * now let's just disable changing the filter settings. They will
-	 * be updated any on config().
-	 */
-	/* schedule_work(&wl->filter_work); */
 }
 
 /* HW encryption */
@@ -1390,7 +1355,6 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 
 	skb_queue_head_init(&wl->tx_queue);
 
-	INIT_WORK(&wl->filter_work, wl1251_filter_work);
 	INIT_DELAYED_WORK(&wl->elp_work, wl1251_elp_work);
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->scanning = false;
diff --git a/drivers/net/wireless/ti/wl1251/wl1251.h b/drivers/net/wireless/ti/wl1251/wl1251.h
index 9d8f581..fd02060 100644
--- a/drivers/net/wireless/ti/wl1251/wl1251.h
+++ b/drivers/net/wireless/ti/wl1251/wl1251.h
@@ -315,7 +315,6 @@ struct wl1251 {
 	bool tx_queue_stopped;
 
 	struct work_struct tx_work;
-	struct work_struct filter_work;
 
 	/* Pending TX frames */
 	struct sk_buff *tx_frames[16];
-- 
1.7.0.4

