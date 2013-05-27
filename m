Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3293 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab3E0TKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 4/7] brcmfmac: free net device when
 registration fails
Date: Mon, 27 May 2013 21:09:56 +0200
Message-ID: <1369681799-3163-5-git-send-email-arend@broadcom.com> (sfid-20130527_211034_327879_E049EE4E)
In-Reply-To: <1369681799-3163-1-git-send-email-arend@broadcom.com>
References: <1369681799-3163-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When registration fails the net device is no longer needed. Free
the net device and remove reference to private data from the
driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |   10 +++++++---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c      |    3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 59c2546..f04e355 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -656,7 +656,9 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	return 0;
 
 fail:
+	drvr->iflist[ifp->bssidx] = NULL;
 	ndev->netdev_ops = NULL;
+	free_netdev(ndev);
 	return -EBADE;
 }
 
@@ -720,6 +722,9 @@ static int brcmf_net_p2p_attach(struct brcmf_if *ifp)
 	return 0;
 
 fail:
+	ifp->drvr->iflist[ifp->bssidx] = NULL;
+	ndev->netdev_ops = NULL;
+	free_netdev(ndev);
 	return -EBADE;
 }
 
@@ -925,8 +930,6 @@ fail:
 			brcmf_fws_del_interface(ifp);
 			brcmf_fws_deinit(drvr);
 		}
-		free_netdev(ifp->ndev);
-		drvr->iflist[0] = NULL;
 		if (p2p_ifp) {
 			free_netdev(p2p_ifp->ndev);
 			drvr->iflist[1] = NULL;
@@ -934,7 +937,8 @@ fail:
 		return ret;
 	}
 	if ((brcmf_p2p_enable) && (p2p_ifp))
-		brcmf_net_p2p_attach(p2p_ifp);
+		if (brcmf_net_p2p_attach(p2p_ifp) < 0)
+			brcmf_p2p_enable = 0;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 5a64280..83ee53a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -202,7 +202,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 			return;
 		brcmf_fws_add_interface(ifp);
 		if (!drvr->fweh.evt_handler[BRCMF_E_IF])
-			err = brcmf_net_attach(ifp, false);
+			if (brcmf_net_attach(ifp, false) < 0)
+				return;
 	}
 
 	if (ifevent->action == BRCMF_E_IF_CHANGE)
-- 
1.7.10.4


