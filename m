Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0L1RhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:03 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so4306524eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:02 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 02/18] wl1271: AP mode - AP specific CMD_CONFIGURE sub-commands
Date: Tue, 28 Dec 2010 19:36:32 +0200
Message-Id: <1293557808-27068-3-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add AP max retries and rate policy configuration.
Rename STA rate policy configuration function.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   60 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/acx.h  |   29 ++++++++++++++++-
 drivers/net/wireless/wl12xx/conf.h |    6 +++
 drivers/net/wireless/wl12xx/init.c |    2 +-
 drivers/net/wireless/wl12xx/main.c |   10 +++---
 drivers/net/wireless/wl12xx/tx.c   |    2 +-
 6 files changed, 98 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 30ff32a..0f802d5 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -751,9 +751,9 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
 	return 0;
 }
 
-int wl1271_acx_rate_policies(struct wl1271 *wl)
+int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
 {
-	struct acx_rate_policy *acx;
+	struct acx_sta_rate_policy *acx;
 	struct conf_tx_rate_class *c = &wl->conf.tx.sta_rc_conf;
 	int idx = 0;
 	int ret = 0;
@@ -794,6 +794,38 @@ out:
 	return ret;
 }
 
+int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
+		      u8 idx)
+{
+	struct acx_ap_rate_policy *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx ap rate policy");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->rate_policy.enabled_rates = cpu_to_le32(c->enabled_rates);
+	acx->rate_policy.short_retry_limit = c->short_retry_limit;
+	acx->rate_policy.long_retry_limit = c->long_retry_limit;
+	acx->rate_policy.aflags = c->aflags;
+
+	acx->rate_policy_idx = idx;
+
+	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of ap rate policy failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifsn, u16 txop)
 {
@@ -1334,3 +1366,27 @@ out:
 	kfree(tsf_info);
 	return ret;
 }
+
+int wl1271_acx_max_tx_retry(struct wl1271 *wl)
+{
+	struct wl1271_acx_max_tx_retry *acx = NULL;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx max tx retry");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx)
+		return -ENOMEM;
+
+	acx->max_tx_retry = cpu_to_le16(wl->conf.tx.ap_max_tx_retries);
+
+	ret = wl1271_cmd_configure(wl, ACX_MAX_TX_FAILURE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx max tx retry failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 9cbc3f4..89d3748 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -747,13 +747,23 @@ struct acx_rate_class {
 #define ACX_TX_BASIC_RATE      0
 #define ACX_TX_AP_FULL_RATE    1
 #define ACX_TX_RATE_POLICY_CNT 2
-struct acx_rate_policy {
+struct acx_sta_rate_policy {
 	struct acx_header header;
 
 	__le32 rate_class_cnt;
 	struct acx_rate_class rate_class[CONF_TX_MAX_RATE_CLASSES];
 } __packed;
 
+
+#define ACX_TX_AP_MODE_MGMT_RATE 4
+#define ACX_TX_AP_MODE_BCST_RATE 5
+struct acx_ap_rate_policy {
+	struct acx_header header;
+
+	__le32 rate_policy_idx;
+	struct acx_rate_class rate_policy;
+} __packed;
+
 struct acx_ac_cfg {
 	struct acx_header header;
 	u8 ac;
@@ -1062,6 +1072,17 @@ struct wl1271_acx_fw_tsf_information {
 	u8 padding[3];
 } __packed;
 
+struct wl1271_acx_max_tx_retry {
+	struct acx_header header;
+
+	/*
+	 * the number of frames transmission failures before
+	 * issuing the aging event.
+	 */
+	__le16 max_tx_retry;
+	u8 padding_1[2];
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1119,6 +1140,7 @@ enum {
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
+	ACX_MAX_TX_FAILURE          = 0x0072,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
 	DOT11_RX_DOT11_MODE         = 0x1012,
@@ -1160,7 +1182,9 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
 int wl1271_acx_cts_protect(struct wl1271 *wl,
 			   enum acx_ctsprotect_type ctsprotect);
 int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
-int wl1271_acx_rate_policies(struct wl1271 *wl);
+int wl1271_acx_sta_rate_policies(struct wl1271 *wl);
+int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
+		      u8 idx);
 int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifsn, u16 txop);
 int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
@@ -1186,5 +1210,6 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
+int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 7563ce3..f5c048c 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -683,6 +683,12 @@ struct conf_tx_settings {
 	struct conf_tx_rate_class ap_bcst_conf;
 
 	/*
+	 * AP-mode - allow this number of TX retries to a station before an
+	 * event is triggered from FW.
+	 */
+	u16 ap_max_tx_retries;
+
+	/*
 	 * Configuration for TID parameters.
 	 */
 	u8 tid_conf_count;
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 785a530..f468d71 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -322,7 +322,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 	}
 
 	/* Configure TX rate classes */
-	ret = wl1271_acx_rate_policies(wl);
+	ret = wl1271_acx_sta_rate_policies(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 788959a..b40568e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -191,7 +191,7 @@ static struct conf_drv_settings default_conf = {
 			.long_retry_limit    = 10,
 			.aflags              = 0,
 		},
-
+		.ap_max_tx_retries = 100,
 		.tid_conf_count = 4,
 		.tid_conf = {
 			[CONF_TX_AC_BE] = {
@@ -1393,7 +1393,7 @@ static int wl1271_handle_idle(struct wl1271 *wl, bool idle)
 		}
 		wl->rate_set = wl1271_min_rate_get(wl);
 		wl->sta_rate_set = 0;
-		ret = wl1271_acx_rate_policies(wl);
+		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			goto out;
 		ret = wl1271_acx_keep_alive_config(
@@ -1468,7 +1468,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl1271_set_band_rate(wl);
 
 		wl->basic_rate = wl1271_min_rate_get(wl);
-		ret = wl1271_acx_rate_policies(wl);
+		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			wl1271_warning("rate policy for update channel "
 				       "failed %d", ret);
@@ -2017,7 +2017,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
 									 rates);
 			wl->basic_rate = wl1271_min_rate_get(wl);
-			ret = wl1271_acx_rate_policies(wl);
+			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out_sleep;
 
@@ -2071,7 +2071,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl);
 			wl->basic_rate = wl1271_min_rate_get(wl);
-			ret = wl1271_acx_rate_policies(wl);
+			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out_sleep;
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index b44c75c..0cf210d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -303,7 +303,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 		woken_up = true;
 
 		wl->rate_set = wl1271_tx_enabled_rates_get(wl, sta_rates);
-		wl1271_acx_rate_policies(wl);
+		wl1271_acx_sta_rate_policies(wl);
 	}
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
-- 
1.7.1

