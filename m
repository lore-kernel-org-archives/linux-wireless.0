Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:44627 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751388AbdILJWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 05:22:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/7] brcmfmac: get rid of brcmf_cfg80211_escan() function
Date: Tue, 12 Sep 2017 11:22:21 +0200
Message-Id: <1505208143-30166-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170912_112243_548359_1D20BF6F)
In-Reply-To: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 8e7717a..34c2945 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1082,13 +1082,16 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
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
@@ -1113,6 +1116,8 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
 		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 
+	brcmf_dbg(SCAN, "START ESCAN\n");
+
 	cfg->scan_request = request;
 	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 
@@ -1132,31 +1137,12 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
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
