Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33519 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbcEKTxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 15:53:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id r12so11579456wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 12:53:24 -0700 (PDT)
From: Jaap Jan Meijer <jjmeijer88@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
	brcm80211-dev-list@broadcom.com,
	Jaap Jan Meijer <jjmeijer88@gmail.com>
Subject: [PATCH] brcmfmac: add fallback for devices that do not report per-chain values
Date: Wed, 11 May 2016 21:40:34 +0200
Message-Id: <1462995634-24602-1-git-send-email-jjmeijer88@gmail.com> (sfid-20160511_215345_922511_61AD9C00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If brcmf_cfg80211_get_station fails to determine the RSSI from the
per-chain values get all values individually as a fallback.

Signed-off-by: Jaap Jan Meijer <jjmeijer88@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 42 ++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d5c2a27..60229c8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2480,12 +2480,16 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   const u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_scb_val_le scb_val;
 	s32 err = 0;
 	struct brcmf_sta_info_le sta_info_le;
 	u32 sta_flags;
 	u32 is_tdls_peer;
 	s32 total_rssi;
 	s32 count_rssi;
+	int rssi;
+	u32 beacon_period;
+	u32 dtim_period;
 	u32 i;
 
 	brcmf_dbg(TRACE, "Enter, MAC %pM\n", mac);
@@ -2569,6 +2573,44 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 			total_rssi /= count_rssi;
 			sinfo->signal = total_rssi;
+		} else if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
+			&ifp->vif->sme_state)) {
+			memset(&scb_val, 0, sizeof(scb_val));
+			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
+						     &scb_val, sizeof(scb_val));
+			if (err) {
+				brcmf_err("Could not get rssi (%d)\n", err);
+				goto done;
+			} else {
+				rssi = le32_to_cpu(scb_val.val);
+				sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+				sinfo->signal = rssi;
+				brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
+			}
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
+			sinfo->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
 		}
 	}
 done:
-- 
1.9.1

