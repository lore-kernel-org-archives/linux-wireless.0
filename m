Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45545 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965934AbXDIPxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 11:53:39 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 4E43A8D151
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2007 17:53:32 +0200 (CEST)
Message-Id: <20070409155336.002012553@warmcat.com>
References: <20070409154802.470925215@warmcat.com>
Date: Mon, 09 Apr 2007 16:48:09 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH 7/7] zd1211rw-mac80211: return hardware specific tx rate code for rx status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw-mac80211 uses different hardware-specific codings to talk about
rates when doing transmit and receive.  Because mac80211 looks up the rx
rate against the rates table used for selecting hardware-specific coding for
tx, the rate returned in the rx_status struct needs to be adjusted to use the
coding used to hardware-specific tx rates.  This patch performs this adjustment.

From: Andy Green <andy@warmcat.com>
Signed-off-by: Andy Green <andy@warmcat.com>

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
index 4d226dc..30684e3 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
@@ -1563,6 +1563,28 @@ u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
 	return rate;
 }
 
+int zd_rx_rate_using_tx_format(const void *rx_frame,
+   const struct rx_status *status)
+{
+	if (status->frame_status & ZD_RX_OFDM) {
+		return ZD_CS_OFDM | (zd_ofdm_plcp_header_rate(rx_frame) & 0xf);
+	}
+
+	switch (zd_cck_plcp_header_rate(rx_frame)) {
+	case ZD_CCK_SIGNAL_1M:
+		return ZD_CS_CCK_RATE_1M;
+	case ZD_CCK_SIGNAL_2M:
+		return ZD_CS_CCK_RATE_2M;
+	case ZD_CCK_SIGNAL_5M5:
+		return ZD_CS_CCK_RATE_5_5M;
+	case ZD_CCK_SIGNAL_11M:
+		return ZD_CS_CCK_RATE_11M;
+	default:
+		return 0;
+	}
+
+}
+
 int zd_chip_switch_radio_on(struct zd_chip *chip)
 {
 	int r;
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
index a4dc06c..4f4fe8c 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
@@ -873,6 +873,8 @@ u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 u8 zd_rx_strength_percent(u8 rssi);
 
 u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
+int zd_rx_rate_using_tx_format(const void *rx_frame,
+   const struct rx_status *status);
 
 struct zd_mc_hash {
 	u32 low;
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 65eabfa..bfaa923 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -411,7 +411,7 @@ static int fill_rx_stats(struct ieee80211_rx_status *stats,
 	stats->signal = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
-	stats->rate = zd_rx_rate(buffer, status);
+	stats->rate = zd_rx_rate_using_tx_format(buffer, status);
 
 	return 0;
 }

-- 
