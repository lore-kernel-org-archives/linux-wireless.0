Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3743 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760214Ab3BHO4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 21/27] brcmfmac: Reject change vif for p2p if.
Date: Fri, 8 Feb 2013 15:53:56 +0100
Message-ID: <1360335242-12608-22-git-send-email-arend@broadcom.com> (sfid-20130208_160533_880132_41286583)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 58b2437..cba2f34 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -673,6 +673,18 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
+		/* Ignore change for p2p IF. Unclear why supplicant does this */
+		if ((vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT) ||
+		    (vif->wdev.iftype == NL80211_IFTYPE_P2P_GO)) {
+			brcmf_dbg(TRACE, "Ignoring cmd for p2p if\n");
+			/* WAR: It is unexpected to get a change of VIF for P2P
+			 * IF, but it happens. The request can not be handled
+			 * but returning EPERM causes a crash. Returning 0
+			 * without setting ieee80211_ptr->iftype causes trace
+			 * (WARN_ON) but it works with wpa_supplicant
+			 */
+			return 0;
+		}
 		vif->mode = WL_MODE_BSS;
 		infra = 1;
 		break;
-- 
1.7.10.4


