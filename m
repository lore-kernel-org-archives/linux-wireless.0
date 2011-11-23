Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1655 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 19/24] brcm80211: fmac: change function bus_rxctl
 parameter
Date: Tue, 22 Nov 2011 17:21:54 -0800
Message-ID: <1322011319-24863-20-git-send-email-frankyl@broadcom.com> (sfid-20111123_022249_974277_AB69297C)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdbrcm_bus_rxctl acts as an interface function of bus layer.
Change parameter from struct brcmf_sdio to device pointer in order to
provide a more compatible interface for different bus layers. This
is part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 ++++-
 5 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a104b74..b68d136 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -591,6 +591,7 @@ struct brcmf_pub {
 	struct brcmf_proto *prot;
 	struct brcmf_info *info;
 	struct brcmf_cfg80211_dev *config;
+	struct device *dev;		/* fullmac dongle device pointer */
 
 	/* Internal brcmf items */
 	bool up;		/* Driver up/down (to OS) */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 81fc1db..44f46d1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -46,7 +46,7 @@ extern int
 brcmf_sdbrcm_bus_txctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen);
 
 extern int
-brcmf_sdbrcm_bus_rxctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen);
+brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen);
 
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 8e46bc6..5ab8671 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -128,7 +128,7 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	do {
-		ret = brcmf_sdbrcm_bus_rxctl(drvr->bus,
+		ret = brcmf_sdbrcm_bus_rxctl(drvr->dev,
 				(unsigned char *)&prot->msg,
 				len + sizeof(struct brcmf_proto_cdc_dcmd));
 		if (ret < 0)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c13b30f..c20c72d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -963,6 +963,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen,
 	drvr_priv->pub.bus = bus;
 	drvr_priv->pub.hdrlen = bus_hdrlen;
 	drvr_priv->pub.bus_if = dev_get_drvdata(dev);
+	drvr_priv->pub.dev = dev;
 
 	/* Attach and link in the protocol */
 	if (brcmf_proto_attach(&drvr_priv->pub) != 0) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 885d16a..e13c9e9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2912,11 +2912,14 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen)
 }
 
 int
-brcmf_sdbrcm_bus_rxctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen)
+brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	int timeleft;
 	uint rxlen = 0;
 	bool pending;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-- 
1.7.5.4


