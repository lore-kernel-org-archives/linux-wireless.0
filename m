Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0115.outbound.protection.outlook.com ([104.47.41.115]:31295
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754449AbeALHn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 02:43:28 -0500
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2] brcmfmac: fix CLM load error for legacy chips when user helper is enabled
Date: Fri, 12 Jan 2018 15:44:16 +0800
Message-Id: <1515743056-8109-1-git-send-email-wright.feng@cypress.com> (sfid-20180112_084338_034377_CEC412BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For legacy chips without CLM blob files, kernel with user helper function
returns -EAGAIN when we request_firmware() for blob file. In this case,
brcmf_bus_started gets error and failed to bring up legacy chips.
Because of that, we should continue with CLM data currently present in
firmware if getting -EAGAIN when doing request_firmware().

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v2: remove retry from patch v1
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 6a59d06..0baab4c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -182,7 +182,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 
 	err = request_firmware(&clm, clm_name, dev);
 	if (err) {
-		if (err == -ENOENT) {
+		if (err == -ENOENT || err == -EAGAIN) {
 			brcmf_dbg(INFO, "continue with CLM data currently present in firmware\n");
 			return 0;
 		}
-- 
1.9.1
