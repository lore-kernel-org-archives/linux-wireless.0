Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:36680 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752376AbdKHNgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 08:36:45 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 5/7] brcmfmac: get rid of brcmf_cfg80211_escan() function
Date: Wed,  8 Nov 2017 14:36:35 +0100
Message-Id: <1510148197-17851-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171108_143651_412668_5F951B80)
In-Reply-To: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend Van Spriel <arend.vanspriel@broadcom.com>

The function brcmf_cfg80211_escan() is only called by brcmf_cfg80211_scan()
so there is no reason to split in two function especially since the latter
does not do an awful lot.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 34 +++++++---------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index afdf6bb..31a80a6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1071,13 +1071,16 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 }
 
 static s32
-brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
-		     struct cfg80211_scan_request *request)
+brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	s32 err;
+	struct brcmf_cfg80211_vif *vif;
+	s32 err = 0;
 
-	brcmf_dbg(SCAN, "START ESCAN\n");
+	brcmf_dbg(TRACE, "Enter\n");
+	vif = container_of(request->wdev, struct brcmf_cfg80211_vif, wdev);
+	if (!check_vif_up(vif))
+		return -EIO;
 
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
@@ -1102,6 +1105,8 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
 		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 
+	brcmf_dbg(SCAN, "START ESCAN\n");
+
 	cfg->scan_request = request;
 	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 
@@ -1121,31 +1126,12 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	return 0;
 
 scan_out:
+	brcmf_err("scan error (%d)\n", err);
 	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	cfg->scan_request = NULL;
 	return err;
 }
 
-static s32
-brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
-{
-	struct brcmf_cfg80211_vif *vif;
-	s32 err = 0;
-
-	brcmf_dbg(TRACE, "Enter\n");
-	vif = container_of(request->wdev, struct brcmf_cfg80211_vif, wdev);
-	if (!check_vif_up(vif))
-		return -EIO;
-
-	err = brcmf_cfg80211_escan(wiphy, vif, request);
-
-	if (err)
-		brcmf_err("scan error (%d)\n", err);
-
-	brcmf_dbg(TRACE, "Exit\n");
-	return err;
-}
-
 static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 {
 	s32 err = 0;
-- 
1.9.1
