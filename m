Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1527 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760982Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 20/30] brcm80211: fmac: stop referencing brcmf_sdio in
 common layer
Date: Fri, 16 Dec 2011 18:37:10 -0800
Message-ID: <1324089440-8957-21-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_587320_B7E3EB1D)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdio is the data structure for sdio bus layer. Stop
referencing brcmf_sdio from common layer. This patch is part of
the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    5 +----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 ---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    4 ++++
 5 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index dcb1bb5..5d0be12 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -583,14 +583,12 @@ struct brcmf_bus {
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
-struct brcmf_sdio;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
 
 /* Common structure for module and instance linkage */
 struct brcmf_pub {
 	/* Linkage ponters */
-	struct brcmf_sdio *bus;
 	struct brcmf_bus *bus_if;
 	struct brcmf_proto *prot;
 	struct brcmf_cfg80211_dev *config;
@@ -669,8 +667,7 @@ extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
  * Returned structure should have bus and prot pointers filled in.
  * bus_hdrlen specifies required headroom for bus module header.
  */
-extern int brcmf_attach(struct brcmf_sdio *bus,
-			uint bus_hdrlen, struct device *dev);
+extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 1841f99..1b34877 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -44,7 +44,4 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen);
 
 extern int
 brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen);
-
-extern void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
-
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 533418e..70f0b31 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -922,8 +922,7 @@ void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
 	}
 }
 
-int brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
-			       struct device *dev)
+int brcmf_attach(uint bus_hdrlen, struct device *dev)
 {
 	struct brcmf_pub *drvr = NULL;
 	int ret = 0;
@@ -938,7 +937,6 @@ int brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 	mutex_init(&drvr->proto_block);
 
 	/* Link to bus module */
-	drvr->bus = bus;
 	drvr->hdrlen = bus_hdrlen;
 	drvr->bus_if = dev_get_drvdata(dev);
 	drvr->bus_if->drvr = drvr;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 399567f..129cfd6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3953,7 +3953,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* Attach to the brcmf/OS/network interface */
-	ret = brcmf_attach(bus, SDPCM_RESERVE, bus->sdiodev->dev);
+	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
 	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_attach failed\n");
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index d36a2a8..a63490e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -122,6 +122,8 @@ struct brcmf_sdreg {
 	int value;
 };
 
+struct brcmf_sdio;
+
 struct brcmf_sdio_dev {
 	struct sdio_func *func[SDIO_MAX_FUNCS];
 	u8 num_funcs;			/* Supported funcs on client */
@@ -262,4 +264,6 @@ extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
 extern void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev);
 extern void brcmf_sdbrcm_disconnect(void *ptr);
 extern void brcmf_sdbrcm_isr(void *arg);
+
+extern void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.5.4


