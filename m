Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49713 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab0KGJEX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 04:04:23 -0500
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id oA794MEa001167
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 7 Nov 2010 03:04:22 -0600
Received: from localhost.localdomain (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id oA794KFb024037
	for <linux-wireless@vger.kernel.org>; Sun, 7 Nov 2010 03:04:21 -0600 (CST)
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl1271: cleanup unused code of calibration structures
Date: Sun,  7 Nov 2010 11:04:20 +0200
Message-Id: <1289120660-25892-1-git-send-email-geryk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cleanup unused code for calibration procedures.

Signed-off-by: Gery Kahn <geryk@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.h |   48 ------------------------------
 1 files changed, 0 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index a0caf4f..27fd6a8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -327,9 +327,6 @@ enum wl1271_channel_tune_bands {
 
 #define WL1271_PD_REFERENCE_POINT_BAND_B_G  0
 
-#define TEST_CMD_P2G_CAL                    0x02
-#define TEST_CMD_CHANNEL_TUNE               0x0d
-#define TEST_CMD_UPDATE_PD_REFERENCE_POINT  0x1d
 #define TEST_CMD_INI_FILE_RADIO_PARAM       0x19
 #define TEST_CMD_INI_FILE_GENERAL_PARAM     0x1E
 #define TEST_CMD_INI_FILE_RF_EXTENDED_PARAM 0x26
@@ -375,51 +372,6 @@ struct wl1271_ext_radio_parms_cmd {
 	u8 padding[3];
 } __packed;
 
-struct wl1271_cmd_cal_channel_tune {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	u8 band;
-	u8 channel;
-
-	__le16 radio_status;
-} __packed;
-
-struct wl1271_cmd_cal_update_ref_point {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	__le32 ref_power;
-	__le32 ref_detector;
-	u8  sub_band;
-	u8  padding[3];
-} __packed;
-
-#define MAX_TLV_LENGTH         400
-#define	MAX_NVS_VERSION_LENGTH 12
-
-#define WL1271_CAL_P2G_BAND_B_G BIT(0)
-
-struct wl1271_cmd_cal_p2g {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	__le16 len;
-	u8  buf[MAX_TLV_LENGTH];
-	u8  type;
-	u8  padding;
-
-	__le16 radio_status;
-	u8  nvs_version[MAX_NVS_VERSION_LENGTH];
-
-	u8  sub_band_mask;
-	u8  padding2;
-} __packed;
-
-
 /*
  * There are three types of disconnections:
  *
-- 
1.7.0.4

