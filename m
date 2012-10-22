Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4249 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/12] brcmfmac: use memset when setting a broadcast mac
 address
Date: Mon, 22 Oct 2012 13:55:38 -0700
Message-ID: <1350939341-17687-10-git-send-email-frankyl@broadcom.com> (sfid-20121022_225855_456216_061FE348)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The driver had a global constant ether_bcast, which was copied
whenever a broadcast mac address was needed. This patch does a
memset(dest, 0xFF, ETH_ALEN) instead and consequently removes
the global ether_bcast.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5ce0068..94c619a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -94,8 +94,6 @@
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
-static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
-
 static u32 brcmf_dbg_level = WL_DBG_ERR;
 
 static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
@@ -534,7 +532,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 static void brcmf_iscan_prep(struct brcmf_scan_params_le *params_le,
 			     struct brcmf_ssid *ssid)
 {
-	memcpy(params_le->bssid, ether_bcast, ETH_ALEN);
+	memset(params_le->bssid, 0xFF, ETH_ALEN);
 	params_le->bss_type = DOT11_BSSTYPE_ANY;
 	params_le->scan_type = 0;
 	params_le->channel_num = 0;
@@ -721,7 +719,7 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 	char *ptr;
 	struct brcmf_ssid_le ssid_le;
 
-	memcpy(params_le->bssid, ether_bcast, ETH_ALEN);
+	memset(params_le->bssid, 0xFF, ETH_ALEN);
 	params_le->bss_type = DOT11_BSSTYPE_ANY;
 	params_le->scan_type = 0;
 	params_le->channel_num = 0;
@@ -810,7 +808,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		/* Do a scan abort to stop the driver's scan engine */
 		WL_SCAN("ABORT scan in firmware\n");
 		memset(&params_le, 0, sizeof(params_le));
-		memcpy(params_le.bssid, ether_bcast, ETH_ALEN);
+		memset(params_le.bssid, 0xFF, ETH_ALEN);
 		params_le.bss_type = DOT11_BSSTYPE_ANY;
 		params_le.scan_type = 0;
 		params_le.channel_num = cpu_to_le32(1);
@@ -1283,7 +1281,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 				   BRCMF_ASSOC_PARAMS_FIXED_SIZE;
 		memcpy(profile->bssid, params->bssid, ETH_ALEN);
 	} else {
-		memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
+		memset(join_params.params_le.bssid, 0xFF, ETH_ALEN);
 		memset(profile->bssid, 0, ETH_ALEN);
 	}
 
@@ -1673,7 +1671,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	memcpy(&profile->ssid.SSID, sme->ssid, profile->ssid.SSID_len);
 	join_params.ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
 
-	memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
+	memset(join_params.params_le.bssid, 0xFF, ETH_ALEN);
 
 	if (ssid.SSID_len < IEEE80211_MAX_SSID_LEN)
 		WL_CONN("ssid \"%s\", len (%d)\n",
-- 
1.7.9.5


