Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1562 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2BIUJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:24 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/15] brcm80211: fmac: move module entry points to
 dhd_linux.c
Date: Thu, 9 Feb 2012 21:09:03 +0100
Message-ID: <1328818149-4826-10-git-send-email-arend@broadcom.com> (sfid-20120209_210929_086124_1D05EA21)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The module_init/exit functions are moved to dhd_linux.c to prepare
for supporting multiple host interface types.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    7 +----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    6 +++++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   24 ++++++++++++++++++++
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1d2b74d..83ca3cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -597,14 +597,14 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 #endif	/* CONFIG_PM_SLEEP */
 };
 
-static void __exit brcmf_sdio_exit(void)
+void brcmf_sdio_exit(void)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
 
-static int __init brcmf_sdio_init(void)
+int brcmf_sdio_init(void)
 {
 	int ret;
 
@@ -617,6 +617,3 @@ static int __init brcmf_sdio_init(void)
 
 	return ret;
 }
-
-module_init(brcmf_sdio_init);
-module_exit(brcmf_sdio_exit);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 567a966..bc575b4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -105,4 +105,10 @@ extern int brcmf_bus_start(struct device *dev);
 
 extern int brcmf_add_if(struct device *dev, int ifidx,
 			char *name, u8 *mac_addr);
+
+#ifdef CONFIG_BRCMFMAC_SDIO
+extern void brcmf_sdio_exit(void);
+extern int brcmf_sdio_init(void);
+#endif
+
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index eff0073..ff7fc0e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1183,3 +1183,27 @@ exit:
 	return ret;
 }
 #endif				/* DEBUG */
+
+static int __init brcmfmac_init(void)
+{
+	int ret = 0;
+
+#ifdef CONFIG_BRCMFMAC_SDIO
+	ret = brcmf_sdio_init();
+	if (ret)
+		goto fail;
+#endif
+
+fail:
+	return ret;
+}
+
+static void __exit brcmfmac_exit(void)
+{
+#ifdef CONFIG_BRCMFMAC_SDIO
+	brcmf_sdio_exit();
+#endif
+}
+
+module_init(brcmfmac_init);
+module_exit(brcmfmac_exit);
-- 
1.7.5.4


