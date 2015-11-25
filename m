Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20307 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbKYKcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:53 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/11] brcmfmac: Fix double free on exception at module load.
Date: Wed, 25 Nov 2015 11:32:47 +0100
Message-ID: <1448447567-12189-12-git-send-email-arend@broadcom.com> (sfid-20151125_113303_311316_0D614143)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9038932..3a39192 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1083,6 +1083,8 @@ fail:
 			brcmf_net_detach(ifp->ndev);
 		if (p2p_ifp)
 			brcmf_net_detach(p2p_ifp->ndev);
+		drvr->iflist[0] = NULL;
+		drvr->iflist[1] = NULL;
 		return ret;
 	}
 	return 0;
-- 
1.9.1

