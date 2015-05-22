Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36811 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbbEVISW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:18:22 -0400
Received: by wizk4 with SMTP id k4so39382218wiz.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 01:18:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/2] ath10k: handle cycle counter wraparound
Date: Fri, 22 May 2015 10:18:12 +0200
Message-Id: <1432282693-4553-1-git-send-email-michal.kazior@tieto.com> (sfid-20150522_101841_558812_5D2BF512)
In-Reply-To: <CA+BoTQ=V1psOoaL1WG7vSUjSLhPnQqBUODjeB3NyWt-pMtmNFA@mail.gmail.com>
References: <CA+BoTQ=V1psOoaL1WG7vSUjSLhPnQqBUODjeB3NyWt-pMtmNFA@mail.gmail.com>
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
it is possible to compute survey data.

This fixes some occasional incorrect survey data
on QCA988X as some channels (depending on how/when
scan/offchannel requests were requested) would
have approx 24 sec active time which wasn't
actually the case.

This should help make hostapd ACS more reliable.

Reported-by: Srinivasa Duvvuri <sduvvuri@chromium.org>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * split into 2 separate patches
     * don't ignore all wraparound data: scans can be computed
     * apply the shifted wraparound fix only for QCA988X
     * improve commit log

 drivers/net/wireless/ath/ath10k/core.c | 15 +++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h | 12 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 14 ++++++++++++--
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bcccae19325d..0cc2122d6921 100644
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
@@ -102,6 +103,20 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	},
 };
 
+void ath10k_core_get_cc_delta(struct ath10k *ar,
+			      u32 *cc_delta, u32 *rcc_delta,
+			      u32 cc, u32 rcc,
+			      u32 cc_prev, u32 rcc_prev)
+{
+	if (ar->hw_params.has_shifted_cc_wraparound && cc < cc_prev) {
+		cc_prev -= 0x7fffffff;
+		rcc *= 2;
+	}
+
+	*cc_delta = cc - cc_prev;
+	*rcc_delta = rcc - rcc_prev;
+}
+
 static void ath10k_send_suspend_complete(struct ath10k *ar)
 {
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot suspend complete\n");
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 827b3d79ed0c..fb403972b1c5 100644
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
@@ -742,4 +749,9 @@ void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar, u32 chip_id);
 void ath10k_core_unregister(struct ath10k *ar);
 
+void ath10k_core_get_cc_delta(struct ath10k *ar,
+			      u32 *cc_delta, u32 *rcc_delta,
+			      u32 cc, u32 rcc,
+			      u32 cc_prev, u32 rcc_prev);
+
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0fabe689179c..52ed48b7e5f9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1640,8 +1640,18 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 		 * visited channel. The reported cycle count is global
 		 * and per-channel cycle count must be calculated */
 
-		cycle_count -= ar->survey_last_cycle_count;
-		rx_clear_count -= ar->survey_last_rx_clear_count;
+		/* Worst case wraparound time is approx 24 seconds (2**31 /
+		 * 88MHz). Since scan channel visit times are max 5 seconds
+		 * (offchannel case) it is guaranteed there's been at most 1
+		 * wraparound and it is possible to compute survey data.
+		 */
+		ath10k_core_get_cc_delta(ar,
+					 &cycle_count,
+					 &rx_clear_count,
+					 cycle_count,
+					 rx_clear_count,
+					 ar->survey_last_cycle_count,
+					 ar->survey_last_rx_clear_count);
 
 		survey = &ar->survey[idx];
 		survey->time = WMI_CHAN_INFO_MSEC(cycle_count);
-- 
2.1.4

