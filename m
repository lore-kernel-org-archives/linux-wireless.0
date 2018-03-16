Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:45718 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752872AbeCPKLf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:11:35 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 01/12] brcmfmac: do not convert linux error to firmware error string
Date: Fri, 16 Mar 2018 11:11:14 +0100
Message-Id: <1521195085-439-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180316_111304_018919_338057AE)
In-Reply-To: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of a linux error brcmf_fil_cmd_data() blurts an error message
in which the error code is translated to an error string. However, it
maps it to a firmware error string which should not happen. Simply
print only the numeric error code and be done with it.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index f2cfdd3..f527edc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -124,8 +124,7 @@ static const char *brcmf_fil_get_errstr(u32 err)
 					     data, len, &fwerr);
 
 	if (err) {
-		brcmf_dbg(FIL, "Failed: %s (%d)\n",
-			  brcmf_fil_get_errstr((u32)(-err)), err);
+		brcmf_dbg(FIL, "Failed: error=%d\n", err);
 	} else if (fwerr < 0) {
 		brcmf_dbg(FIL, "Firmware error: %s (%d)\n",
 			  brcmf_fil_get_errstr((u32)(-fwerr)), fwerr);
-- 
1.9.1
