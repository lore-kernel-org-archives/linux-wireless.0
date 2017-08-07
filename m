Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:40755 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbdHGINQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 04:13:16 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
Subject: [PATCH] brcmfmac: add setting carrier state ON for successful roaming
Date: Mon,  7 Aug 2017 16:16:52 +0800
Message-Id: <1502093812-5011-1-git-send-email-wright.feng@cypress.com> (sfid-20170807_101319_978133_0FFD519A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

After association, ping is not working when sweeping the channel at the
AP side. It is caused by having incorrect carrier state (OFF) for the STA
in successful roaming. This patch sets the carrier state ON for the case.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 617199c..71f18b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5552,10 +5552,13 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 	u32 status = e->status;
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
-		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
+		if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
+			     &ifp->vif->sme_state)) {
 			brcmf_bss_roaming_done(cfg, ifp->ndev, e);
-		else
+		} else {
 			brcmf_bss_connect_done(cfg, ifp->ndev, e, true);
+			brcmf_net_setcarrier(ifp, true);
+		}
 	}
 
 	return 0;
-- 
1.9.1
