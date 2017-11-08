Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:36684 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752593AbdKHNgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 08:36:45 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 7/7] brcmfmac: move configuration of probe request IEs
Date: Wed,  8 Nov 2017 14:36:37 +0100
Message-Id: <1510148197-17851-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171108_143657_160023_B8678542)
In-Reply-To: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend Van Spriel <arend.vanspriel@broadcom.com>

The configuration of the IEs for probe requests was done in a P2P
related function, which is not very obvious. Moving it to
.scan callback function, ie. brcmf_cfg80211_scan().

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      | 6 ++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 9b334e2..6e70df9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1108,6 +1108,11 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	if (err)
 		goto scan_out;
 
+	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBREQ_FLAG,
+				    request->ie, request->ie_len);
+	if (err)
+		goto scan_out;
+
 	err = brcmf_do_escan(vif->ifp, request);
 	if (err)
 		goto scan_out;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index c6cccb8..2ee5413 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -881,7 +881,7 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
-	int err = 0;
+	int err;
 
 	if (brcmf_p2p_scan_is_p2p_request(request)) {
 		/* find my listen channel */
@@ -904,9 +904,7 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 		/* override .run_escan() callback. */
 		cfg->escan_info.run = brcmf_p2p_run_escan;
 	}
-	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBREQ_FLAG,
-				    request->ie, request->ie_len);
-	return err;
+	return 0;
 }
 
 
-- 
1.9.1
