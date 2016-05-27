Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:3572 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbcE0Iyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 04:54:37 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V6] brcmfmac: print errors if creating interface fails
Date: Fri, 27 May 2016 10:54:28 +0200
Message-Id: <1464339268-27916-1-git-send-email-arend@broadcom.com> (sfid-20160527_105441_116870_283BFCF0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <zajec5@gmail.com>

This is helpful for debugging. Without this all I was getting from "iw"
command on failed creating of P2P interface was:
> command failed: Too many open files in system (-23)

Signed-off-by: Rafal Milecki <zajec5@gmail.com>
[arend@broadcom.com: reduce error prints upon iface creation]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
V2: s/in/if/ in commit message
V3: Add one more error message as suggested by Arend
V4: Also update brcmf_cfg80211_add_iface & print error for AP
V5: remove error prints from p2p.c
V6: fix compiler warning and remove duplicate calls
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 16 ++++++++++------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c   |  2 --
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d0631b6..2248e8e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -669,20 +669,24 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 		return ERR_PTR(-EOPNOTSUPP);
 	case NL80211_IFTYPE_AP:
 		wdev = brcmf_ap_add_vif(wiphy, name, flags, params);
-		if (!IS_ERR(wdev))
-			brcmf_cfg80211_update_proto_addr_mode(wdev);
-		return wdev;
+		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		wdev = brcmf_p2p_add_vif(wiphy, name, name_assign_type, type, flags, params);
-		if (!IS_ERR(wdev))
-			brcmf_cfg80211_update_proto_addr_mode(wdev);
-		return wdev;
+		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	default:
 		return ERR_PTR(-EINVAL);
 	}
+
+	if (IS_ERR(wdev))
+		brcmf_err("add iface %s type %d failed: err=%d\n",
+			  name, type, (int)PTR_ERR(wdev));
+	else
+		brcmf_cfg80211_update_proto_addr_mode(wdev);
+
+	return wdev;
 }
 
 static void brcmf_scan_config_mpc(struct brcmf_if *ifp, int mpc)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index a70cda6..a812381 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2030,8 +2030,6 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_p2p_info *p2p,
 
 	err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
 				       sizeof(if_request));
-	if (err)
-		return err;
 
 	return err;
 }
-- 
1.9.1

