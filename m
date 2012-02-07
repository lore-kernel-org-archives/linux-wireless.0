Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58357 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2BGW4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 17:56:52 -0500
From: Prasanna Kumar <kumarpra@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] add support for AR6003 2048 byte board file
Date: Tue, 7 Feb 2012 14:58:54 -0800
Message-ID: <1328655534-8660-1-git-send-email-kumarpra@qca.qualcomm.com> (sfid-20120207_235656_947051_2ABB5556)
In-Reply-To: <no>
References: <no>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR6003 2.1.1 supports both 1792 and 2048 byte board files.
Add support for 2048 byte board file.

Signed-off-by: Prasanna Kumar <kumarpra@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c   |    2 ++
 drivers/net/wireless/ath/ath6kl/target.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d1d89b5..47b9897 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1142,6 +1142,8 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	case TARGET_TYPE_AR6003:
 		board_data_size = AR6003_BOARD_DATA_SZ;
 		board_ext_data_size = AR6003_BOARD_EXT_DATA_SZ;
+		if (ar->fw_board_len > (board_data_size + board_ext_data_size))
+			board_ext_data_size = AR6003_BOARD_EXT_DATA_SZ_V2;
 		break;
 	case TARGET_TYPE_AR6004:
 		board_data_size = AR6004_BOARD_DATA_SZ;
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 108a723..b51cd19 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -19,6 +19,7 @@
 
 #define AR6003_BOARD_DATA_SZ		1024
 #define AR6003_BOARD_EXT_DATA_SZ	768
+#define AR6003_BOARD_EXT_DATA_SZ_V2	1024
 
 #define AR6004_BOARD_DATA_SZ     6144
 #define AR6004_BOARD_EXT_DATA_SZ 0
-- 
1.7.0.2

