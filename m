Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3975 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/15] brcm80211: fmac: update bus state in common
 driver part
Date: Thu, 9 Feb 2012 21:09:05 +0100
Message-ID: <1328818149-4826-12-git-send-email-arend@broadcom.com> (sfid-20120209_210935_497474_52A45F8B)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bus state is updated in the sdio bus init function, but it is
better to do it when the brcmf_bus_start() function is completed
successfully. The brcmf_netdev_open() function will return -EAGAIN
until the state is updated instead of calling brcmf_bus_start() to
avoid reentering that function.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   19 ++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    3 ---
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index ff7fc0e..68da756 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -796,18 +796,19 @@ static int brcmf_netdev_open(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_bus *bus_if = drvr->bus_if;
 	u32 toe_ol;
 	s32 ret = 0;
 
 	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
 
 	if (ifp->idx == 0) {	/* do it only for primary eth0 */
-		/* try to bring up bus */
-		ret = brcmf_bus_start(drvr->dev);
-		if (ret != 0) {
-			brcmf_dbg(ERROR, "failed with code %d\n", ret);
-			return -1;
+		/* If bus is not ready, can't continue */
+		if (bus_if->state != BRCMF_BUS_DATA) {
+			brcmf_dbg(ERROR, "failed bus is not ready\n");
+			return -EAGAIN;
 		}
+
 		atomic_set(&drvr->pend_8021x_cnt, 0);
 
 		memcpy(ndev->dev_addr, drvr->mac, ETH_ALEN);
@@ -979,12 +980,6 @@ int brcmf_bus_start(struct device *dev)
 		return ret;
 	}
 
-	/* If bus is not ready, can't come up */
-	if (bus_if->state != BRCMF_BUS_DATA) {
-		brcmf_dbg(ERROR, "failed bus is not ready\n");
-		return -ENODEV;
-	}
-
 	brcmf_c_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR, iovbuf,
@@ -1021,6 +1016,8 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		return ret;
 
+	/* signal bus ready */
+	bus_if->state = BRCMF_BUS_DATA;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 47a192d..253fc20 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3464,9 +3464,6 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_WATERMARK, 8, &err);
-
-		/* Set bus state according to enable result */
-		bus_if->state = BRCMF_BUS_DATA;
 	} else {
 		/* Disable F2 again */
 		enable = SDIO_FUNC_ENABLE_1;
-- 
1.7.5.4


