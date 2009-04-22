Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4412 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbZDVDov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 23:44:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] wl12xx: remove sysfs file
Date: Tue, 21 Apr 2009 23:44:19 -0400
Message-Id: <1240371860-9001-2-git-send-email-me@bobcopeland.com> (sfid-20090422_054520_850439_23E96DF1)
In-Reply-To: <1240371860-9001-1-git-send-email-me@bobcopeland.com>
References: <1240371860-9001-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove tx_mgmt_frm_rate file since we don't need it.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/main.c |  152 ------------------------------------
 1 files changed, 0 insertions(+), 152 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2e01295..7f2da39 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -44,151 +44,6 @@
 #include "init.h"
 #include "netlink.h"
 
-static ssize_t wl12xx_sysfs_show_tx_mgmt_frm_rate(struct device *dev,
-						  struct device_attribute *attr,
-						  char *buf)
-{
-	struct wl12xx *wl = dev_get_drvdata(dev);
-	ssize_t len;
-	int val;
-
-	/* FIXME: what's the maximum length of buf? page size?*/
-	len = 500;
-
-	switch (wl->tx_mgmt_frm_rate) {
-		/* skip 1 and 12 Mbps because they have same value 0x0a */
-	case RATE_2MBPS:
-		val = 20;
-		break;
-	case RATE_5_5MBPS:
-		val = 55;
-		break;
-	case RATE_11MBPS:
-		val = 110;
-		break;
-	case RATE_6MBPS:
-		val = 60;
-		break;
-	case RATE_9MBPS:
-		val = 90;
-		break;
-	case RATE_12MBPS:
-		val = 120;
-		break;
-	case RATE_18MBPS:
-		val = 180;
-		break;
-	case RATE_24MBPS:
-		val = 240;
-		break;
-	case RATE_36MBPS:
-		val = 360;
-		break;
-	case RATE_48MBPS:
-		val = 480;
-		break;
-	case RATE_54MBPS:
-		val = 540;
-		break;
-	default:
-		val = 10;
-	}
-
-	/* for 1 and 12 Mbps we have to check the modulation */
-	if (wl->tx_mgmt_frm_rate == RATE_1MBPS) {
-		switch (wl->tx_mgmt_frm_rate) {
-		case CCK_LONG:
-			val = 10;
-			break;
-		case OFDM:
-			val = 120;
-			break;
-		default:
-			val = 10;
-			break;
-		}
-	}
-	len = snprintf(buf, len, "%d", val);
-
-	return len;
-}
-
-static ssize_t wl12xx_sysfs_store_tx_mgmt_frm_rate(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	struct wl12xx *wl = dev_get_drvdata(dev);
-	unsigned long res;
-	int ret;
-
-	ret = strict_strtoul(buf, 10, &res);
-
-	if (ret < 0) {
-		wl12xx_warning("incorrect value written to tx_mgmt_frm_rate");
-		return 0;
-	}
-
-	switch (res) {
-	case 10:
-		wl->tx_mgmt_frm_rate = RATE_1MBPS;
-		wl->tx_mgmt_frm_mod = CCK_LONG;
-		break;
-	case 20:
-		wl->tx_mgmt_frm_rate = RATE_2MBPS;
-		wl->tx_mgmt_frm_mod = CCK_LONG;
-		break;
-	case 55:
-		wl->tx_mgmt_frm_rate = RATE_5_5MBPS;
-		wl->tx_mgmt_frm_mod = CCK_LONG;
-		break;
-	case 110:
-		wl->tx_mgmt_frm_rate = RATE_11MBPS;
-		wl->tx_mgmt_frm_mod = CCK_LONG;
-		break;
-	case 60:
-		wl->tx_mgmt_frm_rate = RATE_6MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	case 90:
-		wl->tx_mgmt_frm_rate = RATE_9MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	case 120:
-		wl->tx_mgmt_frm_rate = RATE_12MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	case 180:
-		wl->tx_mgmt_frm_rate = RATE_18MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	case 240:
-		wl->tx_mgmt_frm_rate = RATE_24MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	case 360:
-		wl->tx_mgmt_frm_rate = RATE_36MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	case 480:
-		wl->tx_mgmt_frm_rate = RATE_48MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	case 540:
-		wl->tx_mgmt_frm_rate = RATE_54MBPS;
-		wl->tx_mgmt_frm_mod = OFDM;
-		break;
-	default:
-		wl12xx_warning("incorrect value written to tx_mgmt_frm_rate");
-		return 0;
-	}
-
-	return count;
-}
-
-static DEVICE_ATTR(tx_mgmt_frm_rate, S_IRUGO | S_IWUSR,
-		   wl12xx_sysfs_show_tx_mgmt_frm_rate,
-		   wl12xx_sysfs_store_tx_mgmt_frm_rate);
-
 static void wl12xx_disable_interrupts(struct wl12xx *wl)
 {
 	disable_irq(gpio_to_irq(wl->config->irq_gpio));
@@ -1402,13 +1257,6 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	if (ret)
 		goto out_register_hw;
 
-	ret = device_create_file(&wl12xx_device.dev,
-				 &dev_attr_tx_mgmt_frm_rate);
-	if (ret < 0) {
-		wl12xx_error("failed to create sysfs file tx_mgmt_frm_rate");
-		goto out_register_hw;
-	}
-
 	wl12xx_notice("initialized");
 
 	return 0;
-- 
1.6.0.6


