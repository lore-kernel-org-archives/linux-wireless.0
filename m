Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4355 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab2ISUVo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/13] brcmfmac: fix sparse warnings in e-scan related
 code
Date: Wed, 19 Sep 2012 22:21:06 +0200
Message-ID: <1348086078-19183-2-git-send-email-arend@broadcom.com> (sfid-20120919_222156_836414_32D8ACC8)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the introduction of e-scan mechanism in brcmfmac
(e756af5 brcmfmac: add e-scan support.) a couple of sparse
warnings were introduced. This patch resolves those.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   35 ++++++++++----------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 200a6c2..8e5a01d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -700,11 +700,11 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 	u32 n_channels;
 	s32 i;
 	s32 offset;
-	__le16 chanspec;
+	u16 chanspec;
 	u16 channel;
 	struct ieee80211_channel *req_channel;
 	char *ptr;
-	struct brcmf_ssid ssid;
+	struct brcmf_ssid_le ssid_le;
 
 	memcpy(params_le->bssid, ether_bcast, ETH_ALEN);
 	params_le->bss_type = DOT11_BSSTYPE_ANY;
@@ -747,13 +747,10 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 					chanspec |= WL_CHANSPEC_CTL_SB_UPPER;
 			}
 
-			params_le->channel_list[i] =
-				(channel & WL_CHANSPEC_CHAN_MASK) |
-				chanspec;
+			chanspec |= (channel & WL_CHANSPEC_CHAN_MASK);
 			WL_SCAN("Chan : %d, Channel spec: %x\n",
-				channel, params_le->channel_list[i]);
-			params_le->channel_list[i] =
-				cpu_to_le16(params_le->channel_list[i]);
+				channel, chanspec);
+			params_le->channel_list[i] = cpu_to_le16(chanspec);
 		}
 	} else {
 		WL_SCAN("Scanning all channels\n");
@@ -766,17 +763,18 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 		offset = roundup(offset, sizeof(u32));
 		ptr = (char *)params_le + offset;
 		for (i = 0; i < n_ssids; i++) {
-			memset(&ssid, 0, sizeof(ssid));
-			ssid.SSID_len = cpu_to_le32(request->ssids[i].ssid_len);
-			memcpy(ssid.SSID, request->ssids[i].ssid,
-					request->ssids[i].ssid_len);
-			if (!ssid.SSID_len)
+			memset(&ssid_le, 0, sizeof(ssid_le));
+			ssid_le.SSID_len =
+					cpu_to_le32(request->ssids[i].ssid_len);
+			memcpy(ssid_le.SSID, request->ssids[i].ssid,
+			       request->ssids[i].ssid_len);
+			if (!ssid_le.SSID_len)
 				WL_SCAN("%d: Broadcast scan\n", i);
 			else
 				WL_SCAN("%d: scan for  %s size =%d\n", i,
-				ssid.SSID, ssid.SSID_len);
-			memcpy(ptr, &ssid, sizeof(ssid));
-			ptr += sizeof(ssid);
+					ssid_le.SSID, ssid_le.SSID_len);
+			memcpy(ptr, &ssid_le, sizeof(ssid_le));
+			ptr += sizeof(ssid_le);
 		}
 	} else {
 		WL_SCAN("Broadcast scan %p\n", request->ssids);
@@ -2842,10 +2840,13 @@ brcmf_compare_update_same_bss(struct brcmf_bss_info_le *bss,
 		!memcmp(bss_info_le->SSID, bss->SSID, bss_info_le->SSID_len)) {
 		if ((bss->flags & WLC_BSS_RSSI_ON_CHANNEL) ==
 			(bss_info_le->flags & WLC_BSS_RSSI_ON_CHANNEL)) {
+			s16 bss_rssi = le16_to_cpu(bss->RSSI);
+			s16 bss_info_rssi = le16_to_cpu(bss_info_le->RSSI);
+
 			/* preserve max RSSI if the measurements are
 			* both on-channel or both off-channel
 			*/
-			if (bss_info_le->RSSI > bss->RSSI)
+			if (bss_info_rssi > bss_rssi)
 				bss->RSSI = bss_info_le->RSSI;
 		} else if ((bss->flags & WLC_BSS_RSSI_ON_CHANNEL) &&
 			(bss_info_le->flags & WLC_BSS_RSSI_ON_CHANNEL) == 0) {
-- 
1.7.9.5


