Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:48916 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759168Ab1JFTLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:24 -0400
Received: by mail-bw0-f52.google.com with SMTP id 5so3592068bke.25
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:23 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] wl12xx: mark some symbols static
Date: Thu,  6 Oct 2011 22:10:58 +0300
Message-Id: <1317928259-26437-8-git-send-email-coelho@ti.com> (sfid-20111006_211130_278698_870A9DA2)
In-Reply-To: <1317928259-26437-1-git-send-email-coelho@ti.com>
References: <1317928259-26437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <balbi@ti.com>

after re-factoring a bunch of symbols are only
used inside main.c which allows us to mark
them as static.

Signed-off-by: Felipe Balbi <balbi@ti.com>
[forward-ported]
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/io.h   |    9 ++-------
 drivers/net/wireless/wl12xx/main.c |   18 ++++++------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index e82dad1..d398cbc 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -170,15 +170,10 @@ u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
 int wl1271_set_partition(struct wl1271 *wl,
 			 struct wl1271_partition_set *p);
 
+bool wl1271_set_block_size(struct wl1271 *wl);
+
 /* Functions from wl1271_main.c */
 
-int wl1271_register_hw(struct wl1271 *wl);
-void wl1271_unregister_hw(struct wl1271 *wl);
-int wl1271_init_ieee80211(struct wl1271 *wl);
-struct ieee80211_hw *wl1271_alloc_hw(void);
-int wl1271_free_hw(struct wl1271 *wl);
-irqreturn_t wl1271_irq(int irq, void *data);
-bool wl1271_set_block_size(struct wl1271 *wl);
 int wl1271_tx_dummy_packet(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e84948d..18f87f0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -922,7 +922,7 @@ static void wl1271_netstack_work(struct work_struct *work)
 
 #define WL1271_IRQ_MAX_LOOPS 256
 
-irqreturn_t wl1271_irq(int irq, void *cookie)
+static irqreturn_t wl1271_irq(int irq, void *cookie)
 {
 	int ret;
 	u32 intr;
@@ -1044,7 +1044,6 @@ out:
 
 	return IRQ_HANDLED;
 }
-EXPORT_SYMBOL_GPL(wl1271_irq);
 
 static int wl1271_fetch_firmware(struct wl1271 *wl)
 {
@@ -4676,7 +4675,7 @@ static struct bin_attribute fwlog_attr = {
 	.read = wl1271_sysfs_read_fwlog,
 };
 
-int wl1271_register_hw(struct wl1271 *wl)
+static int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
 
@@ -4717,9 +4716,8 @@ int wl1271_register_hw(struct wl1271 *wl)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(wl1271_register_hw);
 
-void wl1271_unregister_hw(struct wl1271 *wl)
+static void wl1271_unregister_hw(struct wl1271 *wl)
 {
 	if (wl->state == WL1271_STATE_PLT)
 		__wl1271_plt_stop(wl);
@@ -4729,9 +4727,8 @@ void wl1271_unregister_hw(struct wl1271 *wl)
 	wl->mac80211_registered = false;
 
 }
-EXPORT_SYMBOL_GPL(wl1271_unregister_hw);
 
-int wl1271_init_ieee80211(struct wl1271 *wl)
+static int wl1271_init_ieee80211(struct wl1271 *wl)
 {
 	static const u32 cipher_suites[] = {
 		WLAN_CIPHER_SUITE_WEP40,
@@ -4817,11 +4814,10 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(wl1271_init_ieee80211);
 
 #define WL1271_DEFAULT_CHANNEL 0
 
-struct ieee80211_hw *wl1271_alloc_hw(void)
+static struct ieee80211_hw *wl1271_alloc_hw(void)
 {
 	struct ieee80211_hw *hw;
 	struct platform_device *plat_dev = NULL;
@@ -5003,9 +4999,8 @@ err_hw_alloc:
 
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 
-int wl1271_free_hw(struct wl1271 *wl)
+static int wl1271_free_hw(struct wl1271 *wl)
 {
 	/* Unblock any fwlog readers */
 	mutex_lock(&wl->mutex);
@@ -5040,7 +5035,6 @@ int wl1271_free_hw(struct wl1271 *wl)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(wl1271_free_hw);
 
 static irqreturn_t wl12xx_hardirq(int irq, void *cookie)
 {
-- 
1.7.1

