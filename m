Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbXLCLpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:12 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 16/34] iwlwifi: Clean up unused definitions in iwl-3945-hw.h
Date: Mon,  3 Dec 2007 13:43:28 +0200
Message-Id: <1196682231211-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114519_189657_CE7262CF)
In-Reply-To: <1196682230754-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Clean up unused definitions in iwl-3945-hw.h

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |  130 +---------------------------
 1 files changed, 1 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 6e961ac..b63cd72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -102,10 +102,6 @@
 #define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
 #define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
 
-/* EEPROM field values */
-#define ANTENNA_SWITCH_NORMAL     0
-#define ANTENNA_SWITCH_INVERSE    1
-
 /*
  * Regulatory channel usage flags in EEPROM struct iwl_eeprom_channel.flags.
  *
@@ -127,31 +123,10 @@ enum {
 	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
 	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
 	EEPROM_CHANNEL_WIDE = (1 << 5),		/* 20 MHz channel okay */
-	EEPROM_CHANNEL_NARROW = (1 << 6),	/* 10 MHz channel, not used */
+	EEPROM_CHANNEL_NARROW = (1 << 6),	/* 10 MHz channel (not used) */
 	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
 };
 
-/* EEPROM field lengths */
-#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
-
-/* EEPROM field lengths */
-#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
-#define EEPROM_REGULATORY_SKU_ID_LENGTH                 4
-#define EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH         14
-#define EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH         13
-#define EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH         12
-#define EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH         11
-#define EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH         6
-
-#define EEPROM_REGULATORY_CHANNELS_LENGTH ( \
-	EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH)
-
-#define EEPROM_REGULATORY_NUMBER_OF_BANDS               5
-
 /* SKU Capabilities */
 #define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
 #define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
@@ -646,15 +621,7 @@ struct iwl3945_eeprom {
 /* spectrum and channel data structures */
 #define IWL_NUM_SCAN_RATES         (2)
 
-#define IWL_SCAN_FLAG_24GHZ  (1<<0)
-#define IWL_SCAN_FLAG_52GHZ  (1<<1)
-#define IWL_SCAN_FLAG_ACTIVE (1<<2)
-#define IWL_SCAN_FLAG_DIRECT (1<<3)
-
-#define IWL_MAX_CMD_SIZE 1024
-
 #define IWL_DEFAULT_TX_RETRY  15
-#define IWL_MAX_TX_RETRY      16
 
 /*********************************************/
 
@@ -665,101 +632,6 @@ struct iwl3945_eeprom {
 #define RX_QUEUE_MASK                         255
 #define RX_QUEUE_SIZE_LOG                     8
 
-/* QoS  definitions */
-
-#define CW_MIN_OFDM          15
-#define CW_MAX_OFDM          1023
-#define CW_MIN_CCK           31
-#define CW_MAX_CCK           1023
-
-#define QOS_TX0_CW_MIN_OFDM      CW_MIN_OFDM
-#define QOS_TX1_CW_MIN_OFDM      CW_MIN_OFDM
-#define QOS_TX2_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
-#define QOS_TX3_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 4 - 1)
-
-#define QOS_TX0_CW_MIN_CCK       CW_MIN_CCK
-#define QOS_TX1_CW_MIN_CCK       CW_MIN_CCK
-#define QOS_TX2_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
-#define QOS_TX3_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 4 - 1)
-
-#define QOS_TX0_CW_MAX_OFDM      CW_MAX_OFDM
-#define QOS_TX1_CW_MAX_OFDM      CW_MAX_OFDM
-#define QOS_TX2_CW_MAX_OFDM      CW_MIN_OFDM
-#define QOS_TX3_CW_MAX_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
-
-#define QOS_TX0_CW_MAX_CCK       CW_MAX_CCK
-#define QOS_TX1_CW_MAX_CCK       CW_MAX_CCK
-#define QOS_TX2_CW_MAX_CCK       CW_MIN_CCK
-#define QOS_TX3_CW_MAX_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
-
-#define QOS_TX0_AIFS            3
-#define QOS_TX1_AIFS            7
-#define QOS_TX2_AIFS            2
-#define QOS_TX3_AIFS            2
-
-#define QOS_TX0_ACM             0
-#define QOS_TX1_ACM             0
-#define QOS_TX2_ACM             0
-#define QOS_TX3_ACM             0
-
-#define QOS_TX0_TXOP_LIMIT_CCK          0
-#define QOS_TX1_TXOP_LIMIT_CCK          0
-#define QOS_TX2_TXOP_LIMIT_CCK          6016
-#define QOS_TX3_TXOP_LIMIT_CCK          3264
-
-#define QOS_TX0_TXOP_LIMIT_OFDM      0
-#define QOS_TX1_TXOP_LIMIT_OFDM      0
-#define QOS_TX2_TXOP_LIMIT_OFDM      3008
-#define QOS_TX3_TXOP_LIMIT_OFDM      1504
-
-#define DEF_TX0_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX1_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX2_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX3_CW_MIN_OFDM      CW_MIN_OFDM
-
-#define DEF_TX0_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX1_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX2_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX3_CW_MIN_CCK       CW_MIN_CCK
-
-#define DEF_TX0_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX1_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX2_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX3_CW_MAX_OFDM      CW_MAX_OFDM
-
-#define DEF_TX0_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX1_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX2_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX3_CW_MAX_CCK       CW_MAX_CCK
-
-#define DEF_TX0_AIFS            (2)
-#define DEF_TX1_AIFS            (2)
-#define DEF_TX2_AIFS            (2)
-#define DEF_TX3_AIFS            (2)
-
-#define DEF_TX0_ACM             0
-#define DEF_TX1_ACM             0
-#define DEF_TX2_ACM             0
-#define DEF_TX3_ACM             0
-
-#define DEF_TX0_TXOP_LIMIT_CCK        0
-#define DEF_TX1_TXOP_LIMIT_CCK        0
-#define DEF_TX2_TXOP_LIMIT_CCK        0
-#define DEF_TX3_TXOP_LIMIT_CCK        0
-
-#define DEF_TX0_TXOP_LIMIT_OFDM       0
-#define DEF_TX1_TXOP_LIMIT_OFDM       0
-#define DEF_TX2_TXOP_LIMIT_OFDM       0
-#define DEF_TX3_TXOP_LIMIT_OFDM       0
-
-#define QOS_QOS_SETS                  3
-#define QOS_PARAM_SET_ACTIVE          0
-#define QOS_PARAM_SET_DEF_CCK         1
-#define QOS_PARAM_SET_DEF_OFDM        2
-
-#define CTRL_QOS_NO_ACK               (0x0020)
-#define DCT_FLAG_EXT_QOS_ENABLED      (0x10)
-
 #define U32_PAD(n)		((4-(n))&0x3)
 
 /*
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
