Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:43597 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbdERKcP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 06:32:15 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com,
        Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH] brcmfmac: remove setting IBSS mode when stopping AP
Date: Thu, 18 May 2017 17:22:19 +0800
Message-Id: <1495099339-7626-1-git-send-email-wright.feng@cypress.com> (sfid-20170518_123218_649881_964028C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>

Setting IBSS mode when stopping AP may affect functionality of INFRA
mode on another interface. For instance, if user creates and stops
hostap daemon on virtual interface, then association cannot work on
primary interface because default BSS has been set to IBSS mode in
firmware side. The IBSS mode should be set when cfg80211 changes the
interface.

Reviewed-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 944b83c..ce2a5b6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4658,9 +4658,6 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
 		if (err < 0)
 			brcmf_err("setting AP mode failed %d\n", err);
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 0);
-		if (err < 0)
-			brcmf_err("setting INFRA mode failed %d\n", err);
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
 			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
-- 
2.1.0
