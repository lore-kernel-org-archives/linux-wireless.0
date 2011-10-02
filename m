Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1722 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/20] staging: brcm80211: removed 'enforce_mutex'
 parameter in fullmac
Date: Sun, 2 Oct 2011 10:14:42 -0700
Message-ID: <1317575685-3156-18-git-send-email-frankyl@broadcom.com> (sfid-20111002_191528_174873_D300BF9E)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Parameter was always called with the value 'true'.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h   |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   23 ++++++++++-------------
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index a5064f5..a249407 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -35,10 +35,10 @@ extern void brcmf_bus_unregister(void);
 extern struct device *brcmf_bus_get_device(struct brcmf_bus *bus);
 
 /* Stop bus module: clear pending frames, disable data flow */
-extern void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex);
+extern void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus);
 
 /* Initialize bus module: prepare for communication w/dongle */
-extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex);
+extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
 extern int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *txp);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 3ae0d43..a31b8a3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1093,7 +1093,7 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	brcmf_dbg(TRACE, "\n");
 
 	/* Bring up the bus */
-	ret = brcmf_sdbrcm_bus_init(&drvr_priv->pub, true);
+	ret = brcmf_sdbrcm_bus_init(&drvr_priv->pub);
 	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
@@ -1217,7 +1217,7 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 			brcmf_proto_stop(&drvr_priv->pub);
 
 			/* Stop the bus module */
-			brcmf_sdbrcm_bus_stop(drvr_priv->pub.bus, true);
+			brcmf_sdbrcm_bus_stop(drvr_priv->pub.bus);
 		}
 	}
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 655209d..aa05cc0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2720,7 +2720,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 				if (brcmf_sdbrcm_dpc(bus))
 					complete(&bus->dpc_wait);
 			} else {
-				brcmf_sdbrcm_bus_stop(bus, true);
+				brcmf_sdbrcm_bus_stop(bus);
 			}
 		} else
 			break;
@@ -2736,8 +2736,9 @@ static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
 	if (bus->drvr->busstate != BRCMF_BUS_DOWN) {
 		if (brcmf_sdbrcm_dpc(bus))
 			tasklet_schedule(&bus->tasklet);
-	} else
-		brcmf_sdbrcm_bus_stop(bus, true);
+	} else {
+		brcmf_sdbrcm_bus_stop(bus);
+	}
 }
 
 static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus)
@@ -3639,7 +3640,7 @@ brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 	return ret;
 }
 
-void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
+void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 {
 	u32 local_hostintmask;
 	u8 saveclk;
@@ -3648,8 +3649,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (enforce_mutex)
-		down(&bus->sdsem);
+	down(&bus->sdsem);
 
 	bus_wake(bus);
 
@@ -3720,11 +3720,10 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	bus->rxskip = false;
 	bus->tx_seq = bus->rx_seq = 0;
 
-	if (enforce_mutex)
-		up(&bus->sdsem);
+	up(&bus->sdsem);
 }
 
-int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
+int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 {
 	struct brcmf_bus *bus = drvr->bus;
 	unsigned long timeout;
@@ -3748,8 +3747,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	bus->drvr->tickcnt = 0;
 	brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 
-	if (enforce_mutex)
-		down(&bus->sdsem);
+	down(&bus->sdsem);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -3822,8 +3820,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
-	if (enforce_mutex)
-		up(&bus->sdsem);
+	up(&bus->sdsem);
 
 	return ret;
 }
-- 
1.7.1


