Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1136 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761006Ab1LQChl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:41 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/30] brcm80211: fmac: change function bus_start
 parameter
Date: Fri, 16 Dec 2011 18:36:55 -0800
Message-ID: <1324089440-8957-6-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_958322_4DB98913)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_bus_start. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   10 ++++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a8e94eb..0f1384d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -752,7 +752,7 @@ extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 extern int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx,\
 			 struct sk_buff *pkt);
 
-extern int brcmf_bus_start(struct brcmf_pub *drvr);
+extern int brcmf_bus_start(struct device *dev);
 
 extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 3d0177a..0440471 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -800,7 +800,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	if (ifp->idx == 0) {	/* do it only for primary eth0 */
 		/* try to bring up bus */
-		ret = brcmf_bus_start(drvr);
+		ret = brcmf_bus_start(drvr->dev);
 		if (ret != 0) {
 			brcmf_dbg(ERROR, "failed with code %d\n", ret);
 			return -1;
@@ -960,23 +960,25 @@ fail:
 	return NULL;
 }
 
-int brcmf_bus_start(struct brcmf_pub *drvr)
+int brcmf_bus_start(struct device *dev)
 {
 	int ret = -1;
 	/* Room for "event_msgs" + '\0' + bitvec */
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_dbg(TRACE, "\n");
 
 	/* Bring up the bus */
-	ret = brcmf_sdbrcm_bus_init(drvr->dev);
+	ret = brcmf_sdbrcm_bus_init(dev);
 	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
 	}
 
 	/* If bus is not ready, can't come up */
-	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
+	if (bus_if->state != BRCMF_BUS_DATA) {
 		brcmf_dbg(ERROR, "failed bus is not ready\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4e3e4ec..a961627 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3971,7 +3971,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	brcmf_dbg(INFO, "completed!!\n");
 
 	/* if firmware path present try to download and bring up bus */
-	ret = brcmf_bus_start(bus->drvr);
+	ret = brcmf_bus_start(bus->sdiodev->dev);
 	if (ret != 0) {
 		if (ret == -ENOLINK) {
 			brcmf_dbg(ERROR, "dongle is not responding\n");
-- 
1.7.5.4


