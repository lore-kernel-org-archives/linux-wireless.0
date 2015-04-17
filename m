Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35242 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbDQJWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 05:22:42 -0400
Received: by lbbuc2 with SMTP id uc2so78064246lbb.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 02:22:40 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/2] ath10k: share board file loading code across FW APIs
Date: Fri, 17 Apr 2015 09:19:16 +0000
Message-Id: <1429262357-25139-1-git-send-email-michal.kazior@tieto.com> (sfid-20150417_112246_261035_88EE28C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to implement the same thing twice.
Reduce code duplication.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 68 +++++++++++++++-------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2d64926c8228..70f5b7acc411 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -482,6 +482,30 @@ static int ath10k_fetch_cal_file(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_core_fetch_board_file(struct ath10k *ar)
+{
+	int ret;
+
+	if (!ar->hw_params.fw.board) {
+		ath10k_err(ar, "failed to find board file fw entry\n");
+		return -EINVAL;
+	}
+
+	ar->board = ath10k_fetch_fw_file(ar,
+					 ar->hw_params.fw.dir,
+					 ar->hw_params.fw.board);
+	if (IS_ERR(ar->board)) {
+		ret = PTR_ERR(ar->board);
+		ath10k_err(ar, "failed to fetch board data: %d\n", ret);
+		return ret;
+	}
+
+	ar->board_data = ar->board->data;
+	ar->board_len = ar->board->size;
+
+	return 0;
+}
+
 static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
 {
 	int ret = 0;
@@ -491,23 +515,6 @@ static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
 		return -EINVAL;
 	}
 
-	if (ar->hw_params.fw.board == NULL) {
-		ath10k_err(ar, "board data file not defined");
-		return -EINVAL;
-	}
-
-	ar->board = ath10k_fetch_fw_file(ar,
-					 ar->hw_params.fw.dir,
-					 ar->hw_params.fw.board);
-	if (IS_ERR(ar->board)) {
-		ret = PTR_ERR(ar->board);
-		ath10k_err(ar, "could not fetch board data (%d)\n", ret);
-		goto err;
-	}
-
-	ar->board_data = ar->board->data;
-	ar->board_len = ar->board->size;
-
 	ar->firmware = ath10k_fetch_fw_file(ar,
 					    ar->hw_params.fw.dir,
 					    ar->hw_params.fw.fw);
@@ -706,27 +713,6 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 		goto err;
 	}
 
-	/* now fetch the board file */
-	if (ar->hw_params.fw.board == NULL) {
-		ath10k_err(ar, "board data file not defined");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	ar->board = ath10k_fetch_fw_file(ar,
-					 ar->hw_params.fw.dir,
-					 ar->hw_params.fw.board);
-	if (IS_ERR(ar->board)) {
-		ret = PTR_ERR(ar->board);
-		ath10k_err(ar, "could not fetch board data '%s/%s' (%d)\n",
-			   ar->hw_params.fw.dir, ar->hw_params.fw.board,
-			   ret);
-		goto err;
-	}
-
-	ar->board_data = ar->board->data;
-	ar->board_len = ar->board->size;
-
 	return 0;
 
 err:
@@ -741,6 +727,12 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 	/* calibration file is optional, don't check for any errors */
 	ath10k_fetch_cal_file(ar);
 
+	ret = ath10k_core_fetch_board_file(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to fetch board file: %d\n", ret);
+		return ret;
+	}
+
 	ar->fw_api = 5;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
-- 
2.1.4

