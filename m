Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3249 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193Ab2KOCqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:32 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/19] brcmfmac: ignore IF event if it is a add for
 ifidx 0
Date: Wed, 14 Nov 2012 18:46:15 -0800
Message-ID: <1352947583-25341-12-git-send-email-frankyl@broadcom.com> (sfid-20121115_041528_626178_BA780FAA)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Firmware fires IF event to add the primary interface but that
is already created in the driver.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   15 ++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    7 +++++--
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 51cbc72..a39ea20 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -696,12 +696,17 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	 * in case we missed the BRCMF_E_IF_DEL event.
 	 */
 	if (ifp) {
-		brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
+		brcmf_dbg(ERROR, "ERROR: netdev:%s already exists\n",
 			  ifp->ndev->name);
-		netif_stop_queue(ifp->ndev);
-		unregister_netdev(ifp->ndev);
-		free_netdev(ifp->ndev);
-		drvr->iflist[ifidx] = NULL;
+		if (ifidx) {
+			netif_stop_queue(ifp->ndev);
+			unregister_netdev(ifp->ndev);
+			free_netdev(ifp->ndev);
+			drvr->iflist[ifidx] = NULL;
+		} else {
+			brcmf_dbg(ERROR, "ignore IF event\n");
+			return ERR_PTR(-EINVAL);
+		}
 	}
 
 	/* Allocate netdev, including space for private structure */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 283acee..7b57b89 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -402,7 +402,8 @@ int brcmf_fweh_register(struct brcmf_pub *drvr, enum brcmf_fweh_event_code code,
 		return -ENOSPC;
 	}
 	drvr->fweh.evt_handler[code] = handler;
-	brcmf_dbg(TRACE, "event handler registered for code %d\n", code);
+	brcmf_dbg(TRACE, "event handler registered for %s\n",
+		  brcmf_fweh_event_name(code));
 	return 0;
 }
 
@@ -415,7 +416,8 @@ int brcmf_fweh_register(struct brcmf_pub *drvr, enum brcmf_fweh_event_code code,
 void brcmf_fweh_unregister(struct brcmf_pub *drvr,
 			   enum brcmf_fweh_event_code code)
 {
-	brcmf_dbg(TRACE, "event handler cleared for code %d\n", code);
+	brcmf_dbg(TRACE, "event handler cleared for %s\n",
+		  brcmf_fweh_event_name(code));
 	drvr->fweh.evt_handler[code] = NULL;
 }
 
@@ -438,6 +440,7 @@ int brcmf_fweh_activate_events(struct brcmf_if *ifp)
 	}
 
 	/* want to handle IF event as well */
+	brcmf_dbg(EVENT, "enable event IF\n");
 	setbit(eventmask, BRCMF_E_IF);
 
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs",
-- 
1.7.9.5


