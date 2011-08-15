Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2722 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab1HONet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:49 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/15] staging: brcm80211: void * cleanup in fullmac
Date: Mon, 15 Aug 2011 15:34:17 +0200
Message-ID: <1313415267-5264-6-git-send-email-arend@broadcom.com> (sfid-20110815_153504_291782_C3E59D5E)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove improper usage of void * in dhd_linux.c and dhd_sdio.c

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    5 +++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   14 +++++++-------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |    6 +++---
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index ae8a9a6..ee09c17 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -760,8 +760,9 @@ extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
 
 extern void brcmf_c_init(void);
 
-extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle,
-		      char *name, u8 *mac_addr, u32 flags, u8 bssidx);
+extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx,
+			struct net_device *net, char *name, u8 *mac_addr,
+			u32 flags, u8 bssidx);
 extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
 
 /* Send packet to dongle via data channel */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index ca26cc1..b8f9922 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -978,7 +978,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
-		return brcmf_ethtool(drvr_priv, (void *)ifr->ifr_data);
+		return brcmf_ethtool(drvr_priv, ifr->ifr_data);
 
 	if (cmd != SIOCDEVPRIVATE)
 		return -EOPNOTSUPP;
@@ -1140,12 +1140,12 @@ static int brcmf_netdev_open(struct net_device *net)
 }
 
 int
-brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
-	   u8 *mac_addr, u32 flags, u8 bssidx)
+brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *net,
+	     char *name, u8 *mac_addr, u32 flags, u8 bssidx)
 {
 	struct brcmf_if *ifp;
 
-	BRCMF_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
+	BRCMF_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, net));
 
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
@@ -1163,12 +1163,12 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
-	if (handle == NULL) {
+	if (net == NULL) {
 		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
 		wake_up(&drvr_priv->sysioc_waitq);
 	} else
-		ifp->net = (struct net_device *)handle;
+		ifp->net = net;
 
 	return 0;
 }
@@ -1228,7 +1228,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 			strcat(net->name, "%d");
 	}
 
-	if (brcmf_add_if(drvr_priv, 0, (void *)net, net->name, NULL, 0, 0) ==
+	if (brcmf_add_if(drvr_priv, 0, net, net->name, NULL, 0, 0) ==
 	    BRCMF_BAD_IF)
 		goto fail;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index cc321d6..7632a0e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -910,7 +910,7 @@ static int brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn,
 			       uint flags, u8 *buf, uint nbytes,
 			       struct sk_buff *pkt);
 
-static bool brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus, void *card);
+static bool brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus);
 static int  _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus);
 
 static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus);
@@ -3100,7 +3100,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 	/* try to download image and nvram to the dongle */
 	if (drvr->busstate == BRCMF_BUS_DOWN) {
-		if (!(brcmf_sdbrcm_download_firmware(bus, bus->sdiodev)))
+		if (!(brcmf_sdbrcm_download_firmware(bus)))
 			return -1;
 	}
 
@@ -5122,7 +5122,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 }
 
 static bool
-brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus, void *card)
+brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 {
 	bool ret;
 
-- 
1.7.4.1


