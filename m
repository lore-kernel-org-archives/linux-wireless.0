Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2017 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/13] brcmfmac: only do auth_type workaround when no
 WPA or RSN IE is provided
Date: Sun, 3 Mar 2013 12:45:24 +0100
Message-ID: <1362311132-29561-6-git-send-email-arend@broadcom.com> (sfid-20130303_124611_530276_DB95CBBF)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The workaround is only needed when auth_type is automatic AND there is
no WPA or RSN information element provided by cfg80211.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-yb: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2af9c0f..73f5528 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1605,6 +1605,9 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 			}
 		}
 		brcmf_fil_iovar_data_set(ifp, "wpaie", ie, ie_len);
+		if (!ie_len)
+			sme->auth_type = brcmf_war_auth_type(ifp,
+							     sme->auth_type);
 	}
 
 	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
@@ -1635,7 +1638,6 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	sme->auth_type = brcmf_war_auth_type(ifp, sme->auth_type);
 	err = brcmf_set_auth_type(ndev, sme);
 	if (err) {
 		brcmf_err("wl_set_auth_type failed (%d)\n", err);
-- 
1.7.6


