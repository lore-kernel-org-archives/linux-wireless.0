Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:5691 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbKYKcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:51 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/11] brcmfmac: Change error print on wlan0 existence.
Date: Wed, 25 Nov 2015 11:32:39 +0100
Message-ID: <1448447567-12189-4-git-send-email-arend@broadcom.com> (sfid-20151125_113256_163025_60163AF2)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

During initialization of the device, but also on some other
moments the driver prints an error that the netdev already exists.
This is a result of the way the driver is initializing the
firmware and not really an error. The code is not treating it as
an error either. This error print has resulted in many questions
by users and is confusing and incorrect. This patch changes the
error log into a debug info log.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8d16f50..9038932 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -811,14 +811,15 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 	 * in case we missed the BRCMF_E_IF_DEL event.
 	 */
 	if (ifp) {
-		brcmf_err("ERROR: netdev:%s already exists\n",
-			  ifp->ndev->name);
 		if (ifidx) {
+			brcmf_err("ERROR: netdev:%s already exists\n",
+				  ifp->ndev->name);
 			netif_stop_queue(ifp->ndev);
 			brcmf_net_detach(ifp->ndev);
 			drvr->iflist[bsscfgidx] = NULL;
 		} else {
-			brcmf_err("ignore IF event\n");
+			brcmf_dbg(INFO, "netdev:%s ignore IF event\n",
+				  ifp->ndev->name);
 			return ERR_PTR(-EINVAL);
 		}
 	}
-- 
1.9.1

