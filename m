Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51931 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaKXO3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:29:39 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5818394wid.15
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:29:38 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: put board size into hw_params
Date: Mon, 24 Nov 2014 15:17:25 +0100
Message-Id: <1416838646-18801-2-git-send-email-michal.kazior@tieto.com> (sfid-20141124_152944_941645_2AE46294)
In-Reply-To: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to extend the list of
supported hardware.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 +++++---
 drivers/net/wireless/ath/ath10k/core.h | 2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 3904ce3..204aa04 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -63,6 +63,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.fw = QCA988X_HW_2_0_FW_FILE,
 			.otp = QCA988X_HW_2_0_OTP_FILE,
 			.board = QCA988X_HW_2_0_BOARD_DATA_FILE,
+			.board_size = QCA988X_BOARD_DATA_SZ,
+			.board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
 		},
 	},
 };
@@ -156,8 +158,8 @@ static const struct firmware *ath10k_fetch_fw_file(struct ath10k *ar,
 static int ath10k_push_board_ext_data(struct ath10k *ar, const void *data,
 				      size_t data_len)
 {
-	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
-	u32 board_ext_data_size = QCA988X_BOARD_EXT_DATA_SZ;
+	u32 board_data_size = ar->hw_params.fw.board_size;
+	u32 board_ext_data_size = ar->hw_params.fw.board_ext_size;
 	u32 board_ext_data_addr;
 	int ret;
 
@@ -203,7 +205,7 @@ static int ath10k_push_board_ext_data(struct ath10k *ar, const void *data,
 static int ath10k_download_board_data(struct ath10k *ar, const void *data,
 				      size_t data_len)
 {
-	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
+	u32 board_data_size = ar->hw_params.fw.board_size;
 	u32 address;
 	int ret;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d37ffd6..1cc81e8 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -482,6 +482,8 @@ struct ath10k {
 			const char *fw;
 			const char *otp;
 			const char *board;
+			size_t board_size;
+			size_t board_ext_size;
 		} fw;
 	} hw_params;
 
-- 
1.8.5.3

