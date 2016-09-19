Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58953 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757583AbcISLKL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:11 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 8/9] brcmfmac: fix out of bound access on clearing wowl wake indicator
Date: Mon, 19 Sep 2016 12:09:58 +0100
Message-Id: <1474283399-14385-9-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131032_828151_72FE4C2D)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

Clearing the wowl wakeindicator happens with a rather odd
construction where the string "clear" is used to set the iovar
wowl_wakeind. This was implemented incorrectly as it caused an
out of bound access. Use an intermediate variable of correct
length and copy string in that. Problem was found using coverity.

Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c3b8f59..386ad7e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3703,6 +3703,7 @@ static void brcmf_configure_wowl(struct brcmf_cfg80211_info *cfg,
 				 struct cfg80211_wowlan *wowl)
 {
 	u32 wowl_config;
+	struct brcmf_wowl_wakeind_le wowl_wakeind;
 	u32 i;
 
 	brcmf_dbg(TRACE, "Suspend, wowl config.\n");
@@ -3744,8 +3745,9 @@ static void brcmf_configure_wowl(struct brcmf_cfg80211_info *cfg,
 	if (!test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
 		wowl_config |= BRCMF_WOWL_UNASSOC;
 
-	brcmf_fil_iovar_data_set(ifp, "wowl_wakeind", "clear",
-				 sizeof(struct brcmf_wowl_wakeind_le));
+	memcpy(&wowl_wakeind, "clear", 6);
+	brcmf_fil_iovar_data_set(ifp, "wowl_wakeind", &wowl_wakeind,
+				 sizeof(wowl_wakeind));
 	brcmf_fil_iovar_int_set(ifp, "wowl", wowl_config);
 	brcmf_fil_iovar_int_set(ifp, "wowl_activate", 1);
 	brcmf_bus_wowl_config(cfg->pub->bus_if, true);
-- 
1.9.1
