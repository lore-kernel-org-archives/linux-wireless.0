Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:52753 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934126AbcKWK1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:27:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 05/12] brcmfmac: change prototype for brcmf_do_escan()
Date: Wed, 23 Nov 2016 10:25:24 +0000
Message-Id: <1479896731-5091-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_112731_708218_255E5C7E)
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce the number of parameters as the removed ones can be obtained
through struct brcmf_if parameter.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 096e214..70eca76 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1080,9 +1080,9 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 }
 
 static s32
-brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
-	       struct brcmf_if *ifp, struct cfg80211_scan_request *request)
+brcmf_do_escan(struct brcmf_if *ifp, struct cfg80211_scan_request *request)
 {
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	s32 err;
 	u32 passive_scan;
 	struct brcmf_scan_results *results;
@@ -1090,7 +1090,7 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 
 	brcmf_dbg(SCAN, "Enter\n");
 	escan->ifp = ifp;
-	escan->wiphy = wiphy;
+	escan->wiphy = cfg->wiphy;
 	escan->escan_state = WL_ESCAN_STATE_SCANNING;
 	passive_scan = cfg->active_scan ? 0 : 1;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
@@ -1170,7 +1170,7 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 		if (err)
 			goto scan_out;
 
-		err = brcmf_do_escan(cfg, wiphy, vif->ifp, request);
+		err = brcmf_do_escan(vif->ifp, request);
 		if (err)
 			goto scan_out;
 	} else {
@@ -3289,7 +3289,7 @@ static void brcmf_init_escan(struct brcmf_cfg80211_info *cfg)
 
 		set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 		cfg->escan_info.run = brcmf_run_escan;
-		err = brcmf_do_escan(cfg, wiphy, ifp, request);
+		err = brcmf_do_escan(ifp, request);
 		if (err) {
 			clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 			goto out_err;
-- 
1.9.1
