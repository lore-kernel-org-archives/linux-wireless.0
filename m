Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0KRLcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:32:39 -0500
Received: by mail-fx0-f46.google.com with SMTP id 6so1460042fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:32:38 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/18] wl1271: AP mode - AP specific CMD_CONFIGURE sub-commands
Date: Thu, 18 Nov 2010 13:32:15 +0200
Message-Id: <1290079951-16793-3-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add AP max retries and rate policy configuration.
Rename STA rate policy configuration function.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   60 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/acx.h  |   31 +++++++++++++++++-
 drivers/net/wireless/wl12xx/init.c |    2 +-
 drivers/net/wireless/wl12xx/main.c |    8 ++--
 drivers/net/wireless/wl12xx/tx.c   |    2 +-
 5 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 4f1cb84..1a9ef46 100644
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
+	acx->max_tx_retry = cpu_to_le16(WL1271_AP_MAX_TX_RETRY);
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
index 75a6306..f8b1d97 100644
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
+	__le32 rate_policy_idx; /* The index of the rate policy */
+	struct acx_rate_class rate_policy;
+} __packed;
+
 struct acx_ac_cfg {
 	struct acx_header header;
 	u8 ac;
@@ -1057,6 +1067,19 @@ struct wl1271_acx_fw_tsf_information {
 	u8 padding[3];
 } __packed;
 
+#define WL1271_AP_MAX_TX_RETRY   100
+
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
@@ -1114,6 +1137,7 @@ enum {
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
+	ACX_MAX_TX_FAILURE          = 0x0072,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
 	DOT11_RX_DOT11_MODE         = 0x1012,
@@ -1155,7 +1179,9 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
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
@@ -1181,5 +1207,6 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
+int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 7949d34..52d1aa2 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -317,7 +317,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 	}
 
 	/* Configure TX rate classes */
-	ret = wl1271_acx_rate_policies(wl);
+	ret = wl1271_acx_sta_rate_policies(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1bb2575..6ada706 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1373,7 +1373,7 @@ static int wl1271_handle_idle(struct wl1271 *wl, bool idle)
 		}
 		wl->rate_set = wl1271_min_rate_get(wl);
 		wl->sta_rate_set = 0;
-		ret = wl1271_acx_rate_policies(wl);
+		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			goto out;
 		ret = wl1271_acx_keep_alive_config(
@@ -1448,7 +1448,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl1271_set_band_rate(wl);
 
 		wl->basic_rate = wl1271_min_rate_get(wl);
-		ret = wl1271_acx_rate_policies(wl);
+		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			wl1271_warning("rate policy for update channel "
 				       "failed %d", ret);
@@ -1993,7 +1993,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
 									 rates);
 			wl->basic_rate = wl1271_min_rate_get(wl);
-			ret = wl1271_acx_rate_policies(wl);
+			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out_sleep;
 
@@ -2043,7 +2043,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl);
 			wl->basic_rate = wl1271_min_rate_get(wl);
-			ret = wl1271_acx_rate_policies(wl);
+			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out_sleep;
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index d332b3f..67888f3 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -267,7 +267,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 		woken_up = true;
 
 		wl->rate_set = wl1271_tx_enabled_rates_get(wl, sta_rates);
-		wl1271_acx_rate_policies(wl);
+		wl1271_acx_sta_rate_policies(wl);
 	}
 
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
-- 
1.7.1

