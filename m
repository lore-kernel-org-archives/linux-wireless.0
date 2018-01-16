Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0111.outbound.protection.outlook.com ([104.47.36.111]:41380
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750764AbeAPGM5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 01:12:57 -0500
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v3] brcmfmac: fix CLM load error for legacy chips when user helper is enabled
Date: Tue, 16 Jan 2018 14:14:06 +0800
Message-Id: <1516083246-16013-1-git-send-email-wright.feng@cypress.com> (sfid-20180116_071306_388867_B74EEAC2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For legacy chips without CLM blob files, kernel with user helper function
returns -EAGAIN when we request_firmware(), and then driver got failed
when bringing up legacy chips. We expect the CLM blob file for legacy chip
is not existence in firmware path, but the -ENOENT error is transferred to
-EAGAIN in firmware_class.c with user helper.
Because of that, we continue with CLM data currently present in firmware
if getting error from doing request_firmware().

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v2: remove retry from patch v1
v3: remove redundant log print
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 6a59d06..b0ef0e7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -182,12 +182,9 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 
 	err = request_firmware(&clm, clm_name, dev);
 	if (err) {
-		if (err == -ENOENT) {
-			brcmf_dbg(INFO, "continue with CLM data currently present in firmware\n");
-			return 0;
-		}
-		brcmf_err("request CLM blob file failed (%d)\n", err);
-		return err;
+		brcmf_info("no clm_blob available(%d), device may have limited channels available\n",
+			   err);
+		return 0;
 	}
 
 	chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN - 1, GFP_KERNEL);
-- 
1.9.1
