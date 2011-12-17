Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2325 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760750Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 25/30] brcm80211: fmac: abstract bus_txdata interface
 function pointer
Date: Fri, 16 Dec 2011 18:37:15 -0800
Message-ID: <1324089440-8957-26-git-send-email-frankyl@broadcom.com> (sfid-20111217_033738_680941_9E16861D)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Abstract bus layer brcmf_bus_txdata function pointer for common
layer. This patch is part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    5 ++---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    3 ++-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 5d5f2af..d5e0ec3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -53,6 +53,8 @@ struct brcmf_bus {
 	void (*brcmf_bus_stop)(struct device *);
 	/* Initialize bus module: prepare for communication w/dongle */
 	int (*brcmf_bus_init)(struct device *);
+	/* Send a data frame to the dongle.  Callee disposes of txp. */
+	int (*brcmf_bus_txdata)(struct device *, struct sk_buff *);
 };
 
 /*
@@ -99,9 +101,6 @@ extern int brcmf_add_if(struct device *dev, int ifidx,
 /*
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
-/* Send a data frame to the dongle.  Callee disposes of txp. */
-extern int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *txp);
-
 /* Send/receive a control message to/from the dongle.
  * Expects caller to enforce a single outstanding transaction.
  */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 62b4575..72bee2c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -291,7 +291,7 @@ int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 	brcmf_proto_hdrpush(drvr, ifidx, pktbuf);
 
 	/* Use bus module to send data frame */
-	return brcmf_sdbrcm_bus_txdata(drvr->dev, pktbuf);
+	return drvr->bus_if->brcmf_bus_txdata(drvr->dev, pktbuf);
 }
 
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5089b64..6a30950 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2655,7 +2655,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 	return 0;
 }
 
-int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
+static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
 	uint datalen, prec;
@@ -3955,6 +3955,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	/* Assign bus interface call back */
 	bus->sdiodev->bus_if->brcmf_bus_stop = brcmf_sdbrcm_bus_stop;
 	bus->sdiodev->bus_if->brcmf_bus_init = brcmf_sdbrcm_bus_init;
+	bus->sdiodev->bus_if->brcmf_bus_txdata = brcmf_sdbrcm_bus_txdata;
 	/* Attach to the brcmf/OS/network interface */
 	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
 	if (ret != 0) {
-- 
1.7.5.4


