Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:59414 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbKPOF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/19] staging/wilc1000: avoid static definitions in header
Date: Mon, 16 Nov 2015 15:04:57 +0100
Message-Id: <1447682710-2908925-7-git-send-email-arnd@arndb.de> (sfid-20151116_150810_636550_F2B1145F)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wilc_wfi_cfgoperations.h header defines the ieee80211_txrx_stypes
and cipher_suites variables that are only used in wilc_wfi_cfgoperations.c
and should not be shared in a header file.

This moves over all that data into the .c file, and also moves all
the macro definitions from the file that are also not needed here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 84 +++++++++++++++++++++++
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 83 ----------------------
 2 files changed, 84 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 49b82b4a0688..46c3f578a6fd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -17,6 +17,90 @@
 #include "host_interface.h"
 #include <linux/errno.h>
 
+/* The following macros describe the bitfield map used by the firmware to determine its 11i mode */
+#define NO_ENCRYPT		0
+#define ENCRYPT_ENABLED		BIT(0)
+#define WEP			BIT(1)
+#define WEP_EXTENDED		BIT(2)
+#define WPA			BIT(3)
+#define WPA2			BIT(4)
+#define AES			BIT(5)
+#define TKIP			BIT(6)
+
+/*Public action frame index IDs*/
+#define FRAME_TYPE_ID			0
+#define ACTION_CAT_ID			24
+#define ACTION_SUBTYPE_ID		25
+#define P2P_PUB_ACTION_SUBTYPE		30
+
+/*Public action frame Attribute IDs*/
+#define ACTION_FRAME			0xd0
+#define GO_INTENT_ATTR_ID		0x04
+#define CHANLIST_ATTR_ID		0x0b
+#define OPERCHAN_ATTR_ID		0x11
+#define PUB_ACTION_ATTR_ID		0x04
+#define P2PELEM_ATTR_ID			0xdd
+
+/*Public action subtype values*/
+#define GO_NEG_REQ			0x00
+#define GO_NEG_RSP			0x01
+#define GO_NEG_CONF			0x02
+#define P2P_INV_REQ			0x03
+#define P2P_INV_RSP			0x04
+#define PUBLIC_ACT_VENDORSPEC		0x09
+#define GAS_INTIAL_REQ			0x0a
+#define GAS_INTIAL_RSP			0x0b
+
+#define INVALID_CHANNEL			0
+
+#define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
+#define SCAN_RESULT_EXPIRE		(40 * HZ)
+
+static const u32 cipher_suites[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+	WLAN_CIPHER_SUITE_AES_CMAC,
+};
+
+static const struct ieee80211_txrx_stypes
+	wilc_wfi_cfg80211_mgmt_types[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+			BIT(IEEE80211_STYPE_ACTION >> 4)
+	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4)
+	}
+};
+
+/* Time to stay on the channel */
+#define WILC_WFI_DWELL_PASSIVE 100
+#define WILC_WFI_DWELL_ACTIVE  40
+
+#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
+#define DEFAULT_LINK_SPEED			72
+
+
 #define IS_MANAGMEMENT				0x100
 #define IS_MANAGMEMENT_CALLBACK			0x080
 #define IS_MGMT_STATUS_SUCCES			0x040
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index ae2aaea508db..158d98c0eb87 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -10,86 +10,6 @@
 #define NM_WFI_CFGOPERATIONS
 #include "wilc_wfi_netdevice.h"
 
-/* The following macros describe the bitfield map used by the firmware to determine its 11i mode */
-#define NO_ENCRYPT		0
-#define ENCRYPT_ENABLED		BIT(0)
-#define WEP			BIT(1)
-#define WEP_EXTENDED		BIT(2)
-#define WPA			BIT(3)
-#define WPA2			BIT(4)
-#define AES			BIT(5)
-#define TKIP			BIT(6)
-
-/*Public action frame index IDs*/
-#define FRAME_TYPE_ID			0
-#define ACTION_CAT_ID			24
-#define ACTION_SUBTYPE_ID		25
-#define P2P_PUB_ACTION_SUBTYPE		30
-
-/*Public action frame Attribute IDs*/
-#define ACTION_FRAME			0xd0
-#define GO_INTENT_ATTR_ID		0x04
-#define CHANLIST_ATTR_ID		0x0b
-#define OPERCHAN_ATTR_ID		0x11
-#define PUB_ACTION_ATTR_ID		0x04
-#define P2PELEM_ATTR_ID			0xdd
-
-/*Public action subtype values*/
-#define GO_NEG_REQ			0x00
-#define GO_NEG_RSP			0x01
-#define GO_NEG_CONF			0x02
-#define P2P_INV_REQ			0x03
-#define P2P_INV_RSP			0x04
-#define PUBLIC_ACT_VENDORSPEC		0x09
-#define GAS_INTIAL_REQ			0x0a
-#define GAS_INTIAL_RSP			0x0b
-
-#define INVALID_CHANNEL			0
-
-#define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
-#define SCAN_RESULT_EXPIRE		(40 * HZ)
-
-static const u32 cipher_suites[] = {
-	WLAN_CIPHER_SUITE_WEP40,
-	WLAN_CIPHER_SUITE_WEP104,
-	WLAN_CIPHER_SUITE_TKIP,
-	WLAN_CIPHER_SUITE_CCMP,
-	WLAN_CIPHER_SUITE_AES_CMAC,
-};
-
-static const struct ieee80211_txrx_stypes
-	wilc_wfi_cfg80211_mgmt_types[NUM_NL80211_IFTYPES] = {
-	[NL80211_IFTYPE_STATION] = {
-		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-			BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
-	},
-	[NL80211_IFTYPE_AP] = {
-		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
-			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
-			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
-			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
-			BIT(IEEE80211_STYPE_AUTH >> 4) |
-			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
-			BIT(IEEE80211_STYPE_ACTION >> 4)
-	},
-	[NL80211_IFTYPE_P2P_CLIENT] = {
-		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
-			BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
-			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
-			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
-			BIT(IEEE80211_STYPE_AUTH >> 4) |
-			BIT(IEEE80211_STYPE_DEAUTH >> 4)
-	}
-};
-
-/* Time to stay on the channel */
-#define WILC_WFI_DWELL_PASSIVE 100
-#define WILC_WFI_DWELL_ACTIVE  40
-
 struct wireless_dev *wilc_create_wiphy(struct net_device *net);
 void wilc_free_wiphy(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
@@ -101,7 +21,4 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      u16 frame_type, bool reg);
 
-#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
-#define DEFAULT_LINK_SPEED			72
-
 #endif
-- 
2.1.0.rc2

