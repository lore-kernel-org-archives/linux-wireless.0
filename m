Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4373 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab2CBV4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:17 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/7] brcm80211: fmac: initialize host interface drivers
 regardless result
Date: Fri, 2 Mar 2012 22:55:48 +0100
Message-ID: <1330725351-3803-5-git-send-email-arend@broadcom.com> (sfid-20120302_225625_502099_D52BCF9C)
In-Reply-To: <1330725351-3803-1-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The module init function of brcmfmac calls init functions for SDIO and
USB doing driver registration. This patch removes terminating the module
init when a driver registration for one host interface fails.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 +---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    4 ++--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   14 +++-----------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    4 ++--
 4 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 83ca3cc..4688904 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -604,7 +604,7 @@ void brcmf_sdio_exit(void)
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
 
-int brcmf_sdio_init(void)
+void brcmf_sdio_init(void)
 {
 	int ret;
 
@@ -614,6 +614,4 @@ int brcmf_sdio_init(void)
 
 	if (ret)
 		brcmf_dbg(ERROR, "sdio_register_driver failed: %d\n", ret);
-
-	return ret;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index b7671b3..3669164 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -108,11 +108,11 @@ extern int brcmf_add_if(struct device *dev, int ifidx,
 
 #ifdef CONFIG_BRCMFMAC_SDIO
 extern void brcmf_sdio_exit(void);
-extern int brcmf_sdio_init(void);
+extern void brcmf_sdio_init(void);
 #endif
 #ifdef CONFIG_BRCMFMAC_USB
 extern void brcmf_usb_exit(void);
-extern int brcmf_usb_init(void);
+extern void brcmf_usb_init(void);
 #endif
 
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c4da058..e734556 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1183,21 +1183,13 @@ exit:
 
 static int __init brcmfmac_init(void)
 {
-	int ret = 0;
-
 #ifdef CONFIG_BRCMFMAC_SDIO
-	ret = brcmf_sdio_init();
-	if (ret)
-		goto fail;
+	brcmf_sdio_init();
 #endif
 #ifdef CONFIG_BRCMFMAC_USB
-	ret = brcmf_usb_init();
-	if (ret)
-		goto fail;
+	brcmf_usb_init();
 #endif
-
-fail:
-	return ret;
+	return 0;
 }
 
 static void __exit brcmfmac_exit(void)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index a2a0c45..8236422 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1615,7 +1615,7 @@ void brcmf_usb_exit(void)
 	g_image.len = 0;
 }
 
-int brcmf_usb_init(void)
+void brcmf_usb_init(void)
 {
-	return usb_register(&brcmf_usbdrvr);
+	usb_register(&brcmf_usbdrvr);
 }
-- 
1.7.5.4


