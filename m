Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1134 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761005Ab1LQChl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:41 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/30] brcm80211: fmac: change function brcmf_detach
 parameter
Date: Fri, 16 Dec 2011 18:36:56 -0800
Message-ID: <1324089440-8957-7-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_952292_F70D0945)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_detach. This is part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   33 ++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 +-
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 0f1384d..4e59c86 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -703,7 +703,7 @@ extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 extern s32 brcmf_exec_dcmd(struct net_device *dev, u32 cmd, void *arg, u32 len);
 
 /* Indication from bus module regarding removal/absence of dongle */
-extern void brcmf_detach(struct brcmf_pub *drvr);
+extern void brcmf_detach(struct device *dev);
 
 /* Indication from bus module to change flow-control state */
 extern void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool on);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 0440471..6b0739b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -955,7 +955,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 
 fail:
 	if (drvr)
-		brcmf_detach(drvr);
+		brcmf_detach(dev);
 
 	return NULL;
 }
@@ -1093,29 +1093,30 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 	}
 }
 
-void brcmf_detach(struct brcmf_pub *drvr)
+void brcmf_detach(struct device *dev)
 {
+	int i;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (drvr) {
-		int i;
 
-		/* make sure primary interface removed last */
-		for (i = BRCMF_MAX_IFS-1; i > -1; i--)
-			if (drvr->iflist[i])
-				brcmf_del_if(drvr, i);
+	/* make sure primary interface removed last */
+	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
+		if (drvr->iflist[i])
+			brcmf_del_if(drvr, i);
 
-		cancel_work_sync(&drvr->setmacaddr_work);
-		cancel_work_sync(&drvr->multicast_work);
+	cancel_work_sync(&drvr->setmacaddr_work);
+	cancel_work_sync(&drvr->multicast_work);
 
-		brcmf_bus_detach(drvr);
+	brcmf_bus_detach(drvr);
 
-		if (drvr->prot)
-			brcmf_proto_detach(drvr);
+	if (drvr->prot)
+		brcmf_proto_detach(drvr);
 
-		drvr->bus_if->drvr = NULL;
-		kfree(drvr);
-	}
+	bus_if->drvr = NULL;
+	kfree(drvr);
 }
 
 static int brcmf_get_pend_8021x_cnt(struct brcmf_pub *drvr)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a961627..6e347ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3865,8 +3865,8 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 		/* De-register interrupt handler */
 		brcmf_sdcard_intr_dereg(bus->sdiodev);
 
-		if (bus->drvr) {
-			brcmf_detach(bus->drvr);
+		if (bus->sdiodev->bus_if->drvr) {
+			brcmf_detach(bus->sdiodev->dev);
 			brcmf_sdbrcm_release_dongle(bus);
 			bus->drvr = NULL;
 		}
-- 
1.7.5.4


