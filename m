Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35536 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934310AbeFVSnd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 14:43:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: increase buffer for obtaining firmware capabilities
Date: Fri, 22 Jun 2018 20:43:22 +0200
Message-Id: <1529693004-20569-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180622_204350_340160_6AF10AE4)
In-Reply-To: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When obtaining the firmware capability a buffer is provided of 512
bytes. However, if all features in firmware are supported the buffer
needs to be 565 bytes as otherwise truncated information is retrieved
from firmware. Increasing the buffer to 768 bytes on stack.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index a78b9ba..0ee3a25 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -141,7 +141,7 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 	ifp->fwil_fwerr = false;
 }
 
-#define MAX_CAPS_BUFFER_SIZE	512
+#define MAX_CAPS_BUFFER_SIZE	768
 static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 {
 	char caps[MAX_CAPS_BUFFER_SIZE];
-- 
1.9.1
