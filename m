Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7542 "EHLO
        mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757532AbcISLKX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:23 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/9] brcmfmac: remove unnecessary null pointer check
Date: Mon, 19 Sep 2016 12:09:56 +0100
Message-Id: <1474283399-14385-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131033_421568_71D01608)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

in the function brcmf_bus_start() in the exception handling a
check is made to dermine whether ifp is null, though this is not
possible. Removing the unnessary check.

Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 77c4180..3394184 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1048,8 +1048,7 @@ fail:
 		brcmf_fws_del_interface(ifp);
 		brcmf_fws_deinit(drvr);
 	}
-	if (ifp)
-		brcmf_net_detach(ifp->ndev, false);
+	brcmf_net_detach(ifp->ndev, false);
 	if (p2p_ifp)
 		brcmf_net_detach(p2p_ifp->ndev, false);
 	drvr->iflist[0] = NULL;
-- 
1.9.1
