Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34569 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab1KKKSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:18:03 -0500
Subject: [PATCH 04/10] ath6kl: update ar6004 definitions
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:17:59 +0200
Message-ID: <20111111101759.12075.56620.stgit@localhost6.localdomain6> (sfid-20111111_111807_443500_62CAA779)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add also hw 1.1.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h   |   18 +++++++++++++-----
 drivers/net/wireless/ath/ath6kl/target.h |    9 ++++++---
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c08c02e..415fa00 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -114,11 +114,19 @@ struct ath6kl_fw_ie {
 
 /* AR6004 1.0 definitions */
 #define AR6004_REV1_VERSION                 0x30000623
-#define AR6004_REV1_FIRMWARE_FILE           "ath6k/AR6004/hw6.1/fw.ram.bin"
-#define AR6004_REV1_FIRMWARE_2_FILE         "ath6k/AR6004/hw6.1/fw-2.bin"
-#define AR6004_REV1_BOARD_DATA_FILE         "ath6k/AR6004/hw6.1/bdata.bin"
-#define AR6004_REV1_DEFAULT_BOARD_DATA_FILE "ath6k/AR6004/hw6.1/bdata.DB132.bin"
-#define AR6004_REV1_EPPING_FIRMWARE_FILE "ath6k/AR6004/hw6.1/endpointping.bin"
+#define AR6004_REV1_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.0/fw-2.bin"
+#define AR6004_REV1_FIRMWARE_FILE           "ath6k/AR6004/hw1.0/fw.ram.bin"
+#define AR6004_REV1_BOARD_DATA_FILE         "ath6k/AR6004/hw1.0/bdata.bin"
+#define AR6004_REV1_DEFAULT_BOARD_DATA_FILE \
+	"ath6k/AR6004/hw1.0/bdata.DB132.bin"
+
+/* AR6004 1.1 definitions */
+#define AR6004_REV2_VERSION                 0x30000001
+#define AR6004_REV2_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.1/fw-2.bin"
+#define AR6004_REV2_FIRMWARE_FILE           "ath6k/AR6004/hw1.1/fw.ram.bin"
+#define AR6004_REV2_BOARD_DATA_FILE         "ath6k/AR6004/hw1.1/bdata.bin"
+#define AR6004_REV2_DEFAULT_BOARD_DATA_FILE \
+	"ath6k/AR6004/hw1.1/bdata.DB132.bin"
 
 /* Per STA data, used in AP mode */
 #define STA_PS_AWAKE		BIT(0)
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 687e2b3..35478d4 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -20,7 +20,7 @@
 #define AR6003_BOARD_DATA_SZ		1024
 #define AR6003_BOARD_EXT_DATA_SZ	768
 
-#define AR6004_BOARD_DATA_SZ     7168
+#define AR6004_BOARD_DATA_SZ     6144
 #define AR6004_BOARD_EXT_DATA_SZ 0
 
 #define RESET_CONTROL_ADDRESS		0x00000000
@@ -344,9 +344,12 @@ struct host_interest {
 #define AR6003_REV3_DATASET_PATCH_ADDRESS       0x57FF74
 #define AR6003_REV3_RAM_RESERVE_SIZE            512
 
-#define AR6004_REV1_BOARD_DATA_ADDRESS          0x435400
+#define AR6004_REV1_BOARD_DATA_ADDRESS          0x433900
 #define AR6004_REV1_BOARD_EXT_DATA_ADDRESS      0x437000
-#define AR6004_REV1_RAM_RESERVE_SIZE            11264
+#define AR6004_REV1_RAM_RESERVE_SIZE            19456
+
+#define AR6004_REV2_BOARD_DATA_ADDRESS          0x43d400
+#define AR6004_REV2_RAM_RESERVE_SIZE            11264
 
 #define ATH6KL_FWLOG_PAYLOAD_SIZE		1500
 

