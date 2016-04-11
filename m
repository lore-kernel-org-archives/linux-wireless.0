Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8031 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbcDKJp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 05:45:27 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/8] brcmfmac: fix clearing wowl wake indicators
Date: Mon, 11 Apr 2016 11:35:22 +0200
Message-Id: <1460367328-12082-3-git-send-email-arend@broadcom.com> (sfid-20160411_114530_332507_5364661A)
In-Reply-To: <1460367328-12082-1-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

Newer firmwares require the usage of the wowl wakeind struct as size
for the iovar to clear the wake indicators. Older firmwares do not
care, so change the used size.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d5c2a27..7486925 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3608,7 +3608,8 @@ static void brcmf_configure_wowl(struct brcmf_cfg80211_info *cfg,
 	if (!test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
 		wowl_config |= BRCMF_WOWL_UNASSOC;
 
-	brcmf_fil_iovar_data_set(ifp, "wowl_wakeind", "clear", strlen("clear"));
+	brcmf_fil_iovar_data_set(ifp, "wowl_wakeind", "clear",
+				 sizeof(struct brcmf_wowl_wakeind_le));
 	brcmf_fil_iovar_int_set(ifp, "wowl", wowl_config);
 	brcmf_fil_iovar_int_set(ifp, "wowl_activate", 1);
 	brcmf_bus_wowl_config(cfg->pub->bus_if, true);
-- 
1.9.1

