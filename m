Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:63700 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943AbbAYTbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:48 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/14] brcmfmac: wait for driver to go idle during suspend
Date: Sun, 25 Jan 2015 20:31:34 +0100
Message-ID: <1422214303-7816-6-git-send-email-arend@broadcom.com> (sfid-20150125_203200_562525_4F312A5C)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before going in suspend state the watchdog thread needs to put the
device in bus sleep state, which assures it can go in deep-sleep
state during D3 state.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 20 +++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   | 18 ++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.h   |  2 ++
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 8ba60f6..9afaeb6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1045,7 +1045,9 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		bus_if->wowl_supported = true;
 #endif
 
+	sdiodev->sleeping = false;
 	atomic_set(&sdiodev->suspend, false);
+	init_waitqueue_head(&sdiodev->idle_wait);
 
 	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdiod_probe...\n");
 	err = brcmf_sdiod_probe(sdiodev);
@@ -1107,12 +1109,23 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
 #ifdef CONFIG_PM_SLEEP
 static int brcmf_ops_sdio_suspend(struct device *dev)
 {
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_bus *bus_if;
+	struct brcmf_sdio_dev *sdiodev;
 	mmc_pm_flag_t sdio_flags;
 
 	brcmf_dbg(SDIO, "Enter\n");
 
+	bus_if = dev_get_drvdata(dev);
+	sdiodev = bus_if->bus_priv.sdio;
+
+	/* wait for watchdog to go idle */
+	if (wait_event_timeout(sdiodev->idle_wait, sdiodev->sleeping,
+			       msecs_to_jiffies(3 * BRCMF_WD_POLL_MS)) == 0) {
+		brcmf_err("bus still active\n");
+		return -EBUSY;
+	}
+	/* disable watchdog */
+	brcmf_sdio_wd_timer(sdiodev->bus, 0);
 	atomic_set(&sdiodev->suspend, true);
 
 	if (sdiodev->wowl_enabled) {
@@ -1124,9 +1137,6 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 		if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
 			brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
 	}
-
-	brcmf_sdio_wd_timer(sdiodev->bus, 0);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index b4f5fe5..488a0f6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -515,7 +515,6 @@ struct brcmf_sdio {
 	bool txoff;		/* Transmit flow-controlled */
 	struct brcmf_sdio_count sdcnt;
 	bool sr_enabled; /* SaveRestore enabled */
-	bool sleeping; /* SDIO bus sleeping */
 
 	u8 tx_hdrlen;		/* sdio bus header length for tx packet */
 	bool txglom;		/* host tx glomming enable flag */
@@ -1014,12 +1013,12 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 
 	brcmf_dbg(SDIO, "Enter: request %s currently %s\n",
 		  (sleep ? "SLEEP" : "WAKE"),
-		  (bus->sleeping ? "SLEEP" : "WAKE"));
+		  (bus->sdiodev->sleeping ? "SLEEP" : "WAKE"));
 
 	/* If SR is enabled control bus state with KSO */
 	if (bus->sr_enabled) {
 		/* Done if we're already in the requested state */
-		if (sleep == bus->sleeping)
+		if (sleep == bus->sdiodev->sleeping)
 			goto end;
 
 		/* Going to sleep */
@@ -1051,12 +1050,7 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 			bus->idlecount = 0;
 			err = brcmf_sdio_kso_control(bus, true);
 		}
-		if (!err) {
-			/* Change state */
-			bus->sleeping = sleep;
-			brcmf_dbg(SDIO, "new state %s\n",
-				  (sleep ? "SLEEP" : "WAKE"));
-		} else {
+		if (err) {
 			brcmf_err("error while changing bus sleep state %d\n",
 				  err);
 			goto done;
@@ -1071,6 +1065,11 @@ end:
 	} else {
 		brcmf_sdio_clkctl(bus, CLK_AVAIL, pendok);
 	}
+	bus->sdiodev->sleeping = sleep;
+	if (sleep)
+		wake_up(&bus->sdiodev->idle_wait);
+	brcmf_dbg(SDIO, "new state %s\n",
+		  (sleep ? "SLEEP" : "WAKE"));
 done:
 	brcmf_dbg(SDIO, "Exit: err=%d\n", err);
 	return err;
@@ -4215,7 +4214,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->idleclock = BRCMF_IDLE_ACTIVE;
 
 	/* SR state */
-	bus->sleeping = false;
 	bus->sr_enabled = false;
 
 	brcmf_sdio_debugfs_create(bus);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
index 82494df..9c5d42d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
@@ -169,6 +169,8 @@ struct brcmf_sdio_dev {
 	u32 sbwad;			/* Save backplane window address */
 	struct brcmf_sdio *bus;
 	atomic_t suspend;		/* suspend flag */
+	bool sleeping;
+	wait_queue_head_t idle_wait;
 	struct device *dev;
 	struct brcmf_bus *bus_if;
 	struct brcmfmac_sdio_platform_data *pdata;
-- 
1.9.1

