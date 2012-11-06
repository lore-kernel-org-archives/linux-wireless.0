Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4925 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab2KFAWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:50 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/24] brcmfmac: fix NULL pointer access in
 brcmf_create_iovar()
Date: Mon, 5 Nov 2012 16:22:21 -0800
Message-ID: <1352161352-30405-14-git-send-email-frankyl@broadcom.com> (sfid-20121106_012312_887310_9F21D7F6)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function brcmf_fil_bsscfg_data_get() calls brcmf_create_iovar()
with data pointer set to NULL, which caused a NULL pointer access.
As it should be possible to provide data in message towards the
firmware, it should just pass the data buffer instead.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 4b272c3..f121d41 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -294,7 +294,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 
 	mutex_lock(&drvr->proto_block);
 
-	buflen = brcmf_create_bsscfg(ifp->bssidx, name, NULL, len,
+	buflen = brcmf_create_bsscfg(ifp->bssidx, name, data, len,
 				     drvr->proto_buf, sizeof(drvr->proto_buf));
 	if (buflen) {
 		err = brcmf_fil_cmd_data(ifp, BRCMF_C_GET_VAR, drvr->proto_buf,
-- 
1.7.9.5


