Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33570 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbcEZXDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 19:03:41 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V4] brcmfmac: print errors if creating interface fails
Date: Fri, 27 May 2016 01:03:07 +0200
Message-Id: <1464303792-3041-1-git-send-email-zajec5@gmail.com> (sfid-20160527_010412_290416_A715C86F)
In-Reply-To: <1464216299-25232-1-git-send-email-zajec5@gmail.com>
References: <1464216299-25232-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is helpful for debugging. Without this all I was getting from "iw"
command on failed creating of P2P interface was:
> command failed: Too many open files in system (-23)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: s/in/if/ in commit message
V3: Add one more error message as suggested by Arend
V4: Also update brcmf_cfg80211_add_iface & print error for AP
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 ++++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      | 3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 3d09d23..e7975a3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -669,14 +669,18 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 		return ERR_PTR(-EOPNOTSUPP);
 	case NL80211_IFTYPE_AP:
 		wdev = brcmf_ap_add_vif(wiphy, name, flags, params);
-		if (!IS_ERR(wdev))
+		if (IS_ERR(wdev))
+			brcmf_err("Failed to create AP interface %s: %d\n", name, PTR_ERR(wdev));
+		else
 			brcmf_cfg80211_update_proto_addr_mode(wdev);
 		return wdev;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		wdev = brcmf_p2p_add_vif(wiphy, name, name_assign_type, type, flags, params);
-		if (!IS_ERR(wdev))
+		if (IS_ERR(wdev))
+			brcmf_err("Failed to create P2P interface %s: %d\n", name, PTR_ERR(wdev));
+		else
 			brcmf_cfg80211_update_proto_addr_mode(wdev);
 		return wdev;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 1652a48..bc26aec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2031,7 +2031,7 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_p2p_info *p2p,
 	err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
 				       sizeof(if_request));
 	if (err)
-		return err;
+		brcmf_err("p2p_ifadd failed %d\n", err);
 
 	return err;
 }
@@ -2185,6 +2185,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	err = brcmf_p2p_request_p2p_if(&cfg->p2p, ifp, cfg->p2p.int_addr,
 				       iftype);
 	if (err) {
+		brcmf_err("Failed to request P2P virtual interface %s\n", name);
 		brcmf_cfg80211_arm_vif_event(cfg, NULL);
 		goto fail;
 	}
-- 
1.8.4.5

