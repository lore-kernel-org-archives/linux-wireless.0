Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4441 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab2KFAWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:49 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/24] brcmfmac: make pointer type constant in
 brcmf_set_management_ie()
Date: Mon, 5 Nov 2012 16:22:12 -0800
Message-ID: <1352161352-30405-5-git-send-email-frankyl@broadcom.com> (sfid-20121106_012310_211384_AD205020)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The vendor ie buffer passed to brcmf_set_management_ie() is not modified
and the caller always provided a constant buffer, which needed a cast.
Better making the buffer parameter of the function constant so the
casts can be removed.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c979ce1..94da6c9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3681,7 +3681,7 @@ exit:
 }
 
 static s32
-brcmf_parse_vndr_ies(u8 *vndr_ie_buf, u32 vndr_ie_len,
+brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 		     struct parsed_vndr_ies *vndr_ies)
 {
 	s32 err = 0;
@@ -3760,10 +3760,10 @@ brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 	return ie_len + VNDR_IE_HDR_SIZE;
 }
 
-static s32
-brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
-			struct net_device *ndev, s32 pktflag,
-			u8 *vndr_ie_buf, u32 vndr_ie_len)
+static
+s32 brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
+			    struct net_device *ndev, s32 pktflag,
+			    const u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct vif_saved_ie *saved_ie = &ifp->vif->saved_ie;
@@ -4004,7 +4004,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	/* Set Beacon IEs to FW */
 	err = brcmf_set_management_ie(cfg, ndev,
 				      VNDR_IE_BEACON_FLAG,
-				      (u8 *)settings->beacon.tail,
+				      settings->beacon.tail,
 				      settings->beacon.tail_len);
 	if (err)
 		WL_ERR("Set Beacon IE Failed\n");
@@ -4014,7 +4014,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	/* Set Probe Response IEs to FW */
 	err = brcmf_set_management_ie(cfg, ndev,
 				      VNDR_IE_PRBRSP_FLAG,
-				      (u8 *)settings->beacon.proberesp_ies,
+				      settings->beacon.proberesp_ies,
 				      settings->beacon.proberesp_ies_len);
 	if (err)
 		WL_ERR("Set Probe Resp IE Failed\n");
-- 
1.7.9.5


