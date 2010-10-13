Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14919 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab0JMGRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 02:17:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 23:17:13 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	<Vasanth.Thiagarajan@Atheros.com>,
	<Rajkumar.Manoharan@Atheros.com>, <Vivek.Natarajan@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Fix documentation in rate control
Date: Wed, 13 Oct 2010 11:47:09 +0530
Message-ID: <1286950629-13902-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This fix updates the documenation in Rate Control Table structure

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 drivers/net/wireless/ath/ath9k/rc.h |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 13f9e88..abebf24 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -302,7 +302,7 @@ static const struct ath_rate_table ar5416_11ng_ratetable = {
 		[64] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
 			205100, 20, 20, 8, 64, 65, 65 }, /* 243 Mb */
 		[65] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
-			224700, 20, 20, 8, 64, 65, 65 }, /* 170 Mb */
+			224700, 20, 20, 8, 64, 65, 65 }, /* 270 Mb */
 		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
 			263100, 21, 21, 8, 66, 67, 67 }, /* 324 Mb */
 		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 268072f..fbb1d33 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -135,20 +135,21 @@ enum {
 
 /**
  * struct ath_rate_table - Rate Control table
- * @valid: valid for use in rate control
- * @valid_single_stream: valid for use in rate control for
- * 	single stream operation
- * @phy: CCK/OFDM
+ * @rate_cnt: total number of rates for the given wireless mode
+ * @mcs_start: MCS rate index offset
+ * @rate_flags: Rate Control flags
+ * @phy: CCK/OFDM/HT20/HT40
  * @ratekbps: rate in Kbits per second
  * @user_ratekbps: user rate in Kbits per second
  * @ratecode: rate that goes into HW descriptors
- * @short_preamble: Mask for enabling short preamble in ratecode for CCK
  * @dot11rate: value that goes into supported
  * 	rates info element of MLME
  * @ctrl_rate: Index of next lower basic rate, used for duration computation
- * @max_4ms_framelen: maximum frame length(bytes) for tx duration
+ * @cw40index: Index of rates having 40MHz channel width
+ * @sgi_index: Index of rates having Short Guard Interval
+ * @ht_index: high throughput rates having 40MHz channel width and
+ * 	Short Guard Interval
  * @probe_interval: interval for rate control to probe for other rates
- * @rssi_reduce_interval: interval for rate control to reduce rssi
  * @initial_ratemax: initial ratemax value
  */
 struct ath_rate_table {
-- 
1.7.0.4

