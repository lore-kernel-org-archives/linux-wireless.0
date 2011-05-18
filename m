Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40028 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab1ERUps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 16:45:48 -0400
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linville@tuxdriver.com, eliad@wizery.com,
	ido@wizery.com
Subject: [PATCH] wl12xx: fix compilation error when CONFIG_PM is not set
Date: Wed, 18 May 2011 23:45:37 +0300
Message-Id: <1305751537-27533-1-git-send-email-coelho@ti.com> (sfid-20110518_224557_011335_A659F568)
In-Reply-To: <1305751102.12586.1546.camel@cumari>
References: <1305751102.12586.1546.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a compilation error when PM is not enabled:

  CC [M]  drivers/net/wireless/wl12xx/main.o
drivers/net/wireless/wl12xx/main.c:3653: error: unknown field 'suspend' specified in initializer
drivers/net/wireless/wl12xx/main.c:3653: warning: initialization from incompatible pointer type
drivers/net/wireless/wl12xx/main.c:3654: error: unknown field 'resume' specified in initializer
drivers/net/wireless/wl12xx/main.c:3654: warning: initialization from incompatible pointer type

Fix this by adding #ifdef's in the appropriate places.

Cc: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 ++++
 drivers/net/wireless/wl12xx/sdio.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 610be03..bc00e52 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1350,6 +1350,7 @@ static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
 
+#ifdef CONFIG_PM
 static int wl1271_configure_suspend(struct wl1271 *wl)
 {
 	int ret;
@@ -1493,6 +1494,7 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 
 	return 0;
 }
+#endif
 
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
@@ -3650,8 +3652,10 @@ static const struct ieee80211_ops wl1271_ops = {
 	.stop = wl1271_op_stop,
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
+#ifdef CONFIG_PM
 	.suspend = wl1271_op_suspend,
 	.resume = wl1271_op_resume,
+#endif
 	.config = wl1271_op_config,
 	.prepare_multicast = wl1271_op_prepare_multicast,
 	.configure_filter = wl1271_op_configure_filter,
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 92d29a8..536e506 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -330,6 +330,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	wl1271_free_hw(wl);
 }
 
+#ifdef CONFIG_PM
 static int wl1271_suspend(struct device *dev)
 {
 	/* Tell MMC/SDIO core it's OK to power down the card
@@ -385,15 +386,18 @@ static const struct dev_pm_ops wl1271_sdio_pm_ops = {
 	.suspend	= wl1271_suspend,
 	.resume		= wl1271_resume,
 };
+#endif
 
 static struct sdio_driver wl1271_sdio_driver = {
 	.name		= "wl1271_sdio",
 	.id_table	= wl1271_devices,
 	.probe		= wl1271_probe,
 	.remove		= __devexit_p(wl1271_remove),
+#ifdef CONFIG_PM
 	.drv = {
 		.pm = &wl1271_sdio_pm_ops,
 	},
+#endif
 };
 
 static int __init wl1271_init(void)
-- 
1.7.1

