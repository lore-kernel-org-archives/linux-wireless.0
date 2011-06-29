Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4583 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 008/119] staging: brcm80211: move sdtxqlock codes to
 dhd_sdio.c
Date: Wed, 29 Jun 2011 16:46:32 -0700
Message-ID: <1309391303-22741-9-git-send-email-frankyl@broadcom.com> (sfid-20110630_014932_012169_0FF699B9)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move sdio specific tx queue lock codes to dhd_sdio.c for fullmac

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    2 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   18 ------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   14 +++++++++-----
 3 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 01bacdb..a4dcaf8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -972,8 +972,6 @@ extern void dhd_os_close_image(void *image);
 extern void dhd_os_wd_timer(void *bus, uint wdtick);
 extern void dhd_os_sdlock(dhd_pub_t *pub);
 extern void dhd_os_sdunlock(dhd_pub_t *pub);
-extern void dhd_os_sdlock_txq(dhd_pub_t *pub);
-extern void dhd_os_sdunlock_txq(dhd_pub_t *pub);
 extern void dhd_os_sdlock_sndup_rxq(dhd_pub_t *pub);
 extern void dhd_customer_gpio_wlan_ctrl(int onoff);
 extern int dhd_custom_get_mac_address(unsigned char *buf);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 4811d7a..dfbbda7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -232,7 +232,6 @@ typedef struct dhd_info {
 	bool wd_timer_valid;
 	struct tasklet_struct tasklet;
 	spinlock_t sdlock;
-	spinlock_t txqlock;
 	/* Thread based operation */
 	bool threads_only;
 	struct semaphore sdsem;
@@ -1918,7 +1917,6 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 
 	/* Initialize the spinlocks */
 	spin_lock_init(&dhd->sdlock);
-	spin_lock_init(&dhd->txqlock);
 
 	/* Link to info module */
 	dhd->pub.info = dhd;
@@ -2579,22 +2577,6 @@ void dhd_os_sdunlock(dhd_pub_t *pub)
 		spin_unlock_bh(&dhd->sdlock);
 }
 
-void dhd_os_sdlock_txq(dhd_pub_t *pub)
-{
-	dhd_info_t *dhd;
-
-	dhd = (dhd_info_t *) (pub->info);
-	spin_lock_bh(&dhd->txqlock);
-}
-
-void dhd_os_sdunlock_txq(dhd_pub_t *pub)
-{
-	dhd_info_t *dhd;
-
-	dhd = (dhd_info_t *) (pub->info);
-	spin_unlock_bh(&dhd->txqlock);
-}
-
 static int
 dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 		  wl_event_msg_t *event, void **data)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index dcfebac..48550f3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -592,6 +592,8 @@ typedef struct dhd_bus {
 	u8 *ctrl_frame_buf;
 	u32 ctrl_frame_len;
 	bool ctrl_frame_stat;
+
+	spinlock_t txqlock;
 } dhd_bus_t;
 
 typedef volatile struct _sbconfig {
@@ -1370,7 +1372,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		bus->fcqueued++;
 
 		/* Priority based enq */
-		dhd_os_sdlock_txq(bus->dhd);
+		spin_lock_bh(&bus->txqlock);
 		if (dhd_prec_enq(bus->dhd, &bus->txq, pkt, prec) == false) {
 			skb_pull(pkt, SDPCM_HDRLEN);
 			dhd_txcomplete(bus->dhd, pkt, false);
@@ -1380,7 +1382,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		} else {
 			ret = 0;
 		}
-		dhd_os_sdunlock_txq(bus->dhd);
+		spin_unlock_bh(&bus->txqlock);
 
 		if (pktq_len(&bus->txq) >= TXHI)
 			dhd_txflowcontrol(bus->dhd, 0, ON);
@@ -1446,13 +1448,13 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 
 	/* Send frames until the limit or some other event */
 	for (cnt = 0; (cnt < maxframes) && DATAOK(bus); cnt++) {
-		dhd_os_sdlock_txq(bus->dhd);
+		spin_lock_bh(&bus->txqlock);
 		pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
 		if (pkt == NULL) {
-			dhd_os_sdunlock_txq(bus->dhd);
+			spin_unlock_bh(&bus->txqlock);
 			break;
 		}
-		dhd_os_sdunlock_txq(bus->dhd);
+		spin_unlock_bh(&bus->txqlock);
 		datalen = pkt->len - SDPCM_HDRLEN;
 
 #ifndef SDTEST
@@ -5264,6 +5266,8 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 		goto fail;
 	}
 
+	spin_lock_init(&bus->txqlock);
+
 	/* Attach to the dhd/OS/network interface */
 	bus->dhd = dhd_attach(bus, SDPCM_RESERVE);
 	if (!bus->dhd) {
-- 
1.7.1


