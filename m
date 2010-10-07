Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36525 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0JGNEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 09:04:11 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 01/03] wl1271: BA Initiator support, Add Definitions
Date: Thu,  7 Oct 2010 15:06:00 +0200
Message-Id: <1286456762-17480-2-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
References: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New acx cmd wl1271_acx_ba_session_policy to set BA policy to the FW.
Macros to use with BA setting.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   16 ++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index b8da1bc..6c3c7c0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1055,6 +1055,22 @@ struct wl1271_acx_ht_information {
 	u8 padding[3];
 } __packed;
 
+/*
+ * BA sessen interface structure
+ */
+struct wl1271_acx_ba_session_policy {
+	struct acx_header header;
+	/* Mac address of: SA as receiver / RA as initiator */
+	u8 mac_address[ETH_ALEN];
+	u8 tid;			/* TID */
+	u8 policy;		/* Enable / Disable */
+	u16 win_size;		/* windows size in num of packet */
+	u16 inactivity_timeout;	/* as initiator inactivity timeout
+				 * in time units(TU) of 1024us.
+				 * as receiver reserved
+				 */
+} __packed;
+
 struct wl1271_acx_fw_tsf_information {
 	struct acx_header header;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index b3e608e..63a0a9a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -94,6 +94,9 @@ enum {
 #define HW_BG_RATES_MASK	0xffff
 #define HW_HT_RATES_OFFSET	16
 
+#define BA_RECEIVER_WIN_SIZE 8
+#define BA_INACTIVITY_TIMEOUT 10000
+
 enum {
 	CONF_SG_DISABLE = 0,
 	CONF_SG_PROTECTIVE,
-- 
1.6.0.4

