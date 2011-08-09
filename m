Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1HIJOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:00 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/40] wl12xx: add set_rate_mgmt_params acx
Date: Tue,  9 Aug 2011 12:13:28 +0300
Message-Id: <1312881233-9366-16-git-send-email-eliad@wizery.com> (sfid-20110809_111412_877756_43FEAF4C)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure rate management parameters on hw init

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   45 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   27 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/conf.h |   20 ++++++++++++++++
 drivers/net/wireless/wl12xx/init.c |    4 +++
 drivers/net/wireless/wl12xx/main.c |   21 ++++++++++++++++
 5 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index a545134..bb2e4fc 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1704,6 +1704,51 @@ int wl1271_acx_fm_coex(struct wl1271 *wl)
 	}
 
 out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_set_rate_mgmt_params(struct wl1271 *wl)
+{
+	struct wl1271_acx_set_rate_mgmt_params *acx = NULL;
+	struct conf_rate_policy_settings *conf = &wl->conf.rate;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx set rate mgmt params");
+	BUILD_BUG_ON(sizeof(conf->rate_retry_policy) !=
+		     sizeof(acx->rate_retry_policy));
+	BUILD_BUG_ON(sizeof(*acx) % 4);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx)
+		return -ENOMEM;
+
+	acx->index = ACX_RATE_MGMT_ALL_PARAMS;
+	acx->rate_retry_score = cpu_to_le16(conf->rate_retry_score);
+	acx->per_add = cpu_to_le16(conf->per_add);
+	acx->per_th1 = cpu_to_le16(conf->per_th1);
+	acx->per_th2 = cpu_to_le16(conf->per_th2);
+	acx->max_per = cpu_to_le16(conf->max_per);
+	acx->inverse_curiosity_factor = conf->inverse_curiosity_factor;
+	acx->tx_fail_low_th = conf->tx_fail_low_th;
+	acx->tx_fail_high_th = conf->tx_fail_high_th;
+	acx->per_alpha_shift = conf->per_alpha_shift;
+	acx->per_add_shift = conf->per_add_shift;
+	acx->per_beta1_shift = conf->per_beta1_shift;
+	acx->per_beta2_shift = conf->per_beta2_shift;
+	acx->rate_check_up = conf->rate_check_up;
+	acx->rate_check_down = conf->rate_check_down;
+	memcpy(acx->rate_retry_policy, conf->rate_retry_policy,
+	       sizeof(acx->rate_retry_policy));
+
+	ret = wl1271_cmd_configure(wl, ACX_SET_RATE_MAMAGEMENT_PARAMS,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx set rate mgmt params failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 5a2e9bc..2ea71d1 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1150,12 +1150,38 @@ struct wl1271_acx_fm_coex {
 	 * The swallow clock difference of the swallowing mechanism.
 	 * 0xFF = use FW default
 	 */
 	u8 swallow_clk_diff;
 } __packed;
 
+#define ACX_RATE_MGMT_ALL_PARAMS 0xff
+#define ACX_RATE_MGMT_NUM_OF_RATES 13
+struct wl1271_acx_set_rate_mgmt_params {
+	struct acx_header header;
+
+	/* the param we configure */
+	u8 index;
+	u8 padding1; /* MISSING */
+	__le16 rate_retry_score;
+	__le16 per_add;
+	__le16 per_th1;
+	__le16 per_th2;
+	__le16 max_per;
+	u8 inverse_curiosity_factor;
+	u8 tx_fail_low_th;
+	u8 tx_fail_high_th;
+	u8 per_alpha_shift;
+	u8 per_add_shift;
+	u8 per_beta1_shift;
+	u8 per_beta2_shift;
+	u8 rate_check_up;
+	u8 rate_check_down;
+	u8 rate_retry_policy[ACX_RATE_MGMT_NUM_OF_RATES];
+	u8 padding2[2]; /* MISSING */
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
 	ACX_SLOT                    = 0x0004,
 	ACX_AC_CFG                  = 0x0007,
 	ACX_MEM_MAP                 = 0x0008,
@@ -1290,8 +1316,9 @@ int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
 int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
+int wl1271_acx_set_rate_mgmt_params(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 6080e01..ebc8c6b 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1306,12 +1306,31 @@ struct conf_fwlog {
 	u8 output;
 
 	/* Regulates the frequency of log messages */
 	u8 threshold;
 };
 
+#define CONF_RATE_RETRY_POLICY_LEN 13
+struct conf_rate_policy_settings {
+	u16 rate_retry_score;
+	u16 per_add;
+	u16 per_th1;
+	u16 per_th2;
+	u16 max_per;
+	u8 inverse_curiosity_factor;
+	u8 tx_fail_low_th;
+	u8 tx_fail_high_th;
+	u8 per_alpha_shift;
+	u8 per_add_shift;
+	u8 per_beta1_shift;
+	u8 per_beta2_shift;
+	u8 rate_check_up;
+	u8 rate_check_down;
+	u8 rate_retry_policy[CONF_RATE_RETRY_POLICY_LEN];
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
 	struct conf_tx_settings tx;
 	struct conf_conn_settings conn;
 	struct conf_itrim_settings itrim;
@@ -1324,9 +1343,10 @@ struct conf_drv_settings {
 	struct conf_memory_settings mem_wl127x;
 	struct conf_memory_settings mem_wl128x;
 	struct conf_fm_coex fm_coex;
 	struct conf_rx_streaming_settings rx_streaming;
 	struct conf_fwlog fwlog;
 	u8 hci_io_ds;
+	struct conf_rate_policy_settings rate;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 10a66c7..4691297 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -712,12 +712,16 @@ int wl1271_hw_init(struct wl1271 *wl)
 	else
 		ret = wl1271_sta_hw_init_post_mem(wl);
 
 	if (ret < 0)
 		goto out_free_memmap;
 
+	ret = wl1271_acx_set_rate_mgmt_params(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	/* Configure initiator BA sessions policies */
 	ret = wl1271_set_ba_policies(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b0fd1fa..153189b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -376,12 +376,33 @@ static struct conf_drv_settings default_conf = {
 		.severity                     = 0,
 		.timestamp                    = WL12XX_FWLOG_TIMESTAMP_DISABLED,
 		.output                       = WL12XX_FWLOG_OUTPUT_HOST,
 		.threshold                    = 0,
 	},
 	.hci_io_ds = HCI_IO_DS_6MA,
+	.rate = {
+		.rate_retry_score = 32000,
+		.per_add = 8192,
+		.per_th1 = 2048,
+		.per_th2 = 4096,
+		.max_per = 8100,
+		.inverse_curiosity_factor = 5,
+		.tx_fail_low_th = 4,
+		.tx_fail_high_th = 10,
+		.per_alpha_shift = 4,
+		.per_add_shift = 13,
+		.per_beta1_shift = 10,
+		.per_beta2_shift = 8,
+		.rate_check_up = 2,
+		.rate_check_down = 12,
+		.rate_retry_policy = {
+			0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00,
+		},
+	},
 };
 
 static char *fwlog_param;
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues);
-- 
1.7.6.401.g6a319

