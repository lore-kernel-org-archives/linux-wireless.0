Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7542 "EHLO
        mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934245AbcISLKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:24 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/9] brcmfmac: rework pointer trickery in brcmf_proto_bcdc_query_dcmd()
Date: Mon, 19 Sep 2016 12:09:52 +0100
Message-Id: <1474283399-14385-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131034_269630_F78E2BF1)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable info is assigned to point to bcdc->msg[1], which is the
same as pointing to bcdc->buf. As that is what we want to access
make it clear by fixing the assignment. This also avoid out-of-bounds
errors from static analyzers are bcdc->msg[1] is not in the structure
definition.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index d1bc51f..038a960 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -194,7 +194,7 @@ retry:
 	}
 
 	/* Check info buffer */
-	info = (void *)&msg[1];
+	info = (void *)&bcdc->buf[0];
 
 	/* Copy info buffer */
 	if (buf) {
-- 
1.9.1
