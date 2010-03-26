Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24430 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0CZKyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:21 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 23/24] wl1271: Enable hardware keep alive messages
Date: Fri, 26 Mar 2010 12:53:32 +0200
Message-Id: <1269600813-32145-24-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch will enable the hardware keep-alive mode, configure the required
template, configure keep-alive parameters, and re-order JOIN's and ACX_AID
in such a way that the keep-alive is activated.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   55 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   31 ++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_conf.h |    9 +++++
 drivers/net/wireless/wl12xx/wl1271_init.c |   13 +++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   33 ++++++++++++++++-
 5 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index e7d1181..8f0bd5b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1139,3 +1139,58 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable)
+{
+	struct wl1271_acx_keep_alive_mode *acx = NULL;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx keep alive mode: %d", enable);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->enabled = enable;
+
+	ret = wl1271_cmd_configure(wl, ACX_KEEP_ALIVE_MODE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx keep alive mode failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid)
+{
+	struct wl1271_acx_keep_alive_config *acx = NULL;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx keep alive config");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->period = cpu_to_le32(wl->conf.conn.keep_alive_interval);
+	acx->index = index;
+	acx->tpl_validation = tpl_valid;
+	acx->trigger = ACX_KEEP_ALIVE_NO_TX;
+
+	ret = wl1271_cmd_configure(wl, ACX_SET_KEEP_ALIVE_CONFIG,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx keep alive config failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index b6eb0c1..15cc561 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -915,6 +915,33 @@ struct wl1271_acx_pm_config {
 	u8 padding[3];
 } __attribute__ ((packed));
 
+struct wl1271_acx_keep_alive_mode {
+	struct acx_header header;
+
+	u8 enabled;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+enum {
+	ACX_KEEP_ALIVE_NO_TX = 0,
+	ACX_KEEP_ALIVE_PERIOD_ONLY
+};
+
+enum {
+	ACX_KEEP_ALIVE_TPL_INVALID = 0,
+	ACX_KEEP_ALIVE_TPL_VALID
+};
+
+struct wl1271_acx_keep_alive_config {
+	struct acx_header header;
+
+	__le32 period;
+	u8 index;
+	u8 tpl_validation;
+	u8 trigger;
+	u8 padding;
+} __attribute__ ((packed));
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -964,7 +991,7 @@ enum {
 	ACX_BET_ENABLE              = 0x0050,
 	ACX_RSSI_SNR_TRIGGER        = 0x0051,
 	ACX_RSSI_SNR_WEIGHTS        = 0x0051,
-	ACX_KEEP_ALIVE_MODE         = 0x0052,
+	ACX_KEEP_ALIVE_MODE         = 0x0053,
 	ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
 	ACX_BA_SESSION_RESPONDER_POLICY = 0x0055,
 	ACX_BA_SESSION_INITIATOR_POLICY = 0x0056,
@@ -1031,5 +1058,7 @@ int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
 int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
 			     u8 version);
 int wl1271_acx_pm_config(struct wl1271 *wl);
+int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable);
+int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index f63dd5e..82b5dab 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -955,6 +955,15 @@ struct conf_conn_settings {
 	 * Range 0 - 255
 	 */
 	u8 psm_entry_retries;
+
+	/*
+	 *
+	 * Specifies the interval of the connection keep-alive null-func
+	 * frame in ms.
+	 *
+	 * Range: 1000 - 3600000
+	 */
+	u32 keep_alive_interval;
 };
 
 enum {
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 0106663..8ec94ac 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -337,6 +337,19 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* disable all keep-alive templates */
+	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
+		ret = wl1271_acx_keep_alive_config(wl, i,
+						   ACX_KEEP_ALIVE_TPL_INVALID);
+		if (ret < 0)
+			goto out_free_memmap;
+	}
+
+	/* disable the keep-alive feature */
+	ret = wl1271_acx_keep_alive_mode(wl, false);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	return 0;
 
  out_free_memmap:
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index afab52b..033cef0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -264,7 +264,8 @@ static struct conf_drv_settings default_conf = {
 		},
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 10,
-		.psm_entry_retries           = 3
+		.psm_entry_retries           = 3,
+		.keep_alive_interval         = 55000
 	},
 	.init = {
 		.radioparam = {
@@ -1203,6 +1204,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 			wl->sta_rate_set = 0;
 			wl1271_acx_rate_policies(wl);
+			wl1271_acx_keep_alive_config(
+				wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
+				ACX_KEEP_ALIVE_TPL_INVALID);
 		}
 	}
 
@@ -1676,7 +1680,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1271_cmd_build_probe_req(wl, NULL, 0,
 							 NULL, 0, wl->band);
 
-			ret = wl1271_acx_aid(wl, wl->aid);
+			/* Enable the keep-alive feature */
+			ret = wl1271_acx_keep_alive_mode(wl, true);
 			if (ret < 0)
 				goto out_sleep;
 
@@ -1700,6 +1705,10 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			/* disable connection monitor features */
 			ret = wl1271_acx_conn_monit_params(wl, false);
+
+			/* Disable the keep-alive feature */
+			ret = wl1271_acx_keep_alive_mode(wl, false);
+
 			if (ret < 0)
 				goto out_sleep;
 		}
@@ -1744,6 +1753,26 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		set_bit(WL1271_FLAG_JOINED, &wl->flags);
 	}
 
+	/*
+	 * The JOIN operation shuts down the firmware keep-alive as a side
+	 * effect, and the ACX_AID will start the keep-alive as a side effect.
+	 * Hence, for non-IBSS, the ACX_AID must always happen *after* the
+	 * JOIN operation, and the template config after the ACX_AID.
+	 */
+	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+		ret = wl1271_acx_aid(wl, wl->aid);
+		if (ret < 0)
+			goto out_sleep;
+		ret = wl1271_cmd_build_klv_null_data(wl);
+		if (ret < 0)
+			goto out_sleep;
+		ret = wl1271_acx_keep_alive_config(
+			wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
+			ACX_KEEP_ALIVE_TPL_VALID);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
-- 
1.6.3.3

