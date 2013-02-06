Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1357 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab3BFRmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:42:39 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/12] brcmfmac: fix problem connecting to AP without
 security
Date: Wed, 6 Feb 2013 18:40:47 +0100
Message-ID: <1360172447-2424-13-git-send-email-arend@broadcom.com> (sfid-20130206_184246_131279_268B816A)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bcm43236 device showed having an issue connection to an AP without
security when auth_type was set to automatic. For this particular device
a workaround is made by selecting open-system. This problem does not
occur when using wpa_supplicant as it will not use auth type automatic.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   22 +++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 153924e..4389ec3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1365,9 +1365,28 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	return err;
 }
 
+static
+enum nl80211_auth_type brcmf_war_auth_type(struct brcmf_if *ifp,
+					   enum nl80211_auth_type type)
+{
+	u32 ci;
+	if (type == NL80211_AUTHTYPE_AUTOMATIC) {
+		/* shift to ignore chip revision */
+		ci = brcmf_get_chip_info(ifp) >> 4;
+		switch (ci) {
+		case 43236:
+			brcmf_dbg(CONN, "43236 WAR: use OPEN instead of AUTO\n");
+			return NL80211_AUTHTYPE_OPEN_SYSTEM;
+		default:
+			break;
+		}
+	}
+	return type;
+}
+
 static s32
 brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
-		    struct cfg80211_connect_params *sme)
+		       struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
@@ -1410,6 +1429,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
+	sme->auth_type = brcmf_war_auth_type(ifp, sme->auth_type);
 	err = brcmf_set_auth_type(ndev, sme);
 	if (err) {
 		brcmf_err("wl_set_auth_type failed (%d)\n", err);
-- 
1.7.10.4


