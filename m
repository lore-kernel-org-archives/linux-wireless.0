Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:48814 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3I0Qy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 12:54:57 -0400
Subject: [PATCH v3 1/3] ath10k: rename board_data in struct ath10k
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 19:54:55 +0300
Message-ID: <20130927165455.2570.86725.stgit@localhost6.localdomain6> (sfid-20130927_185500_346041_0389AB84)
In-Reply-To: <20130927164636.2570.24076.stgit@localhost6.localdomain6>
References: <20130927164636.2570.24076.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will use board_data for something else in the following patch
so I need to rename it.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   18 +++++++++---------
 drivers/net/wireless/ath/ath10k/core.h |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 76906d5..e07c487 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -236,7 +236,7 @@ static int ath10k_push_board_ext_data(struct ath10k *ar,
 
 static int ath10k_download_board_data(struct ath10k *ar)
 {
-	const struct firmware *fw = ar->board_data;
+	const struct firmware *fw = ar->board;
 	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
 	u32 address;
 	int ret;
@@ -319,8 +319,8 @@ exit:
 
 static void ath10k_core_free_firmware_files(struct ath10k *ar)
 {
-	if (ar->board_data && !IS_ERR(ar->board_data))
-		release_firmware(ar->board_data);
+	if (ar->board && !IS_ERR(ar->board))
+		release_firmware(ar->board);
 
 	if (ar->otp && !IS_ERR(ar->otp))
 		release_firmware(ar->otp);
@@ -328,7 +328,7 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	if (ar->firmware && !IS_ERR(ar->firmware))
 		release_firmware(ar->firmware);
 
-	ar->board_data = NULL;
+	ar->board = NULL;
 	ar->otp = NULL;
 	ar->firmware = NULL;
 }
@@ -347,11 +347,11 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 		return -EINVAL;
 	}
 
-	ar->board_data = ath10k_fetch_fw_file(ar,
-					      ar->hw_params.fw.dir,
-					      ar->hw_params.fw.board);
-	if (IS_ERR(ar->board_data)) {
-		ret = PTR_ERR(ar->board_data);
+	ar->board = ath10k_fetch_fw_file(ar,
+					 ar->hw_params.fw.dir,
+					 ar->hw_params.fw.board);
+	if (IS_ERR(ar->board)) {
+		ret = PTR_ERR(ar->board);
 		ath10k_err("could not fetch board data (%d)\n", ret);
 		goto err;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 292ad45..12b03b6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -324,7 +324,7 @@ struct ath10k {
 		} fw;
 	} hw_params;
 
-	const struct firmware *board_data;
+	const struct firmware *board;
 	const struct firmware *otp;
 	const struct firmware *firmware;
 

