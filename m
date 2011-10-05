Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab1JEJzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:43 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/29] wl12xx: replace wl->mac_addr with vif->addr
Date: Wed,  5 Oct 2011 11:55:39 +0200
Message-Id: <1317808566-18857-3-git-send-email-eliad@wizery.com> (sfid-20111005_115548_256104_64572751)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac address of the interface already exists in vif->addr.
Use it instead of wl->mac_addr.

It seems that due to some fw bug, we still need to set nvs->mac
to the actual mac addresss, otherwise the fw doesn't function
well (e.g. can't get dhcp address).
Thus, use wl->mac_addr for this purpose, and don't delete it yet.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |    9 +++++----
 drivers/net/wireless/wl12xx/cmd.h    |    5 +++--
 drivers/net/wireless/wl12xx/event.c  |    2 +-
 drivers/net/wireless/wl12xx/init.c   |   29 ++++++++++++++++-------------
 drivers/net/wireless/wl12xx/init.h   |    4 ++--
 drivers/net/wireless/wl12xx/main.c   |   19 +++++++++++++------
 drivers/net/wireless/wl12xx/scan.c   |   32 ++++++++++++++++++--------------
 drivers/net/wireless/wl12xx/scan.h   |    5 +++--
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 9 files changed, 62 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 53eb858..cbe544b 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -358,7 +358,8 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 	return 0;
 }
 
-int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id)
+int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
+			   u8 *role_id)
 {
 	struct wl12xx_cmd_role_enable *cmd;
 	int ret;
@@ -381,7 +382,7 @@ int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id)
 		goto out_free;
 	}
 
-	memcpy(cmd->mac_address, wl->mac_addr, ETH_ALEN);
+	memcpy(cmd->mac_address, addr, ETH_ALEN);
 	cmd->role_type = role_type;
 
 	ret = wl1271_cmd_send(wl, CMD_ROLE_ENABLE, cmd, sizeof(*cmd), 0);
@@ -1200,14 +1201,14 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
 	return ret;
 }
 
-int wl1271_build_qos_null_data(struct wl1271 *wl)
+int wl1271_build_qos_null_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	struct ieee80211_qos_hdr template;
 
 	memset(&template, 0, sizeof(template));
 
 	memcpy(template.addr1, wl->bssid, ETH_ALEN);
-	memcpy(template.addr2, wl->mac_addr, ETH_ALEN);
+	memcpy(template.addr2, vif->addr, ETH_ALEN);
 	memcpy(template.addr3, wl->bssid, ETH_ALEN);
 
 	template.frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 8e4d11e..a9cea86 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -36,7 +36,8 @@ int wl128x_cmd_general_parms(struct wl1271 *wl);
 int wl1271_cmd_radio_parms(struct wl1271 *wl);
 int wl128x_cmd_radio_parms(struct wl1271 *wl);
 int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
-int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id);
+int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
+			   u8 *role_id);
 int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
 int wl12xx_cmd_role_start_dev(struct wl1271 *wl);
 int wl12xx_cmd_role_stop_dev(struct wl1271 *wl);
@@ -62,7 +63,7 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct sk_buff *skb);
 int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr);
-int wl1271_build_qos_null_data(struct wl1271 *wl);
+int wl1271_build_qos_null_data(struct wl1271 *wl, struct ieee80211_vif *vif);
 int wl1271_cmd_build_klv_null_data(struct wl1271 *wl);
 int wl12xx_cmd_set_default_wep_key(struct wl1271 *wl, u8 id, u8 hlid);
 int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index e66db69..4886032 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -234,7 +234,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl1271_debug(DEBUG_EVENT, "status: 0x%x",
 			     mbox->scheduled_scan_status);
 
-		wl1271_scan_stm(wl);
+		wl1271_scan_stm(wl, wl->scan_vif);
 	}
 
 	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 04db64c..4692a91 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -123,7 +123,8 @@ out:
 	return ret;
 }
 
-static int wl1271_ap_init_null_template(struct wl1271 *wl)
+static int wl1271_ap_init_null_template(struct wl1271 *wl,
+					struct ieee80211_vif *vif)
 {
 	struct ieee80211_hdr_3addr *nullfunc;
 	int ret;
@@ -141,8 +142,8 @@ static int wl1271_ap_init_null_template(struct wl1271 *wl)
 
 	/* nullfunc->addr1 is filled by FW */
 
-	memcpy(nullfunc->addr2, wl->mac_addr, ETH_ALEN);
-	memcpy(nullfunc->addr3, wl->mac_addr, ETH_ALEN);
+	memcpy(nullfunc->addr2, vif->addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, vif->addr, ETH_ALEN);
 
 	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, nullfunc,
@@ -153,7 +154,8 @@ out:
 	return ret;
 }
 
-static int wl1271_ap_init_qos_null_template(struct wl1271 *wl)
+static int wl1271_ap_init_qos_null_template(struct wl1271 *wl,
+					    struct ieee80211_vif *vif)
 {
 	struct ieee80211_qos_hdr *qosnull;
 	int ret;
@@ -171,8 +173,8 @@ static int wl1271_ap_init_qos_null_template(struct wl1271 *wl)
 
 	/* qosnull->addr1 is filled by FW */
 
-	memcpy(qosnull->addr2, wl->mac_addr, ETH_ALEN);
-	memcpy(qosnull->addr3, wl->mac_addr, ETH_ALEN);
+	memcpy(qosnull->addr2, vif->addr, ETH_ALEN);
+	memcpy(qosnull->addr3, vif->addr, ETH_ALEN);
 
 	rate = wl1271_tx_min_rate_get(wl, wl->basic_rate_set);
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, qosnull,
@@ -449,7 +451,7 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	return 0;
 }
 
-int wl1271_ap_init_templates(struct wl1271 *wl)
+int wl1271_ap_init_templates(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	int ret;
 
@@ -457,11 +459,11 @@ int wl1271_ap_init_templates(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_ap_init_null_template(wl);
+	ret = wl1271_ap_init_null_template(wl, vif);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_ap_init_qos_null_template(wl);
+	ret = wl1271_ap_init_qos_null_template(wl, vif);
 	if (ret < 0)
 		return ret;
 
@@ -476,9 +478,10 @@ int wl1271_ap_init_templates(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
+static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl,
+				      struct ieee80211_vif *vif)
 {
-	return wl1271_ap_init_templates(wl);
+	return wl1271_ap_init_templates(wl, vif);
 }
 
 int wl1271_init_ap_rates(struct wl1271 *wl)
@@ -576,7 +579,7 @@ out:
 }
 
 
-int wl1271_hw_init(struct wl1271 *wl)
+int wl1271_hw_init(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	struct conf_tx_ac_category *conf_ac;
 	struct conf_tx_tid *conf_tid;
@@ -694,7 +697,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 
 	/* Mode specific init - post mem init */
 	if (is_ap)
-		ret = wl1271_ap_hw_init_post_mem(wl);
+		ret = wl1271_ap_hw_init_post_mem(wl, vif);
 	else
 		ret = wl1271_sta_hw_init_post_mem(wl);
 
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index 3a3c230..b1f97bc 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -32,8 +32,8 @@ int wl1271_init_phy_config(struct wl1271 *wl);
 int wl1271_init_pta(struct wl1271 *wl);
 int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_chip_specific_init(struct wl1271 *wl);
-int wl1271_hw_init(struct wl1271 *wl);
+int wl1271_hw_init(struct wl1271 *wl, struct ieee80211_vif *vif);
 int wl1271_init_ap_rates(struct wl1271 *wl);
-int wl1271_ap_init_templates(struct wl1271 *wl);
+int wl1271_ap_init_templates(struct wl1271 *wl, struct ieee80211_vif *vif);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0aac62f..d676794 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1896,6 +1896,10 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		ret = -EINVAL;
 		goto out;
 	}
+	/*
+	 * we still need this in order to configure the fw
+	 * while uploading the nvs
+	 */
 	memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 
 	if (wl->state != WL1271_STATE_OFF) {
@@ -1923,18 +1927,19 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 			 * the STA role can get packets only from
 			 * its associated bssid)
 			 */
-			ret = wl12xx_cmd_role_enable(wl,
+			ret = wl12xx_cmd_role_enable(wl, vif->addr,
 							 WL1271_ROLE_DEVICE,
 							 &wl->dev_role_id);
 			if (ret < 0)
 				goto irq_disable;
 		}
 
-		ret = wl12xx_cmd_role_enable(wl, role_type, &wl->role_id);
+		ret = wl12xx_cmd_role_enable(wl, vif->addr,
+					     role_type, &wl->role_id);
 		if (ret < 0)
 			goto irq_disable;
 
-		ret = wl1271_hw_init(wl);
+		ret = wl1271_hw_init(wl, vif);
 		if (ret < 0)
 			goto irq_disable;
 
@@ -2019,6 +2024,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
+		wl->scan_vif = NULL;
 		wl->scan.req = NULL;
 		ieee80211_scan_completed(wl->hw, true);
 	}
@@ -2880,7 +2886,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		wl12xx_cmd_role_stop_dev(wl);
 	}
 
-	ret = wl1271_scan(hw->priv, ssid, len, req);
+	ret = wl1271_scan(hw->priv, vif, ssid, len, req);
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 out:
@@ -2916,6 +2922,7 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 	}
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
+	wl->scan_vif = NULL;
 	wl->scan.req = NULL;
 	ieee80211_scan_completed(wl->hw, true);
 
@@ -3290,7 +3297,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 			goto out;
 		}
 
-		ret = wl1271_ap_init_templates(wl);
+		ret = wl1271_ap_init_templates(wl, vif);
 		if (ret < 0)
 			goto out;
 	}
@@ -3423,7 +3430,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			if (ret < 0)
 				goto out;
 
-			ret = wl1271_build_qos_null_data(wl);
+			ret = wl1271_build_qos_null_data(wl, vif);
 			if (ret < 0)
 				goto out;
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 128ccb7..a857618 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -53,6 +53,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan.req = NULL;
+	wl->scan_vif = NULL;
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
@@ -155,8 +156,9 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 
 #define WL1271_NOTHING_TO_SCAN 1
 
-static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
-			     bool passive, u32 basic_rate)
+static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
+			    enum ieee80211_band band,
+			    bool passive, u32 basic_rate)
 {
 	struct wl1271_cmd_scan *cmd;
 	struct wl1271_cmd_trigger_scan_to *trigger;
@@ -208,7 +210,7 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 		memcpy(cmd->params.ssid, wl->scan.ssid, wl->scan.ssid_len);
 	}
 
-	memcpy(cmd->addr, wl->mac_addr, ETH_ALEN);
+	memcpy(cmd->addr, vif->addr, ETH_ALEN);
 
 	ret = wl1271_cmd_build_probe_req(wl, wl->scan.ssid, wl->scan.ssid_len,
 					 wl->scan.req->ie, wl->scan.req->ie_len,
@@ -241,7 +243,7 @@ out:
 	return ret;
 }
 
-void wl1271_scan_stm(struct wl1271 *wl)
+void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	int ret = 0;
 	enum ieee80211_band band;
@@ -254,10 +256,10 @@ void wl1271_scan_stm(struct wl1271 *wl)
 	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
 		band = IEEE80211_BAND_2GHZ;
 		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
-		ret = wl1271_scan_send(wl, band, false, rate);
+		ret = wl1271_scan_send(wl, vif, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
-			wl1271_scan_stm(wl);
+			wl1271_scan_stm(wl, vif);
 		}
 
 		break;
@@ -265,13 +267,13 @@ void wl1271_scan_stm(struct wl1271 *wl)
 	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
 		band = IEEE80211_BAND_2GHZ;
 		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
-		ret = wl1271_scan_send(wl, band, true, rate);
+		ret = wl1271_scan_send(wl, vif, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			if (wl->enable_11a)
 				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
 			else
 				wl->scan.state = WL1271_SCAN_STATE_DONE;
-			wl1271_scan_stm(wl);
+			wl1271_scan_stm(wl, vif);
 		}
 
 		break;
@@ -279,10 +281,10 @@ void wl1271_scan_stm(struct wl1271 *wl)
 	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
 		band = IEEE80211_BAND_5GHZ;
 		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
-		ret = wl1271_scan_send(wl, band, false, rate);
+		ret = wl1271_scan_send(wl, vif, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
-			wl1271_scan_stm(wl);
+			wl1271_scan_stm(wl, vif);
 		}
 
 		break;
@@ -290,10 +292,10 @@ void wl1271_scan_stm(struct wl1271 *wl)
 	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
 		band = IEEE80211_BAND_5GHZ;
 		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
-		ret = wl1271_scan_send(wl, band, true, rate);
+		ret = wl1271_scan_send(wl, vif, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_DONE;
-			wl1271_scan_stm(wl);
+			wl1271_scan_stm(wl, vif);
 		}
 
 		break;
@@ -317,7 +319,8 @@ void wl1271_scan_stm(struct wl1271 *wl)
 	}
 }
 
-int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
+int wl1271_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
+		const u8 *ssid, size_t ssid_len,
 		struct cfg80211_scan_request *req)
 {
 	/*
@@ -338,6 +341,7 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 		wl->scan.ssid_len = 0;
 	}
 
+	wl->scan_vif = vif;
 	wl->scan.req = req;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 
@@ -346,7 +350,7 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
 				     msecs_to_jiffies(WL1271_SCAN_TIMEOUT));
 
-	wl1271_scan_stm(wl);
+	wl1271_scan_stm(wl, vif);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index 9211515..15177bd 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -26,13 +26,14 @@
 
 #include "wl12xx.h"
 
-int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
+int wl1271_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
+		const u8 *ssid, size_t ssid_len,
 		struct cfg80211_scan_request *req);
 int wl1271_scan_stop(struct wl1271 *wl);
 int wl1271_scan_build_probe_req(struct wl1271 *wl,
 				const u8 *ssid, size_t ssid_len,
 				const u8 *ie, size_t ie_len, u8 band);
-void wl1271_scan_stm(struct wl1271 *wl);
+void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif);
 void wl1271_scan_complete_work(struct work_struct *work);
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 				     struct cfg80211_sched_scan_request *req,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 781ab3a..006c34c 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -506,6 +506,7 @@ struct wl1271 {
 	u32 mbox_ptr[2];
 
 	/* Are we currently scanning */
+	struct ieee80211_vif *scan_vif;
 	struct wl1271_scan scan;
 	struct delayed_work scan_complete_work;
 
-- 
1.7.6.401.g6a319

