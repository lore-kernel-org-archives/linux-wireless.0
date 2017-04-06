Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46769 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754781AbdDFMPA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:15:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: ignore interfaces when fwsignal is disabled
Date: Thu,  6 Apr 2017 13:14:38 +0100
Message-Id: <1491480882-13877-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170406_141506_974693_CC5F4860)
In-Reply-To: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When brcmf_fws_add_interface() is called the struct brcmf_if::fws_desc
field is initialized regardless the state of the fwsignal functionality,
ie. the fcmode. This is not needed when fcmode is NONE, which is the
default mode.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index c27a225..23b2b3f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2145,7 +2145,7 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 	struct brcmf_fws_info *fws = ifp->drvr->fws;
 	struct brcmf_fws_mac_descriptor *entry;
 
-	if (!ifp->ndev)
+	if (!ifp->ndev || fws->fcmode == BRCMF_FWS_FCMODE_NONE)
 		return;
 
 	entry = &fws->desc.iface[ifp->ifidx];
-- 
1.9.1
