Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59686 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbFOUsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 16:48:45 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/2] brcmfmac: fix double free of p2pdev interface
Date: Mon, 15 Jun 2015 22:48:38 +0200
Message-ID: <1434401319-16136-2-git-send-email-arend@broadcom.com> (sfid-20150615_224853_194604_A4B679A7)
In-Reply-To: <1434401319-16136-1-git-send-email-arend@broadcom.com>
References: <1434401319-16136-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When freeing the driver ifp pointer it should also be removed from
the driver interface list, which is what brcmf_remove_interface()
does. Otherwise, the ifp pointer will be freed twice triggering
a kernel oops.

Fixes: f37d69a4babc ("brcmfmac: free ifp for non-netdev interface in p2p module")
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 2e1598f..a9ba775 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2140,7 +2140,7 @@ static void brcmf_p2p_delete_p2pdev(struct brcmf_p2p_info *p2p,
 {
 	cfg80211_unregister_wdev(&vif->wdev);
 	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
-	kfree(vif->ifp);
+	brcmf_remove_interface(vif->ifp->drvr, vif->ifp->bssidx);
 	brcmf_free_vif(vif);
 }
 
-- 
1.9.1

