Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:44641 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751395AbdILJWe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 05:22:34 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: move configuration of probe request IEs
Date: Tue, 12 Sep 2017 11:22:23 +0200
Message-Id: <1505208143-30166-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170912_112310_128588_59F18D4F)
In-Reply-To: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 35e9cac..b6d1aaa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1119,6 +1119,11 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
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
index 8e0b3f4..cec25dd 100644
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
