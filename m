Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbXK2DKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:52 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 17/36] iwlwifi: Clean up unused definitions in iwl-3945-hw.h
Date: Thu, 29 Nov 2007 11:09:57 +0800
Message-Id: <1196305816-23023-18-git-send-email-yi.zhu@intel.com> (sfid-20071129_033544_883429_2201B98E)
In-Reply-To: <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
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
index 9526129..ea4bdd8 100644
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
1.5.3.6
