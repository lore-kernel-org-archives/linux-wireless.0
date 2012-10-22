Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4250 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/12] brcmfmac: add virtual interface support in
 brcmf_cfg80211_suspend()
Date: Mon, 22 Oct 2012 13:55:39 -0700
Message-ID: <1350939341-17687-11-git-send-email-frankyl@broadcom.com> (sfid-20121022_225608_629358_8CB617BB)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

With multiple interfaces suspend will need to iterate over all and
bring down the link.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   53 +++++++++++---------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 94c619a..82c7c77 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3008,46 +3008,49 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = cfg_to_ndev(cfg);
-	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_vif *vif;
 
 	WL_TRACE("Enter\n");
 
 	/*
-	 * Check for BRCMF_VIF_STATUS_READY before any function call which
-	 * could result is bus access. Don't block the suspend for
-	 * any driver error conditions
-	 */
-
-	/*
-	 * While going to suspend if associated with AP disassociate
-	 * from AP to save power while system is in suspended state
+	 * if the primary net_device is not READY there is nothing
+	 * we can do but pray resume goes smoothly.
 	 */
-	if ((test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state) ||
-	     test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) &&
-	     check_vif_up(ifp->vif)) {
-		WL_INFO("Disassociating from AP"
-			" while entering suspend state\n");
-		brcmf_link_down(cfg);
+	vif = ((struct brcmf_if *)netdev_priv(ndev))->vif;
+	if (!check_vif_up(vif))
+		goto exit;
 
+	list_for_each_entry(vif, &cfg->vif_list, list) {
+		if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state))
+			continue;
 		/*
-		 * Make sure WPA_Supplicant receives all the event
-		 * generated due to DISASSOC call to the fw to keep
-		 * the state fw and WPA_Supplicant state consistent
+		 * While going to suspend if associated with AP disassociate
+		 * from AP to save power while system is in suspended state
 		 */
-		brcmf_delay(500);
+		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state) ||
+		    test_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state)) {
+			WL_INFO("Disassociating from AP before suspend\n");
+			brcmf_link_down(cfg);
+
+			/* Make sure WPA_Supplicant receives all the event
+			 * generated due to DISASSOC call to the fw to keep
+			 * the state fw and WPA_Supplicant state consistent
+			 */
+			brcmf_delay(500);
+		}
 	}
 
-	if (test_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state))
+	/* end any scanning */
+	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
 		brcmf_abort_scanning(cfg);
-	else
-		clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 
 	/* Turn off watchdog timer */
-	if (test_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state))
-		brcmf_set_mpc(ndev, 1);
+	brcmf_set_mpc(ndev, 1);
 
+exit:
 	WL_TRACE("Exit\n");
-
+	/* clear any scanning activity */
+	cfg->scan_status = 0;
 	return 0;
 }
 
-- 
1.7.9.5


