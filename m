Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1HNKRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:33 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 15/40] wl12xx: add set_rate_mgmt_params acx
Date: Sun, 14 Aug 2011 13:17:14 +0300
Message-Id: <1313317059-16567-16-git-send-email-eliad@wizery.com> (sfid-20110814_121741_621376_EAE96B86)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure rate management parameters on hw init

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: remove BUILD_BUG_ON, fix typos, reorder conf struct.
 drivers/net/wireless/wl12xx/acx.c  |   42 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   25 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/conf.h |   20 +++++++++++++++++
 drivers/net/wireless/wl12xx/init.c |    4 +++
 drivers/net/wireless/wl12xx/main.c |   21 ++++++++++++++++++
 5 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 968d219..a784ba6 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1696,6 +1696,48 @@ int wl1271_acx_fm_coex(struct wl1271 *wl)
 	}
 
 out:
 	kfree(acx);
 	return ret;
 }
+
+int wl12xx_acx_set_rate_mgmt_params(struct wl1271 *wl)
+{
+	struct wl12xx_acx_set_rate_mgmt_params *acx = NULL;
+	struct conf_rate_policy_settings *conf = &wl->conf.rate;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx set rate mgmt params");
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
+	ret = wl1271_cmd_configure(wl, ACX_SET_RATE_MGMT_PARAMS,
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
index 3aec410..6909bc5 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1152,12 +1152,36 @@ struct wl1271_acx_fm_coex {
 	 * The swallow clock difference of the swallowing mechanism.
 	 * 0xFF = use FW default
 	 */
 	u8 swallow_clk_diff;
 } __packed;
 
+#define ACX_RATE_MGMT_ALL_PARAMS 0xff
+struct wl12xx_acx_set_rate_mgmt_params {
+	struct acx_header header;
+
+	u8 index; /* 0xff to configure all params */
+	u8 padding1;
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
+	u8 padding2[2];
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
 	ACX_SLOT                    = 0x0004,
 	ACX_AC_CFG                  = 0x0007,
 	ACX_MEM_MAP                 = 0x0008,
@@ -1291,8 +1315,9 @@ int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
 int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
+int wl12xx_acx_set_rate_mgmt_params(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 6080e01..30ee7d3 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1306,12 +1306,31 @@ struct conf_fwlog {
 	u8 output;
 
 	/* Regulates the frequency of log messages */
 	u8 threshold;
 };
 
+#define ACX_RATE_MGMT_NUM_OF_RATES 13
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
+	u8 rate_retry_policy[ACX_RATE_MGMT_NUM_OF_RATES];
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
 	struct conf_tx_settings tx;
 	struct conf_conn_settings conn;
 	struct conf_itrim_settings itrim;
@@ -1323,10 +1342,11 @@ struct conf_drv_settings {
 	struct conf_ht_setting ht;
 	struct conf_memory_settings mem_wl127x;
 	struct conf_memory_settings mem_wl128x;
 	struct conf_fm_coex fm_coex;
 	struct conf_rx_streaming_settings rx_streaming;
 	struct conf_fwlog fwlog;
+	struct conf_rate_policy_settings rate;
 	u8 hci_io_ds;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 3a66609..1bc246f 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -712,12 +712,16 @@ int wl1271_hw_init(struct wl1271 *wl)
 	else
 		ret = wl1271_sta_hw_init_post_mem(wl);
 
 	if (ret < 0)
 		goto out_free_memmap;
 
+	ret = wl12xx_acx_set_rate_mgmt_params(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	/* Configure initiator BA sessions policies */
 	ret = wl1271_set_ba_policies(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d683bca..3db191d 100644
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

