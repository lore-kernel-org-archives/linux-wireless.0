Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1343 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3BFRmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:42:36 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/12] brcmfmac: Remove drvr_up from bus interface.
Date: Wed, 6 Feb 2013 18:40:36 +0100
Message-ID: <1360172447-2424-2-git-send-email-arend@broadcom.com> (sfid-20130206_184240_673562_40202627)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The tracking of up/down status in bus interface is unnecessary.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h   |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |   16 +---------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c  |    6 +-----
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 64c38f4..57826dc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -72,7 +72,6 @@ struct brcmf_bus_ops {
  * @drvr: public driver information.
  * @state: operational state of the bus interface.
  * @maxctl: maximum size for rxctl request message.
- * @drvr_up: indicates driver up/down status.
  * @tx_realloc: number of tx packets realloced for headroom.
  * @dstats: dongle-based statistical data.
  * @align: alignment requirement for the bus.
@@ -87,7 +86,6 @@ struct brcmf_bus {
 	struct brcmf_pub *drvr;
 	enum brcmf_bus_state state;
 	uint maxctl;
-	bool drvr_up;
 	unsigned long tx_realloc;
 	struct dngl_stats dstats;
 	u8 align;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e3326a5..2104a4f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -452,13 +452,7 @@ static int brcmf_ethtool(struct brcmf_if *ifp, void __user *uaddr)
 			sprintf(info.driver, "dhd");
 			strcpy(info.version, BRCMF_VERSION_STR);
 		}
-
-		/* otherwise, require dongle to be up */
-		else if (!drvr->bus_if->drvr_up) {
-			brcmf_err("dongle is not up\n");
-			return -ENODEV;
-		}
-		/* finally, report dongle driver type */
+		/* report dongle driver type */
 		else
 			sprintf(info.driver, "wl");
 
@@ -545,18 +539,11 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 
 static int brcmf_netdev_stop(struct net_device *ndev)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pub *drvr = ifp->drvr;
-
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (drvr->bus_if->drvr_up == 0)
-		return 0;
-
 	brcmf_cfg80211_down(ndev);
 
 	/* Set state and stop OS transmissions */
-	drvr->bus_if->drvr_up = false;
 	netif_stop_queue(ndev);
 
 	return 0;
@@ -591,7 +578,6 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	/* Allow transmit calls */
 	netif_start_queue(ndev);
-	drvr->bus_if->drvr_up = true;
 	if (brcmf_cfg80211_up(ndev)) {
 		brcmf_err("failed to bring up cfg80211\n");
 		return -1;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 7fef9b5..df8a185 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1962,8 +1962,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if (bus->sdiodev->bus_if->drvr_up &&
-	    (bus->sdiodev->bus_if->state == BRCMF_BUS_DATA) &&
+	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DATA) &&
 	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
 		bus->txoff = false;
 		brcmf_txflowblock(bus->sdiodev->dev, false);
@@ -3308,9 +3307,6 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_sdio *bus)
 {
 	int ret;
 
-	if (bus->sdiodev->bus_if->drvr_up)
-		return -EISCONN;
-
 	ret = request_firmware(&bus->firmware, BRCMF_SDIO_NV_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
-- 
1.7.10.4


