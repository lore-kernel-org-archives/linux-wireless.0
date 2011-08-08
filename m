Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2825 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1HHN70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 43/82] staging: brcm80211: remove private timeout
 functions in fullmac
Date: Mon, 8 Aug 2011 15:58:27 +0200
Message-ID: <1312811946-16713-44-git-send-email-arend@broadcom.com> (sfid-20110808_160203_492579_CCE3F95D)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use kernel timer macros to replace current private timeout functions
used in dhd_sdio.c

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |   10 ----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   58 ------------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   18 +++++---
 3 files changed, 11 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index f3633fe..1fe9d69 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -614,13 +614,6 @@ struct brcmf_if_event {
 	u8 bssidx;
 };
 
-struct brcmf_timeout {
-	u32 limit;		/* Expiration time (usec) */
-	u32 increment;	/* Current expiration increment (usec) */
-	u32 elapsed;		/* Current elapsed time (usec) */
-	u32 tick;		/* O/S tick time (usec) */
-};
-
 struct bcmevent_name {
 	uint event;
 	const char *name;
@@ -783,9 +776,6 @@ extern int brcmf_os_proto_unblock(struct brcmf_pub *drvr);
 extern int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size);
 #endif				/* BCMDBG */
 
-extern void brcmf_timeout_start(struct brcmf_timeout *tmo, uint usec);
-extern int brcmf_timeout_expired(struct brcmf_timeout *tmo);
-
 extern int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name);
 extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
 			      void *pktdata, struct brcmf_event_msg *,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 0d86819..07ceaf9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -143,64 +143,6 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktd
 			    struct brcmf_event_msg *event_ptr,
 			    void **data_ptr);
 
-/*
- * Generalized timeout mechanism.  Uses spin sleep with exponential
- * back-off until
- * the sleep time reaches one jiffy, then switches over to task delay.  Usage:
- *
- *      brcmf_timeout_start(&tmo, usec);
- *      while (!brcmf_timeout_expired(&tmo))
- *              if (poll_something())
- *                      break;
- *      if (brcmf_timeout_expired(&tmo))
- *              fatal();
- */
-
-void brcmf_timeout_start(struct brcmf_timeout *tmo, uint usec)
-{
-	tmo->limit = usec;
-	tmo->increment = 0;
-	tmo->elapsed = 0;
-	tmo->tick = 1000000 / HZ;
-}
-
-int brcmf_timeout_expired(struct brcmf_timeout *tmo)
-{
-	/* Does nothing the first call */
-	if (tmo->increment == 0) {
-		tmo->increment = 1;
-		return 0;
-	}
-
-	if (tmo->elapsed >= tmo->limit)
-		return 1;
-
-	/* Add the delay that's about to take place */
-	tmo->elapsed += tmo->increment;
-
-	if (tmo->increment < tmo->tick) {
-		udelay(tmo->increment);
-		tmo->increment *= 2;
-		if (tmo->increment > tmo->tick)
-			tmo->increment = tmo->tick;
-	} else {
-		wait_queue_head_t delay_wait;
-		DECLARE_WAITQUEUE(wait, current);
-		int pending;
-		init_waitqueue_head(&delay_wait);
-		add_wait_queue(&delay_wait, &wait);
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(1);
-		pending = signal_pending(current);
-		remove_wait_queue(&delay_wait, &wait);
-		set_current_state(TASK_RUNNING);
-		if (pending)
-			return 1;	/* Interrupted */
-	}
-
-	return 0;
-}
-
 static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *net)
 {
 	int i = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8d4c48f..b38525c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -3306,7 +3306,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 {
 	struct brcmf_bus *bus = drvr->bus;
-	struct brcmf_timeout tmo;
+	unsigned long timeout;
 	uint retries = 0;
 	u8 ready, enable;
 	int err, ret = 0;
@@ -3358,16 +3358,20 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
 			       NULL);
 
-	/* Give the dongle some time to do its thing and set IOR2 */
-	brcmf_timeout_start(&tmo, BRCMF_WAIT_F2RDY * 1000);
-
+	timeout = jiffies + msecs_to_jiffies(BRCMF_WAIT_F2RDY);
 	ready = 0;
-	while (ready != enable && !brcmf_timeout_expired(&tmo))
+	while (enable != ready) {
 		ready = brcmf_sdcard_cfg_read(bus->card, SDIO_FUNC_0,
 					      SDIO_CCCR_IORx, NULL);
+		if (time_after(jiffies, timeout))
+			break;
+		else if (time_after(jiffies, timeout - BRCMF_WAIT_F2RDY + 50))
+			/* prevent busy waiting if it takes too long */
+			msleep_interruptible(20);
+	}
 
-	BRCMF_INFO(("%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
-		    __func__, enable, ready, tmo.elapsed));
+	BRCMF_INFO(("%s: enable 0x%02x, ready 0x%02x\n",
+		    __func__, enable, ready));
 
 	/* If F2 successfully enabled, set core and enable interrupts */
 	if (ready == enable) {
-- 
1.7.4.1


