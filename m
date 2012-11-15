Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3408 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/19] brcmfmac: change mac address parameter in
 brcmf_add_if()
Date: Wed, 14 Nov 2012 18:46:11 -0800
Message-ID: <1352947583-25341-8-git-send-email-frankyl@broadcom.com> (sfid-20121115_034652_556402_BC02EA25)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function brcmf_add_if() is called with mac address set to NULL
for the primary interface. When handling IF ADD events the firmware
provides a address mask in the event to derive its mac address from
the primary mac address. Rename the parameter and use it as a mask.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 32b7355..9a590cb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -690,10 +690,11 @@ fail:
 }
 
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
-			      char *name, u8 *mac_addr)
+			      char *name, u8 *addr_mask)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
+	int i;
 
 	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
@@ -728,11 +729,12 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
 
-	if (mac_addr != NULL)
-		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
+	if (addr_mask != NULL)
+		for (i = 0; i < ETH_ALEN; i++)
+			ifp->mac_addr[i] = drvr->mac[i] ^ addr_mask[i];
 
-	brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
-		  current->pid, ifp->ndev->name);
+	brcmf_dbg(TRACE, " ==== pid:%x, if:%s (%pM) created ===\n",
+		  current->pid, ifp->ndev->name, ifp->mac_addr);
 
 	return ifp;
 }
-- 
1.7.9.5


