Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.13]:51404 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3EQTKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 15:10:25 -0400
Message-ID: <51968098.9070104@einfach.org> (sfid-20130517_211033_007120_B7C89919)
Date: Fri, 17 May 2013 20:10:16 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: Bruno Randolf <br1@einfach.org>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, meuleman@broadcom.com,
	brudley@broadcom.com, brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?5rW36Je7?= =?UTF-8?B?5pWs5LmL?= <tkaiso@thinktube.com>
Subject: Re: Broadcom brcmfmac vs bcmdhd on Android
References: <5176ABB1.2070506@einfach.org> <5176F8C2.7050502@broadcom.com> <5177F7D6.2020800@einfach.org> <51797866.9030403@einfach.org> <51799C33.7040109@broadcom.com>
In-Reply-To: <51799C33.7040109@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2013 10:12 PM, Franky Lin wrote:
> It looks like the device is not powered up. Do you see the wifi chip get
> enumerated by SDIO bus? There should be something like mmc0:0001:1 under
> /sys/bus/sdio/devices

Just for public reference, this was the problem. I made it work with the 
following patch, which adds the platform_driver as used by bcmdhd to 
power up the wifi chip.

bruno


diff -Nurb 
compat-drivers-3.9-rc4-2-su/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c 
compat-drivers-3.9-rc4-2-su-brcm/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
--- 
compat-drivers-3.9-rc4-2-su/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c 
2013-03-29 06:03:35.000000000 +0000
+++ 
compat-drivers-3.9-rc4-2-su-brcm/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c 
2013-04-29 20:17:13.686085551 +0100
@@ -27,6 +27,7 @@
  #include <linux/module.h>
  #include <linux/platform_device.h>
  #include <net/cfg80211.h>
+#include <linux/wlan_plat.h>

  #include <defs.h>
  #include <brcm_hw_ids.h>
@@ -664,11 +665,80 @@
  		brcmf_err("platform_driver_register failed: %d\n", ret);
  }
  #else
+
+static struct wifi_platform_data *wifi_control_data = NULL;
+
+int wifi_set_power(int on, unsigned long msec)
+{
+	printk("%s = %d\n", __FUNCTION__, on);
+	if (wifi_control_data && wifi_control_data->set_power) {
+		wifi_control_data->set_power(on);
+	}
+	if (msec)
+		msleep(msec);
+	return 0;
+}
+
+static int wifi_set_carddetect(int on)
+{
+	printk("%s = %d\n", __FUNCTION__, on);
+	if (wifi_control_data && wifi_control_data->set_carddetect) {
+		wifi_control_data->set_carddetect(on);
+	}
+	return 0;
+}
+
+static int wifi_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct wifi_platform_data *wifi_ctrl =
+		(struct wifi_platform_data *)(pdev->dev.platform_data);
+
+	printk("## %s\n", __FUNCTION__);
+	//wifi_irqres = platform_get_resource_byname(pdev, IORESOURCE_IRQ, 
"bcmdhd_wlan_irq");
+	wifi_control_data = wifi_ctrl;
+
+	wifi_set_power(1, 0);	/* Power On */
+	wifi_set_carddetect(1);	/* CardDetect (0->1) */
+
+	ret = sdio_register_driver(&brcmf_sdmmc_driver);
+	if (ret)
+		brcmf_err("sdio_register_driver failed: %d\n", ret);
+
+	return 0;
+}
+
+static int wifi_remove(struct platform_device *pdev)
+{
+	struct wifi_platform_data *wifi_ctrl =
+		(struct wifi_platform_data *)(pdev->dev.platform_data);
+
+	printk("## %s\n", __FUNCTION__);
+	wifi_control_data = wifi_ctrl;
+
+	wifi_set_power(0, 0);	/* Power Off */
+	wifi_set_carddetect(0);	/* CardDetect (1->0) */
+
+	//up(&wifi_control_sem);
+	return 0;
+}
+
+static struct platform_driver wifi_device = {
+	.probe          = wifi_probe,
+	.remove         = wifi_remove,
+//	.suspend        = wifi_suspend,
+//	.resume         = wifi_resume,
+	.driver         = {
+	.name   = "bcmdhd_wlan",
+	}
+};
+
  void brcmf_sdio_exit(void)
  {
  	brcmf_dbg(TRACE, "Enter\n");

  	sdio_unregister_driver(&brcmf_sdmmc_driver);
+	platform_driver_unregister(&wifi_device);
  }

  void brcmf_sdio_init(void)
@@ -677,9 +747,8 @@

  	brcmf_dbg(TRACE, "Enter\n");

-	ret = sdio_register_driver(&brcmf_sdmmc_driver);
+	printk("SDIO init\n");

-	if (ret)
-		brcmf_err("sdio_register_driver failed: %d\n", ret);
+	platform_driver_register(&wifi_device);
  }
  #endif		/* CONFIG_BRCMFMAC_SDIO_OOB */

