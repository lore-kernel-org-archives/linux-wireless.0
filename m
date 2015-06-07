Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbFGN4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:56:42 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4/6] wil6210: Support hidden SSID
Date: Sun,  7 Jun 2015 16:56:29 +0300
Message-Id: <1433685391-9026-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150607_155649_616269_F0F244F1)
In-Reply-To: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

Pass hidden SSID information to FW for proper operation.
In order to be able to scan/connect to the hidden SSID, SSID
setting is added when scan is requested from FW. SSID
scanning currently supports single SSID due to FW limitation.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 46 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h  |  3 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |  4 ++-
 drivers/net/wireless/ath/wil6210/wmi.h      | 10 ++++++-
 4 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index dbfcdd1..c79cfe0 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -289,6 +289,26 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	}
 
 	wil_dbg_misc(wil, "Start scan_request 0x%p\n", request);
+	wil_dbg_misc(wil, "SSID count: %d", request->n_ssids);
+
+	for (i = 0; i < request->n_ssids; i++) {
+		wil_dbg_misc(wil, "SSID[%d]", i);
+		print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
+				     request->ssids[i].ssid,
+				     request->ssids[i].ssid_len);
+	}
+
+	if (request->n_ssids)
+		rc = wmi_set_ssid(wil, request->ssids[0].ssid_len,
+				  request->ssids[0].ssid);
+	else
+		rc = wmi_set_ssid(wil, 0, NULL);
+
+	if (rc) {
+		wil_err(wil, "set SSID for scan request failed: %d\n", rc);
+		return rc;
+	}
+
 	wil->scan_request = request;
 	mod_timer(&wil->scan_timer, jiffies + WIL6210_SCAN_TO);
 
@@ -778,6 +798,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	size_t hlen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
 	const u8 *pr_ies = NULL;
 	size_t pr_ies_len = 0;
+	u8 hidden_ssid;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
@@ -790,6 +811,8 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 		     channel->center_freq, info->privacy ? "secure" : "open");
 	wil_dbg_misc(wil, "Privacy: %d auth_type %d\n",
 		     info->privacy, info->auth_type);
+	wil_dbg_misc(wil, "Hidden SSID mode: %d\n",
+		     info->hidden_ssid);
 	wil_dbg_misc(wil, "BI %d DTIM %d\n", info->beacon_interval,
 		     info->dtim_period);
 	print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
@@ -835,10 +858,28 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	wil->privacy = info->privacy;
 
+	switch (info->hidden_ssid) {
+	case NL80211_HIDDEN_SSID_NOT_IN_USE:
+		hidden_ssid = WMI_HIDDEN_SSID_DISABLED;
+		break;
+
+	case NL80211_HIDDEN_SSID_ZERO_LEN:
+		hidden_ssid = WMI_HIDDEN_SSID_SEND_EMPTY;
+		break;
+
+	case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
+		hidden_ssid = WMI_HIDDEN_SSID_CLEAR;
+		break;
+
+	default:
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
 	netif_carrier_on(ndev);
 
 	rc = wmi_pcp_start(wil, info->beacon_interval, wmi_nettype,
-			   channel->hw_value);
+			   channel->hw_value, hidden_ssid);
 	if (rc)
 		goto err_pcp_start;
 
@@ -1023,8 +1064,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 
 static void wil_wiphy_init(struct wiphy *wiphy)
 {
-	/* TODO: set real value */
-	wiphy->max_scan_ssids = 10;
+	wiphy->max_scan_ssids = 1;
 	wiphy->max_scan_ie_len = WMI_MAX_IE_LEN;
 	wiphy->max_num_pmkids = 0 /* TODO: */;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c39369f..78c7536 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -764,7 +764,8 @@ struct wireless_dev *wil_cfg80211_init(struct device *dev);
 void wil_wdev_free(struct wil6210_priv *wil);
 
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
-int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan);
+int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
+		  u8 chan, u8 hidden_ssid);
 int wmi_pcp_stop(struct wil6210_priv *wil);
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 			u16 reason_code, bool from_event);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 26c707f..c759759 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -825,7 +825,8 @@ int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
 	return wmi_send(wil, WMI_SET_MAC_ADDRESS_CMDID, &cmd, sizeof(cmd));
 }
 
-int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
+int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
+		  u8 chan, u8 hidden_ssid)
 {
 	int rc;
 
@@ -835,6 +836,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 		.disable_sec_offload = 1,
 		.channel = chan - 1,
 		.pcp_max_assoc_sta = max_assoc_sta,
+		.hidden_ssid = hidden_ssid,
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index cc04ab7..6e90e78 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -495,10 +495,18 @@ struct wmi_power_mgmt_cfg_cmd {
 /*
  * WMI_PCP_START_CMDID
  */
+
+enum wmi_hidden_ssid {
+	WMI_HIDDEN_SSID_DISABLED	= 0,
+	WMI_HIDDEN_SSID_SEND_EMPTY	= 1,
+	WMI_HIDDEN_SSID_CLEAR	= 2,
+};
+
 struct wmi_pcp_start_cmd {
 	__le16 bcon_interval;
 	u8 pcp_max_assoc_sta;
-	u8 reserved0[9];
+	u8 hidden_ssid;
+	u8 reserved0[8];
 	u8 network_type;
 	u8 channel;
 	u8 disable_sec_offload;
-- 
2.1.4

