Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2380 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbbFOUs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 16:48:56 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/2] brcmfmac: make brcmf_p2p_detach() call conditional
Date: Mon, 15 Jun 2015 22:48:39 +0200
Message-ID: <1434401319-16136-3-git-send-email-arend@broadcom.com> (sfid-20150615_224906_910010_91FA5655)
In-Reply-To: <1434401319-16136-1-git-send-email-arend@broadcom.com>
References: <1434401319-16136-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During verification of error handling in brcmf_cfg80211_attach() a
null pointer dereference occurred upon calling brcmf_p2p_detach()
from brcmf_detach(). This should only be called when the
brcmf_cfg80211_attach() has succeeded.

Fixes: f7a40873d2fa ("brcmfmac: assure p2pdev is unregistered upon driver unload")
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 866b818..fe9d3fb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -1098,7 +1098,8 @@ void brcmf_detach(struct device *dev)
 
 	/* stop firmware event handling */
 	brcmf_fweh_detach(drvr);
-	brcmf_p2p_detach(&drvr->config->p2p);
+	if (drvr->config)
+		brcmf_p2p_detach(&drvr->config->p2p);
 
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_DOWN);
 
-- 
1.9.1

