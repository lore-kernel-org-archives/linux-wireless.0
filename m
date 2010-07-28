Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44938 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0G1TaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 15:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1251: add get_survey callback in order to get channel noise
Date: Wed, 28 Jul 2010 15:25:47 -0400
Message-Id: <1280345147-24137-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The calculation of the noise value looks a bit strange to me, but this
is the same calculation from commit 446cfaa412beef0dd6cb0edf3b4eaed34d824537,
some hopefully it was/is correct (or good enough)...

 drivers/net/wireless/wl12xx/wl1251.h      |    3 +++
 drivers/net/wireless/wl12xx/wl1251_main.c |   17 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_rx.c   |    6 ++++++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 4f5f02a..6b942a2 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -381,6 +381,9 @@ struct wl1251 {
 
 	u32 chip_id;
 	char fw_ver[21];
+
+	/* Most recently reported noise in dBm */
+	s8 noise;
 };
 
 int wl1251_plt_start(struct wl1251 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 38f72f4..a6d8d1a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1172,6 +1172,22 @@ out:
 	return ret;
 }
 
+static int wl1251_op_get_survey(struct ieee80211_hw *hw, int idx,
+				struct survey_info *survey)
+{
+	struct wl1251 *wl = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+ 
+	if (idx != 0)
+		return -ENOENT;
+ 
+	survey->channel = conf->channel;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = wl->noise;
+ 
+	return 0;
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_supported_band wl1251_band_2ghz = {
 	.channels = wl1251_channels,
@@ -1193,6 +1209,7 @@ static const struct ieee80211_ops wl1251_ops = {
 	.bss_info_changed = wl1251_op_bss_info_changed,
 	.set_rts_threshold = wl1251_op_set_rts_threshold,
 	.conf_tx = wl1251_op_conf_tx,
+	.get_survey = wl1251_op_get_survey,
 };
 
 static int wl1251_read_eeprom_byte(struct wl1251 *wl, off_t offset, u8 *data)
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index 8515158..1b6294b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -74,6 +74,12 @@ static void wl1251_rx_status(struct wl1251 *wl,
 
 	status->signal = desc->rssi;
 
+	/*
+	 * FIXME: guessing that snr needs to be divided by two, otherwise
+	 * the values don't make any sense
+	 */
+	wl->noise = desc->rssi - desc->snr / 2;
+
 	status->freq = ieee80211_channel_to_frequency(desc->channel);
 
 	status->flag |= RX_FLAG_TSFT;
-- 
1.7.1.1

