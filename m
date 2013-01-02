Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3957 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab3ABOXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:08 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/18] brcmfmac: assure USB dongle firmware is reset
 upon module unload
Date: Wed, 2 Jan 2013 15:22:40 +0100
Message-ID: <1357136572-18273-8-git-send-email-arend@broadcom.com> (sfid-20130102_152316_775255_BB41A7AD)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon unloading the brcmfmac module the USB firmware should be reset
as the device remains powered. The reset assures a known device
state when a new brcmfmac driver load is being done.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h       |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h   |    3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |   11 +++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c       |   13 +++++++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index fd672bf..7245b17 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -39,6 +39,7 @@
 #define BRCMF_C_GET_BSSID			23
 #define BRCMF_C_GET_SSID			25
 #define BRCMF_C_SET_SSID			26
+#define BRCMF_C_TERMINATED			28
 #define BRCMF_C_GET_CHANNEL			29
 #define BRCMF_C_SET_CHANNEL			30
 #define BRCMF_C_GET_SRL				31
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index dd38b78..358b54f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -154,7 +154,8 @@ static inline void brcmf_rx_packet(struct device *dev, int ifidx,
 extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
 /* Indication from bus module regarding removal/absence of dongle */
 extern void brcmf_detach(struct device *dev);
-
+/* Indication from bus module that dongle should be reset */
+extern void brcmf_dev_reset(struct device *dev);
 /* Indication from bus module to change flow-control state */
 extern void brcmf_txflowblock(struct device *dev, bool state);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 74a616b..16efcb4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -845,6 +845,17 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 	}
 }
 
+void brcmf_dev_reset(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+
+	if (drvr == NULL)
+		return;
+
+	brcmf_fil_cmd_int_set(drvr->iflist[0], BRCMF_C_TERMINATED, 1);
+}
+
 void brcmf_detach(struct device *dev)
 {
 	int i;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 22eae57..1df8595 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1524,10 +1524,23 @@ static void brcmf_release_fw(struct list_head *q)
 	}
 }
 
+static int brcmf_usb_reset_device(struct device *dev, void *notused)
+{
+	/* device past is the usb interface so we
+	 * need to use parent here.
+	 */
+	brcmf_dev_reset(dev->parent);
+	return 0;
+}
 
 void brcmf_usb_exit(void)
 {
+	struct device_driver *drv = &brcmf_usbdrvr.drvwrap.driver;
+	int ret;
+
 	brcmf_dbg(USB, "Enter\n");
+	ret = driver_for_each_device(drv, NULL, NULL,
+				     brcmf_usb_reset_device);
 	usb_deregister(&brcmf_usbdrvr);
 	brcmf_release_fw(&fw_image_list);
 }
-- 
1.7.10.4


