Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:6981 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbXGAQkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2007 12:40:37 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: kune@deine-taler.de
Cc: flamingice@sourmilk.net
Subject: [PATCH] zd1211rw-mac80211: Fix SSI reporting
Message-Id: <20070701164037.6ACC87B409F@zog.reactivated.net>
Date: Sun,  1 Jul 2007 17:40:37 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw-mac80211 currently reports different values for signal level
than zd1211rw-softmac. This is because the softmac driver passes the raw
strength value, whereas zd1211rw-mac80211 is performing some other
calculation.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.c |    8 --------
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.h |    1 -
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c  |    2 +-
 3 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
index 75728bb..662e66e 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
@@ -1464,14 +1464,6 @@ u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 		cck_qual_percent(status->signal_quality_cck);
 }
 
-u8 zd_rx_strength_percent(u8 rssi)
-{
-	int r = (rssi*100) / 41;
-	if (r > 100)
-		r = 100;
-	return (u8) r;
-}
-
 u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
 {
 	static const u16 ofdm_rates[] = {
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
index 96ada90..5229290 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
@@ -877,7 +877,6 @@ struct rx_status;
 
 u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 	               const struct rx_status *status);
-u8 zd_rx_strength_percent(u8 rssi);
 
 u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
 
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 49633d4..373916a 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -652,7 +652,7 @@ static int fill_rx_stats(struct ieee80211_rx_status *stats,
 	stats->channel = _zd_chip_get_channel(&mac->chip);
 	stats->freq = zd_channels[stats->channel - 1].freq;
 	stats->phymode = MODE_IEEE80211G;
-	stats->ssi = zd_rx_strength_percent(status->signal_strength);
+	stats->ssi = status->signal_strength;
 	stats->signal = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
-- 
1.5.2.2

