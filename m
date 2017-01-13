Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36255 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdAMVf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:35:29 -0500
Received: by mail-lf0-f68.google.com with SMTP id h65so7043284lfi.3
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:35:28 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 06/10] ath10k: disable frame aggregation for high latency
Date: Fri, 13 Jan 2017 22:35:05 +0100
Message-Id: <1484343309-6327-7-git-send-email-erik.stromdahl@gmail.com> (sfid-20170113_223539_570865_88DB47CD)
In-Reply-To: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
References: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch disables frame aggregation for HL interfaces.
It is safest to do so until a mechanism for setting the limits
from fw etc. has been implemented.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 9 +++++++--
 drivers/net/wireless/ath/ath10k/htt.h  | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c275a52..573e772 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1615,8 +1615,13 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		return -EINVAL;
 	}
 
-	ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
-	ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
+	if (ar->is_high_latency) {
+		ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_HL;
+		ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_HL;
+	} else {
+		ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
+		ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
+	}
 
 	if (rawmode) {
 		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 3d1bd6f..dd9e582 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1777,6 +1777,10 @@ struct htt_rx_desc {
 #define ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT 3
 #define ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT 64
 
+/* Disable frame aggregation for high latency devices */
+#define ATH10K_HTT_MAX_NUM_AMSDU_HL 1
+#define ATH10K_HTT_MAX_NUM_AMPDU_HL 1
+
 int ath10k_htt_connect(struct ath10k_htt *htt);
 int ath10k_htt_init(struct ath10k *ar);
 int ath10k_htt_setup(struct ath10k_htt *htt);
-- 
2.7.4
