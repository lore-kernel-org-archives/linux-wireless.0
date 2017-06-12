Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:49467 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751796AbdFLL4i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 07:56:38 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.12] brcmfmac: fix brcmf_fws_add_interface() for USB devices
Date: Mon, 12 Jun 2017 12:56:35 +0100
Message-Id: <1497268595-4836-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170612_135642_102468_390D1555)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB devices rely on queuing functionality provided by the fwsignal
module regardless the mode fwsignal is operating in. For this some
data structure needs to be reserved which is tied to the interface,
which is done by brcmf_fws_add_interface(). However, it checks the
mode. Replace that by checking result from brcmf_fws_queue_skbs().

Fixes: fc0471e3e884 ("brcmfmac: ignore interfaces when fwsignal is disabled")
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

This patch fixes a regression that was introduced upstream in
4.12-rc1. It applies to the master branch of the wireless-drivers
repository.

Regards,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 72373e5..f59642b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2145,7 +2145,7 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 	struct brcmf_fws_mac_descriptor *entry;
 
-	if (!ifp->ndev || fws->fcmode == BRCMF_FWS_FCMODE_NONE)
+	if (!ifp->ndev || !brcmf_fws_queue_skbs(fws))
 		return;
 
 	entry = &fws->desc.iface[ifp->ifidx];
-- 
1.9.1
