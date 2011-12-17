Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1125 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760932Ab1LQChl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:41 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/30] brcm80211: fmac: change function add_if parameter
Date: Fri, 16 Dec 2011 18:36:54 -0800
Message-ID: <1324089440-8957-5-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_635742_E64F7752)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_add_if. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 ++-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 +++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 74ea4b0..a8e94eb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -574,6 +574,7 @@ struct brcmf_dcmd {
 struct brcmf_bus {
 	u8 type;		/* bus type */
 	void *bus_priv;		/* pointer to bus private structure */
+	void *drvr;		/* pointer to driver pub structure brcmf_pub */
 	enum brcmf_bus_state state;
 };
 
@@ -743,7 +744,7 @@ extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
 			      void *pktdata, struct brcmf_event_msg *,
 			      void **data_ptr);
 
-extern int brcmf_add_if(struct brcmf_pub *drvr, int ifidx,
+extern int brcmf_add_if(struct device *dev, int ifidx,
 			char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 5e5a954..e9f7d66 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -473,7 +473,7 @@ brcmf_c_host_event(struct brcmf_pub *drvr, int *ifidx, void *pktdata,
 
 		if (ifevent->ifidx > 0 && ifevent->ifidx < BRCMF_MAX_IFS) {
 			if (ifevent->action == BRCMF_E_IF_ADD)
-				brcmf_add_if(drvr, ifevent->ifidx,
+				brcmf_add_if(drvr->dev, ifevent->ifidx,
 					     event->ifname,
 					     pvt_data->eth.h_dest);
 			else
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index cd0a698..3d0177a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -840,10 +840,12 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 };
 
 int
-brcmf_add_if(struct brcmf_pub *drvr, int ifidx, char *name, u8 *mac_addr)
+brcmf_add_if(struct device *dev, int ifidx, char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
@@ -937,6 +939,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 	drvr->bus = bus;
 	drvr->hdrlen = bus_hdrlen;
 	drvr->bus_if = dev_get_drvdata(dev);
+	drvr->bus_if->drvr = drvr;
 	drvr->dev = dev;
 
 	/* Attach and link in the protocol */
@@ -1108,6 +1111,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 		if (drvr->prot)
 			brcmf_proto_detach(drvr);
 
+		drvr->bus_if->drvr = NULL;
 		kfree(drvr);
 	}
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3096166..4e3e4ec 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3980,7 +3980,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* add interface and open for business */
-	if (brcmf_add_if(bus->drvr, 0, "wlan%d", NULL)) {
+	if (brcmf_add_if(bus->sdiodev->dev, 0, "wlan%d", NULL)) {
 		brcmf_dbg(ERROR, "Add primary net device interface failed!!\n");
 		goto fail;
 	}
-- 
1.7.5.4


