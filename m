Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:19595 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbJHSdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/11] brcmfmac: Add RSSI information to get_station.
Date: Thu, 8 Oct 2015 20:33:17 +0200
Message-ID: <1444329201-3696-8-git-send-email-arend@broadcom.com> (sfid-20151008_203330_719254_AB4E1842)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
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
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 73eddad..ca9d239 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2432,6 +2432,9 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_sta_info_le sta_info_le;
 	u32 sta_flags;
 	u32 is_tdls_peer;
+	s32 total_rssi;
+	s32 count_rssi;
+	u32 i;
 
 	brcmf_dbg(TRACE, "Enter, MAC %pM\n", mac);
 	if (!check_vif_up(ifp->vif))
@@ -2492,6 +2495,26 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES);
 			sinfo->rx_bytes = le64_to_cpu(sta_info_le.rx_tot_bytes);
 		}
+		total_rssi = 0;
+		count_rssi = 0;
+		for (i = 0; i < BRCMF_ANT_MAX; i++) {
+			if (sta_info_le.rssi[i]) {
+				sinfo->chain_signal_avg[count_rssi] =
+					sta_info_le.rssi[i];
+				sinfo->chain_signal[count_rssi] =
+					sta_info_le.rssi[i];
+				total_rssi += sta_info_le.rssi[i];
+				count_rssi++;
+			}
+		}
+		if (count_rssi) {
+			sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL);
+			sinfo->chains = count_rssi;
+
+			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+			total_rssi /= count_rssi;
+			sinfo->signal = total_rssi;
+		}
 	}
 done:
 	brcmf_dbg(TRACE, "Exit\n");
-- 
1.9.1

