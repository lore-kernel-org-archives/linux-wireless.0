Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37332 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbEYMH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 08:07:29 -0400
Received: by wibt6 with SMTP id t6so47139728wib.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 05:07:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 2/3] ath10k: handle cycle counter wraparound
Date: Mon, 25 May 2015 14:06:18 +0200
Message-Id: <1432555579-18347-2-git-send-email-michal.kazior@tieto.com> (sfid-20150525_140733_810149_D615F02F)
In-Reply-To: <1432555579-18347-1-git-send-email-michal.kazior@tieto.com>
References: <1432282693-4553-1-git-send-email-michal.kazior@tieto.com>
 <1432555579-18347-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When QCA988X cycle counter HW register wraps
around it resets to 0x7fffffff instead of 0. All
other cycle counter related registers are divided
by 2 so they never wraparound themselves. QCA61X4
has a uniform CC and it wraparounds in a regular
fashion though.

Worst case wraparound time is approx 24 seconds
(2**31 / 88MHz). Since scan channel visit times
are max 5 seconds (offchannel case) it is
guaranteed there's been at most 1 wraparound and
it is possible to compute survey active time
value. It is, however, impossible to determine the
point at which Rx Clear Count has been divided by
two so it is not reported upon wraparound.

This fixes some occasional incorrect survey data
on QCA988X as some channels (depending on how/when
scan/offchannel requests were requested) would
have approx 24 sec active time which wasn't
actually the case.

This should improve hostapd ACS a little bit.

Reported-by: Srinivasa Duvvuri <sduvvuri@chromium.org>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v4:
     * use hw.c for cc computation logic [Kalle]
     * drop rx_clear_count upon wraparound [Srinivasa]
    
    v3:
     * split into 2 separate patches
     * don't ignore all wraparound data: scans can be computed
     * apply the shifted wraparound fix only for QCA988X
     * improve commit log

 drivers/net/wireless/ath/ath10k/core.c |  1 +
 drivers/net/wireless/ath/ath10k/core.h |  7 +++++++
 drivers/net/wireless/ath/ath10k/hw.c   | 21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  3 +++
 drivers/net/wireless/ath/ath10k/wmi.c  | 17 +++++++++--------
 5 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bcccae19325d..684d460d79b7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -48,6 +48,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca988x hw2.0",
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
+		.has_shifted_cc_wraparound = true,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 827b3d79ed0c..729b366e2a18 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -572,6 +572,13 @@ struct ath10k {
 		u32 patch_load_addr;
 		int uart_pin;
 
+		/* This is true if given HW chip has a quirky Cycle Counter
+		 * wraparound which resets to 0x7fffffff instead of 0. All
+		 * other CC related counters (e.g. Rx Clear Count) are divided
+		 * by 2 so they never wraparound themselves.
+		 */
+		bool has_shifted_cc_wraparound;
+
 		struct ath10k_hw_params_fw {
 			const char *dir;
 			const char *fw;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 839a8791fb9e..5997f00afe3b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/types.h>
+#include "core.h"
 #include "hw.h"
 
 const struct ath10k_hw_regs qca988x_regs = {
@@ -56,3 +57,23 @@ const struct ath10k_hw_regs qca6174_regs = {
 	.soc_chip_id_address			= 0x000f0,
 	.scratch_3_address			= 0x0028,
 };
+
+void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
+				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev)
+{
+	u32 cc_fix = 0;
+
+	survey->filled |= SURVEY_INFO_TIME |
+			  SURVEY_INFO_TIME_BUSY;
+
+	if (ar->hw_params.has_shifted_cc_wraparound && cc < cc_prev) {
+		cc_fix = 0x7fffffff;
+		survey->filled &= ~SURVEY_INFO_TIME_BUSY;
+	}
+
+	cc -= cc_prev - cc_fix;
+	rcc -= rcc_prev;
+
+	survey->time = CCNT_TO_MSEC(cc);
+	survey->time_busy = CCNT_TO_MSEC(rcc);
+}
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 372f0b8c96f5..85cca29375fe 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -169,6 +169,9 @@ struct ath10k_hw_regs {
 extern const struct ath10k_hw_regs qca988x_regs;
 extern const struct ath10k_hw_regs qca6174_regs;
 
+void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
+				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev);
+
 #define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
 #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 43caabf5b025..70e6efa2c071 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -27,6 +27,7 @@
 #include "testmode.h"
 #include "wmi-ops.h"
 #include "p2p.h"
+#include "hw.h"
 
 /* MAIN WMI cmd track */
 static struct wmi_cmd_map wmi_cmd_map = {
@@ -1640,16 +1641,16 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 		 * visited channel. The reported cycle count is global
 		 * and per-channel cycle count must be calculated */
 
-		cycle_count -= ar->survey_last_cycle_count;
-		rx_clear_count -= ar->survey_last_rx_clear_count;
-
 		survey = &ar->survey[idx];
-		survey->time = CCNT_TO_MSEC(cycle_count);
-		survey->time_busy = CCNT_TO_MSEC(rx_clear_count);
 		survey->noise = noise_floor;
-		survey->filled = SURVEY_INFO_TIME |
-				 SURVEY_INFO_TIME_BUSY |
-				 SURVEY_INFO_NOISE_DBM;
+		survey->filled = SURVEY_INFO_NOISE_DBM;
+
+		ath10k_hw_fill_survey_time(ar,
+					   survey,
+					   cycle_count,
+					   rx_clear_count,
+					   ar->survey_last_cycle_count,
+					   ar->survey_last_rx_clear_count);
 	}
 
 	ar->survey_last_rx_clear_count = rx_clear_count;
-- 
2.1.4

