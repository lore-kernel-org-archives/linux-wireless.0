Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3253 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217Ab2KOCqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:32 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 14/19] brcmfmac: Handle mmc exceptions during init
 correct.
Date: Wed, 14 Nov 2012 18:46:18 -0800
Message-ID: <1352947583-25341-15-git-send-email-frankyl@broadcom.com> (sfid-20121115_041526_456364_49DC9DD6)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

when brcmf_sdbrcm_probe_attach results in error then cleanup
will result in null pointer access. In brcmf_sdbrcm_release and
in brcmf_ops_sdio_remove. This patch fixes order of init and
de-init.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 +++++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   17 +++++++++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c62ec2a..8545733 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -512,6 +512,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
 		ret = brcmf_sdio_probe(sdiodev);
+		if (ret)
+			dev_set_drvdata(&func->dev, NULL);
 	}
 
 	return ret;
@@ -532,8 +534,12 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 		sdiodev = bus_if->bus_priv.sdio;
 		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_remove...\n");
 		brcmf_sdio_remove(sdiodev);
-		dev_set_drvdata(&func->card->dev, NULL);
 		dev_set_drvdata(&func->dev, NULL);
+	}
+	if (func->num == 1) {
+		sdiodev = dev_get_drvdata(&func->card->dev);
+		bus_if = sdiodev->bus_if;
+		dev_set_drvdata(&func->card->dev, NULL);
 		kfree(bus_if);
 		kfree(sdiodev);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index e2351a7..40a37ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3867,7 +3867,8 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 		brcmf_sdio_intr_unregister(bus->sdiodev);
 
 		cancel_work_sync(&bus->datawork);
-		destroy_workqueue(bus->brcmf_wq);
+		if (bus->brcmf_wq)
+			destroy_workqueue(bus->brcmf_wq);
 
 		if (bus->sdiodev->bus_if->drvr) {
 			brcmf_detach(bus->sdiodev->dev);
@@ -3909,6 +3910,13 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->txminmax = BRCMF_TXMINMAX;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 
+	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
+	bus->brcmf_wq = create_singlethread_workqueue("brcmf_wq");
+	if (bus->brcmf_wq == NULL) {
+		brcmf_dbg(ERROR, "insufficient memory to create txworkqueue\n");
+		goto fail;
+	}
+
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
 		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_attach failed\n");
@@ -3920,13 +3928,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	init_waitqueue_head(&bus->ctrl_wait);
 	init_waitqueue_head(&bus->dcmd_resp_wait);
 
-	bus->brcmf_wq = create_singlethread_workqueue("brcmf_wq");
-	if (bus->brcmf_wq == NULL) {
-		brcmf_dbg(ERROR, "insufficient memory to create txworkqueue\n");
-		goto fail;
-	}
-	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
-
 	/* Set up the watchdog timer */
 	init_timer(&bus->timer);
 	bus->timer.data = (unsigned long)bus;
-- 
1.7.9.5


