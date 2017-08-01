Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38523 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdHAJKQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:10:16 -0400
Received: by mail-pf0-f194.google.com with SMTP id e3so1574504pfc.5
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 02:10:15 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH 4/8] rsi: add support for U-APSD power save
Date: Tue,  1 Aug 2017 14:35:48 +0530
Message-Id: <1501578352-10795-5-git-send-email-amitkarwar@gmail.com> (sfid-20170801_111019_453902_B7A97390)
In-Reply-To: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
References: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

This patch adds support for U-APSD power save. Configuration
frame is downloaded to firmware with default settings and
support is advertised to mac80211

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 19 +++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  3 +++
 drivers/net/wireless/rsi/rsi_91x_ps.c       | 18 ++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_mgmt.h         |  6 ++++++
 5 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 38f4e59..dfa952e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -327,6 +327,7 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
 	struct rsi_common *common = adapter->priv;
 	int ret = -EOPNOTSUPP;
 
+	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
 	mutex_lock(&common->mutex);
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -561,6 +562,16 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 		/* Update DTIM period and listen interval */
 		adapter->ps_info.dtim_interval_duration = bss->dtim_period;
 		adapter->ps_info.listen_interval = conf->listen_interval;
+
+	/* If U-APSD is updated, send ps parameters to firmware */
+	if (bss->assoc) {
+		if (common->uapsd_bitmap) {
+			rsi_dbg(INFO_ZONE, "Configuring UAPSD\n");
+			rsi_conf_uapsd(adapter);
+		}
+	} else {
+		common->uapsd_bitmap = 0;
+	}
 	}
 
 	if (changed & BSS_CHANGED_CQM) {
@@ -642,6 +653,12 @@ static int rsi_mac80211_conf_tx(struct ieee80211_hw *hw,
 	memcpy(&common->edca_params[idx],
 	       params,
 	       sizeof(struct ieee80211_tx_queue_params));
+
+	if (params->uapsd)
+		common->uapsd_bitmap |= idx;
+	else
+		common->uapsd_bitmap &= (~idx);
+
 	mutex_unlock(&common->mutex);
 
 	return 0;
@@ -1312,6 +1329,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	hw->max_rates = 1;
 	hw->max_rate_tries = MAX_RETRIES;
+	hw->uapsd_queues = RSI_IEEE80211_UAPSD_QUEUES;
+	hw->uapsd_max_sp_len = IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL;
 
 	hw->max_tx_aggregation_subframes = 6;
 	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 1758d84..2568945 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1425,6 +1425,9 @@ int rsi_send_ps_request(struct rsi_hw *adapter, bool enable)
 		ps->desc.desc_dword0.len_qno |= cpu_to_le16(RSI_PS_DISABLE_IND);
 		ps->desc.desc_dword3.token = cpu_to_le16(RSI_WAKEUP_REQUEST);
 	}
+
+	ps->ps_uapsd_acs = common->uapsd_bitmap;
+
 	ps->ps_sleep.sleep_type = ps_info->sleep_type;
 	ps->ps_sleep.num_bcns_per_lis_int =
 		cpu_to_le16(ps_info->num_bcns_per_lis_int);
diff --git a/drivers/net/wireless/rsi/rsi_91x_ps.c b/drivers/net/wireless/rsi/rsi_91x_ps.c
index 5762363..a20b2cb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_ps.c
+++ b/drivers/net/wireless/rsi/rsi_91x_ps.c
@@ -124,6 +124,23 @@ void rsi_disable_ps(struct rsi_hw *adapter)
 	rsi_modify_ps_state(adapter, PS_DISABLE_REQ_SENT);
 }
 
+/* This function configures UAPSD powersave */
+void rsi_conf_uapsd(struct rsi_hw *adapter)
+{
+	int ret;
+
+	if (adapter->ps_state != PS_ENABLED)
+		return;
+
+	ret = rsi_send_ps_request(adapter, false);
+	if (!ret)
+		ret = rsi_send_ps_request(adapter, true);
+	if (ret)
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to send PS request to device\n",
+			__func__);
+}
+
 /* This function Processes powersave confirmation */
 int rsi_handle_ps_confirm(struct rsi_hw *adapter, u8 *msg)
 {
@@ -147,3 +164,4 @@ int rsi_handle_ps_confirm(struct rsi_hw *adapter, u8 *msg)
 
 	return 0;
 }
+
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 9aada0b..d2cc47e 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -243,6 +243,7 @@ struct rsi_common {
 	u16 oper_mode;
 	u8 lp_ps_handshake_mode;
 	u8 ulp_ps_handshake_mode;
+	u8 uapsd_bitmap;
 	u8 rf_power_val;
 	u8 wlan_rf_power_mode;
 	u8 obm_ant_sel_val;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index c5d114d..b22103f 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -181,6 +181,12 @@
 #define RSI_SLEEP_REQUEST		1
 #define RSI_WAKEUP_REQUEST		2
 
+#define RSI_IEEE80211_UAPSD_QUEUES \
+	(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO | \
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI | \
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE | \
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
+
 enum opmode {
 	STA_OPMODE = 1,
 	AP_OPMODE = 2
-- 
2.7.4
