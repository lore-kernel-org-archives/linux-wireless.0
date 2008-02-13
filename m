Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38651 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbYBMTfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 14:35:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/3] iwlwifi-2.6: Adds and fixes defines about security
Date: Wed, 13 Feb 2008 11:32:29 -0800
Message-Id: <1202931151-4141-2-git-send-email-reinette.chatre@intel.com> (sfid-20080213_193511_782385_4D1460EE)
In-Reply-To: <1202931151-4141-1-git-send-email-reinette.chatre@intel.com>
References: <1202931151-4141-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds some missing defines defines for HW security. It also fixes
the add_station host cmd layout.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   19 +++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   19 +++++++++++++------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 46bb2c7..20fbb32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -515,14 +515,20 @@ struct iwl3945_qosparam_cmd {
 #define STA_CONTROL_MODIFY_MSK		0x01
 
 /* key flags __le16*/
-#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x7)
-#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0)
-#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x1)
-#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x2)
-#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x3)
+#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x0007)
+#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0000)
+#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x0001)
+#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x0002)
+#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x0003)
 
 #define STA_KEY_FLG_KEYID_POS	8
 #define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
+/* wep key is either from global key (0) or from station info array (1) */
+#define STA_KEY_FLG_WEP_KEY_MAP_MSK  __constant_cpu_to_le16(0x0008)
+
+/* wep key in STA: 5-bytes (0) or 13-bytes (1) */
+#define STA_KEY_FLG_KEY_SIZE_MSK     __constant_cpu_to_le16(0x1000)
+#define STA_KEY_MULTICAST_MSK        __constant_cpu_to_le16(0x4000)
 
 /* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
@@ -546,7 +552,8 @@ struct iwl3945_keyinfo {
 	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
 	u8 reserved1;
 	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
-	__le16 reserved2;
+	u8 key_offset;
+	u8 reserved2;
 	u8 key[16];		/* 16-byte unicast decryption key */
 } __attribute__ ((packed));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 9edd8ab..b21ffea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -727,14 +727,20 @@ struct iwl4965_qosparam_cmd {
 #define STA_CONTROL_MODIFY_MSK		0x01
 
 /* key flags __le16*/
-#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x7)
-#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0)
-#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x1)
-#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x2)
-#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x3)
+#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x0007)
+#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0000)
+#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x0001)
+#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x0002)
+#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x0003)
 
 #define STA_KEY_FLG_KEYID_POS	8
 #define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
+/* wep key is either from global key (0) or from station info array (1) */
+#define STA_KEY_FLG_MAP_KEY_MSK	__constant_cpu_to_le16(0x0008)
+
+/* wep key in STA: 5-bytes (0) or 13-bytes (1) */
+#define STA_KEY_FLG_KEY_SIZE_MSK     __constant_cpu_to_le16(0x1000)
+#define STA_KEY_MULTICAST_MSK        __constant_cpu_to_le16(0x4000)
 
 /* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
@@ -752,7 +758,8 @@ struct iwl4965_keyinfo {
 	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
 	u8 reserved1;
 	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
-	__le16 reserved2;
+	u8 key_offset;
+	u8 reserved2;
 	u8 key[16];		/* 16-byte unicast decryption key */
 } __attribute__ ((packed));
 
-- 
1.5.3.4

