Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47987 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932269AbeBSXOd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:33 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/8] brcmfmac: move brcmf_bus_preinit() call just after changing bus state
Date: Tue, 20 Feb 2018 00:14:18 +0100
Message-Id: <1519082065-10128-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001447_436567_DCAF4F28)
In-Reply-To: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving the brcmf_bus_preinit() call allows the bus code to do some
required initialization before handling firmware control messages.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 3 ---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 9be0b05..70ef983 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -365,9 +365,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 
 	/* Enable tx beamforming, errors can be ignored (not supported) */
 	(void)brcmf_fil_iovar_int_set(ifp, "txbf", 1);
-
-	/* do bus specific preinit here */
-	err = brcmf_bus_preinit(ifp->drvr->bus_if);
 done:
 	return err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 930e423..6dd6da7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1013,6 +1013,11 @@ int brcmf_bus_started(struct device *dev)
 	/* signal bus ready */
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_UP);
 
+	/* do bus specific preinit here */
+	ret = brcmf_bus_preinit(ifp->drvr->bus_if);
+	if (ret < 0)
+		goto fail;
+
 	/* Bus is ready, do any initialization */
 	ret = brcmf_c_preinit_dcmds(ifp);
 	if (ret < 0)
-- 
1.9.1
