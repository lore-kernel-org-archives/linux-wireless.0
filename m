Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:27981 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaJ1N5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:57:52 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/16] brcmfmac: Add wowl support for SDIO devices.
Date: Tue, 28 Oct 2014 14:56:05 +0100
Message-ID: <1414504579-12562-3-git-send-email-arend@broadcom.com> (sfid-20141028_145756_827230_B402B904)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch adds wowl support for SDIO bus devices. This feature
requires FW which has support for wowl built in.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   | 45 +++++++++++++++-------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  1 +
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |  2 +
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 8dbd5db..79b2c7e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1064,6 +1064,16 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	if (!sdiodev->pdata)
 		brcmf_of_probe(sdiodev);
 
+#ifdef CONFIG_PM_SLEEP
+	/* wowl can be supported when KEEP_POWER is true and (WAKE_SDIO_IRQ
+	 * is true or when platform data OOB irq is true).
+	 */
+	if ((sdio_get_host_pm_caps(sdiodev->func[1]) & MMC_PM_KEEP_POWER) &&
+	    ((sdio_get_host_pm_caps(sdiodev->func[1]) & MMC_PM_WAKE_SDIO_IRQ) ||
+	     (sdiodev->pdata->oob_irq_supported)))
+		bus_if->wowl_supported = true;
+#endif
+
 	atomic_set(&sdiodev->suspend, false);
 	init_waitqueue_head(&sdiodev->request_word_wait);
 	init_waitqueue_head(&sdiodev->request_buffer_wait);
@@ -1116,34 +1126,39 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	brcmf_dbg(SDIO, "Exit\n");
 }
 
+void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+
+	brcmf_dbg(SDIO, "Configuring WOWL, enabled=%d\n", enabled);
+	sdiodev->wowl_enabled = enabled;
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int brcmf_ops_sdio_suspend(struct device *dev)
 {
-	mmc_pm_flag_t sdio_flags;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
-	int ret = 0;
+	mmc_pm_flag_t sdio_flags;
 
 	brcmf_dbg(SDIO, "Enter\n");
 
-	sdio_flags = sdio_get_host_pm_caps(sdiodev->func[1]);
-	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
-		brcmf_err("Host can't keep power while suspended\n");
-		return -EINVAL;
-	}
-
 	atomic_set(&sdiodev->suspend, true);
 
-	ret = sdio_set_host_pm_flags(sdiodev->func[1], MMC_PM_KEEP_POWER);
-	if (ret) {
-		brcmf_err("Failed to set pm_flags\n");
-		atomic_set(&sdiodev->suspend, false);
-		return ret;
+	if (sdiodev->wowl_enabled) {
+		sdio_flags = MMC_PM_KEEP_POWER;
+		if (sdiodev->pdata->oob_irq_supported)
+			enable_irq_wake(sdiodev->pdata->oob_irq_nr);
+		else
+			sdio_flags = MMC_PM_WAKE_SDIO_IRQ;
+		if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
+			brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
 	}
 
 	brcmf_sdio_wd_timer(sdiodev->bus, 0);
 
-	return ret;
+	return 0;
 }
 
 static int brcmf_ops_sdio_resume(struct device *dev)
@@ -1152,6 +1167,8 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
 	brcmf_dbg(SDIO, "Enter\n");
+	if (sdiodev->pdata->oob_irq_supported)
+		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
 	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
 	atomic_set(&sdiodev->suspend, false);
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f55f625..079187c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3949,6 +3949,7 @@ static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.txctl = brcmf_sdio_bus_txctl,
 	.rxctl = brcmf_sdio_bus_rxctl,
 	.gettxq = brcmf_sdio_bus_gettxq,
+	.wowl_config = brcmf_sdio_wowl_config
 };
 
 static void brcmf_sdio_firmware_callback(struct device *dev,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index f2d06ca..262aedf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -186,6 +186,7 @@ struct brcmf_sdio_dev {
 	struct sg_table sgtable;
 	char fw_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
+	bool wowl_enabled;
 };
 
 /* sdio core registers */
@@ -334,5 +335,6 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus);
 void brcmf_sdio_isr(struct brcmf_sdio *bus);
 
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
+void brcmf_sdio_wowl_config(struct device *dev, bool enabled);
 
 #endif				/* _BRCM_SDH_H_ */
-- 
1.9.1

