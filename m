Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:6952 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3LLK7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:17 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 17/18] brcmfmac: remove brcmf_sdio_disconnect() function
Date: Thu, 12 Dec 2013 11:59:05 +0100
Message-ID: <1386845946-9859-18-git-send-email-arend@broadcom.com> (sfid-20131212_122500_142979_D3F12FF6)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of calling brcmf_sdio_disconnect() expose brcmf_sdio_remove()
and call it directly.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   51 ++++++++------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 3 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index e07bad2..337802c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -901,7 +901,7 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 
 	if (sdiodev->bus) {
-		brcmf_sdio_disconnect(sdiodev->bus);
+		brcmf_sdio_remove(sdiodev->bus);
 		sdiodev->bus = NULL;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f3069b4..f214510 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3973,33 +3973,6 @@ static void brcmf_sdio_release_dongle(struct brcmf_sdio *bus)
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-/* Detach and free everything */
-static void brcmf_sdio_release(struct brcmf_sdio *bus)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (bus) {
-		/* De-register interrupt handler */
-		brcmf_sdiod_intr_unregister(bus->sdiodev);
-
-		cancel_work_sync(&bus->datawork);
-		if (bus->brcmf_wq)
-			destroy_workqueue(bus->brcmf_wq);
-
-		if (bus->sdiodev->bus_if->drvr) {
-			brcmf_detach(bus->sdiodev->dev);
-			brcmf_sdio_release_dongle(bus);
-		}
-
-		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
-		brcmf_sdio_release_malloc(bus);
-		kfree(bus->hdrbuf);
-		kfree(bus);
-	}
-
-	brcmf_dbg(TRACE, "Disconnected\n");
-}
-
 static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.stop = brcmf_sdio_bus_stop,
 	.preinit = brcmf_sdio_bus_preinit,
@@ -4116,15 +4089,33 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	return bus;
 
 fail:
-	brcmf_sdio_release(bus);
+	brcmf_sdio_remove(bus);
 	return NULL;
 }
 
-void brcmf_sdio_disconnect(struct brcmf_sdio *bus)
+/* Detach and free everything */
+void brcmf_sdio_remove(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_sdio_release(bus);
+	if (bus) {
+		/* De-register interrupt handler */
+		brcmf_sdiod_intr_unregister(bus->sdiodev);
+
+		cancel_work_sync(&bus->datawork);
+		if (bus->brcmf_wq)
+			destroy_workqueue(bus->brcmf_wq);
+
+		if (bus->sdiodev->bus_if->drvr) {
+			brcmf_detach(bus->sdiodev->dev);
+			brcmf_sdio_release_dongle(bus);
+		}
+
+		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
+		brcmf_sdio_release_malloc(bus);
+		kfree(bus->hdrbuf);
+		kfree(bus);
+	}
 
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index e28498e..a0981b3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -236,7 +236,7 @@ int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
-void brcmf_sdio_disconnect(struct brcmf_sdio *bus);
+void brcmf_sdio_remove(struct brcmf_sdio *bus);
 void brcmf_sdio_isr(struct brcmf_sdio *bus);
 
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
-- 
1.7.10.4

