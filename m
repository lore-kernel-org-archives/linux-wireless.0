Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61142 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3EBIMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 04:12:00 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0Lnmgj-1U696f3hT5-00hrp6 for
 <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 10:11:58 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 1/2] ath9k_htc: add STBC TX support
Date: Thu,  2 May 2013 10:11:47 +0200
Message-Id: <1367482308-9882-2-git-send-email-linux@rempel-privat.de> (sfid-20130502_101205_017176_22980FBC)
In-Reply-To: <1367482308-9882-1-git-send-email-linux@rempel-privat.de>
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

current firmware will enable STBC_TX, only if other peer support it.
This patch provide ht_peer_caps to firmware.
FW versions 1.3, 1.4 should be able to work with it.
Tested on ar7010+ar9280 and ar7010+ar9287.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 4 ++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index d3b099d..db4a793 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -142,6 +142,8 @@ struct ath9k_htc_target_aggr {
 #define WLAN_RC_40_FLAG  0x02
 #define WLAN_RC_SGI_FLAG 0x04
 #define WLAN_RC_HT_FLAG  0x08
+#define WLAN_RC_TX_STBC_FLAG 0x20 /* TX STBC */
+#define WLAN_RC_RX_STBC_FLAG 0xC0 /* RX STBC ,2 bits */
 
 struct ath9k_htc_rateset {
 	u8 rs_nrates;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a47f5e0..c79c5ac 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -517,6 +517,9 @@ static void setup_ht_cap(struct ath9k_htc_priv *priv,
 	ath_dbg(common, CONFIG, "TX streams %d, RX streams: %d\n",
 		tx_streams, rx_streams);
 
+	if (tx_streams >= 2)
+		ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
+
 	if (tx_streams != rx_streams) {
 		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
 		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0743a47..af08b4a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -623,6 +623,10 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		trate->rates.ht_rates.rs_nrates = j;
 
 		caps = WLAN_RC_HT_FLAG;
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC)
+			caps |= WLAN_RC_RX_STBC_FLAG;
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC)
+			caps |= WLAN_RC_TX_STBC_FLAG;
 		if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
 		if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-- 
1.8.1.2

