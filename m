Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42745 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab1DDHFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 03:05:55 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p3475tpf011830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Apr 2011 02:05:55 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: FM WLAN coexistence
Date: Mon,  4 Apr 2011 10:07:40 +0300
Message-Id: <1301900860-19337-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to FM WLAN coexistence (STA only).
Few WiFi harmonics may interfere FM operation, to
avoid this problem special coexistence techniques are
activated around some FM frequencies.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   42 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   61 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/conf.h |   14 ++++++++
 drivers/net/wireless/wl12xx/init.c |    5 +++
 drivers/net/wireless/wl12xx/main.c |   17 ++++++++++
 5 files changed, 139 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index e005aa4..5f5afbe 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1604,3 +1604,45 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_fm_coex(struct wl1271 *wl)
+{
+	struct wl1271_acx_fm_coex *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx fm coex setting");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->enable = wl->conf.fm_coex.enable;
+	acx->swallow_period = wl->conf.fm_coex.swallow_period;
+	acx->n_divider_fref_set_1 = wl->conf.fm_coex.n_divider_fref_set_1;
+	acx->n_divider_fref_set_2 = wl->conf.fm_coex.n_divider_fref_set_2;
+	acx->m_divider_fref_set_1 =
+		cpu_to_le16(wl->conf.fm_coex.m_divider_fref_set_1);
+	acx->m_divider_fref_set_2 =
+		cpu_to_le16(wl->conf.fm_coex.m_divider_fref_set_2);
+	acx->coex_pll_stabilization_time =
+		cpu_to_le32(wl->conf.fm_coex.coex_pll_stabilization_time);
+	acx->ldo_stabilization_timwl12xx-fm-coex-v2/e =
+		cpu_to_le16(wl->conf.fm_coex.ldo_stabilization_time);
+	acx->fm_disturbed_band_margin =
+		wl->conf.fm_coex.fm_disturbed_band_margin;
+	acx->swallow_clk_diff = wl->conf.fm_coex.swallow_clk_diff;
+
+	ret = wl1271_cmd_configure(wl, ACX_FM_COEX_CFG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx fm coex setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 0a40cae..45242db 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1172,6 +1172,65 @@ struct wl1271_acx_inconnection_sta {
 	u8 padding1[2];
 } __packed;
 
+/*
+ * ACX_FM_COEX_CFG
+ * set the FM co-existence parameters.
+ */
+struct wl1271_acx_fm_coex {
+	struct acx_header header;
+	/* enable(1) / disable(0) the FM Coex feature */
+	u8 enable;
+	/*
+	 * Swallow period used in COEX PLL swallowing mechanism.
+	 * 0xFF = use FW default
+	 */
+	u8 swallow_period;
+	/*
+	 * The N divider used in COEX PLL swallowing mechanism for Fref of
+	 * 38.4/19.2 Mhz. 0xFF = use FW default
+	 */
+	u8 n_divider_fref_set_1;
+	/*
+	 * The N divider used in COEX PLL swallowing mechanism for Fref of
+	 * 26/52 Mhz. 0xFF = use FW default
+	 */
+	u8 n_divider_fref_set_2;
+	/*
+	 * The M divider used in COEX PLL swallowing mechanism for Fref of
+	 * 38.4/19.2 Mhz. 0xFFFF = use FW default
+	 */
+	u16 m_divider_fref_set_1;
+	/*
+	 * The M divider used in COEX PLL swallowing mechanism for Fref of
+	 * 26/52 Mhz. 0xFFFF = use FW default
+	 */
+	u16 m_divider_fref_set_2;
+	/*
+	 * The time duration in uSec required for COEX PLL to stabilize.
+	 * 0xFFFFFFFF = use FW default
+	 */
+	u32 coex_pll_stabilization_time;
+	/*
+	 * The time duration in uSec required for LDO to stabilize.
+	 * 0xFFFFFFFF = use FW default
+	 */
+	u16 ldo_stabilization_time;
+	/*
+	 * The disturbed frequency band margin around the disturbed frequency
+	 * center (single sided).
+	 * For example, if 2 is configured, the following channels will be
+	 * considered disturbed channel:
+	 *   80 +- 0.1 MHz, 91 +- 0.1 MHz, 98 +- 0.1 MHz, 102 +- 0.1 MH
+	 * 0xFF = use FW default
+	 */
+	u8 fm_disturbed_band_margin;
+	/*
+	 * The swallow clock difference of the swallowing mechanism.
+	 * 0xFF = use FW default
+	 */
+	u8 swallow_clk_diff;
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1201,6 +1260,7 @@ enum {
 	ACX_BCN_DTIM_OPTIONS        = 0x0031,
 	ACX_SG_ENABLE               = 0x0032,
 	ACX_SG_CFG                  = 0x0033,
+	ACX_FM_COEX_CFG             = 0x0034,
 	ACX_BEACON_FILTER_TABLE     = 0x0038,
 	ACX_ARP_IP_FILTER           = 0x0039,
 	ACX_ROAMING_STATISTICS_TBL  = 0x003B,
@@ -1310,5 +1370,6 @@ int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
+int wl1271_acx_fm_coex(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 743bd0b..44cbce6 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1193,6 +1193,19 @@ struct conf_memory_settings {
 	u8 tx_min;
 };
 
+struct conf_fm_coex {
+	u8 enable;
+	u8 swallow_period;
+	u8 n_divider_fref_set_1;
+	u8 n_divider_fref_set_2;
+	u16 m_divider_fref_set_1;
+	u16 m_divider_fref_set_2;
+	u32 coex_pll_stabilization_time;
+	u16 ldo_stabilization_time;
+	u8 fm_disturbed_band_margin;
+	u8 swallow_clk_diff;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1206,6 +1219,7 @@ struct conf_drv_settings {
 	struct conf_ht_setting ht;
 	struct conf_memory_settings mem_wl127x;
 	struct conf_memory_settings mem_wl128x;
+	struct conf_fm_coex fm_coex;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 2dbc083..7169d82 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -356,6 +356,11 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* FM WLAN coexistence */
+	ret = wl1271_acx_fm_coex(wl);
+	if (ret < 0)
+		return ret;
+
 	/* Beacons and broadcast settings */
 	ret = wl1271_init_beacon_broadcast(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..f4c0063 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -318,6 +318,18 @@ static struct conf_drv_settings default_conf = {
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
 	},
+	.fm_coex = {
+		.enable                       = true,
+		.swallow_period               = 5,
+		.n_divider_fref_set_1         = 0xff,       /* default */
+		.n_divider_fref_set_2         = 12,
+		.m_divider_fref_set_1         = 148,
+		.m_divider_fref_set_2         = 0xffff,     /* default */
+		.coex_pll_stabilization_time  = 0xffffffff, /* default */
+		.ldo_stabilization_time       = 0xffff,     /* default */
+		.fm_disturbed_band_margin     = 0xff,       /* default */
+		.swallow_clk_diff             = 0xff,       /* default */
+	},
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
@@ -505,6 +517,11 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* FM WLAN coexistence */
+	ret = wl1271_acx_fm_coex(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	/* Energy detection */
 	ret = wl1271_init_energy_detection(wl);
 	if (ret < 0)
-- 
1.7.0.4

