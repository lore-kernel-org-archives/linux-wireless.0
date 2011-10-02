Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1731 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1JBRPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/20] staging: brcm80211: removed fullmac function
 brcmf_bus_devreset()
Date: Sun, 2 Oct 2011 10:14:41 -0700
Message-ID: <1317575685-3156-17-git-send-email-frankyl@broadcom.com> (sfid-20111002_191537_148776_8362EC75)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Function is not called anymore.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h      |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   82 +------------------------
 2 files changed, 1 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index be6c620..d79bd79 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -599,7 +599,6 @@ struct brcmf_pub {
 	/* Internal brcmf items */
 	bool up;		/* Driver up/down (to OS) */
 	bool txoff;		/* Transmit flow-controlled */
-	bool dongle_reset;	/* true = DEVRESET put dongle into reset */
 	enum brcmf_bus_state busstate;
 	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
 	uint maxctl;		/* Max size rxctl request from proto to bus */
@@ -744,7 +743,6 @@ extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
 extern int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx,\
 			 struct sk_buff *pkt);
 
-extern int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag);
 extern int brcmf_bus_start(struct brcmf_pub *drvr);
 
 extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 198d544..655209d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2269,11 +2269,6 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->drvr->dongle_reset) {
-		ret = -EPERM;
-		goto done;
-	}
-
 	frame = (u8 *) (pkt->data);
 
 	/* Add alignment padding, allocate new packet if needed */
@@ -2997,9 +2992,6 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->drvr->dongle_reset)
-		return -EIO;
-
 	/* Back the pointer to make a room for bus header */
 	frame = msg - SDPCM_HDRLEN;
 	len = (msglen += SDPCM_HDRLEN);
@@ -3112,9 +3104,6 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->drvr->dongle_reset)
-		return -EIO;
-
 	/* Wait until control frame is available */
 	timeleft = brcmf_sdbrcm_ioctl_resp_wait(bus, &bus->rxlen, &pending);
 
@@ -3880,9 +3869,6 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 
 	bus = drvr->bus;
 
-	if (bus->drvr->dongle_reset)
-		return false;
-
 	/* Ignore the timer if simulating bus down */
 	if (bus->sleeping)
 		return false;
@@ -3968,9 +3954,6 @@ static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->drvr && bus->drvr->dongle_reset)
-		return;
-
 	kfree(bus->rxbuf);
 	bus->rxctl = bus->rxbuf = NULL;
 	bus->rxlen = 0;
@@ -4406,8 +4389,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 		if (kthread_should_stop())
 			break;
 		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
-			if (bus->drvr->dongle_reset == false)
-				brcmf_sdbrcm_bus_watchdog(bus->drvr);
+			brcmf_sdbrcm_bus_watchdog(bus->drvr);
 			/* Count the tick for reference */
 			bus->drvr->tickcnt++;
 		} else
@@ -4451,9 +4433,6 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->drvr && bus->drvr->dongle_reset)
-		return;
-
 	if (bus->ci) {
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
@@ -4672,65 +4651,6 @@ struct device *brcmf_bus_get_device(struct brcmf_bus *bus)
 	return &bus->sdiodev->func[2]->dev;
 }
 
-int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
-{
-	int bcmerror = 0;
-	struct brcmf_bus *bus;
-
-	bus = drvr->bus;
-
-	if (flag == true) {
-		brcmf_sdbrcm_wd_timer(bus, 0);
-		if (!bus->drvr->dongle_reset) {
-			/* Expect app to have torn down any
-			 connection before calling */
-			/* Stop the bus, disable F2 */
-			brcmf_sdbrcm_bus_stop(bus, false);
-
-			/* Clean tx/rx buffer pointers,
-			 detach from the dongle */
-			brcmf_sdbrcm_release_dongle(bus);
-
-			bus->drvr->dongle_reset = true;
-			bus->drvr->up = false;
-
-			brcmf_dbg(TRACE, "WLAN OFF DONE\n");
-			/* App can now remove power from device */
-		} else
-			bcmerror = -EIO;
-	} else {
-		/* App must have restored power to device before calling */
-
-		brcmf_dbg(TRACE, " == WLAN ON ==\n");
-
-		if (bus->drvr->dongle_reset) {
-			/* Turn on WLAN */
-
-			/* Attempt to re-attach & download */
-			if (brcmf_sdbrcm_probe_attach(bus, SI_ENUM_BASE)) {
-				/* Attempt to download binary to the dongle */
-				if (brcmf_sdbrcm_probe_init(bus)) {
-					/* Re-init bus, enable F2 transfer */
-					brcmf_sdbrcm_bus_init(bus->drvr, false);
-
-					bus->drvr->dongle_reset = false;
-					bus->drvr->up = true;
-
-					brcmf_dbg(TRACE, "WLAN ON DONE\n");
-				} else
-					bcmerror = -EIO;
-			} else
-				bcmerror = -EIO;
-		} else {
-			bcmerror = -EISCONN;
-			brcmf_dbg(ERROR, "Set DEVRESET=false invoked when device is on\n");
-			bcmerror = -EIO;
-		}
-		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
-	}
-	return bcmerror;
-}
-
 void
 brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 {
-- 
1.7.1


