Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:55050 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754869AbeDCISY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 04:18:24 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] brcmfmac: fix firmware request processing if nvram load fails
Date: Tue,  3 Apr 2018 10:18:15 +0200
Message-Id: <1522743495-13004-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180403_101829_119882_18F545D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When nvram loading fails a double free occurred. Fix this and reorg the
code a little.

Fixes: commit d09ae51a4b67 ("brcmfmac: pass struct in brcmf_fw_get_firmwares()")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

This fix is for code currently(?) in linux-next in error path caused
a double free.

Regards,
Arend
---
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 36 ++++++++++++----------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 9277f4c..94e177d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -459,7 +459,7 @@ static void brcmf_fw_free_request(struct brcmf_fw_request *req)
 	kfree(req);
 }
 
-static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
+static int brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
 	struct brcmf_fw_item *cur;
@@ -498,13 +498,10 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	brcmf_dbg(TRACE, "nvram %p len %d\n", nvram, nvram_length);
 	cur->nv_data.data = nvram;
 	cur->nv_data.len = nvram_length;
-	return;
+	return 0;
 
 fail:
-	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
-	fwctx->done(fwctx->dev, -ENOENT, NULL);
-	brcmf_fw_free_request(fwctx->req);
-	kfree(fwctx);
+	return -ENOENT;
 }
 
 static int brcmf_fw_request_next_item(struct brcmf_fw *fwctx, bool async)
@@ -553,20 +550,27 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 	brcmf_dbg(TRACE, "enter: firmware %s %sfound\n", cur->path,
 		  fw ? "" : "not ");
 
-	if (fw) {
-		if (cur->type == BRCMF_FW_TYPE_BINARY)
-			cur->binary = fw;
-		else if (cur->type == BRCMF_FW_TYPE_NVRAM)
-			brcmf_fw_request_nvram_done(fw, fwctx);
-		else
-			release_firmware(fw);
-	} else if (cur->type == BRCMF_FW_TYPE_NVRAM) {
-		brcmf_fw_request_nvram_done(NULL, fwctx);
-	} else if (!(cur->flags & BRCMF_FW_REQF_OPTIONAL)) {
+	if (!fw)
 		ret = -ENOENT;
+
+	switch (cur->type) {
+	case BRCMF_FW_TYPE_NVRAM:
+		ret = brcmf_fw_request_nvram_done(fw, fwctx);
+		break;
+	case BRCMF_FW_TYPE_BINARY:
+		cur->binary = fw;
+		break;
+	default:
+		/* something fishy here so bail out early */
+		brcmf_err("unknown fw type: %d\n", cur->type);
+		release_firmware(fw);
+		ret = -EINVAL;
 		goto fail;
 	}
 
+	if (ret < 0 && !(cur->flags & BRCMF_FW_REQF_OPTIONAL))
+		goto fail;
+
 	do {
 		if (++fwctx->curpos == fwctx->req->n_items) {
 			ret = 0;
-- 
1.9.1
