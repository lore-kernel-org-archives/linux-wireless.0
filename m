Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33901 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759765AbXFKKjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 06:39:18 -0400
Message-Id: <20070611103914.481787013@warmcat.com>
References: <20070611103828.961999956@warmcat.com>
Date: Mon, 11 Jun 2007 11:38:29 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	Andy Green <andy@warmcat.com>
Subject: [PATCH 1/2] zd1211rw-mac80211: return hardware specific tx rate code for rx status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw-mac80211 uses different hardware-specific codings to talk about
rates when doing transmit and receive.  Because mac80211 looks up the rx
rate against the rates table used for selecting hardware-specific coding for
tx, the rate returned in the rx_status struct needs to be adjusted to use the
coding used to hardware-specific tx rates.  This patch performs this adjustment.

Without this patch the radiotap-based monitor stuff reports a "0.0Mbps" rate for
all packets from this driver.

CC: Daniel Drake <dsd@gentoo.org>
CC: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Andy Green <andy@warmcat.com>

---
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.h |    2 ++
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c  |    2 +-
 3 files changed, 25 insertions(+), 1 deletion(-)

Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
@@ -1569,6 +1569,28 @@ u16 zd_rx_rate(const void *rx_frame, con
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
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
@@ -877,6 +877,8 @@ u8 zd_rx_qual_percent(const void *rx_fra
 u8 zd_rx_strength_percent(u8 rssi);
 
 u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
+int zd_rx_rate_using_tx_format(const void *rx_frame,
+   const struct rx_status *status);
 
 struct zd_mc_hash {
 	u32 low;
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -642,7 +642,7 @@ static int fill_rx_stats(struct ieee8021
 	stats->signal = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
-	stats->rate = zd_rx_rate(buffer, status);
+	stats->rate = zd_rx_rate_using_tx_format(buffer, status);
 
 	return 0;
 }

-- 
