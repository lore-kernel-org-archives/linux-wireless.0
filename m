Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:56626 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbcDKJpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 05:45:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/8] brcmfmac: fix p2p scan abort null pointer exception
Date: Mon, 11 Apr 2016 11:35:24 +0200
Message-Id: <1460367328-12082-5-git-send-email-arend@broadcom.com> (sfid-20160411_114533_672264_1FC5359B)
In-Reply-To: <1460367328-12082-1-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

When p2p connection setup is performed without having ever done an
escan a null pointer exception can occur. This is because the ifp
to abort scanning is taken from escan struct while it was never
initialized. Fix this by using the primary ifp for scan abort. The
abort should still be performed and all scan related commands are
performed on primary ifp.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index b5a49e5..9408717 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1266,7 +1266,7 @@ static void
 brcmf_p2p_stop_wait_next_action_frame(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
-	struct brcmf_if *ifp = cfg->escan_info.ifp;
+	struct brcmf_if *ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
 
 	if (test_bit(BRCMF_P2P_STATUS_SENDING_ACT_FRAME, &p2p->status) &&
 	    (test_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status) ||
-- 
1.9.1

