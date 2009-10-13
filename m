Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43381 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933777AbZJMJuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:09 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 03/22] wl1271: Add config structure for RX path parameters
Date: Tue, 13 Oct 2009 12:47:40 +0300
Message-Id: <1255427279-1224-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add a configuration structure for RX path parameters, and set default
configuration values there.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   20 ++++----
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   43 +--------------
 drivers/net/wireless/wl12xx/wl1271_conf.h |   85 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   12 ++++
 5 files changed, 110 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index d19d860..63aa646 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -198,7 +198,7 @@ int wl1271_acx_mem_map(struct wl1271 *wl, struct acx_header *mem_map,
 	return 0;
 }
 
-int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl, u32 life_time)
+int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl)
 {
 	struct acx_rx_msdu_lifetime *acx;
 	int ret;
@@ -211,7 +211,7 @@ int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl, u32 life_time)
 		goto out;
 	}
 
-	acx->lifetime = life_time;
+	acx->lifetime = wl->conf.rx.rx_msdu_life_time;
 	ret = wl1271_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
 				   acx, sizeof(*acx));
 	if (ret < 0) {
@@ -265,7 +265,7 @@ int wl1271_acx_pd_threshold(struct wl1271 *wl)
 		goto out;
 	}
 
-	/* FIXME: threshold value not set */
+	pd->threshold = wl->conf.rx.packet_detection_threshold;
 
 	ret = wl1271_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
 	if (ret < 0) {
@@ -349,8 +349,8 @@ int wl1271_acx_service_period_timeout(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_ACX, "acx service period timeout");
 
-	rx_timeout->ps_poll_timeout = RX_TIMEOUT_PS_POLL_DEF;
-	rx_timeout->upsd_timeout = RX_TIMEOUT_UPSD_DEF;
+	rx_timeout->ps_poll_timeout = wl->conf.rx.ps_poll_timeout;
+	rx_timeout->upsd_timeout = wl->conf.rx.upsd_timeout;
 
 	ret = wl1271_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
 				   rx_timeout, sizeof(*rx_timeout));
@@ -557,7 +557,7 @@ int wl1271_acx_cca_threshold(struct wl1271 *wl)
 		goto out;
 	}
 
-	detection->rx_cca_threshold = CCA_THRSH_DISABLE_ENERGY_D;
+	detection->rx_cca_threshold = wl->conf.rx.rx_cca_threshold;
 	detection->tx_energy_detection = 0;
 
 	ret = wl1271_cmd_configure(wl, ACX_CCA_THRESHOLD,
@@ -966,10 +966,10 @@ int wl1271_acx_init_rx_interrupt(struct wl1271 *wl)
 		goto out;
 	}
 
-	rx_conf->threshold = WL1271_RX_INTR_THRESHOLD_DEF;
-	rx_conf->timeout = WL1271_RX_INTR_TIMEOUT_DEF;
-	rx_conf->mblk_threshold = USHORT_MAX; /* Disabled */
-	rx_conf->queue_type = RX_QUEUE_TYPE_RX_LOW_PRIORITY;
+	rx_conf->threshold = wl->conf.rx.irq_pkt_threshold;
+	rx_conf->timeout = wl->conf.rx.irq_timeout;
+	rx_conf->mblk_threshold = wl->conf.rx.irq_blk_threshold;
+	rx_conf->queue_type = wl->conf.rx.queue_type;
 
 	ret = wl1271_cmd_configure(wl, ACX_RX_CONFIG_OPT, rx_conf,
 				   sizeof(*rx_conf));
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 8e3b97c..1fbd4e5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -314,35 +314,13 @@ struct acx_dot11_grp_addr_tbl {
 	u8 mac_table[ADDRESS_GROUP_MAX_LEN];
 } __attribute__ ((packed));
 
-#define  RX_TIMEOUT_PS_POLL_MIN    0
-#define  RX_TIMEOUT_PS_POLL_MAX    (200000)
-#define  RX_TIMEOUT_PS_POLL_DEF    (15)
-#define  RX_TIMEOUT_UPSD_MIN       0
-#define  RX_TIMEOUT_UPSD_MAX       (200000)
-#define  RX_TIMEOUT_UPSD_DEF       (15)
-
 struct acx_rx_timeout {
 	struct acx_header header;
 
-	/*
-	 * The longest time the STA will wait to receive
-	 * traffic from the AP after a PS-poll has been
-	 * transmitted.
-	 */
 	u16 ps_poll_timeout;
-
-	/*
-	 * The longest time the STA will wait to receive
-	 * traffic from the AP after a frame has been sent
-	 * from an UPSD enabled queue.
-	 */
 	u16 upsd_timeout;
 } __attribute__ ((packed));
 
-#define RTS_THRESHOLD_MIN              0
-#define RTS_THRESHOLD_MAX              4096
-#define RTS_THRESHOLD_DEF              2347
-
 struct acx_rts_threshold {
 	struct acx_header header;
 
@@ -510,9 +488,6 @@ struct acx_bt_wlan_coex_param {
 	u8 padding[3];
 } __attribute__ ((packed));
 
-#define CCA_THRSH_ENABLE_ENERGY_D       0x140A
-#define CCA_THRSH_DISABLE_ENERGY_D      0xFFEF
-
 struct acx_energy_detection {
 	struct acx_header header;
 
@@ -1017,22 +992,6 @@ struct wl1271_acx_mem_map {
 	void *tx_ctrl;
 } __attribute__ ((packed));
 
-enum wl1271_acx_rx_queue_type {
-	RX_QUEUE_TYPE_RX_LOW_PRIORITY,    /* All except the high priority */
-	RX_QUEUE_TYPE_RX_HIGH_PRIORITY,   /* Management and voice packets */
-	RX_QUEUE_TYPE_NUM,
-	RX_QUEUE_TYPE_MAX = USHORT_MAX
-};
-
-#define WL1271_RX_INTR_THRESHOLD_DEF  0       /* no pacing, send interrupt on
-					       * every event */
-#define WL1271_RX_INTR_THRESHOLD_MIN  0
-#define WL1271_RX_INTR_THRESHOLD_MAX  15
-
-#define WL1271_RX_INTR_TIMEOUT_DEF    5
-#define WL1271_RX_INTR_TIMEOUT_MIN    1
-#define WL1271_RX_INTR_TIMEOUT_MAX    100
-
 struct wl1271_acx_rx_config_opt {
 	struct acx_header header;
 
@@ -1122,7 +1081,7 @@ int wl1271_acx_tx_power(struct wl1271 *wl, int power);
 int wl1271_acx_feature_cfg(struct wl1271 *wl);
 int wl1271_acx_mem_map(struct wl1271 *wl,
 		       struct acx_header *mem_map, size_t len);
-int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl, u32 life_time);
+int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl);
 int wl1271_acx_rx_config(struct wl1271 *wl, u32 config, u32 filter);
 int wl1271_acx_pd_threshold(struct wl1271 *wl);
 int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time);
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 1d6a44b..8bf8bff 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -171,8 +171,93 @@ struct conf_sg_settings {
 	s8 rate_adaptation_snr;
 };
 
+enum conf_rx_queue_type {
+	CONF_RX_QUEUE_TYPE_LOW_PRIORITY,  /* All except the high priority */
+	CONF_RX_QUEUE_TYPE_HIGH_PRIORITY, /* Management and voice packets */
+};
+
+struct conf_rx_settings {
+	/*
+	 * The maximum amount of time, in TU, before the
+	 * firmware discards the MSDU.
+	 *
+	 * Range: 0 - 0xFFFFFFFF
+	 */
+	u32 rx_msdu_life_time;
+
+	/*
+	 * Packet detection threshold in the PHY.
+	 *
+	 * FIXME: details unknown.
+	 */
+	u32 packet_detection_threshold;
+
+	/*
+	 * The longest time the STA will wait to receive traffic from the AP
+	 * after a PS-poll has been transmitted.
+	 *
+	 * Range: 0 - 200000
+	 */
+	u16 ps_poll_timeout;
+	/*
+	 * The longest time the STA will wait to receive traffic from the AP
+	 * after a frame has been sent from an UPSD enabled queue.
+	 *
+	 * Range: 0 - 200000
+	 */
+	u16 upsd_timeout;
+
+	/*
+	 * The number of octets in an MPDU, below which an RTS/CTS
+	 * handshake is not performed.
+	 *
+	 * Range: 0 - 4096
+	 */
+	u16 rts_threshold;
+
+	/*
+	 * The RX Clear Channel Assessment threshold in the PHY
+	 * (the energy threshold).
+	 *
+	 * Range: ENABLE_ENERGY_D  == 0x140A
+	 *        DISABLE_ENERGY_D == 0xFFEF
+	 */
+	u16 rx_cca_threshold;
+
+	/*
+	 * Occupied Rx mem-blocks number which requires interrupting the host
+	 * (0 = no buffering, 0xffff = disabled).
+	 *
+	 * Range: u16
+	 */
+	u16 irq_blk_threshold;
+
+	/*
+	 * Rx packets number which requires interrupting the host
+	 * (0 = no buffering).
+	 *
+	 * Range: u16
+	 */
+	u16 irq_pkt_threshold;
+
+	/*
+	 * Max time in msec the FW may delay RX-Complete interrupt.
+	 *
+	 * Range: 1 - 100
+	 */
+	u16 irq_timeout;
+
+	/*
+	 * The RX queue type.
+	 *
+	 * Range: RX_QUEUE_TYPE_RX_LOW_PRIORITY, RX_QUEUE_TYPE_RX_HIGH_PRIORITY,
+	 */
+	u8 queue_type;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
+	struct conf_rx_settings rx;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 9abe062..5738263 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -94,7 +94,7 @@ static int wl1271_init_rx_config(struct wl1271 *wl, u32 config, u32 filter)
 {
 	int ret;
 
-	ret = wl1271_acx_rx_msdu_life_time(wl, RX_MSDU_LIFETIME_DEF);
+	ret = wl1271_acx_rx_msdu_life_time(wl);
 	if (ret < 0)
 		return ret;
 
@@ -125,7 +125,7 @@ static int wl1271_init_phy_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_rts_threshold(wl, RTS_THRESHOLD_DEF);
+	ret = wl1271_acx_rts_threshold(wl, wl->conf.rx.rts_threshold);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 69bc929..d04706d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -61,6 +61,18 @@ static void wl1271_conf_init(struct wl1271 *wl)
 			.beacon_miss_threshold      = 60,
 			.rate_adaptation_threshold  = CONF_HW_BIT_RATE_12MBPS,
 			.rate_adaptation_snr        = 0
+		},
+		.rx = {
+			.rx_msdu_life_time          = 512000,
+			.packet_detection_threshold = 0,
+			.ps_poll_timeout            = 15,
+			.upsd_timeout               = 15,
+			.rts_threshold              = 2347,
+			.rx_cca_threshold           = 0xFFEF,
+			.irq_blk_threshold          = 0,
+			.irq_pkt_threshold          = USHORT_MAX,
+			.irq_timeout                = 5,
+			.queue_type           = CONF_RX_QUEUE_TYPE_LOW_PRIORITY,
 		}
 	};
 
-- 
1.5.6.5

