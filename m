Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4701 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 078/119] staging: brcm80211: move waitqueue code to
 dhd_sdio.c
Date: Wed, 29 Jun 2011 16:47:42 -0700
Message-ID: <1309391303-22741-79-git-send-email-frankyl@broadcom.com> (sfid-20110630_014956_103260_CA3E04EE)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fullmac waitqueue for tx control is used by bus interface layer
only. So move the related code to dhd_sdio.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    3 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   20 ------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   26 ++++++++++++++++++++++-
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 7e19d80..ffdee84 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -963,9 +963,6 @@ extern int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pkt);
 extern int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag);
 extern int brcmf_bus_start(dhd_pub_t *dhdp);
 
-extern void brcmf_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
-extern void brcmf_wait_event_wakeup(dhd_pub_t *dhd);
-
 extern void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg,
 					     int enable, int master_mode);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 6f351eb..6516cc6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -100,7 +100,6 @@ typedef struct dhd_info {
 	bool set_multicast;
 	bool set_macaddress;
 	u8 macvalue[ETH_ALEN];
-	wait_queue_head_t ctrl_wait;
 	atomic_t pend_8021x_cnt;
 
 #ifdef CONFIG_HAS_EARLYSUSPEND
@@ -1641,7 +1640,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	sema_init(&dhd->proto_sem, 1);
 	/* Initialize other structure content */
 	init_waitqueue_head(&dhd->ioctl_resp_wait);
-	init_waitqueue_head(&dhd->ctrl_wait);
 
 	/* Initialize the spinlocks */
 	spin_lock_init(&dhd->sdlock);
@@ -2255,24 +2253,6 @@ static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 	return bcmerror;
 }
 
-void brcmf_wait_for_event(dhd_pub_t *dhd, bool *lockvar)
-{
-	struct dhd_info *dhdinfo = dhd->info;
-	brcmf_os_sdunlock(dhd);
-	wait_event_interruptible_timeout(dhdinfo->ctrl_wait,
-					 (*lockvar == false), HZ * 2);
-	brcmf_os_sdlock(dhd);
-	return;
-}
-
-void brcmf_wait_event_wakeup(dhd_pub_t *dhd)
-{
-	struct dhd_info *dhdinfo = dhd->info;
-	if (waitqueue_active(&dhdinfo->ctrl_wait))
-		wake_up_interruptible(&dhdinfo->ctrl_wait);
-	return;
-}
-
 int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index a97fd7c..ec2c744 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -586,6 +586,7 @@ typedef struct dhd_bus {
 	bool ctrl_frame_stat;
 
 	spinlock_t txqlock;
+	wait_queue_head_t ctrl_wait;
 } dhd_bus_t;
 
 typedef volatile struct _sbconfig {
@@ -777,6 +778,8 @@ static void brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio *sdh, u32 corebase);
 static void brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus,
 					u32 drivestrength);
 static void brcmf_sdbrcm_chip_detach(struct dhd_bus *bus);
+static void brcmf_sdbrcm_wait_for_event(dhd_pub_t *dhd, bool *lockvar);
+static void brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
@@ -1501,7 +1504,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		bus->ctrl_frame_buf = frame;
 		bus->ctrl_frame_len = len;
 
-		brcmf_wait_for_event(bus->dhd, &bus->ctrl_frame_stat);
+		brcmf_sdbrcm_wait_for_event(bus->dhd, &bus->ctrl_frame_stat);
 
 		if (bus->ctrl_frame_stat == false) {
 			DHD_INFO(("%s: ctrl_frame_stat == false\n", __func__));
@@ -4577,7 +4580,7 @@ clkwait:
 
 		DHD_INFO(("Return_dpc value is : %d\n", ret));
 		bus->ctrl_frame_stat = false;
-		brcmf_wait_event_wakeup(bus->dhd);
+		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
 	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
@@ -5213,6 +5216,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	}
 
 	spin_lock_init(&bus->txqlock);
+	init_waitqueue_head(&bus->ctrl_wait);
 
 	/* Attach to the dhd/OS/network interface */
 	bus->dhd = brcmf_attach(bus, SDPCM_RESERVE);
@@ -6317,3 +6321,21 @@ brcmf_sdbrcm_chip_detach(struct dhd_bus *bus)
 	kfree(bus->ci);
 	bus->ci = NULL;
 }
+
+static void
+brcmf_sdbrcm_wait_for_event(dhd_pub_t *dhd, bool *lockvar)
+{
+	brcmf_os_sdunlock(dhd);
+	wait_event_interruptible_timeout(dhd->bus->ctrl_wait,
+					 (*lockvar == false), HZ * 2);
+	brcmf_os_sdlock(dhd);
+	return;
+}
+
+static void
+brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus)
+{
+	if (waitqueue_active(&bus->ctrl_wait))
+		wake_up_interruptible(&bus->ctrl_wait);
+	return;
+}
-- 
1.7.1


