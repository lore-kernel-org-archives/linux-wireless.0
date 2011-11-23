Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1639 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759513Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 23/24] brcm80211: fmac: remove function
 brcmf_bus_get_device
Date: Tue, 22 Nov 2011 17:21:58 -0800
Message-ID: <1322011319-24863-24-git-send-email-frankyl@broadcom.com> (sfid-20111123_022251_550952_09BA7D90)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_bus_get_device is no longer necessary. Use dongle device pointer
saved in brcmf_pub directly. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 ---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    8 ++------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 -----
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index cfcf5a9..1b57860 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -27,9 +27,6 @@
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
 
-/* obtain linux device object providing bus function */
-extern struct device *brcmf_bus_get_device(struct brcmf_sdio *bus);
-
 /* Stop bus module: clear pending frames, disable data flow */
 extern void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f8c0ae4..20d8221 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -608,8 +608,7 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
-	sprintf(info->bus_info, "%s",
-		dev_name(brcmf_bus_get_device(drvr_priv->pub.bus)));
+	sprintf(info->bus_info, "%s", dev_name(drvr_priv->pub.dev));
 }
 
 static struct ethtool_ops brcmf_ethtool_ops = {
@@ -1082,10 +1081,7 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 
 	/* attach to cfg80211 for primary interface */
 	if (!ifidx) {
-		drvr->config =
-			brcmf_cfg80211_attach(ndev,
-					      brcmf_bus_get_device(drvr->bus),
-					      drvr);
+		drvr->config = brcmf_cfg80211_attach(ndev, drvr->dev, drvr);
 		if (drvr->config == NULL) {
 			brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
 			goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 8c00014..5d81052 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3999,11 +3999,6 @@ void brcmf_sdbrcm_disconnect(void *ptr)
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-struct device *brcmf_bus_get_device(struct brcmf_sdio *bus)
-{
-	return &bus->sdiodev->func[2]->dev;
-}
-
 void
 brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 {
-- 
1.7.5.4


