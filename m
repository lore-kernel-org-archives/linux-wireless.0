Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49735 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab2DSWdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 18:33:31 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH 1/2] ath6kl: support fw reporting phy capabilities
Date: Thu, 19 Apr 2012 15:31:56 -0700
Message-ID: <1334874717-7431-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120420_003335_627113_7E11B4DE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the supported bands are just hard coded in the driver.
However, the ath6kl FW will include its 11n and band capabilites in a
WMI_READY event. Handle this and report capabilites to cfg80211
accordingly.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   36 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   10 +++++++
 5 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a8a7570..b848977 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3419,6 +3419,7 @@ err:
 int ath6kl_cfg80211_init(struct ath6kl *ar)
 {
 	struct wiphy *wiphy = ar->wiphy;
+	bool band_2gig = false, band_5gig = false, ht = false;
 	int ret;
 
 	wiphy->mgmt_stypes = ath6kl_mgmt_stypes;
@@ -3439,8 +3440,39 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	/* max num of ssids that can be probed during scanning */
 	wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
 	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
-	wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
-	wiphy->bands[IEEE80211_BAND_5GHZ] = &ath6kl_band_5ghz;
+	switch (ar->hw.cap) {
+	case WMI_11AN_CAP:
+		ht = true;
+	case WMI_11A_CAP:
+		band_5gig = true;
+		break;
+	case WMI_11GN_CAP:
+		ht = true;
+	case WMI_11G_CAP:
+		band_2gig = true;
+		break;
+	case WMI_11AGN_CAP:
+		ht = true;
+	case WMI_11AG_CAP:
+		band_2gig = true;
+		band_5gig = true;
+		break;
+	default:
+		ath6kl_err("invalid phy capability!\n");
+		return -EINVAL;
+	}
+
+	if (!ht) {
+		ath6kl_band_2ghz.ht_cap.cap = 0;
+		ath6kl_band_2ghz.ht_cap.ht_supported = false;
+		ath6kl_band_5ghz.ht_cap.cap = 0;
+		ath6kl_band_5ghz.ht_cap.ht_supported = false;
+	}
+	if (band_2gig)
+		wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
+	if (band_5gig)
+		wiphy->bands[IEEE80211_BAND_5GHZ] = &ath6kl_band_5ghz;
+
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
 	wiphy->cipher_suites = cipher_suites;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index a97cb83..c26f0a26 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -683,6 +683,7 @@ struct ath6kl {
 		u32 refclk_hz;
 		u32 uarttx_pin;
 		u32 testscript_addr;
+		enum wmi_phy_cap cap;
 
 		struct ath6kl_hw_fw {
 			const char *dir;
@@ -816,7 +817,8 @@ void aggr_reset_state(struct aggr_info_conn *aggr_conn);
 struct ath6kl_sta *ath6kl_find_sta(struct ath6kl_vif *vif, u8 *node_addr);
 struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid);
 
-void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver);
+void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver,
+			enum wmi_phy_cap cap);
 int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 		      enum htc_endpoint_id eid);
 void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel,
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 4f3aab2..ff0b999 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -548,7 +548,8 @@ void ath6kl_disconnect(struct ath6kl_vif *vif)
 
 /* WMI Event handlers */
 
-void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
+void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver,
+			enum wmi_phy_cap cap)
 {
 	struct ath6kl *ar = devt;
 
@@ -558,6 +559,7 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 
 	ar->version.wlan_ver = sw_ver;
 	ar->version.abi_ver = abi_ver;
+	ar->hw.cap = cap;
 
 	snprintf(ar->wiphy->fw_version,
 		 sizeof(ar->wiphy->fw_version),
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index db688a2..2eb771a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -690,7 +690,7 @@ static int ath6kl_wmi_ready_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	ath6kl_ready_event(wmi->parent_dev, ev->mac_addr,
 			   le32_to_cpu(ev->sw_version),
-			   le32_to_cpu(ev->abi_version));
+			   le32_to_cpu(ev->abi_version), ev->phy_cap);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 190b2c4..9966140 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1417,6 +1417,16 @@ struct wmi_ready_event_2 {
 	u8 phy_cap;
 } __packed;
 
+/* WMI_PHY_CAPABILITY */
+enum wmi_phy_cap {
+	WMI_11A_CAP = 0x01,
+	WMI_11G_CAP = 0x02,
+	WMI_11AG_CAP = 0x03,
+	WMI_11AN_CAP = 0x04,
+	WMI_11GN_CAP = 0x05,
+	WMI_11AGN_CAP = 0x06,
+};
+
 /* Connect Event */
 struct wmi_connect_event {
 	union {
-- 
1.7.4.1

