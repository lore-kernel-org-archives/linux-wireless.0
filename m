Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1655 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/24] brcmfmac: change parameter of
 brcmf_set_management_ie()
Date: Mon, 5 Nov 2012 16:22:18 -0800
Message-ID: <1352161352-30405-11-git-send-email-frankyl@broadcom.com> (sfid-20121106_013117_270946_C24CF034)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function brcmf_set_management_ie() operates on virtual
interface data and brcmf_cfg80211_vif structure provides
all information needed for interfacing with firmware. As
this function will also be needed for interface without
an associated net device it makes sense to provide the vif
instead of deriving it from the net device.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   33 +++++++++++---------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    6 ++++
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 0970c1a..83a2421 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3344,12 +3344,11 @@ brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 }
 
 static
-s32 brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
-			    struct net_device *ndev, s32 pktflag,
-			    const u8 *vndr_ie_buf, u32 vndr_ie_len)
+s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
+			  const u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct vif_saved_ie *saved_ie = &ifp->vif->saved_ie;
+	struct brcmf_if *ifp;
+	struct vif_saved_ie *saved_ie;
 	s32 err = 0;
 	u8  *iovar_ie_buf;
 	u8  *curr_ie_buf;
@@ -3366,8 +3365,12 @@ s32 brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	u8 *ptr;
 	int remained_buf_len;
 
-	WL_TRACE("bssidx %d, pktflag : 0x%02X\n",
-		 brcmf_ndev_bssidx(ndev), pktflag);
+	if (!vif)
+		return -ENODEV;
+	ifp = vif->ifp;
+	saved_ie = &vif->saved_ie;
+
+	WL_TRACE("bssidx %d, pktflag : 0x%02X\n", ifp->bssidx, pktflag);
 	iovar_ie_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (!iovar_ie_buf)
 		return -ENOMEM;
@@ -3585,20 +3588,20 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_configure_opensecurity(ndev, bssidx);
 	}
 	/* Set Beacon IEs to FW */
-	err = brcmf_set_management_ie(cfg, ndev,
-				      VNDR_IE_BEACON_FLAG,
-				      settings->beacon.tail,
-				      settings->beacon.tail_len);
+	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
+				    VNDR_IE_BEACON_FLAG,
+				    settings->beacon.tail,
+				    settings->beacon.tail_len);
 	if (err)
 		WL_ERR("Set Beacon IE Failed\n");
 	else
 		WL_TRACE("Applied Vndr IEs for Beacon\n");
 
 	/* Set Probe Response IEs to FW */
-	err = brcmf_set_management_ie(cfg, ndev,
-				      VNDR_IE_PRBRSP_FLAG,
-				      settings->beacon.proberesp_ies,
-				      settings->beacon.proberesp_ies_len);
+	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
+				    VNDR_IE_PRBRSP_FLAG,
+				    settings->beacon.proberesp_ies,
+				    settings->beacon.proberesp_ies_len);
 	if (err)
 		WL_ERR("Set Probe Resp IE Failed\n");
 	else
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 3c59931..e4de9fc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -468,6 +468,12 @@ static inline struct brcmf_cfg80211_profile *ndev_to_prof(struct net_device *nd)
 	return &ifp->vif->profile;
 }
 
+static inline struct brcmf_cfg80211_vif *ndev_to_vif(struct net_device *ndev)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	return ifp->vif;
+}
+
 static inline struct
 brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 {
-- 
1.7.9.5


