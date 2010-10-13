Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49620 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0JMG5B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 02:57:01 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2] wl1271: BA Initiator support
Date: Wed, 13 Oct 2010 08:59:51 +0200
Message-Id: <1286953191-9726-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 80211n BA initiator session support wl1271 driver.
BA initiator session management included in FW independently.
BA receiver session not supported in that Series.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Dependencies:
- BA Initiator patches have a runtime dependency on
  commit "[PATCH v3] wl1271: 11n Support" series (patches is in linux-wireless
  mailing list)

Limitation:
- For now only TID0 supported (Beast Effort).

Changes from v1:
- Remove wl1271_op_ampdu_action()
- set CONF_BA_INACTIVITY_TIMEOUT as configurable value
- Clean to Linux code style.

 drivers/net/wireless/wl12xx/wl1271_acx.c  |   46 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   21 +++++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    7 ++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   24 ++++++++++++++-
 4 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index cd89482..43f2512 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1311,6 +1311,52 @@ out:
 	return ret;
 }
 
+/* Configure BA session initiator\receiver parameters setting in the FW. */
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+			       u16 id,
+			       u8 tid_index,
+			       u8 policy)
+{
+	struct wl1271_acx_ba_session_policy *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx ba session setting");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(acx->mac_address, wl->bssid, ETH_ALEN);
+	acx->tid = tid_index;
+	acx->enable = policy;
+	acx->win_size = BA_RECEIVER_WIN_SIZE;
+
+	switch (id) {
+	case ACX_BA_SESSION_INITIATOR_POLICY:
+		acx->inactivity_timeout = wl->conf.ht.ba_win_size;
+		break;
+	case ACX_BA_SESSION_RESPONDER_POLICY:
+		acx->inactivity_timeout = 0;
+		break;
+	default:
+		wl1271_error("Incorrect acx command id=%x\n", id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wl1271_cmd_configure(wl, id, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ba session setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime)
 {
 	struct wl1271_acx_fw_tsf_information *tsf_info;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 57d503b..f0a1c33 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1047,6 +1047,23 @@ struct wl1271_acx_ht_information {
 	u8 padding[3];
 } __packed;
 
+#define BA_RECEIVER_WIN_SIZE 8
+
+struct wl1271_acx_ba_session_policy {
+	struct acx_header header;
+	/* Mac address of: SA as receiver / RA as initiator */
+	u8 mac_address[ETH_ALEN];
+	u8 tid;
+	u8 enable;
+	/* windows size in number of packets */
+	u16 win_size;
+	/*
+	 * As initiator inactivity timeout in time units(TU) of 1024us.
+	 * As receiver reserved
+	 */
+	u16 inactivity_timeout;
+} __packed;
+
 struct wl1271_acx_fw_tsf_information {
 	struct acx_header header;
 
@@ -1181,6 +1198,10 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    bool allow_ht_operation);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+			       u16 id,
+			       u8 tid_index,
+			       u8 policy);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 5f78a6c..811f51f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -1090,6 +1090,12 @@ struct conf_rf_settings {
 	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
 };
 
+#define CONF_BA_INACTIVITY_TIMEOUT 10000
+
+struct conf_ht_setting {
+	u16 ba_win_size;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1100,6 +1106,7 @@ struct conf_drv_settings {
 	struct conf_roam_trigger_settings roam_trigger;
 	struct conf_scan_settings scan;
 	struct conf_rf_settings rf;
+	struct conf_ht_setting ht;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 88a1113..6a3511b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -233,7 +233,7 @@ static struct conf_drv_settings default_conf = {
 		.avg_weight_rssi_beacon       = 20,
 		.avg_weight_rssi_data         = 10,
 		.avg_weight_snr_beacon        = 20,
-		.avg_weight_snr_data          = 10
+		.avg_weight_snr_data          = 10,
 	},
 	.scan = {
 		.min_dwell_time_active        = 7500,
@@ -252,6 +252,9 @@ static struct conf_drv_settings default_conf = {
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		},
 	},
+	.ht = {
+		.ba_win_size = CONF_BA_INACTIVITY_TIMEOUT,
+	},
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
@@ -1141,6 +1144,19 @@ static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
 	}
 }
 
+/* Set the BA session policies to the FW. */
+static void wl1271_set_ba_policies(struct wl1271 *wl)
+{
+	u8 tid_index;
+
+	/* 802.11n BA session setting */
+	for (tid_index = 0; tid_index < CONF_TX_MAX_TID_COUNT; ++tid_index)
+			wl1271_acx_set_ba_session(wl,
+				ACX_BA_SESSION_INITIATOR_POLICY,
+				tid_index,
+				true);
+}
+
 static int wl1271_dummy_join(struct wl1271 *wl)
 {
 	int ret = 0;
@@ -1722,6 +1738,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
 	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
+	bool set_ba = false;
 	bool do_join = false;
 	bool set_assoc = false;
 	int ret;
@@ -1962,6 +1979,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 						wl1271_warning("Set ht information failed %d", ret);
 						goto out_sleep;
 				}
+
+				set_ba = true;
 			}
 			/*
 			 * Takes care of: New association without HT,
@@ -1997,6 +2016,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl1271_warning("cmd join failed %d", ret);
 			goto out_sleep;
 		}
+
+		if (set_ba)
+			wl1271_set_ba_policies(wl);
 	}
 
 out_sleep:
-- 
1.6.0.4

