Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58008 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750977AbeAVUqr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 15:46:47 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/2] brcmfmac: assure bcdc dcmd api does not return value > 0
Date: Mon, 22 Jan 2018 21:46:39 +0100
Message-Id: <1516654000-25314-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180122_214653_991842_666BDFC4)
In-Reply-To: <1516654000-25314-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1516654000-25314-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The protocol layer api defines callbacks for dongle commands.
Although not really well documented these should only return an
error code in case of an error, or 0 upon success. In the bcdc
protocol it can return value above 0 and we carry a fix in the
caller of the protocol layer api. This patch makes it adhere to
the intent of the api as described above.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 6 +++++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c | 8 +++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 9f2d0b0..bd6da05 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -211,6 +211,8 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 		memcpy(buf, info, len);
 	}
 
+	ret = 0;
+
 	/* Check the ERROR flag */
 	if (flags & BCDC_DCMD_ERROR)
 		ret = le32_to_cpu(msg->status);
@@ -225,7 +227,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
-	int ret = 0;
+	int ret;
 	u32 flags, id;
 
 	brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
@@ -249,6 +251,8 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 		goto done;
 	}
 
+	ret = 0;
+
 	/* Check the ERROR flag */
 	if (flags & BCDC_DCMD_ERROR)
 		ret = le32_to_cpu(msg->status);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index f6a2df9..d328aae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -121,11 +121,9 @@ static const char *brcmf_fil_get_errstr(u32 err)
 	else
 		err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd, data, len);
 
-	if (err >= 0)
-		return 0;
-
-	brcmf_dbg(FIL, "Failed: %s (%d)\n",
-		  brcmf_fil_get_errstr((u32)(-err)), err);
+	if (err)
+		brcmf_dbg(FIL, "Failed: %s (%d)\n",
+			  brcmf_fil_get_errstr((u32)(-err)), err);
 
 	return err;
 }
-- 
1.9.1
