Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43538 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbbAWASu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 19:18:50 -0500
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: Enable the MCS8 and MCS9 at 2.4G band
Date: Fri, 23 Jan 2015 08:18:20 +0800
Message-ID: <1421972300-23520-1-git-send-email-yanbol@qca.qualcomm.com> (sfid-20150123_011859_724639_F01F5804)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yanbo Li <yanbol@qti.qualcomm.com>

Enable the MCS8 and MCS9 support for 2.4G band, it will
use these data rate with other devices having the same
capability.

Signed-off-by: Yanbo Li <yanbol@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   14 ++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h |    2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..0b11c9c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1557,6 +1557,10 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 		return;
 
 	arg->peer_flags |= WMI_PEER_VHT;
+
+	if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
+		arg->peer_flags |= WMI_PEER_VHT_2G;
+
 	arg->peer_vht_caps = vht_cap->cap;
 
 	ampdu_factor = (vht_cap->cap &
@@ -1635,7 +1639,12 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 
 	switch (ar->hw->conf.chandef.chan->band) {
 	case IEEE80211_BAND_2GHZ:
-		if (sta->ht_cap.ht_supported) {
+		if (sta->vht_cap.vht_supported) {
+			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
+				phymode = MODE_11AC_VHT40;
+			else
+				phymode = MODE_11AC_VHT20;
+		} else if (sta->ht_cap.ht_supported) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
 				phymode = MODE_11NG_HT40;
 			else
@@ -5215,7 +5224,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		band->bitrates = ath10k_g_rates;
 		band->ht_cap = ht_cap;
 
-		/* vht is not supported in 2.4 GHz */
+		/* Enable the VHT support at 2.4 GHz */
+		band->vht_cap = vht_cap;
 
 		ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = band;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bd7f29a..6de92e8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4430,7 +4430,7 @@ struct wmi_peer_set_q_empty_callback_cmd {
 #define WMI_PEER_SPATIAL_MUX    0x00200000
 #define WMI_PEER_VHT            0x02000000
 #define WMI_PEER_80MHZ          0x04000000
-#define WMI_PEER_PMF            0x08000000
+#define WMI_PEER_VHT_2G         0x08000000
 
 /*
  * Peer rate capabilities.
-- 
1.7.9.5

