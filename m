Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:44312 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaIKUvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:51:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.17 2/3] brcmfmac: conditionally compile firmware protocol source code
Date: Thu, 11 Sep 2014 22:51:31 +0200
Message-ID: <1410468692-20852-3-git-send-email-arend@broadcom.com> (sfid-20140911_225143_527111_C3DD5F46)
In-Reply-To: <1410468692-20852-1-git-send-email-arend@broadcom.com>
References: <1410468692-20852-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The host-interface can select which protocol implementation it
needs. Selecting PCIe will include the msgbuf protocol and selecting
USB and/or SDIO will include the bcdc protocol. The PCIe kconfig
option assures the dependencies for msgbuf are met, ie. HAS_DMA.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig           | 10 ++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/Makefile | 10 ++++++----
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.h   |  7 +++++--
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h | 11 +++++++++--
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index b8e2561..fe3dc12 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -27,10 +27,17 @@ config BRCMFMAC
 	  one of the bus interface support. If you choose to build a module,
 	  it'll be called brcmfmac.ko.
 
+config BRCMFMAC_PROTO_BCDC
+	bool
+
+config BRCMFMAC_PROTO_MSGBUF
+	bool
+
 config BRCMFMAC_SDIO
 	bool "SDIO bus interface support for FullMAC driver"
 	depends on (MMC = y || MMC = BRCMFMAC)
 	depends on BRCMFMAC
+	select BRCMFMAC_PROTO_BCDC
 	select FW_LOADER
 	default y
 	---help---
@@ -42,6 +49,7 @@ config BRCMFMAC_USB
 	bool "USB bus interface support for FullMAC driver"
 	depends on (USB = y || USB = BRCMFMAC)
 	depends on BRCMFMAC
+	select BRCMFMAC_PROTO_BCDC
 	select FW_LOADER
 	---help---
 	  This option enables the USB bus interface support for Broadcom
@@ -52,6 +60,8 @@ config BRCMFMAC_PCIE
 	bool "PCIE bus interface support for FullMAC driver"
 	depends on BRCMFMAC
 	depends on PCI
+	depends on HAS_DMA
+	select BRCMFMAC_PROTO_MSGBUF
 	select FW_LOADER
 	---help---
 	  This option enables the PCIE bus interface support for Broadcom
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index c35adf4..90a977f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -30,16 +30,18 @@ brcmfmac-objs += \
 		fwsignal.o \
 		p2p.o \
 		proto.o \
-		bcdc.o \
-		commonring.o \
-		flowring.o \
-		msgbuf.o \
 		dhd_common.o \
 		dhd_linux.o \
 		firmware.o \
 		feature.o \
 		btcoex.o \
 		vendor.o
+brcmfmac-$(CONFIG_BRCMFMAC_PROTO_BCDC) += \
+		bcdc.o
+brcmfmac-$(CONFIG_BRCMFMAC_PROTO_MSGBUF) += \
+		commonring.o \
+		flowring.o \
+		msgbuf.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 		dhd_sdio.o \
 		bcmsdh.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.h b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.h
index 17e8c03..6003179 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.h
@@ -16,9 +16,12 @@
 #ifndef BRCMFMAC_BCDC_H
 #define BRCMFMAC_BCDC_H
 
-
+#ifdef CONFIG_BRCMFMAC_PROTO_BCDC
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr);
 void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr);
-
+#else
+static inline int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr) { return 0; }
+static inline void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr) {}
+#endif
 
 #endif /* BRCMFMAC_BCDC_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
index f901ae5..77a51b8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
@@ -15,6 +15,7 @@
 #ifndef BRCMFMAC_MSGBUF_H
 #define BRCMFMAC_MSGBUF_H
 
+#ifdef CONFIG_BRCMFMAC_PROTO_MSGBUF
 
 #define BRCMF_H2D_MSGRING_CONTROL_SUBMIT_MAX_ITEM	20
 #define BRCMF_H2D_MSGRING_RXPOST_SUBMIT_MAX_ITEM	256
@@ -32,9 +33,15 @@
 
 
 int brcmf_proto_msgbuf_rx_trigger(struct device *dev);
+void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u8 flowid);
 int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr);
 void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr);
-void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u8 flowid);
-
+#else
+static inline int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
+{
+	return 0;
+}
+static inline void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr) {}
+#endif
 
 #endif /* BRCMFMAC_MSGBUF_H */
-- 
1.9.1

