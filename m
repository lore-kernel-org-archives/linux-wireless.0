Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36086 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033AbZJMJtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:41 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 04/22] wl1271: Add config structure for TX path parameters
Date: Tue, 13 Oct 2009 12:47:41 +0300
Message-Id: <1255427279-1224-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add a configuration structure for TX path parameters, and set defalt
configuration values there.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   54 ++++-----
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   37 +------
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    6 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h |  187 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |  103 ++++++++++++++++
 7 files changed, 321 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 64a3270..985e896 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -107,7 +107,7 @@ enum {
 				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
 				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
 
-#define WL1271_DEFAULT_BASIC_RATE_SET (ACX_RATE_MASK_ALL)
+#define WL1271_DEFAULT_BASIC_RATE_SET (CONF_TX_RATE_MASK_ALL)
 
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 63aa646..038203b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -558,7 +558,7 @@ int wl1271_acx_cca_threshold(struct wl1271 *wl)
 	}
 
 	detection->rx_cca_threshold = wl->conf.rx.rx_cca_threshold;
-	detection->tx_energy_detection = 0;
+	detection->tx_energy_detection = wl->conf.tx.tx_energy_detection;
 
 	ret = wl1271_cmd_configure(wl, ACX_CCA_THRESHOLD,
 				   detection, sizeof(*detection));
@@ -729,6 +729,7 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
 int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates)
 {
 	struct acx_rate_policy *acx;
+	struct conf_tx_rate_class *c = &wl->conf.tx.rc_conf;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx rate policies");
@@ -743,9 +744,9 @@ int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates)
 	/* configure one default (one-size-fits-all) rate class */
 	acx->rate_class_cnt = 1;
 	acx->rate_class[0].enabled_rates = enabled_rates;
-	acx->rate_class[0].short_retry_limit = ACX_RATE_RETRY_LIMIT;
-	acx->rate_class[0].long_retry_limit = ACX_RATE_RETRY_LIMIT;
-	acx->rate_class[0].aflags = 0;
+	acx->rate_class[0].short_retry_limit = c->short_retry_limit;
+	acx->rate_class[0].long_retry_limit = c->long_retry_limit;
+	acx->rate_class[0].aflags = c->aflags;
 
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
@@ -772,22 +773,14 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
-	/*
-	 * FIXME: Configure each AC with appropriate values (most suitable
-	 * values will probably be different for each AC.
-	 */
-	for (i = 0; i < WL1271_ACX_AC_COUNT; i++) {
-		acx->ac = i;
-
-		/*
-		 * FIXME: The following default values originate from
-		 * the TI reference driver. What do they mean?
-		 */
-		acx->cw_min = 15;
-		acx->cw_max = 63;
-		acx->aifsn = 3;
+	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
+		struct conf_tx_ac_category *c = &(wl->conf.tx.ac_conf[i]);
+		acx->ac = c->ac;
+		acx->cw_min = c->cw_min;
+		acx->cw_max = c->cw_max;
+		acx->aifsn = c->aifsn;
 		acx->reserved = 0;
-		acx->tx_op_limit = 0;
+		acx->tx_op_limit = c->tx_op_limit;
 
 		ret = wl1271_cmd_configure(wl, ACX_AC_CFG, acx, sizeof(*acx));
 		if (ret < 0) {
@@ -816,12 +809,15 @@ int wl1271_acx_tid_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
-	/* FIXME: configure each TID with a different AC reference */
-	for (i = 0; i < WL1271_ACX_TID_COUNT; i++) {
-		acx->queue_id = i;
-		acx->tsid = WL1271_ACX_AC_BE;
-		acx->ps_scheme = WL1271_ACX_PS_SCHEME_LEGACY;
-		acx->ack_policy = WL1271_ACX_ACK_POLICY_LEGACY;
+	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
+		struct conf_tx_tid *c = &(wl->conf.tx.tid_conf[i]);
+		acx->queue_id = c->queue_id;
+		acx->channel_type = c->channel_type;
+		acx->tsid = c->tsid;
+		acx->ps_scheme = c->ps_scheme;
+		acx->ack_policy = c->ack_policy;
+		acx->apsd_conf[0] = c->apsd_conf[0];
+		acx->apsd_conf[1] = c->apsd_conf[1];
 
 		ret = wl1271_cmd_configure(wl, ACX_TID_CFG, acx, sizeof(*acx));
 		if (ret < 0) {
@@ -849,7 +845,7 @@ int wl1271_acx_frag_threshold(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->frag_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
+	acx->frag_threshold = wl->conf.tx.frag_threshold;
 	ret = wl1271_cmd_configure(wl, ACX_FRAG_CFG, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of frag threshold failed: %d", ret);
@@ -875,8 +871,8 @@ int wl1271_acx_tx_config_options(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->tx_compl_timeout = WL1271_ACX_TX_COMPL_TIMEOUT;
-	acx->tx_compl_threshold = WL1271_ACX_TX_COMPL_THRESHOLD;
+	acx->tx_compl_timeout = wl->conf.tx.tx_compl_timeout;
+	acx->tx_compl_threshold = wl->conf.tx.tx_compl_threshold;
 	ret = wl1271_cmd_configure(wl, ACX_TX_CONFIG_OPT, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of tx options failed: %d", ret);
@@ -929,7 +925,7 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl)
 		return ret;
 
 	wl->target_mem_map = kzalloc(sizeof(struct wl1271_acx_mem_map),
-					  GFP_KERNEL);
+				     GFP_KERNEL);
 	if (!wl->target_mem_map) {
 		wl1271_error("couldn't allocate target memory map");
 		return -ENOMEM;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 1fbd4e5..63cddce 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -850,11 +850,6 @@ struct acx_statistics {
 	struct acx_rxpipe_statistics rxpipe;
 } __attribute__ ((packed));
 
-#define ACX_MAX_RATE_CLASSES       8
-#define ACX_RATE_MASK_UNSPECIFIED  0
-#define ACX_RATE_MASK_ALL          0x1eff
-#define ACX_RATE_RETRY_LIMIT       10
-
 struct acx_rate_class {
 	u32 enabled_rates;
 	u8 short_retry_limit;
@@ -867,11 +862,9 @@ struct acx_rate_policy {
 	struct acx_header header;
 
 	u32 rate_class_cnt;
-	struct acx_rate_class rate_class[ACX_MAX_RATE_CLASSES];
+	struct acx_rate_class rate_class[CONF_TX_MAX_RATE_CLASSES];
 } __attribute__ ((packed));
 
-#define WL1271_ACX_AC_COUNT 4
-
 struct acx_ac_cfg {
 	struct acx_header header;
 	u8 ac;
@@ -882,31 +875,6 @@ struct acx_ac_cfg {
 	u16 tx_op_limit;
 } __attribute__ ((packed));
 
-enum wl1271_acx_ac {
-	WL1271_ACX_AC_BE = 0,
-	WL1271_ACX_AC_BK = 1,
-	WL1271_ACX_AC_VI = 2,
-	WL1271_ACX_AC_VO = 3,
-	WL1271_ACX_AC_CTS2SELF = 4,
-	WL1271_ACX_AC_ANY_TID = 0x1F,
-	WL1271_ACX_AC_INVALID = 0xFF,
-};
-
-enum wl1271_acx_ps_scheme {
-	WL1271_ACX_PS_SCHEME_LEGACY = 0,
-	WL1271_ACX_PS_SCHEME_UPSD_TRIGGER = 1,
-	WL1271_ACX_PS_SCHEME_LEGACY_PSPOLL = 2,
-	WL1271_ACX_PS_SCHEME_SAPSD = 3,
-};
-
-enum wl1271_acx_ack_policy {
-	WL1271_ACX_ACK_POLICY_LEGACY = 0,
-	WL1271_ACX_ACK_POLICY_NO_ACK = 1,
-	WL1271_ACX_ACK_POLICY_BLOCK = 2,
-};
-
-#define WL1271_ACX_TID_COUNT 7
-
 struct acx_tid_config {
 	struct acx_header header;
 	u8 queue_id;
@@ -924,9 +892,6 @@ struct acx_frag_threshold {
 	u8 padding[2];
 } __attribute__ ((packed));
 
-#define WL1271_ACX_TX_COMPL_TIMEOUT   5
-#define WL1271_ACX_TX_COMPL_THRESHOLD 5
-
 struct acx_tx_config_options {
 	struct acx_header header;
 	u16 tx_compl_timeout;     /* msec */
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index c7a8a64..f05bd77 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -626,9 +626,9 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 
 	cmd->len = cpu_to_le16(buf_len);
 	cmd->template_type = template_id;
-	cmd->enabled_rates = ACX_RATE_MASK_UNSPECIFIED;
-	cmd->short_retry_limit = ACX_RATE_RETRY_LIMIT;
-	cmd->long_retry_limit = ACX_RATE_RETRY_LIMIT;
+	cmd->enabled_rates = wl->conf.tx.rc_conf.enabled_rates;
+	cmd->short_retry_limit = wl->conf.tx.rc_conf.short_retry_limit;
+	cmd->long_retry_limit = wl->conf.tx.rc_conf.long_retry_limit;
 
 	if (buf)
 		memcpy(cmd->template_data, buf, buf_len);
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 8bf8bff..3c5ce31 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -255,9 +255,196 @@ struct conf_rx_settings {
 	u8 queue_type;
 };
 
+#define CONF_TX_MAX_RATE_CLASSES       8
+
+#define CONF_TX_RATE_MASK_UNSPECIFIED  0
+#define CONF_TX_RATE_MASK_ALL          0x1eff
+#define CONF_TX_RATE_RETRY_LIMIT       10
+
+struct conf_tx_rate_class {
+
+	/*
+	 * The rates enabled for this rate class.
+	 *
+	 * Range: CONF_HW_BIT_RATE_* bit mask
+	 */
+	u32 enabled_rates;
+
+	/*
+	 * The dot11 short retry limit used for TX retries.
+	 *
+	 * Range: u8
+	 */
+	u8 short_retry_limit;
+
+	/*
+	 * The dot11 long retry limit used for TX retries.
+	 *
+	 * Range: u8
+	 */
+	u8 long_retry_limit;
+
+	/*
+	 * Flags controlling the attributes of TX transmission.
+	 *
+	 * Range: bit 0: Truncate - when set, FW attempts to send a frame stop
+	 *               when the total valid per-rate attempts have
+	 *               been exhausted; otherwise transmissions
+	 *               will continue at the lowest available rate
+	 *               until the appropriate one of the
+	 *               short_retry_limit, long_retry_limit,
+	 *               dot11_max_transmit_msdu_life_time, or
+	 *               max_tx_life_time, is exhausted.
+	 *            1: Preamble Override - indicates if the preamble type
+	 *               should be used in TX.
+	 *            2: Preamble Type - the type of the preamble to be used by
+	 *               the policy (0 - long preamble, 1 - short preamble.
+	 */
+	u8 aflags;
+};
+
+#define CONF_TX_MAX_AC_COUNT 4
+
+/* Slot number setting to start transmission at PIFS interval */
+#define CONF_TX_AIFS_PIFS 1
+/* Slot number setting to start transmission at DIFS interval normal
+ * DCF access */
+#define CONF_TX_AIFS_DIFS 2
+
+
+enum conf_tx_ac {
+	CONF_TX_AC_BE = 0,         /* best effort / legacy */
+	CONF_TX_AC_BK = 1,         /* background */
+	CONF_TX_AC_VI = 2,         /* video */
+	CONF_TX_AC_VO = 3,         /* voice */
+	CONF_TX_AC_CTS2SELF = 4,   /* fictious AC, follows AC_VO */
+	CONF_TX_AC_ANY_TID = 0x1f
+};
+
+struct conf_tx_ac_category {
+	/*
+	 * The AC class identifier.
+	 *
+	 * Range: enum conf_tx_ac
+	 */
+	u8 ac;
+
+	/*
+	 * The contention window minimum size (in slots) for the access
+	 * class.
+	 *
+	 * Range: u8
+	 */
+	u8 cw_min;
+
+	/*
+	 * The contention window maximum size (in slots) for the access
+	 * class.
+	 *
+	 * Range: u8
+	 */
+	u16 cw_max;
+
+	/*
+	 * The AIF value (in slots) for the access class.
+	 *
+	 * Range: u8
+	 */
+	u8 aifsn;
+
+	/*
+	 * The TX Op Limit (in microseconds) for the access class.
+	 *
+	 * Range: u16
+	 */
+	u16 tx_op_limit;
+};
+
+#define CONF_TX_MAX_TID_COUNT 7
+
+enum {
+	CONF_CHANNEL_TYPE_DCF = 0,   /* DC/LEGACY*/
+	CONF_CHANNEL_TYPE_EDCF = 1,  /* EDCA*/
+	CONF_CHANNEL_TYPE_HCCA = 2,  /* HCCA*/
+};
+
+enum {
+	CONF_PS_SCHEME_LEGACY = 0,
+	CONF_PS_SCHEME_UPSD_TRIGGER = 1,
+	CONF_PS_SCHEME_LEGACY_PSPOLL = 2,
+	CONF_PS_SCHEME_SAPSD = 3,
+};
+
+enum {
+	CONF_ACK_POLICY_LEGACY = 0,
+	CONF_ACK_POLICY_NO_ACK = 1,
+	CONF_ACK_POLICY_BLOCK = 2,
+};
+
+
+struct conf_tx_tid {
+	u8 queue_id;
+	u8 channel_type;
+	u8 tsid;
+	u8 ps_scheme;
+	u8 ack_policy;
+	u32 apsd_conf[2];
+};
+
+struct conf_tx_settings {
+	/*
+	 * The TX ED value for TELEC Enable/Disable.
+	 *
+	 * Range: 0, 1
+	 */
+	u8 tx_energy_detection;
+
+	/*
+	 * Configuration for rate classes for TX (currently only one
+	 * rate class supported.)
+	 */
+	struct conf_tx_rate_class rc_conf;
+
+	/*
+	 * Configuration for access categories for TX rate control.
+	 */
+	u8 ac_conf_count;
+	struct conf_tx_ac_category ac_conf[CONF_TX_MAX_AC_COUNT];
+
+	/*
+	 * Configuration for TID parameters.
+	 */
+	u8 tid_conf_count;
+	struct conf_tx_tid tid_conf[CONF_TX_MAX_TID_COUNT];
+
+	/*
+	 * The TX fragmentation threshold.
+	 *
+	 * Range: u16
+	 */
+	u16 frag_threshold;
+
+	/*
+	 * Max time in msec the FW may delay frame TX-Complete interrupt.
+	 *
+	 * Range: u16
+	 */
+	u16 tx_compl_timeout;
+
+	/*
+	 * Completed TX packet count which requires to issue the TX-Complete
+	 * interrupt.
+	 *
+	 * Range: u16
+	 */
+	u16 tx_compl_threshold;
+
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
+	struct conf_tx_settings tx;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 5738263..a3fc4c9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -382,7 +382,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Configure TX rate classes */
-	ret = wl1271_acx_rate_policies(wl, ACX_RATE_MASK_ALL);
+	ret = wl1271_acx_rate_policies(wl, CONF_TX_RATE_MASK_ALL);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d04706d..35d0b7e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -73,6 +73,109 @@ static void wl1271_conf_init(struct wl1271 *wl)
 			.irq_pkt_threshold          = USHORT_MAX,
 			.irq_timeout                = 5,
 			.queue_type           = CONF_RX_QUEUE_TYPE_LOW_PRIORITY,
+		},
+		.tx = {
+			.tx_energy_detection        = 0,
+			.rc_conf                    = {
+				.enabled_rates      =
+				CONF_TX_RATE_MASK_UNSPECIFIED,
+				.short_retry_limit  = 10,
+				.long_retry_limit   = 10,
+				.aflags             = 0
+			},
+			.ac_conf_count              = 4,
+			.ac_conf                    = {
+				[0] = {
+					.ac         = CONF_TX_AC_BE,
+					.cw_min     = 15,
+					.cw_max     = 63,
+					.aifsn      = 3,
+					.tx_op_limit = 0,
+				},
+				[1] = {
+					.ac         = CONF_TX_AC_BK,
+					.cw_min     = 15,
+					.cw_max     = 63,
+					.aifsn      = 7,
+					.tx_op_limit = 0,
+				},
+				[2] = {
+					.ac         = CONF_TX_AC_VI,
+					.cw_min     = 15,
+					.cw_max     = 63,
+					.aifsn      = CONF_TX_AIFS_PIFS,
+					.tx_op_limit = 3008,
+				},
+				[3] = {
+					.ac         = CONF_TX_AC_VO,
+					.cw_min     = 15,
+					.cw_max     = 63,
+					.aifsn      = CONF_TX_AIFS_PIFS,
+					.tx_op_limit = 1504,
+				},
+			},
+			.tid_conf_count = 7,
+			.tid_conf = {
+				[0] = {
+					.queue_id   = 0,
+					.channel_type = CONF_CHANNEL_TYPE_DCF,
+					.tsid = CONF_TX_AC_BE,
+					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
+					.ack_policy = CONF_ACK_POLICY_LEGACY,
+					.apsd_conf  = {0, 0},
+				},
+				[1] = {
+					.queue_id   = 1,
+					.channel_type = CONF_CHANNEL_TYPE_DCF,
+					.tsid = CONF_TX_AC_BE,
+					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
+					.ack_policy = CONF_ACK_POLICY_LEGACY,
+					.apsd_conf  = {0, 0},
+				},
+				[2] = {
+					.queue_id   = 2,
+					.channel_type = CONF_CHANNEL_TYPE_DCF,
+					.tsid = CONF_TX_AC_BE,
+					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
+					.ack_policy = CONF_ACK_POLICY_LEGACY,
+					.apsd_conf  = {0, 0},
+				},
+				[3] = {
+					.queue_id   = 3,
+					.channel_type = CONF_CHANNEL_TYPE_DCF,
+					.tsid = CONF_TX_AC_BE,
+					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
+					.ack_policy = CONF_ACK_POLICY_LEGACY,
+					.apsd_conf  = {0, 0},
+				},
+				[4] = {
+					.queue_id   = 4,
+					.channel_type = CONF_CHANNEL_TYPE_DCF,
+					.tsid = CONF_TX_AC_BE,
+					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
+					.ack_policy = CONF_ACK_POLICY_LEGACY,
+					.apsd_conf  = {0, 0},
+				},
+				[5] = {
+					.queue_id   = 5,
+					.channel_type = CONF_CHANNEL_TYPE_DCF,
+					.tsid = CONF_TX_AC_BE,
+					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
+					.ack_policy = CONF_ACK_POLICY_LEGACY,
+					.apsd_conf  = {0, 0},
+				},
+				[6] = {
+					.queue_id   = 6,
+					.channel_type = CONF_CHANNEL_TYPE_DCF,
+					.tsid = CONF_TX_AC_BE,
+					.ps_scheme  = CONF_PS_SCHEME_LEGACY,
+					.ack_policy = CONF_ACK_POLICY_LEGACY,
+					.apsd_conf  = {0, 0},
+				}
+			},
+			.frag_threshold          = IEEE80211_MAX_FRAG_THRESHOLD,
+			.tx_compl_timeout           = 5,
+			.tx_compl_threshold         = 5
 		}
 	};
 
-- 
1.5.6.5

