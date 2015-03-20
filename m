Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33057 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbbCTN4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:54 -0400
Received: by lbbrr9 with SMTP id rr9so11374187lbb.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:52 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/9] ath10k: add hw rate definitions
Date: Fri, 20 Mar 2015 13:54:10 +0000
Message-Id: <1426859655-11797-5-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145714_835969_E5B11409)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepare defines for future use.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h     |  1 +
 drivers/net/wireless/ath/ath10k/hw.h      | 21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/rx_desc.h | 22 ++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 874bf44..923d173 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -25,6 +25,7 @@
 #include <net/mac80211.h>
 
 #include "htc.h"
+#include "hw.h"
 #include "rx_desc.h"
 
 enum htt_dbg_stats_type {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 7f04645..70c6ed9 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -180,6 +180,27 @@ struct ath10k_pktlog_hdr {
 	u8 payload[0];
 } __packed;
 
+enum ath10k_hw_rate_ofdm {
+	ATH10K_HW_RATE_OFDM_48M = 0,
+	ATH10K_HW_RATE_OFDM_24M,
+	ATH10K_HW_RATE_OFDM_12M,
+	ATH10K_HW_RATE_OFDM_6M,
+	ATH10K_HW_RATE_OFDM_54M,
+	ATH10K_HW_RATE_OFDM_36M,
+	ATH10K_HW_RATE_OFDM_18M,
+	ATH10K_HW_RATE_OFDM_9M,
+};
+
+enum ath10k_hw_rate_cck {
+	ATH10K_HW_RATE_CCK_LP_11M = 0,
+	ATH10K_HW_RATE_CCK_LP_5_5M,
+	ATH10K_HW_RATE_CCK_LP_2M,
+	ATH10K_HW_RATE_CCK_LP_1M,
+	ATH10K_HW_RATE_CCK_SP_11M,
+	ATH10K_HW_RATE_CCK_SP_5_5M,
+	ATH10K_HW_RATE_CCK_SP_2M,
+};
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index e9cc778..492b5a5 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -661,6 +661,28 @@ struct rx_msdu_end {
 #define RX_PPDU_START_INFO5_SERVICE_MASK 0x0000ffff
 #define RX_PPDU_START_INFO5_SERVICE_LSB  0
 
+/* No idea what this flag means. It seems to be always set in rate. */
+#define RX_PPDU_START_RATE_FLAG BIT(3)
+
+enum rx_ppdu_start_rate {
+	RX_PPDU_START_RATE_OFDM_48M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_48M,
+	RX_PPDU_START_RATE_OFDM_24M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_24M,
+	RX_PPDU_START_RATE_OFDM_12M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_12M,
+	RX_PPDU_START_RATE_OFDM_6M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_6M,
+	RX_PPDU_START_RATE_OFDM_54M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_54M,
+	RX_PPDU_START_RATE_OFDM_36M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_36M,
+	RX_PPDU_START_RATE_OFDM_18M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_18M,
+	RX_PPDU_START_RATE_OFDM_9M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_9M,
+
+	RX_PPDU_START_RATE_CCK_LP_11M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_11M,
+	RX_PPDU_START_RATE_CCK_LP_5_5M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_5_5M,
+	RX_PPDU_START_RATE_CCK_LP_2M   = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_2M,
+	RX_PPDU_START_RATE_CCK_LP_1M   = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_1M,
+	RX_PPDU_START_RATE_CCK_SP_11M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_SP_11M,
+	RX_PPDU_START_RATE_CCK_SP_5_5M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_SP_5_5M,
+	RX_PPDU_START_RATE_CCK_SP_2M   = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_SP_2M,
+};
+
 struct rx_ppdu_start {
 	struct {
 		u8 pri20_mhz;
-- 
2.1.4

