Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0071.outbound.protection.outlook.com ([104.47.0.71]:31136
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752010AbdF0WH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 18:07:58 -0400
From: peter.oh@bowerswilkins.com
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Peter Oh <peter.oh@bowerswilkins.com>, johannes.berg@intel.com
Subject: [PATCH] ieee80211: update public action codes
Date: Tue, 27 Jun 2017 15:07:29 -0700
Message-Id: <1498601249-8372-1-git-send-email-peter.oh@bowerswilkins.com> (sfid-20170628_000813_941100_16976F4A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Oh <peter.oh@bowerswilkins.com>

Update Public Action field values as updated in IEEE Std 802.11-2016,
so that modules/drivers can refer it.

Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
---
 include/linux/ieee80211.h | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6903335..91a1145 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2113,10 +2113,43 @@ enum ieee80211_key_len {
 
 #define PMK_MAX_LEN			48
 
-/* Public action codes */
+/* Public action codes (IEEE Std 802.11-2016, 9.6.8.1, Table 9-307) */
 enum ieee80211_pub_actioncode {
+	WLAN_PUB_ACTION_20_40_BSS_COEX = 0,
+	WLAN_PUB_ACTION_DSE_ENABLEMENT = 1,
+	WLAN_PUB_ACTION_DSE_DEENABLEMENT = 2,
+	WLAN_PUB_ACTION_DSE_REG_LOC_ANN = 3,
 	WLAN_PUB_ACTION_EXT_CHANSW_ANN = 4,
+	WLAN_PUB_ACTION_DSE_MSMT_REQ = 5,
+	WLAN_PUB_ACTION_DSE_MSMT_RESP = 6,
+	WLAN_PUB_ACTION_MSMT_PILOT = 7,
+	WLAN_PUB_ACTION_DSE_PC = 8,
+	WLAN_PUB_ACTION_VENDOR_SPECIFIC = 9,
+	WLAN_PUB_ACTION_GAS_INITIAL_REQ = 10,
+	WLAN_PUB_ACTION_GAS_INITIAL_RESP = 11,
+	WLAN_PUB_ACTION_GAS_COMEBACK_REQ = 12,
+	WLAN_PUB_ACTION_GAS_COMEBACK_RESP = 13,
 	WLAN_PUB_ACTION_TDLS_DISCOVER_RES = 14,
+	WLAN_PUB_ACTION_LOC_TRACK_NOTI = 15,
+	WLAN_PUB_ACTION_QAB_REQUEST_FRAME = 16,
+	WLAN_PUB_ACTION_QAB_RESPONSE_FRAME = 17,
+	WLAN_PUB_ACTION_QMF_POLICY = 18,
+	WLAN_PUB_ACTION_QMF_POLICY_CHANGE = 19,
+	WLAN_PUB_ACTION_QLOAD_REQUEST = 20,
+	WLAN_PUB_ACTION_QLOAD_REPORT = 21,
+	WLAN_PUB_ACTION_HCCA_TXOP_ADVERT = 22,
+	WLAN_PUB_ACTION_HCCA_TXOP_RESPONSE = 23,
+	WLAN_PUB_ACTION_PUBLIC_KEY = 24,
+	WLAN_PUB_ACTION_CHANNEL_AVAIL_QUERY = 25,
+	WLAN_PUB_ACTION_CHANNEL_SCHEDULE_MGMT = 26,
+	WLAN_PUB_ACTION_CONTACT_VERI_SIGNAL = 27,
+	WLAN_PUB_ACTION_GDD_ENABLEMENT_REQ = 28,
+	WLAN_PUB_ACTION_GDD_ENABLEMENT_RESP = 29,
+	WLAN_PUB_ACTION_NETWORK_CHANNEL_CONTROL = 30,
+	WLAN_PUB_ACTION_WHITE_SPACE_MAP_ANN = 31,
+	WLAN_PUB_ACTION_FTM_REQUEST = 32,
+	WLAN_PUB_ACTION_FTM = 33,
+	WLAN_PUB_ACTION_FILS_DISCOVERY = 34,
 };
 
 /* TDLS action codes */
-- 
2.7.4
