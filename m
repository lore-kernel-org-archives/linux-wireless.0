Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59603 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab3CLNpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:34 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id r2CDjYJi017091
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:34 -0500
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r2CDjYrn017346
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:34 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Igal Chernobelsky <igalc@ti.com>
Subject: [PATCH 02/13] wlcore: set max num of Rx BA sessions per chip
Date: Tue, 12 Mar 2013 15:44:13 +0200
Message-ID: <1363095864-24422-3-git-send-email-coelho@ti.com> (sfid-20130312_144601_573232_3706F98F)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Maximum number of supported RX BA sessions depends on chip type.
wl18xx supports 5 RX BA sessions while wl12xx supports 3.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    2 ++
 drivers/net/wireless/ti/wl18xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    4 +++-
 drivers/net/wireless/ti/wlcore/acx.h    |    2 --
 drivers/net/wireless/ti/wlcore/main.c   |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 7 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 09694e3..1c627da 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -723,6 +723,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 	wl->sched_scan_templ_id_2_4 = CMD_TEMPL_CFG_PROBE_REQ_2_4;
 	wl->sched_scan_templ_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
 	wl->max_channels_5 = WL12XX_MAX_CHANNELS_5GHZ;
+	wl->ba_rx_session_count_max = WL12XX_RX_BA_MAX_SESSIONS;
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index d455285..222d035 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -63,6 +63,8 @@
 
 #define WL12XX_NUM_MAC_ADDRESSES 2
 
+#define WL12XX_RX_BA_MAX_SESSIONS 3
+
 struct wl127x_rx_mem_pool_addr {
 	u32 addr;
 	u32 addr_extra;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index da3ef1b..b670776 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -678,6 +678,7 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 	wl->sched_scan_templ_id_2_4 = CMD_TEMPL_PROBE_REQ_2_4_PERIODIC;
 	wl->sched_scan_templ_id_5 = CMD_TEMPL_PROBE_REQ_5_PERIODIC;
 	wl->max_channels_5 = WL18XX_MAX_CHANNELS_5GHZ;
+	wl->ba_rx_session_count_max = WL18XX_RX_BA_MAX_SESSIONS;
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index b6739e7..9204e07 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -29,7 +29,7 @@
 #define WL18XX_IFTYPE_VER	5
 #define WL18XX_MAJOR_VER	WLCORE_FW_VER_IGNORE
 #define WL18XX_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
-#define WL18XX_MINOR_VER	28
+#define WL18XX_MINOR_VER	39
 
 #define WL18XX_CMD_MAX_SIZE          740
 
@@ -40,6 +40,8 @@
 
 #define WL18XX_NUM_MAC_ADDRESSES 3
 
+#define WL18XX_RX_BA_MAX_SESSIONS 5
+
 struct wl18xx_priv {
 	/* buffer for sending commands to FW */
 	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 126536c..1a61e85 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -728,8 +728,6 @@ struct wl1271_acx_ht_information {
 	u8 padding[2];
 } __packed;
 
-#define RX_BA_MAX_SESSIONS 3
-
 struct wl1271_acx_ba_initiator_policy {
 	struct acx_header header;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2c2ff3e..3fc86c4 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4784,7 +4784,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 			break;
 		}
 
-		if (wl->ba_rx_session_count >= RX_BA_MAX_SESSIONS) {
+		if (wl->ba_rx_session_count >= wl->ba_rx_session_count_max) {
 			ret = -EBUSY;
 			wl1271_error("exceeded max RX BA sessions");
 			break;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index af9feca..0034979 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -390,6 +390,9 @@ struct wl1271 {
 	/* number of currently active RX BA sessions */
 	int ba_rx_session_count;
 
+	/* Maximum number of supported RX BA sessions */
+	int ba_rx_session_count_max;
+
 	/* AP-mode - number of currently connected stations */
 	int active_sta_count;
 
-- 
1.7.10.4

