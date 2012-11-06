Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4439 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2KFAWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:49 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/24] brcmfmac: remove obsolete variable from
 brcmf_cfg80211_start_ap()
Date: Mon, 5 Nov 2012 16:22:19 -0800
Message-ID: <1352161352-30405-12-git-send-email-frankyl@broadcom.com> (sfid-20121106_013116_249439_F0653368)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function brcmf_cfg80211_start_ap() had some variables declared
that were not used or not needed any longer. This patch removes
those variables.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 83a2421..4b5b475 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3087,7 +3087,7 @@ static bool brcmf_valid_wpa_oui(u8 *oui, bool is_rsn_ie)
 
 static s32
 brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
-		     bool is_rsn_ie, s32 bssidx)
+		     bool is_rsn_ie)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	u32 auth = 0; /* d11 open authentication */
@@ -3510,7 +3510,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_tlv *rsn_ie;
 	struct brcmf_vs_tlv *wpa_ie;
 	struct brcmf_join_params join_params;
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 bssidx = 0;
 
 	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
@@ -3572,14 +3571,13 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WL_TRACE("WPA(2) IE is found\n");
 		if (wpa_ie != NULL) {
 			/* WPA IE */
-			err = brcmf_configure_wpaie(ndev, wpa_ie, false,
-						    bssidx);
+			err = brcmf_configure_wpaie(ndev, wpa_ie, false);
 			if (err < 0)
 				goto exit;
 		} else {
 			/* RSN IE */
 			err = brcmf_configure_wpaie(ndev,
-				(struct brcmf_vs_tlv *)rsn_ie, true, bssidx);
+				(struct brcmf_vs_tlv *)rsn_ie, true);
 			if (err < 0)
 				goto exit;
 		}
-- 
1.7.9.5


