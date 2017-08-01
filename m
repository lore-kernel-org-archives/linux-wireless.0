Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:32911 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdHAJjd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:39:33 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com
Subject: [PATCH 1/3] brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/opensecurity mode
Date: Tue,  1 Aug 2017 16:48:05 +0800
Message-Id: <1501577287-28904-1-git-send-email-wright.feng@cypress.com> (sfid-20170801_113937_162950_72226E2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting wpa_auth to WPA_AUTH_NONE(1) in AP mode with WEP secuirty,
firmware will set privacy bit and add WPA OUI in VENDOR IE in beacon and
probe response. It confuses the supplicant in sation client by the
security type from softAP beacon and we will see [WPA-?] in scan result.
So we set WPA_AUTH_DISABLED in softAP mode with opensecurity.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index a31ea10..54588d2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3854,6 +3854,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 {
 	s32 err;
+	s32 wpa_val;
 
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", 0);
@@ -3868,7 +3869,11 @@ static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 		return err;
 	}
 	/* set upper-layer auth */
-	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", WPA_AUTH_NONE);
+	if (brcmf_is_ibssmode(ifp->vif))
+		wpa_val = WPA_AUTH_NONE;
+	else
+		wpa_val = WPA_AUTH_DISABLED;
+	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_val);
 	if (err < 0) {
 		brcmf_err("wpa_auth error %d\n", err);
 		return err;
-- 
1.9.1
