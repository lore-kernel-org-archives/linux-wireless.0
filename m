Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35538 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934313AbeFVSnd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 14:43:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: remove fallback mechanism for BRCMF_FEAT_MONITOR
Date: Fri, 22 Jun 2018 20:43:19 +0200
Message-Id: <1529693004-20569-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180622_204347_918452_4565BFDD)
In-Reply-To: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 19f505aa3ae0 ("brcmfmac: detect firmware support for monitor
interface") introduced a fallback mechanism attempting BRCMF_C_MONITOR
command. However, that does not indicate firmware support. Unfortunately,
it only indicates the core part of the stack supports it, but not whether
it is supported in full-dongle mode, ie. firmware has means to transfer
the monitor packets to the host. Firmwares that return the "monitor"
flag in the "cap" iovar are able to send the packets to the host.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 25 ----------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 48d7978..a78b9ba 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -92,26 +92,6 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
 }
 #endif /* DEBUG */
 
-static void brcmf_feat_cmd_int_get(struct brcmf_if *ifp, enum brcmf_feat_id id,
-				   u32 cmd)
-{
-	u32 data;
-	int err;
-
-	ifp->fwil_fwerr = true;
-
-	err = brcmf_fil_cmd_int_get(ifp, cmd, &data);
-	if (err == 0) {
-		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
-		ifp->drvr->feat_flags |= BIT(id);
-	} else {
-		brcmf_dbg(TRACE, "%s feature check failed: %d\n",
-			  brcmf_feat_names[id], err);
-	}
-
-	ifp->fwil_fwerr = false;
-}
-
 /**
  * brcmf_feat_iovar_int_get() - determine feature through iovar query.
  *
@@ -272,11 +252,6 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	}
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 
-	/* Fallback detection for older firmwares */
-	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR))
-		brcmf_feat_cmd_int_get(ifp, BRCMF_FEAT_MONITOR,
-				       BRCMF_C_GET_MONITOR);
-
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43236_CHIP_ID:
-- 
1.9.1
