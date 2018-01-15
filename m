Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34910 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965968AbeAORK6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 12:10:58 -0500
Received: by mail-pg0-f67.google.com with SMTP id d6so8256741pgv.2
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 09:10:58 -0800 (PST)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] brcmfmac: Make sure CLM downloading is optional
Date: Mon, 15 Jan 2018 09:10:53 -0800
Message-Id: <20180115171053.8802-1-bjorn.andersson@linaro.org> (sfid-20180115_181129_513581_00634B87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The presence of a CLM file is described as optional, but missing the clm
blob causes the preinit to return unsuccessfully. Fix this by ignoring
the return value of the brcmf_c_process_clm_blob().

Also remove the extra debug print, as brcmf_c_process_clm_blob() already
did print a useful error message before returning.

Fixes: fdd0bd88ceae ("brcmfmac: add CLM download support")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

This regression was introduced in v4.15-rc1, but I unfortunately didn't test
WiFi until now. Included a Cc to stable@ in case you choose to pick this up
after v4.15.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 6a59d0609d30..0c67ba6ae135 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -278,12 +278,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	}
 	ri->result = err;
 
-	/* Do any CLM downloading */
-	err = brcmf_c_process_clm_blob(ifp);
-	if (err < 0) {
-		brcmf_err("download CLM blob file failed, %d\n", err);
-		goto done;
-	}
+	/* Do any optional CLM downloading */
+	brcmf_c_process_clm_blob(ifp);
 
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
-- 
2.15.0
