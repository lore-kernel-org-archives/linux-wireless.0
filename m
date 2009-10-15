Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:20609 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727AbZJOHfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 03:35:16 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] wl1271: fix sparse warnings about undeclared functions
Date: Thu, 15 Oct 2009 10:33:27 +0300
Message-Id: <1255592010-10287-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
References: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following sparse warnings were fixed:

drivers/net/wireless/wl12xx/wl1271_spi.c:199:6: warning: symbol 'wl1271_spi_read_busy' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1271_cmd.c:84:5: warning: symbol 'wl1271_cmd_cal_channel_tune' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1271_cmd.c:107:5: warning: symbol 'wl1271_cmd_cal_update_ref_point' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1271_cmd.c:132:5: warning: symbol 'wl1271_cmd_cal_p2g' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1271_cmd.c:153:5: warning: symbol 'wl1271_cmd_cal' was not declared. Should it be static?

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    8 ++++----
 drivers/net/wireless/wl12xx/wl1271_spi.c |    5 ++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 1d64aa4..195eee7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -81,7 +81,7 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_cal_channel_tune(struct wl1271 *wl)
+static int wl1271_cmd_cal_channel_tune(struct wl1271 *wl)
 {
 	struct wl1271_cmd_cal_channel_tune *cmd;
 	int ret = 0;
@@ -104,7 +104,7 @@ int wl1271_cmd_cal_channel_tune(struct wl1271 *wl)
 	return ret;
 }
 
-int wl1271_cmd_cal_update_ref_point(struct wl1271 *wl)
+static int wl1271_cmd_cal_update_ref_point(struct wl1271 *wl)
 {
 	struct wl1271_cmd_cal_update_ref_point *cmd;
 	int ret = 0;
@@ -129,7 +129,7 @@ int wl1271_cmd_cal_update_ref_point(struct wl1271 *wl)
 	return ret;
 }
 
-int wl1271_cmd_cal_p2g(struct wl1271 *wl)
+static int wl1271_cmd_cal_p2g(struct wl1271 *wl)
 {
 	struct wl1271_cmd_cal_p2g *cmd;
 	int ret = 0;
@@ -150,7 +150,7 @@ int wl1271_cmd_cal_p2g(struct wl1271 *wl)
 	return ret;
 }
 
-int wl1271_cmd_cal(struct wl1271 *wl)
+static int wl1271_cmd_cal(struct wl1271 *wl)
 {
 	/*
 	 * FIXME: we must make sure that we're not sleeping when calibration
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 3c5aa58..02978a1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -196,7 +196,9 @@ int wl1271_set_partition(struct wl1271 *wl,
 
 #define WL1271_BUSY_WORD_TIMEOUT 1000
 
-void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
+/* FIXME: Check busy words, removed due to SPI bug */
+#if 0
+static void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 {
 	struct spi_transfer t[1];
 	struct spi_message m;
@@ -256,6 +258,7 @@ void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 	memset(buf, 0, len);
 	wl1271_error("SPI read busy-word timeout!\n");
 }
+#endif
 
 void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 			 size_t len, bool fixed)
-- 
1.5.6.5

