Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25856 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaA2Ocg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:36 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/14] brcmfmac: expand sta info to report dtim and beacon period.
Date: Wed, 29 Jan 2014 15:32:11 +0100
Message-ID: <1391005944-3220-2-git-send-email-arend@broadcom.com> (sfid-20140129_153244_949275_5F0C30E0)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Expand the get_station command to also report dtim period and
beacon interval when the device is connected.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d7718a5..17170a5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2164,6 +2164,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 	u8 *bssid = profile->bssid;
 	struct brcmf_sta_info_le sta_info_le;
+	u32 beacon_period;
+	u32 dtim_period;
 
 	brcmf_dbg(TRACE, "Enter, MAC %pM\n", mac);
 	if (!check_vif_up(ifp->vif))
@@ -2218,6 +2220,30 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 				sinfo->signal = rssi;
 				brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
 			}
+			err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_BCNPRD,
+						    &beacon_period);
+			if (err) {
+				brcmf_err("Could not get beacon period (%d)\n",
+					  err);
+				goto done;
+			} else {
+				sinfo->bss_param.beacon_interval =
+					beacon_period;
+				brcmf_dbg(CONN, "Beacon peroid %d\n",
+					  beacon_period);
+			}
+			err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_DTIMPRD,
+						    &dtim_period);
+			if (err) {
+				brcmf_err("Could not get DTIM period (%d)\n",
+					  err);
+				goto done;
+			} else {
+				sinfo->bss_param.dtim_period = dtim_period;
+				brcmf_dbg(CONN, "DTIM peroid %d\n",
+					  dtim_period);
+			}
+			sinfo->filled |= STATION_INFO_BSS_PARAM;
 		}
 	} else
 		err = -EPERM;
-- 
1.7.10.4

