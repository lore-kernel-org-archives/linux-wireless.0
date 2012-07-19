Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:59327 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSNA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 09:00:59 -0400
Subject: [PATCH v2 3/3] ath6kl: add support for changing contry code
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 19 Jul 2012 16:00:56 +0300
Message-ID: <20120719130056.22047.19196.stgit@x201> (sfid-20120719_150103_455709_786B5AEB)
In-Reply-To: <20120719125937.22047.91375.stgit@x201>
References: <20120719125937.22047.91375.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it possible to change the country code from user space via nl80211
add handler for reg_notifier. The feature is only enabled when built
time option CONFIG_ATH6KL_REGDOMAIN is enabled, which again depends on
CFG80211_CERTIFICATION_ONUS for certication purposes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Kconfig    |    9 +++++
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   47 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   17 ++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    6 ++++
 5 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index d755a5e..26c4b72 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -30,3 +30,12 @@ config ATH6KL_DEBUG
 	depends on ATH6KL
 	---help---
 	  Enables debug support
+
+config ATH6KL_REGDOMAIN
+	bool "Atheros ath6kl regdomain support"
+	depends on ATH6KL
+	depends on CFG80211_CERTIFICATION_ONUS
+	---help---
+	  Enabling this makes it possible to change the regdomain in
+	  the firmware. This can be only enabled if regulatory requirements
+	  are taken into account.
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0c3e65e..f834223 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3458,6 +3458,49 @@ void ath6kl_cfg80211_stop_all(struct ath6kl *ar)
 		ath6kl_cfg80211_stop(vif);
 }
 
+static int ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
+				      struct regulatory_request *request)
+{
+	struct ath6kl *ar = wiphy_priv(wiphy);
+	u32 rates[IEEE80211_NUM_BANDS];
+	int ret, i;
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+		   "cfg reg_notify %c%c%s%s initiator %d\n",
+		   request->alpha2[0], request->alpha2[1],
+		   request->intersect ? " intersect" : "",
+		   request->processed ? " processed" : "",
+		   request->initiator);
+
+	ret = ath6kl_wmi_set_regdomain_cmd(ar->wmi, request->alpha2);
+	if (ret) {
+		ath6kl_err("failed to set regdomain: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * Firmware will apply the regdomain change only after a scan is
+	 * issued and it will send a WMI_REGDOMAIN_EVENTID when it has been
+	 * changed.
+	 */
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		if (wiphy->bands[i])
+			rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+
+
+	ret = ath6kl_wmi_beginscan_cmd(ar->wmi, 0, WMI_LONG_SCAN, false,
+				       false, 0, ATH6KL_FG_SCAN_INTERVAL,
+				       0, NULL, false, rates);
+	if (ret) {
+		ath6kl_err("failed to start scan for a regdomain change: %d\n",
+			   ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int ath6kl_cfg80211_vif_init(struct ath6kl_vif *vif)
 {
 	vif->aggr_cntxt = aggr_init(vif);
@@ -3590,6 +3633,10 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 					  BIT(NL80211_IFTYPE_P2P_CLIENT);
 	}
 
+	if (config_enabled(CONFIG_ATH6KL_REGDOMAIN) &&
+	    test_bit(ATH6KL_FW_CAPABILITY_REGDOMAIN, ar->fw_capabilities))
+		wiphy->reg_notifier = ath6kl_cfg80211_reg_notify;
+
 	/* max num of ssids that can be probed during scanning */
 	wiphy->max_scan_ssids = MAX_PROBED_SSIDS;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index a754a15..eb86b31 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -124,6 +124,9 @@ enum ath6kl_fw_capability {
 	/* Firmware supports TX error rate notification */
 	ATH6KL_FW_CAPABILITY_TX_ERR_NOTIFY,
 
+	/* supports WMI_SET_REGDOMAIN_CMDID command */
+	ATH6KL_FW_CAPABILITY_REGDOMAIN,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 05cc871..cf91348 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3216,6 +3216,23 @@ int ath6kl_wmi_sta_bmiss_enhance_cmd(struct wmi *wmi, u8 if_idx, bool enhance)
 	return ret;
 }
 
+int ath6kl_wmi_set_regdomain_cmd(struct wmi *wmi, const char *alpha2)
+{
+	struct sk_buff *skb;
+	struct wmi_set_regdomain_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_regdomain_cmd *) skb->data;
+	memcpy(cmd->iso_name, alpha2, 2);
+
+	return ath6kl_wmi_cmd_send(wmi, 0, skb,
+				   WMI_SET_REGDOMAIN_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 s32 ath6kl_wmi_get_rate(s8 rate_index)
 {
 	if (rate_index == RATE_AUTO)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 5166a8e..1d510ba 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1042,6 +1042,11 @@ struct wmi_sta_bmiss_enhance_cmd {
 	u8 enable;
 } __packed;
 
+struct wmi_set_regdomain_cmd {
+	u8 length;
+	u8 iso_name[2];
+} __packed;
+
 /* WMI_SET_POWER_MODE_CMDID */
 enum wmi_power_mode {
 	REC_POWER = 0x01,
@@ -2640,6 +2645,7 @@ int ath6kl_wmi_add_del_mcast_filter_cmd(struct wmi *wmi, u8 if_idx,
 int ath6kl_wmi_sta_bmiss_enhance_cmd(struct wmi *wmi, u8 if_idx, bool enable);
 int ath6kl_wmi_set_txe_notify(struct wmi *wmi, u8 idx,
 			      u32 rate, u32 pkts, u32 intvl);
+int ath6kl_wmi_set_regdomain_cmd(struct wmi *wmi, const char *alpha2);
 
 /* AP mode uAPSD */
 int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable);

