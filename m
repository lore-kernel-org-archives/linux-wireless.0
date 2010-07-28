Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40406 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0G1UpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 16:45:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1271: add get_survey callback in order to get channel noise
Date: Wed, 28 Jul 2010 16:42:20 -0400
Message-Id: <1280349740-26973-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 +++
 drivers/net/wireless/wl12xx/wl1271_main.c |   17 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    7 +++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 53d47d7..dd3cee6 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -475,6 +475,9 @@ struct wl1271 {
 	bool sg_enabled;
 
 	struct list_head list;
+
+	/* Most recently reported noise in dBm */
+	s8 noise;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 864318f..374abf0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1927,6 +1927,22 @@ out:
 	return mactime;
 }
 
+static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
+				struct survey_info *survey)
+{
+	struct wl1271 *wl = hw->priv;
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
 static struct ieee80211_rate wl1271_rates[] = {
 	{ .bitrate = 10,
@@ -2156,6 +2172,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.set_rts_threshold = wl1271_op_set_rts_threshold,
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
+	.get_survey = wl1271_op_get_survey,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index e98f22b..019aa79 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -55,6 +55,13 @@ static void wl1271_rx_status(struct wl1271 *wl,
 
 	status->signal = desc->rssi;
 
+	/*
+	 * FIXME: In wl1251, the SNR should be divided by two.  In wl1271 we
+	 * need to divide by two for now, but TI has been discussing about
+	 * changing it.  This needs to be rechecked.
+	 */
+	wl->noise = desc->rssi - (desc->snr >> 1);
+
 	status->freq = ieee80211_channel_to_frequency(desc->channel);
 
 	if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
-- 
1.7.1.1

