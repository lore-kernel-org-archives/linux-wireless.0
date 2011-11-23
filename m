Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4834 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759566Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/24] brcm80211: fmac: move module init/exit to sdio
 layer
Date: Tue, 22 Nov 2011 17:21:47 -0800
Message-ID: <1322011319-24863-13-git-send-email-frankyl@broadcom.com> (sfid-20111123_022228_155681_DA6B1088)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is part of the fullmac bus interface refactoring series.
It moves the module init/exit code to bus layer.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   19 ++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    4 ---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   28 --------------------
 3 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index adee305..7a2325b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -577,17 +577,26 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 #endif	/* CONFIG_PM_SLEEP */
 };
 
-/* bus register interface */
-int brcmf_bus_register(void)
+static void __exit brcmf_sdio_exit(void)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	return sdio_register_driver(&brcmf_sdmmc_driver);
+	sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
 
-void brcmf_bus_unregister(void)
+static int __init brcmf_sdio_init(void)
 {
+	int ret;
+
 	brcmf_dbg(TRACE, "Enter\n");
 
-	sdio_unregister_driver(&brcmf_sdmmc_driver);
+	ret = sdio_register_driver(&brcmf_sdmmc_driver);
+
+	if (ret)
+		brcmf_dbg(ERROR, "sdio_register_driver failed: %d\n", ret);
+
+	return ret;
 }
+
+module_init(brcmf_sdio_init);
+module_exit(brcmf_sdio_exit);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index a249407..118216b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -27,10 +27,6 @@
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
 
-/* Indicate (dis)interest in finding dongles. */
-extern int brcmf_bus_register(void);
-extern void brcmf_bus_unregister(void);
-
 /* obtain linux device object providing bus function */
 extern struct device *brcmf_bus_get_device(struct brcmf_bus *bus);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 62413e8..73d32802 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1147,34 +1147,6 @@ void brcmf_detach(struct brcmf_pub *drvr)
 	}
 }
 
-static void __exit brcmf_module_cleanup(void)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	brcmf_bus_unregister();
-}
-
-static int __init brcmf_module_init(void)
-{
-	int error;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	error = brcmf_bus_register();
-
-	if (error) {
-		brcmf_dbg(ERROR, "brcmf_bus_register failed\n");
-		goto failed;
-	}
-	return 0;
-
-failed:
-	return -EINVAL;
-}
-
-module_init(brcmf_module_init);
-module_exit(brcmf_module_cleanup);
-
 int brcmf_os_proto_block(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
-- 
1.7.5.4


