Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:26251 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaELIro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:44 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/14] brcmfmac: Make FWS queueing configurable.
Date: Mon, 12 May 2014 10:47:30 +0200
Message-ID: <1399884459-5048-6-git-send-email-arend@broadcom.com> (sfid-20140512_105149_483231_C9DA043F)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

FWS is always queuing frames and using a worker for de-queueing,
this is not always efficient for all bus layer. For example SDIO
has an internal queue and worker making the queueing of FWS
unnecessary. Make it possible to bypass the worker if fws mode
is none using a bus interface configuration. For USB bus layer
this configuration is set true to have fws provide queueing
regardless the fws mode.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   15 +++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index c453561..c5dcd82 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -99,6 +99,7 @@ struct brcmf_bus {
 	unsigned long tx_realloc;
 	u32 chip;
 	u32 chiprev;
+	bool always_use_fws_queue;
 
 	struct brcmf_bus_ops *ops;
 };
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b58a97a..699908d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -476,6 +476,7 @@ struct brcmf_fws_info {
 	bool bus_flow_blocked;
 	bool creditmap_received;
 	u8 mode;
+	bool avoid_queueing;
 };
 
 /*
@@ -1872,6 +1873,13 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	drvr->tx_multicast += !!multicast;
 
+	if (fws->avoid_queueing) {
+		rc = brcmf_proto_txdata(drvr, ifp->ifidx, 0, skb);
+		if (rc < 0)
+			brcmf_txfinalize(drvr, skb, ifp->ifidx, false);
+		return rc;
+	}
+
 	/* set control buffer information */
 	skcb->if_flags = 0;
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
@@ -2030,6 +2038,13 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	fws->drvr = drvr;
 	fws->fcmode = fcmode;
 
+	if ((drvr->bus_if->always_use_fws_queue == false) &&
+	    (fcmode == BRCMF_FWS_FCMODE_NONE)) {
+		fws->avoid_queueing = true;
+		brcmf_dbg(INFO, "FWS queueing will be avoided\n");
+		return 0;
+	}
+
 	fws->fws_wq = create_singlethread_workqueue("brcmf_fws_wq");
 	if (fws->fws_wq == NULL) {
 		brcmf_err("workqueue creation failed\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 24f65cd..3ce0e7c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1254,6 +1254,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->chip = bus_pub->devid;
 	bus->chiprev = bus_pub->chiprev;
 	bus->proto_type = BRCMF_PROTO_BCDC;
+	bus->always_use_fws_queue = true;
 
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(dev);
-- 
1.7.9.5

