Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51540 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3FIQvf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 12:51:35 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MRQfu-1UwlUD0jJQ-00Shjg for
 <linux-wireless@vger.kernel.org>; Sun, 09 Jun 2013 18:51:33 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v5] ath9k_htc: add STBC TX support
Date: Sun,  9 Jun 2013 18:51:24 +0200
Message-Id: <1370796684-21022-1-git-send-email-linux@rempel-privat.de> (sfid-20130609_185138_576523_F1112648)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All known ar7010+ar* device and current FW support STBC TX. This patch
make use of it and suggest to send STBC if peer support it.
I use wort "suggest" since currenly we have separate rate controller
in FW which will make decision based on rate and hardware.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0085e64..6958103 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -142,6 +142,7 @@ struct ath9k_htc_target_aggr {
 #define WLAN_RC_40_FLAG  0x02
 #define WLAN_RC_SGI_FLAG 0x04
 #define WLAN_RC_HT_FLAG  0x08
+#define ATH_RC_TX_STBC_FLAG 0x20
 
 struct ath9k_htc_rateset {
 	u8 rs_nrates;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 59f6436..bb0ba9e 100644
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
index 34869c2..eaa94fe 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -627,6 +627,8 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		trate->rates.ht_rates.rs_nrates = j;
 
 		caps = WLAN_RC_HT_FLAG;
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC)
+			caps |= ATH_RC_TX_STBC_FLAG;
 		if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
 		if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-- 
1.8.1.2

