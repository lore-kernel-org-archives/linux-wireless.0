Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15590 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbbIRUIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/16] brcmfmac: Workaround in change vif for wpa_supplicant support.
Date: Fri, 18 Sep 2015 22:08:11 +0200
Message-ID: <1442606899-31872-9-git-send-email-arend@broadcom.com> (sfid-20150918_220847_688869_5C9EAE2B)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Different wpa_supplicants have different behavior and expectations
regarding the change_virtual_intf behavior. This patch implements
a workaround for the different versions and possible brcmfmac
configuration.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 43 ++++++++++++++++------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 3e1c8fc..891f4ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -777,6 +777,37 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter, idx=%d, type=%d\n", ifp->bssidx, type);
+
+	/* WAR: There are a number of p2p interface related problems which
+	 * need to be handled initially (before doing the validate).
+	 * wpa_supplicant tends to do iface changes on p2p device/client/go
+	 * which are not always possible/allowed. However we need to return
+	 * OK otherwise the wpa_supplicant wont start. The situation differs
+	 * on configuration and setup (p2pon=1 module param). The first check
+	 * is to see if the request is a change to station for p2p iface.
+	 */
+	if ((type == NL80211_IFTYPE_STATION) &&
+	    ((vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT) ||
+	     (vif->wdev.iftype == NL80211_IFTYPE_P2P_GO) ||
+	     (vif->wdev.iftype == NL80211_IFTYPE_P2P_DEVICE))) {
+		brcmf_dbg(TRACE, "Ignoring cmd for p2p if\n");
+		/* Now depending on whether module param p2pon=1 was used the
+		 * response needs to be either 0 or EOPNOTSUPP. The reason is
+		 * that if p2pon=1 is used, but a newer supplicant is used then
+		 * we should return an error, as this combination wont work.
+		 * In other situations 0 is returned and supplicant will start
+		 * normally. It will give a trace in cfg80211, but it is the
+		 * only way to get it working. Unfortunately this will result
+		 * in situation where we wont support new supplicant in
+		 * combination with module param p2pon=1, but that is the way
+		 * it is. If the user tries this then unloading of driver might
+		 * fail/lock.
+		 */
+		if (cfg->p2p.p2pdev_dynamically)
+			return -EOPNOTSUPP;
+		else
+			return 0;
+	}
 	err = brcmf_vif_change_validate(wiphy_to_cfg(wiphy), vif, type);
 	if (err) {
 		brcmf_err("iface validation failed: err=%d\n", err);
@@ -792,18 +823,6 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
-		/* Ignore change for p2p IF. Unclear why supplicant does this */
-		if ((vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT) ||
-		    (vif->wdev.iftype == NL80211_IFTYPE_P2P_GO)) {
-			brcmf_dbg(TRACE, "Ignoring cmd for p2p if\n");
-			/* WAR: It is unexpected to get a change of VIF for P2P
-			 * IF, but it happens. The request can not be handled
-			 * but returning EPERM causes a crash. Returning 0
-			 * without setting ieee80211_ptr->iftype causes trace
-			 * (WARN_ON) but it works with wpa_supplicant
-			 */
-			return 0;
-		}
 		infra = 1;
 		break;
 	case NL80211_IFTYPE_AP:
-- 
1.9.1

