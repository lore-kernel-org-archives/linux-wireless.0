Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:54330 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753952AbeDRLlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:41:08 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 20/22] staging: wilc1000: rename goto labels starting with '_' in wilc1000_wlan_init()
Date: Wed, 18 Apr 2018 17:09:22 +0530
Message-ID: <1524051564-15497-21-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134111_502657_A02C7B0C)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename goto labels starting with '_' in wilc1000_wlan_init() to follow
linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8f97c62..26edbb6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -735,42 +735,42 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 		ret = wilc_wlan_init(dev);
 		if (ret < 0) {
 			ret = -EIO;
-			goto _fail_locks_;
+			goto fail_locks;
 		}
 
 		if (wl->gpio >= 0 && init_irq(dev)) {
 			ret = -EIO;
-			goto _fail_locks_;
+			goto fail_locks;
 		}
 
 		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
 			ret = -EIO;
-			goto _fail_wilc_wlan_;
+			goto fail_wilc_wlan;
 		}
 
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->enable_interrupt &&
 		    wl->hif_func->enable_interrupt(wl)) {
 			ret = -EIO;
-			goto _fail_irq_init_;
+			goto fail_irq_init;
 		}
 
 		if (wilc_wlan_get_firmware(dev)) {
 			ret = -EIO;
-			goto _fail_irq_enable_;
+			goto fail_irq_enable;
 		}
 
 		ret = wilc1000_firmware_download(dev);
 		if (ret < 0) {
 			ret = -EIO;
-			goto _fail_irq_enable_;
+			goto fail_irq_enable;
 		}
 
 		ret = linux_wlan_start_firmware(dev);
 		if (ret < 0) {
 			ret = -EIO;
-			goto _fail_irq_enable_;
+			goto fail_irq_enable;
 		}
 
 		if (wilc_wlan_cfg_get(vif, 1, WID_FIRMWARE_VERSION, 1, 0)) {
@@ -788,27 +788,27 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 		if (ret < 0) {
 			netdev_err(dev, "Failed to configure firmware\n");
 			ret = -EIO;
-			goto _fail_fw_start_;
+			goto fail_fw_start;
 		}
 
 		wl->initialized = true;
 		return 0;
 
-_fail_fw_start_:
+fail_fw_start:
 		wilc_wlan_stop(wl);
 
-_fail_irq_enable_:
+fail_irq_enable:
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->disable_interrupt)
 			wl->hif_func->disable_interrupt(wl);
-_fail_irq_init_:
+fail_irq_init:
 		if (wl->dev_irq_num)
 			deinit_irq(dev);
 
 		wlan_deinitialize_threads(dev);
-_fail_wilc_wlan_:
+fail_wilc_wlan:
 		wilc_wlan_cleanup(dev);
-_fail_locks_:
+fail_locks:
 		wlan_deinit_locks(dev);
 		netdev_err(dev, "WLAN initialization FAILED\n");
 	} else {
-- 
2.7.4
