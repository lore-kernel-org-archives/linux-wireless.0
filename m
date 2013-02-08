Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3759 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/27] brcmfmac: Use role from wdev on AP commands and
 fix stop_ap.
Date: Fri, 8 Feb 2013 15:53:53 +0100
Message-ID: <1360335242-12608-19-git-send-email-arend@broadcom.com> (sfid-20130208_155827_659154_FE723DE4)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Use the stored role in wdev struct to determine AP/GO role. This
simplifies code. Fix stop_ap for GO role.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   51 ++++++--------------
 1 file changed, 14 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3011575..58b2437 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3655,7 +3655,6 @@ static s32
 brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			struct cfg80211_ap_settings *settings)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 ie_offset;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_tlv *ssid_ie;
@@ -3675,22 +3674,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		  settings->ssid, settings->ssid_len, settings->auth_type,
 		  settings->inactivity_timeout);
 
-	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif) {
-		brcmf_dbg(TRACE, "Role = AP\n");
-		dev_role = NL80211_IFTYPE_AP;
-		if (!test_bit(BRCMF_VIF_STATUS_AP_CREATING,
-			      &ifp->vif->sme_state)) {
-			brcmf_err("Not in AP creation mode\n");
-			return -EPERM;
-		}
-	} else {
-		brcmf_dbg(TRACE, "Role = P2P GO\n");
-		dev_role = NL80211_IFTYPE_P2P_GO;
-		if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif) {
-			ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
-			ndev = ifp->ndev;
-		}
-	}
+	dev_role = ifp->vif->wdev.iftype;
 
 	memset(&ssid_le, 0, sizeof(ssid_le));
 	if (settings->ssid == NULL || settings->ssid_len == 0) {
@@ -3826,10 +3810,11 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = -EPERM;
+	struct brcmf_fil_bss_enable_le bss_enable;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (ifp->vif->mode == WL_MODE_AP) {
+	if (ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) {
 		/* Due to most likely deauths outstanding we sleep */
 		/* first to make sure they get processed by fw. */
 		msleep(400);
@@ -3843,10 +3828,18 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 			brcmf_err("BRCMF_C_UP error %d\n", err);
 			goto exit;
 		}
-		brcmf_set_mpc(ndev, 1);
-		clear_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
-		clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
+	} else {
+		bss_enable.bsscfg_idx = cpu_to_le32(ifp->bssidx);
+		bss_enable.enable = cpu_to_le32(0);
+		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
+					       sizeof(bss_enable));
+		if (err < 0)
+			brcmf_err("bss_enable config failed %d\n", err);
 	}
+	brcmf_set_mpc(ndev, 1);
+	set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
+	clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
+
 exit:
 	return err;
 }
@@ -3855,27 +3848,11 @@ static s32
 brcmf_cfg80211_change_beacon(struct wiphy *wiphy, struct net_device *ndev,
 			     struct cfg80211_beacon_data *info)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif) {
-		brcmf_dbg(TRACE, "Role = AP\n");
-		if (!test_bit(BRCMF_VIF_STATUS_AP_CREATED,
-			      &ifp->vif->sme_state)) {
-			brcmf_err("AP was not yet created\n");
-			return -EPERM;
-		}
-	} else {
-		brcmf_dbg(TRACE, "Role = P2P GO\n");
-		if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif) {
-			ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
-			ndev = ifp->ndev;
-		}
-	}
-
 	err = brcmf_config_ap_mgmt_ie(ifp->vif, info);
 
 	return err;
-- 
1.7.10.4


