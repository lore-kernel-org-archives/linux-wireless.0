Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1153 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab2KOCqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:32 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/19] brcmfmac: change parameter in brcmf_add_if()
 function
Date: Wed, 14 Nov 2012 18:46:08 -0800
Message-ID: <1352947583-25341-5-git-send-email-frankyl@broadcom.com> (sfid-20121115_034647_861040_53EAD0EC)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The brcmf_add_if() function had a struct device as parameter
to accomodate the bus specific code to use this function. The
driver has been reworked so the bus specific code does not need
this function. Better replace the parameter with a more specific
driver object, ie. struct brcmf_pub.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 ++--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 ++----
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 10d92b5..a41e1c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -586,8 +586,8 @@ extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
 			      void **data_ptr);
 
 extern int brcmf_net_attach(struct brcmf_if *ifp);
-extern struct brcmf_if *brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
-				     char *name, u8 *mac_addr);
+extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx,
+				     s32 bssidx, char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 60907de..f102034 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -694,13 +694,11 @@ fail:
 	return -EBADE;
 }
 
-struct brcmf_if *brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
+struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 			      char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
@@ -835,7 +833,7 @@ int brcmf_bus_start(struct device *dev)
 	}
 
 	/* add primary networking interface */
-	ifp = brcmf_add_if(dev, 0, 0, "wlan%d", NULL);
+	ifp = brcmf_add_if(drvr, 0, 0, "wlan%d", NULL);
 	if (IS_ERR(ifp))
 		return PTR_ERR(ifp);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index c091c12..825be26 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -264,7 +264,7 @@ static int brcmf_fweh_process_if_event(struct brcmf_pub *drvr,
 	case BRCMF_E_IF_ADD:
 		brcmf_dbg(EVENT, "adding %s (%pM, %pM)\n", event->ifname,
 			  event->addr, item->ifaddr);
-		ifp = brcmf_add_if(drvr->dev, ifevent->ifidx, ifevent->bssidx,
+		ifp = brcmf_add_if(drvr, ifevent->ifidx, ifevent->bssidx,
 				   event->ifname, item->ifaddr);
 		if (!IS_ERR(ifp)) {
 			*ifpp = ifp;
-- 
1.7.9.5


