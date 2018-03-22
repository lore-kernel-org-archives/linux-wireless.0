Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52654 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751907AbeCVU2i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 16:28:38 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 01/12] brcmfmac: do not convert linux error to firmware error string
Date: Thu, 22 Mar 2018 21:28:20 +0100
Message-Id: <1521750511-12345-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180322_212903_393850_69B30BBF)
In-Reply-To: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
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
