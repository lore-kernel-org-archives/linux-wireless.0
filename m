Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64679 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1H2M3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:29:05 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 10/20] ath6kl: Use set_appie command to add Probe Request IEs
Date: Mon, 29 Aug 2011 15:23:51 +0300
Message-ID: <1314620641-24257-11-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142909_773415_990AE5AD)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 ++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    3 +++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 924f62f..d287f0a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -776,6 +776,15 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 						  request->ssids[i].ssid);
 	}
 
+	if (request->ie) {
+		if (ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_REQ,
+					     request->ie, request->ie_len)) {
+			ath6kl_err("failed to set Probe Request appie for "
+				   "scan");
+			return -EIO;
+		}
+	}
+
 	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
 				     false, 0, 0, 0, NULL) != 0) {
 		ath6kl_err("wmi_startscan_cmd failed\n");
@@ -1763,6 +1772,7 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 	    BIT(NL80211_IFTYPE_ADHOC);
 	/* max num of ssids that can be probed during scanning */
 	wdev->wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
+	wdev->wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
 	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &ath6kl_band_5ghz;
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9a01d38..a32f91d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2216,6 +2216,9 @@ int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags);
 
 int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi);
 
+int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
+			     u8 ie_len);
+
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
 
-- 
1.7.4.1

