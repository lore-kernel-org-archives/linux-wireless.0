Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0115.outbound.protection.outlook.com ([104.47.40.115]:15632
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750853AbdLLJkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 04:40:06 -0500
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Wright Feng <wright.feng@cypress.com>
Subject: [PATCH] brcmfmac: fix CLM load error for legacy chips when user helper is enabled
Date: Tue, 12 Dec 2017 17:39:56 +0800
Message-Id: <1513071596-17506-1-git-send-email-wright.feng@cypress.com> (sfid-20171212_104013_102442_5E722F30)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For legacy chips w/o CLM blob files, kernel with user helper function
enables returns -EAGAIN when we request_firmware() for blob file:
"request_firmware() -> _request_firmware() -> fw_load_from_user_helper()
-> _request_firmware_load() -> retval=-EAGAIN"
We should do one more retry and continue brcmf_c_process_clm_blob if
getting -EAGAIN from request_firmware function.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 6a59d06..56e2654 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -45,6 +45,8 @@
 
 #define BRCMF_DEFAULT_TXGLOM_SIZE	32  /* max tx frames in glom chain */
 
+#define CLM_LOAD_RETRIES 1 /* # of retries to load clm_blob file */
+
 static int brcmf_sdiod_txglomsz = BRCMF_DEFAULT_TXGLOM_SIZE;
 module_param_named(txglomsz, brcmf_sdiod_txglomsz, int, 0);
 MODULE_PARM_DESC(txglomsz, "Maximum tx packet chain size [SDIO]");
@@ -170,6 +172,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 	u16 dl_flag = DL_BEGIN;
 	u32 status;
 	s32 err;
+	uint retries = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -180,11 +183,18 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 		return err;
 	}
 
-	err = request_firmware(&clm, clm_name, dev);
+	do {
+		err = request_firmware(&clm, clm_name, dev);
+	} while (err == -EAGAIN && retries++ < CLM_LOAD_RETRIES);
 	if (err) {
 		if (err == -ENOENT) {
 			brcmf_dbg(INFO, "continue with CLM data currently present in firmware\n");
 			return 0;
+		} else if (err == -EAGAIN) {
+			brcmf_dbg(INFO, "reached maximum retries(%d)\n",
+				  CLM_LOAD_RETRIES);
+			brcmf_dbg(INFO, "continue with CLM data in firmware\n");
+			return 0;
 		}
 		brcmf_err("request CLM blob file failed (%d)\n", err);
 		return err;
-- 
1.9.1
