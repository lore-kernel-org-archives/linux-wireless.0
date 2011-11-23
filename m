Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4844 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 21/24] brcm80211: fmac: change function bus_txdata
 parameter
Date: Tue, 22 Nov 2011 17:21:56 -0800
Message-ID: <1322011319-24863-22-git-send-email-frankyl@broadcom.com> (sfid-20111123_022234_766976_40444657)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_sdbrcm_bus_txdata. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index be20e7d..c73679e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -37,7 +37,7 @@ extern void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus);
 extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
-extern int brcmf_sdbrcm_bus_txdata(struct brcmf_sdio *bus, struct sk_buff *txp);
+extern int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *txp);
 
 /* Send/receive a control message to/from the dongle.
  * Expects caller to enforce a single outstanding transaction.
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c20c72d..1cfe9f3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -310,7 +310,7 @@ int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
 	brcmf_proto_hdrpush(drvr, ifidx, pktbuf);
 
 	/* Use bus module to send data frame */
-	return brcmf_sdbrcm_bus_txdata(drvr->bus, pktbuf);
+	return brcmf_sdbrcm_bus_txdata(drvr->dev, pktbuf);
 }
 
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index b62dc98..f80151b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2565,10 +2565,13 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 	return 0;
 }
 
-int brcmf_sdbrcm_bus_txdata(struct brcmf_sdio *bus, struct sk_buff *pkt)
+int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
 	uint datalen, prec;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-- 
1.7.5.4


