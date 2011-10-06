Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33186 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759169Ab1JFTL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:27 -0400
Received: by mail-bw0-f49.google.com with SMTP id t2so5714913bka.22
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:25 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] wl12xx: drop unneeded plat_dev
Date: Thu,  6 Oct 2011 22:10:59 +0300
Message-Id: <1317928259-26437-9-git-send-email-coelho@ti.com> (sfid-20111006_211132_750410_0105829E)
In-Reply-To: <1317928259-26437-1-git-send-email-coelho@ti.com>
References: <1317928259-26437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <balbi@ti.com>

now that useless plat_dev is unnecessary,
we can remove it.

Signed-off-by: Felipe Balbi <balbi@ti.com>
[forward ported and fixed sysfs file creation]
Signed-off-by: Luciano Coelho <coelho@ti.com>
---

Moved sysfs file creation to the end of the probe function instead of
doing it in the hw_alloc() function.  It's too early to do it in
hw_alloc, because we don't have wl->dev at that point yet.

 drivers/net/wireless/wl12xx/main.c   |  104 ++++++++++------------------------
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 2 files changed, 30 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 18f87f0..63ff36c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -382,22 +382,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues);
 static void wl1271_free_ap_keys(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 
-
-static void wl1271_device_release(struct device *dev)
-{
-
-}
-
-static struct platform_device wl1271_device = {
-	.name           = "wl1271",
-	.id             = -1,
-
-	/* device model insists to have a release function */
-	.dev            = {
-		.release = wl1271_device_release,
-	},
-};
-
 static DEFINE_MUTEX(wl_list_mutex);
 static LIST_HEAD(wl_list);
 
@@ -4820,7 +4804,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 static struct ieee80211_hw *wl1271_alloc_hw(void)
 {
 	struct ieee80211_hw *hw;
-	struct platform_device *plat_dev = NULL;
 	struct wl1271 *wl;
 	int i, j, ret;
 	unsigned int order;
@@ -4834,20 +4817,12 @@ static struct ieee80211_hw *wl1271_alloc_hw(void)
 		goto err_hw_alloc;
 	}
 
-	plat_dev = kmemdup(&wl1271_device, sizeof(wl1271_device), GFP_KERNEL);
-	if (!plat_dev) {
-		wl1271_error("could not allocate platform_device");
-		ret = -ENOMEM;
-		goto err_plat_alloc;
-	}
-
 	wl = hw->priv;
 	memset(wl, 0, sizeof(*wl));
 
 	INIT_LIST_HEAD(&wl->list);
 
 	wl->hw = hw;
-	wl->plat_dev = plat_dev;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		skb_queue_head_init(&wl->tx_queue[i]);
@@ -4936,49 +4911,8 @@ static struct ieee80211_hw *wl1271_alloc_hw(void)
 		goto err_dummy_packet;
 	}
 
-	/* Register platform device */
-	ret = platform_device_register(wl->plat_dev);
-	if (ret) {
-		wl1271_error("couldn't register platform device");
-		goto err_fwlog;
-	}
-	dev_set_drvdata(&wl->plat_dev->dev, wl);
-
-	/* Create sysfs file to control bt coex state */
-	ret = device_create_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
-	if (ret < 0) {
-		wl1271_error("failed to create sysfs file bt_coex_state");
-		goto err_platform;
-	}
-
-	/* Create sysfs file to get HW PG version */
-	ret = device_create_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
-	if (ret < 0) {
-		wl1271_error("failed to create sysfs file hw_pg_ver");
-		goto err_bt_coex_state;
-	}
-
-	/* Create sysfs file for the FW log */
-	ret = device_create_bin_file(&wl->plat_dev->dev, &fwlog_attr);
-	if (ret < 0) {
-		wl1271_error("failed to create sysfs file fwlog");
-		goto err_hw_pg_ver;
-	}
-
 	return hw;
 
-err_hw_pg_ver:
-	device_remove_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
-
-err_bt_coex_state:
-	device_remove_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
-
-err_platform:
-	platform_device_unregister(wl->plat_dev);
-
-err_fwlog:
-	free_page((unsigned long)wl->fwlog);
-
 err_dummy_packet:
 	dev_kfree_skb(wl->dummy_packet);
 
@@ -4990,9 +4924,6 @@ err_wq:
 
 err_hw:
 	wl1271_debugfs_exit(wl);
-	kfree(plat_dev);
-
-err_plat_alloc:
 	ieee80211_free_hw(hw);
 
 err_hw_alloc:
@@ -5008,17 +4939,15 @@ static int wl1271_free_hw(struct wl1271 *wl)
 	wake_up_interruptible_all(&wl->fwlog_waitq);
 	mutex_unlock(&wl->mutex);
 
-	device_remove_bin_file(&wl->plat_dev->dev, &fwlog_attr);
+	device_remove_bin_file(wl->dev, &fwlog_attr);
 
-	device_remove_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
+	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
 
-	device_remove_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
-	platform_device_unregister(wl->plat_dev);
+	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
 	free_page((unsigned long)wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
 	free_pages((unsigned long)wl->aggr_buf,
 			get_order(WL1271_AGGR_BUFFER_SIZE));
-	kfree(wl->plat_dev);
 
 	wl1271_debugfs_exit(wl);
 
@@ -5122,8 +5051,35 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_irq;
 
+	/* Create sysfs file to control bt coex state */
+	ret = device_create_file(wl->dev, &dev_attr_bt_coex_state);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file bt_coex_state");
+		goto out_irq;
+	}
+
+	/* Create sysfs file to get HW PG version */
+	ret = device_create_file(wl->dev, &dev_attr_hw_pg_ver);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file hw_pg_ver");
+		goto out_bt_coex_state;
+	}
+
+	/* Create sysfs file for the FW log */
+	ret = device_create_bin_file(wl->dev, &fwlog_attr);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file fwlog");
+		goto out_hw_pg_ver;
+	}
+
 	return 0;
 
+out_hw_pg_ver:
+	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
+
+out_bt_coex_state:
+	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
+
 out_irq:
 	free_irq(wl->irq, wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 091fdd2..bd58f50 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -350,7 +350,6 @@ struct wl1271_link {
 };
 
 struct wl1271 {
-	struct platform_device *plat_dev;
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
-- 
1.7.1

