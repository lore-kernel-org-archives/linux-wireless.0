Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4504 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab2KFAWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:49 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/24] brcmfmac: use dynamically allocated control frame
 buffer
Date: Mon, 5 Nov 2012 16:22:22 -0800
Message-ID: <1352161352-30405-15-git-send-email-frankyl@broadcom.com> (sfid-20121106_013117_796431_26EEB984)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rxbuf in SDIO interface is used in normal frame and control frame
read. Use dynamically allocated buffer in control frame read path
for post processing to avoid conflicts.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   53 ++++++++++++++------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 415f2be..1d7a340 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -533,9 +533,11 @@ struct brcmf_sdio {
 	u8 *rxbuf;		/* Buffer for receiving control packets */
 	uint rxblen;		/* Allocated length of rxbuf */
 	u8 *rxctl;		/* Aligned pointer into rxbuf */
+	u8 *rxctl_orig;		/* pointer for freeing rxctl */
 	u8 *databuf;		/* Buffer for receiving big glom packet */
 	u8 *dataptr;		/* Aligned pointer into databuf */
 	uint rxlen;		/* Length of valid data in buffer */
+	spinlock_t rxctl_lock;	/* protection lock for ctrl frame resources */
 
 	u8 sdpcm_ver;	/* Bus protocol reported by dongle */
 
@@ -1442,21 +1444,24 @@ static void
 brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 {
 	uint rdlen, pad;
-
+	u8 *buf = NULL, *rbuf;
 	int sdret;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Set rxctl for frame (w/optional alignment) */
-	bus->rxctl = bus->rxbuf;
-	bus->rxctl += BRCMF_FIRSTREAD;
-	pad = ((unsigned long)bus->rxctl % BRCMF_SDALIGN);
+	if (bus->rxblen)
+		buf = vzalloc(bus->rxblen);
+	if (!buf) {
+		brcmf_dbg(ERROR, "no memory for control frame\n");
+		goto done;
+	}
+	rbuf = bus->rxbuf;
+	pad = ((unsigned long)rbuf % BRCMF_SDALIGN);
 	if (pad)
-		bus->rxctl += (BRCMF_SDALIGN - pad);
-	bus->rxctl -= BRCMF_FIRSTREAD;
+		rbuf += (BRCMF_SDALIGN - pad);
 
 	/* Copy the already-read portion over */
-	memcpy(bus->rxctl, hdr, BRCMF_FIRSTREAD);
+	memcpy(buf, hdr, BRCMF_FIRSTREAD);
 	if (len <= BRCMF_FIRSTREAD)
 		goto gotpkt;
 
@@ -1493,11 +1498,11 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		goto done;
 	}
 
-	/* Read remainder of frame body into the rxctl buffer */
+	/* Read remain of frame body */
 	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
 				bus->sdiodev->sbwad,
 				SDIO_FUNC_2,
-				F2SYNC, (bus->rxctl + BRCMF_FIRSTREAD), rdlen);
+				F2SYNC, rbuf, rdlen);
 	bus->sdcnt.f2rxdata++;
 
 	/* Control frame failures need retransmission */
@@ -1507,16 +1512,26 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		bus->sdcnt.rxc_errors++;
 		brcmf_sdbrcm_rxfail(bus, true, true);
 		goto done;
-	}
+	} else
+		memcpy(buf + BRCMF_FIRSTREAD, rbuf, rdlen);
 
 gotpkt:
 
 	brcmf_dbg_hex_dump(BRCMF_BYTES_ON() && BRCMF_CTL_ON(),
-			   bus->rxctl, len, "RxCtrl:\n");
+			   buf, len, "RxCtrl:\n");
 
 	/* Point to valid data and indicate its length */
-	bus->rxctl += doff;
+	spin_lock_bh(&bus->rxctl_lock);
+	if (bus->rxctl) {
+		brcmf_dbg(ERROR, "last control frame is being processed.\n");
+		spin_unlock_bh(&bus->rxctl_lock);
+		vfree(buf);
+		goto done;
+	}
+	bus->rxctl = buf + doff;
+	bus->rxctl_orig = buf;
 	bus->rxlen = len - doff;
+	spin_unlock_bh(&bus->rxctl_lock);
 
 done:
 	/* Awake any waiters */
@@ -2023,7 +2038,9 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	brcmf_sdbrcm_free_glom(bus);
 
 	/* Clear rx control and wake any waiters */
+	spin_lock_bh(&bus->rxctl_lock);
 	bus->rxlen = 0;
+	spin_unlock_bh(&bus->rxctl_lock);
 	brcmf_sdbrcm_dcmd_resp_wake(bus);
 
 	/* Reset some F2 state stuff */
@@ -2989,6 +3006,7 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	int timeleft;
 	uint rxlen = 0;
 	bool pending;
+	u8 *buf;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
@@ -2998,11 +3016,15 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	/* Wait until control frame is available */
 	timeleft = brcmf_sdbrcm_dcmd_resp_wait(bus, &bus->rxlen, &pending);
 
-	down(&bus->sdsem);
+	spin_lock_bh(&bus->rxctl_lock);
 	rxlen = bus->rxlen;
 	memcpy(msg, bus->rxctl, min(msglen, rxlen));
+	bus->rxctl = NULL;
+	buf = bus->rxctl_orig;
+	bus->rxctl_orig = NULL;
 	bus->rxlen = 0;
-	up(&bus->sdsem);
+	spin_unlock_bh(&bus->rxctl_lock);
+	vfree(buf);
 
 	if (rxlen) {
 		brcmf_dbg(CTL, "resumed on rxctl frame, got %d expected %d\n",
@@ -3860,6 +3882,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 
+	spin_lock_init(&bus->rxctl_lock);
 	spin_lock_init(&bus->txqlock);
 	init_waitqueue_head(&bus->ctrl_wait);
 	init_waitqueue_head(&bus->dcmd_resp_wait);
-- 
1.7.9.5


