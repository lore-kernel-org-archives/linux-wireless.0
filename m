Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab2EJJQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:07 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:07 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 44/78] wlcore/wl12xx: add plt_init op and move the code to wl12xx
Date: Thu, 10 May 2012 12:13:49 +0300
Message-Id: <1336641263-5761-45-git-send-email-arik@wizery.com> (sfid-20120510_112110_495453_6C8C6D13)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

PLT mode needs to be initialized differently for each chip.  This
patch adds an operation to init PLT and moves the existing PLT
initialization into the wl12xx driver.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   57 +++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/acx.c    |    4 +++
 drivers/net/wireless/ti/wlcore/cmd.c    |    1 +
 drivers/net/wireless/ti/wlcore/main.c   |   59 +------------------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 5 files changed, 64 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0266855..1d097c1 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1302,10 +1302,67 @@ static void wl12xx_set_tx_desc_csum(struct wl1271 *wl,
 	desc->wl12xx_reserved = 0;
 }
 
+static int wl12xx_plt_init(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl->ops->boot(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl->ops->hw_init(wl);
+	if (ret < 0)
+		goto out_irq_disable;
+
+	ret = wl1271_acx_init_mem_config(wl);
+	if (ret < 0)
+		goto out_irq_disable;
+
+	ret = wl12xx_acx_mem_cfg(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Enable data path */
+	ret = wl1271_cmd_data_path(wl, 1);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Configure for CAM power saving (ie. always active) */
+	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* configure PM */
+	ret = wl1271_acx_pm_config(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	goto out;
+
+out_free_memmap:
+	kfree(wl->target_mem_map);
+	wl->target_mem_map = NULL;
+
+out_irq_disable:
+	mutex_unlock(&wl->mutex);
+	/* Unlocking the mutex in the middle of handling is
+	   inherently unsafe. In this case we deem it safe to do,
+	   because we need to let any possibly pending IRQ out of
+	   the system (and while we are WL1271_STATE_OFF the IRQ
+	   work function will not do anything.) Also, any other
+	   possible concurrent operations will fail due to the
+	   current state, hence the wl1271 struct should be safe. */
+	wlcore_disable_interrupts(wl);
+	mutex_lock(&wl->mutex);
+out:
+	return ret;
+}
+
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip		= wl12xx_identify_chip,
 	.identify_fw		= wl12xx_identify_fw,
 	.boot			= wl12xx_boot,
+	.plt_init		= wl12xx_plt_init,
 	.trigger_cmd		= wl12xx_trigger_cmd,
 	.ack_event		= wl12xx_ack_event,
 	.calc_tx_blocks		= wl12xx_calc_tx_blocks,
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 0fd78a0..611666e 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -86,6 +86,7 @@ out:
 	kfree(auth);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl1271_acx_sleep_auth);
 
 int wl1271_acx_tx_power(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			int power)
@@ -997,6 +998,7 @@ out:
 	kfree(mem_conf);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl12xx_acx_mem_cfg);
 
 int wl1271_acx_init_mem_config(struct wl1271 *wl)
 {
@@ -1027,6 +1029,7 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_acx_init_mem_config);
 
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl)
 {
@@ -1150,6 +1153,7 @@ out:
 	kfree(acx);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl1271_acx_pm_config);
 
 int wl1271_acx_keep_alive_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       bool enable)
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 0dec465..5c47560 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -816,6 +816,7 @@ out:
 	kfree(cmd);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl1271_cmd_data_path);
 
 int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		       u8 ps_mode, u16 auto_ps_timeout)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 414ffa8..3aadf74 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -320,46 +320,6 @@ static void wlcore_adjust_conf(struct wl1271 *wl)
 	}
 }
 
-static int wl1271_plt_init(struct wl1271 *wl)
-{
-	int ret;
-
-	ret = wl->ops->hw_init(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_acx_init_mem_config(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_mem_cfg(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Enable data path */
-	ret = wl1271_cmd_data_path(wl, 1);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Configure for CAM power saving (ie. always active) */
-	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* configure PM */
-	ret = wl1271_acx_pm_config(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	return 0;
-
- out_free_memmap:
-	kfree(wl->target_mem_map);
-	wl->target_mem_map = NULL;
-
-	return ret;
-}
-
 static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 					struct wl12xx_vif *wlvif,
 					u8 hlid, u8 tx_pkts)
@@ -1042,14 +1002,10 @@ int wl1271_plt_start(struct wl1271 *wl)
 		if (ret < 0)
 			goto power_off;
 
-		ret = wl->ops->boot(wl);
+		ret = wl->ops->plt_init(wl);
 		if (ret < 0)
 			goto power_off;
 
-		ret = wl1271_plt_init(wl);
-		if (ret < 0)
-			goto irq_disable;
-
 		wl->plt = true;
 		wl->state = WL1271_STATE_ON;
 		wl1271_notice("firmware booted in PLT mode (%s)",
@@ -1062,19 +1018,6 @@ int wl1271_plt_start(struct wl1271 *wl)
 
 		goto out;
 
-irq_disable:
-		mutex_unlock(&wl->mutex);
-		/* Unlocking the mutex in the middle of handling is
-		   inherently unsafe. In this case we deem it safe to do,
-		   because we need to let any possibly pending IRQ out of
-		   the system (and while we are WL1271_STATE_OFF the IRQ
-		   work function will not do anything.) Also, any other
-		   possible concurrent operations will fail due to the
-		   current state, hence the wl1271 struct should be safe. */
-		wlcore_disable_interrupts(wl);
-		wl1271_flush_deferred_work(wl);
-		cancel_work_sync(&wl->netstack_work);
-		mutex_lock(&wl->mutex);
 power_off:
 		wl1271_power_off(wl);
 	}
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index f62152e..1fc3c77 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -39,6 +39,7 @@ struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*identify_fw)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
+	int (*plt_init)(struct wl1271 *wl);
 	void (*trigger_cmd)(struct wl1271 *wl, int cmd_box_addr,
 			    void *buf, size_t len);
 	void (*ack_event)(struct wl1271 *wl);
-- 
1.7.9.5

