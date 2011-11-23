Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4843 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759578Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 24/24] brcm80211: fmac: change function bus_stop
 parameter
Date: Tue, 22 Nov 2011 17:21:59 -0800
Message-ID: <1322011319-24863-25-git-send-email-frankyl@broadcom.com> (sfid-20111123_022240_179769_79B434BC)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_sdbrcm_bus_stop. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 +++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 1b57860..1841f99 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -28,7 +28,7 @@
  */
 
 /* Stop bus module: clear pending frames, disable data flow */
-extern void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus);
+extern void brcmf_sdbrcm_bus_stop(struct device *dev);
 
 /* Initialize bus module: prepare for communication w/dongle */
 extern int brcmf_sdbrcm_bus_init(struct device *dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 20d8221..58d92bc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1115,7 +1115,7 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 			brcmf_proto_stop(&drvr_priv->pub);
 
 			/* Stop the bus module */
-			brcmf_sdbrcm_bus_stop(drvr_priv->pub.bus);
+			brcmf_sdbrcm_bus_stop(drvr_priv->pub.dev);
 		}
 	}
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5d81052..18597fe 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2555,7 +2555,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 					complete(&bus->dpc_wait);
 			} else {
 				/* after stopping the bus, exit thread */
-				brcmf_sdbrcm_bus_stop(bus);
+				brcmf_sdbrcm_bus_stop(bus->sdiodev->dev);
 				bus->dpc_tsk = NULL;
 				break;
 			}
@@ -3330,12 +3330,15 @@ brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 	return ret;
 }
 
-void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus)
+void brcmf_sdbrcm_bus_stop(struct device *dev)
 {
 	u32 local_hostintmask;
 	u8 saveclk;
 	uint retries;
 	int err;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-- 
1.7.5.4


