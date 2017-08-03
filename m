Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:54356 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdHCJeV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:34:21 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com
Subject: [PATCH v2 1/3] brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/OPEN security mode
Date: Thu,  3 Aug 2017 17:37:57 +0800
Message-Id: <1501753079-1758-1-git-send-email-wright.feng@cypress.com> (sfid-20170803_113424_687298_76CA3DE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/OPEN security mode

When setting wpa_auth to WPA_AUTH_NONE(1) in AP mode with WEP security,
firmware will set privacy bit and add WPA OUI in VENDOR IE in beacon and
probe response. The security type in softAP beacons confuse the
supplicant in client side, and the user client will see [WPA-?] in
supplicant scan result. So we set WPA_AUTH_DISABLED in softAP mode with 
OPEN security.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v2: fix typo in commit message
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2f8776f..0281a22 100644
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
