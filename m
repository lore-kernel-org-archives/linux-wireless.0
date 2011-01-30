Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:42246 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab1A3STf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:19:35 -0500
Message-ID: <4D45A5B7.9010203@davizone.at>
Date: Sun, 30 Jan 2011 18:53:59 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 06/18] wl1251: enable beacon early termination while in power-saving
 mode
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Port the beacon early termination feature from wl1251 driver version
included in the Maemo Fremantle kernel.
It is enabled when going to power-saving mode and disabled when leaving
power-saving mode.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/wl1251/acx.c    |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl1251/acx.h    |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/wl1251/ps.c     |   11 +++++++++++
 drivers/net/wireless/wl1251/wl1251.h |    2 ++
 4 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index 960149e..f1e90e1 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -1013,6 +1013,34 @@ out:
 	return ret;
 }
 +int wl1251_acx_bet_enable(struct wl1251 *wl, enum wl1251_acx_bet_mode mode,
+			  u8 max_consecutive)
+{
+	struct wl1251_acx_bet_enable *acx;
+	int ret;
+
+	wl1251_debug(DEBUG_ACX, "acx bet enable");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->enable = mode;
+	acx->max_consecutive = max_consecutive;
+
+	ret = wl1251_cmd_configure(wl, ACX_BET_ENABLE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1251_warning("wl1251 acx bet enable failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifs, u16 txop)
 {
diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/wl1251/acx.h
index 04d4073..5a44c76 100644
--- a/drivers/net/wireless/wl1251/acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
@@ -1165,6 +1165,31 @@ struct wl1251_acx_wr_tbtt_and_dtim {
 	u8  padding;
 } __packed;
 +enum wl1251_acx_bet_mode {
+	WL1251_ACX_BET_DISABLE = 0,
+	WL1251_ACX_BET_ENABLE = 1,
+};
+
+struct wl1251_acx_bet_enable {
+	struct acx_header header;
+
+	/*
+	 * Specifies if beacon early termination procedure is enabled or
+	 * disabled, see enum wl1251_acx_bet_mode.
+	 */
+	u8 enable;
+
+	/*
+	 * Specifies the maximum number of consecutive beacons that may be
+	 * early terminated. After this number is reached at least one full
+	 * beacon must be correctly received in FW before beacon ET
+	 * resumes. Range 0 - 255.
+	 */
+	u8 max_consecutive;
+
+	u8 padding[2];
+} __packed;
+
 struct wl1251_acx_ac_cfg {
 	struct acx_header header;
 @@ -1403,6 +1428,8 @@ int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime);
 int wl1251_acx_rate_policies(struct wl1251 *wl);
 int wl1251_acx_mem_cfg(struct wl1251 *wl);
 int wl1251_acx_wr_tbtt_and_dtim(struct wl1251 *wl, u16 tbtt, u8 dtim);
+int wl1251_acx_bet_enable(struct wl1251 *wl, enum wl1251_acx_bet_mode mode,
+			  u8 max_consecutive);
 int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifs, u16 txop);
 int wl1251_acx_tid_cfg(struct wl1251 *wl, u8 queue,
diff --git a/drivers/net/wireless/wl1251/ps.c b/drivers/net/wireless/wl1251/ps.c
index 5ed47c8..9ba23ed 100644
--- a/drivers/net/wireless/wl1251/ps.c
+++ b/drivers/net/wireless/wl1251/ps.c
@@ -153,6 +153,11 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum
wl1251_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 +		ret = wl1251_acx_bet_enable(wl, WL1251_ACX_BET_ENABLE,
+					    WL1251_DEFAULT_BET_CONSECUTIVE);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1251_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
@@ -170,6 +175,12 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum
wl1251_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 +		/* disable BET */
+		ret = wl1251_acx_bet_enable(wl, WL1251_ACX_BET_DISABLE,
+					    WL1251_DEFAULT_BET_CONSECUTIVE);
+		if (ret < 0)
+			return ret;
+
 		/* disable beacon filtering */
 		ret = wl1251_acx_beacon_filter_opt(wl, false);
 		if (ret < 0)
diff --git a/drivers/net/wireless/wl1251/wl1251.h
b/drivers/net/wireless/wl1251/wl1251.h
index 04e8f7c..fc778a7 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -421,6 +421,8 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
  #define WL1251_DEFAULT_CHANNEL 0
 +#define WL1251_DEFAULT_BET_CONSECUTIVE 10
+
 #define CHIP_ID_1251_PG10	           (0x7010101)
 #define CHIP_ID_1251_PG11	           (0x7020101)
 #define CHIP_ID_1251_PG12	           (0x7030101)
-- 
1.7.0.4


