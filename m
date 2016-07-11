Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61647 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933947AbcGKPBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 11:01:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6BEpf4R000337
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:01:37 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 2430sge586-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:01:37 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/9] mwifiex: support random MAC address for scanning
Date: Mon, 11 Jul 2016 20:23:47 +0530
Message-ID: <1468248832-21969-5-git-send-email-akarwar@marvell.com> (sfid-20160711_170144_531316_ADA585DB)
In-Reply-To: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

This patch advertises RANDOM_MAC_ADDR feature to cfg80211. It allow the
application to issue scan with a MAC address and mask. Random MACs are
generated and used in probe requests sent for scanning until it is changed
by the application or device is restarted.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 15 ++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/fw.h       |  7 +++++++
 drivers/net/wireless/marvell/mwifiex/main.h     |  1 +
 drivers/net/wireless/marvell/mwifiex/scan.c     | 16 ++++++++++++++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 867ab81..8955f8c 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2483,6 +2483,16 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 
 	priv->scan_request = request;
 
+	if (request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+		ether_addr_copy(priv->random_mac, request->mac_addr);
+		for (i = 0; i < ETH_ALEN; i++) {
+			priv->random_mac[i] &= request->mac_addr_mask[i];
+			priv->random_mac[i] |= get_random_int() &
+					       ~(request->mac_addr_mask[i]);
+		}
+	}
+
+	ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
 	user_scan_cfg->num_ssids = request->n_ssids;
 	user_scan_cfg->ssid_list = request->ssids;
 
@@ -4171,7 +4181,10 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->features |= NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_INACTIVITY_TIMER |
 			   NL80211_FEATURE_LOW_PRIORITY_SCAN |
-			   NL80211_FEATURE_NEED_OBSS_SCAN;
+			   NL80211_FEATURE_NEED_OBSS_SCAN |
+			   NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
+			   NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
+			   NL80211_FEATURE_ND_RANDOM_MAC_ADDR;
 
 	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
 		wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index c46267b..3797ef4 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -188,6 +188,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_BTCOEX_WL_AGGR_WINSIZE  (PROPRIETARY_TLV_BASE_ID + 202)
 #define TLV_BTCOEX_WL_SCANTIME      (PROPRIETARY_TLV_BASE_ID + 203)
 #define TLV_TYPE_BSS_MODE           (PROPRIETARY_TLV_BASE_ID + 206)
+#define TLV_TYPE_RANDOM_MAC         (PROPRIETARY_TLV_BASE_ID + 236)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -780,6 +781,11 @@ struct mwifiex_ie_types_scan_chan_gap {
 	__le16 chan_gap;
 } __packed;
 
+struct mwifiex_ie_types_random_mac {
+	struct mwifiex_ie_types_header header;
+	u8 mac[ETH_ALEN];
+} __packed;
+
 struct mwifiex_ietypes_chanstats {
 	struct mwifiex_ie_types_header header;
 	struct mwifiex_fw_chan_stats chanstats[0];
@@ -1464,6 +1470,7 @@ struct mwifiex_user_scan_cfg {
 	/* Variable number (fixed maximum) of channels to scan up */
 	struct mwifiex_user_scan_chan chan_list[MWIFIEX_USER_SCAN_CHAN_MAX];
 	u16 scan_chan_gap;
+	u8 random_mac[ETH_ALEN];
 } __packed;
 
 #define MWIFIEX_BG_SCAN_CHAN_MAX 38
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 9f6bb40..5902600 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -675,6 +675,7 @@ struct mwifiex_private {
 	struct mwifiex_user_scan_chan hidden_chan[MWIFIEX_USER_SCAN_CHAN_MAX];
 	u8 assoc_resp_ht_param;
 	bool ht_param_present;
+	u8 random_mac[ETH_ALEN];
 };
 
 
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 87e7000..ed252d8 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -820,6 +820,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
 	struct mwifiex_ie_types_scan_chan_gap *chan_gap_tlv;
+	struct mwifiex_ie_types_random_mac *random_mac_tlv;
 	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
 	struct mwifiex_ie_types_bssid_list *bssid_tlv;
 	u8 *tlv_pos;
@@ -835,6 +836,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	u8 ssid_filter;
 	struct mwifiex_ie_types_htcap *ht_cap;
 	struct mwifiex_ie_types_bss_mode *bss_mode;
+	const u8 zero_mac[6] = {0, 0, 0, 0, 0, 0};
 
 	/* The tlv_buf_len is calculated for each scan command.  The TLVs added
 	   in this routine will be preserved since the routine that sends the
@@ -967,6 +969,18 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 			tlv_pos +=
 				  sizeof(struct mwifiex_ie_types_scan_chan_gap);
 		}
+
+		if (!ether_addr_equal(user_scan_in->random_mac, zero_mac)) {
+			random_mac_tlv = (void *)tlv_pos;
+			random_mac_tlv->header.type =
+					 cpu_to_le16(TLV_TYPE_RANDOM_MAC);
+			random_mac_tlv->header.len =
+				    cpu_to_le16(sizeof(random_mac_tlv->mac));
+			ether_addr_copy(random_mac_tlv->mac,
+					user_scan_in->random_mac);
+			tlv_pos +=
+				  sizeof(struct mwifiex_ie_types_random_mac);
+		}
 	} else {
 		scan_cfg_out->bss_mode = (u8) adapter->scan_mode;
 		num_probes = adapter->scan_probes;
@@ -1922,6 +1936,7 @@ mwifiex_active_scan_req_for_passive_chan(struct mwifiex_private *priv)
 	}
 
 	adapter->active_scan_triggered = true;
+	ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
 	user_scan_cfg->num_ssids = priv->scan_request->n_ssids;
 	user_scan_cfg->ssid_list = priv->scan_request->ssids;
 
@@ -2749,6 +2764,7 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	if (!scan_cfg)
 		return -ENOMEM;
 
+	ether_addr_copy(scan_cfg->random_mac, priv->random_mac);
 	scan_cfg->ssid_list = req_ssid;
 	scan_cfg->num_ssids = 1;
 
-- 
1.9.1

