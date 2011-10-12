Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4327 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/22] brcm80211: use endian annotations in scan related
 function
Date: Wed, 12 Oct 2011 20:51:19 +0200
Message-ID: <1318445492-24207-10-git-send-email-arend@broadcom.com> (sfid-20111012_205154_958499_70FAF5F5)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan related functions provide scan parameters to the device
which need to be in little-endian. These parameters have been
annotated and conversions were placed as needed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index fc643c1..1218ed7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -475,7 +475,7 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
 	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 	struct brcmf_ssid ssid;
-	s32 passive_scan;
+	__le32 passive_scan;
 	s32 err = 0;
 
 	/* Broadcast scan by default */
@@ -483,7 +483,7 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
-	passive_scan = cfg_priv->active_scan ? 0 : 1;
+	passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
 	err = brcmf_exec_dcmd(cfg_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (err) {
@@ -511,7 +511,7 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
 	struct brcmf_cfg80211_scan_req *sr = cfg_priv->scan_req_int;
-	s32 passive_scan;
+	__le32 passive_scan;
 	bool iscan_req;
 	bool spec_scan;
 	s32 err = 0;
@@ -567,7 +567,7 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			WL_SCAN("Broadcast scan\n");
 		}
 
-		passive_scan = cfg_priv->active_scan ? 0 : 1;
+		passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
 		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (err) {
-- 
1.7.4.1


