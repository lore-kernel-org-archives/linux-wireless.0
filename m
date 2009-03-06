Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52078 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZCFOcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 09:32:43 -0500
Received: by mail-fx0-f176.google.com with SMTP id 24so402680fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 06:32:41 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Subject: [PATCH 2/3] ipw2x00: Use IE definitions from linux/ieee80211.h
Date: Fri, 6 Mar 2009 15:32:26 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903061532.27306.helmut.schaa@gmail.com> (sfid-20090306_153245_395884_D287F6B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use IE definitions from linux/ieee80211.h and drop the appropriate enum
from ipw2x00/ieee80211.h

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/drivers/net/wireless/ipw2x00/ieee80211.h b/drivers/net/wireless/ipw2x00/ieee80211.h
index e292114..299e29f 100644
--- a/drivers/net/wireless/ipw2x00/ieee80211.h
+++ b/drivers/net/wireless/ipw2x00/ieee80211.h
@@ -358,37 +358,6 @@ Total: 28-2340 bytes
 
 #define BEACON_PROBE_SSID_ID_POSITION 12
 
-/* Management Frame Information Element Types */
-enum ieee80211_mfie {
-	MFIE_TYPE_SSID = 0,
-	MFIE_TYPE_RATES = 1,
-	MFIE_TYPE_FH_SET = 2,
-	MFIE_TYPE_DS_SET = 3,
-	MFIE_TYPE_CF_SET = 4,
-	MFIE_TYPE_TIM = 5,
-	MFIE_TYPE_IBSS_SET = 6,
-	MFIE_TYPE_COUNTRY = 7,
-	MFIE_TYPE_HOP_PARAMS = 8,
-	MFIE_TYPE_HOP_TABLE = 9,
-	MFIE_TYPE_REQUEST = 10,
-	MFIE_TYPE_CHALLENGE = 16,
-	MFIE_TYPE_POWER_CONSTRAINT = 32,
-	MFIE_TYPE_POWER_CAPABILITY = 33,
-	MFIE_TYPE_TPC_REQUEST = 34,
-	MFIE_TYPE_TPC_REPORT = 35,
-	MFIE_TYPE_SUPP_CHANNELS = 36,
-	MFIE_TYPE_CSA = 37,
-	MFIE_TYPE_MEASURE_REQUEST = 38,
-	MFIE_TYPE_MEASURE_REPORT = 39,
-	MFIE_TYPE_QUIET = 40,
-	MFIE_TYPE_IBSS_DFS = 41,
-	MFIE_TYPE_ERP_INFO = 42,
-	MFIE_TYPE_RSN = 48,
-	MFIE_TYPE_RATES_EX = 50,
-	MFIE_TYPE_GENERIC = 221,
-	MFIE_TYPE_QOS_PARAMETER = 222,
-};
-
 struct ieee80211_hdr_1addr {
 	__le16 frame_ctl;
 	__le16 duration_id;
diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
index 794d2fc..0790079 100644
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -1081,36 +1081,36 @@ static int ieee80211_parse_qos_info_param_IE(struct ieee80211_info_element
 }
 
 #ifdef CONFIG_LIBIPW_DEBUG
-#define MFIE_STRING(x) case MFIE_TYPE_ ##x: return #x
+#define MFIE_STRING(x) case WLAN_EID_ ##x: return #x
 
 static const char *get_info_element_string(u16 id)
 {
 	switch (id) {
 		MFIE_STRING(SSID);
-		MFIE_STRING(RATES);
-		MFIE_STRING(FH_SET);
-		MFIE_STRING(DS_SET);
-		MFIE_STRING(CF_SET);
+		MFIE_STRING(SUPP_RATES);
+		MFIE_STRING(FH_PARAMS);
+		MFIE_STRING(DS_PARAMS);
+		MFIE_STRING(CF_PARAMS);
 		MFIE_STRING(TIM);
-		MFIE_STRING(IBSS_SET);
+		MFIE_STRING(IBSS_PARAMS);
 		MFIE_STRING(COUNTRY);
-		MFIE_STRING(HOP_PARAMS);
-		MFIE_STRING(HOP_TABLE);
+		MFIE_STRING(HP_PARAMS);
+		MFIE_STRING(HP_TABLE);
 		MFIE_STRING(REQUEST);
 		MFIE_STRING(CHALLENGE);
-		MFIE_STRING(POWER_CONSTRAINT);
-		MFIE_STRING(POWER_CAPABILITY);
+		MFIE_STRING(PWR_CONSTRAINT);
+		MFIE_STRING(PWR_CAPABILITY);
 		MFIE_STRING(TPC_REQUEST);
 		MFIE_STRING(TPC_REPORT);
-		MFIE_STRING(SUPP_CHANNELS);
-		MFIE_STRING(CSA);
+		MFIE_STRING(SUPPORTED_CHANNELS);
+		MFIE_STRING(CHANNEL_SWITCH);
 		MFIE_STRING(MEASURE_REQUEST);
 		MFIE_STRING(MEASURE_REPORT);
 		MFIE_STRING(QUIET);
 		MFIE_STRING(IBSS_DFS);
 		MFIE_STRING(ERP_INFO);
 		MFIE_STRING(RSN);
-		MFIE_STRING(RATES_EX);
+		MFIE_STRING(EXT_SUPP_RATES);
 		MFIE_STRING(GENERIC);
 		MFIE_STRING(QOS_PARAMETER);
 	default:
@@ -1145,7 +1145,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 		}
 
 		switch (info_element->id) {
-		case MFIE_TYPE_SSID:
+		case WLAN_EID_SSID:
 			network->ssid_len = min(info_element->len,
 						(u8) IW_ESSID_MAX_SIZE);
 			memcpy(network->ssid, info_element->data,
@@ -1154,13 +1154,13 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 				memset(network->ssid + network->ssid_len, 0,
 				       IW_ESSID_MAX_SIZE - network->ssid_len);
 
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_SSID: '%s' len=%d.\n",
+			IEEE80211_DEBUG_MGMT("WLAN_EID_SSID: '%s' len=%d.\n",
 					     print_ssid(ssid, network->ssid,
 							network->ssid_len),
 					     network->ssid_len);
 			break;
 
-		case MFIE_TYPE_RATES:
+		case WLAN_EID_SUPP_RATES:
 #ifdef CONFIG_LIBIPW_DEBUG
 			p = rates_str;
 #endif
@@ -1183,11 +1183,11 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 				}
 			}
 
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_RATES: '%s' (%d)\n",
+			IEEE80211_DEBUG_MGMT("WLAN_EID_SUPP_RATES: '%s' (%d)\n",
 					     rates_str, network->rates_len);
 			break;
 
-		case MFIE_TYPE_RATES_EX:
+		case WLAN_EID_EXT_SUPP_RATES:
 #ifdef CONFIG_LIBIPW_DEBUG
 			p = rates_str;
 #endif
@@ -1210,49 +1210,49 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 				}
 			}
 
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_RATES_EX: '%s' (%d)\n",
+			IEEE80211_DEBUG_MGMT("WLAN_EID_EXT_SUPP_RATES: '%s' (%d)\n",
 					     rates_str, network->rates_ex_len);
 			break;
 
-		case MFIE_TYPE_DS_SET:
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_DS_SET: %d\n",
+		case WLAN_EID_DS_PARAMS:
+			IEEE80211_DEBUG_MGMT("WLAN_EID_DS_PARAMS: %d\n",
 					     info_element->data[0]);
 			network->channel = info_element->data[0];
 			break;
 
-		case MFIE_TYPE_FH_SET:
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_FH_SET: ignored\n");
+		case WLAN_EID_FH_PARAMS:
+			IEEE80211_DEBUG_MGMT("WLAN_EID_FH_PARAMS: ignored\n");
 			break;
 
-		case MFIE_TYPE_CF_SET:
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_CF_SET: ignored\n");
+		case WLAN_EID_CF_PARAMS:
+			IEEE80211_DEBUG_MGMT("WLAN_EID_CF_PARAMS: ignored\n");
 			break;
 
-		case MFIE_TYPE_TIM:
+		case WLAN_EID_TIM:
 			network->tim.tim_count = info_element->data[0];
 			network->tim.tim_period = info_element->data[1];
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_TIM: partially ignored\n");
+			IEEE80211_DEBUG_MGMT("WLAN_EID_TIM: partially ignored\n");
 			break;
 
-		case MFIE_TYPE_ERP_INFO:
+		case WLAN_EID_ERP_INFO:
 			network->erp_value = info_element->data[0];
 			network->flags |= NETWORK_HAS_ERP_VALUE;
 			IEEE80211_DEBUG_MGMT("MFIE_TYPE_ERP_SET: %d\n",
 					     network->erp_value);
 			break;
 
-		case MFIE_TYPE_IBSS_SET:
+		case WLAN_EID_IBSS_PARAMS:
 			network->atim_window = info_element->data[0];
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_IBSS_SET: %d\n",
+			IEEE80211_DEBUG_MGMT("WLAN_EID_IBSS_PARAMS: %d\n",
 					     network->atim_window);
 			break;
 
-		case MFIE_TYPE_CHALLENGE:
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_CHALLENGE: ignored\n");
+		case WLAN_EID_CHALLENGE:
+			IEEE80211_DEBUG_MGMT("WLAN_EID_CHALLENGE: ignored\n");
 			break;
 
-		case MFIE_TYPE_GENERIC:
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_GENERIC: %d bytes\n",
+		case WLAN_EID_GENERIC:
+			IEEE80211_DEBUG_MGMT("WLAN_EID_GENERIC: %d bytes\n",
 					     info_element->len);
 			if (!ieee80211_parse_qos_info_param_IE(info_element,
 							       network))
@@ -1270,8 +1270,8 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			}
 			break;
 
-		case MFIE_TYPE_RSN:
-			IEEE80211_DEBUG_MGMT("MFIE_TYPE_RSN: %d bytes\n",
+		case WLAN_EID_RSN:
+			IEEE80211_DEBUG_MGMT("WLAN_EID_RSN: %d bytes\n",
 					     info_element->len);
 			network->rsn_ie_len = min(info_element->len + 2,
 						  MAX_WPA_IE_LEN);
@@ -1279,22 +1279,22 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			       network->rsn_ie_len);
 			break;
 
-		case MFIE_TYPE_QOS_PARAMETER:
+		case WLAN_EID_QOS_PARAMETER:
 			printk(KERN_ERR
 			       "QoS Error need to parse QOS_PARAMETER IE\n");
 			break;
 			/* 802.11h */
-		case MFIE_TYPE_POWER_CONSTRAINT:
+		case WLAN_EID_PWR_CONSTRAINT:
 			network->power_constraint = info_element->data[0];
 			network->flags |= NETWORK_HAS_POWER_CONSTRAINT;
 			break;
 
-		case MFIE_TYPE_CSA:
+		case WLAN_EID_CHANNEL_SWITCH:
 			network->power_constraint = info_element->data[0];
 			network->flags |= NETWORK_HAS_CSA;
 			break;
 
-		case MFIE_TYPE_QUIET:
+		case WLAN_EID_QUIET:
 			network->quiet.count = info_element->data[0];
 			network->quiet.period = info_element->data[1];
 			network->quiet.duration = info_element->data[2];
@@ -1302,7 +1302,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			network->flags |= NETWORK_HAS_QUIET;
 			break;
 
-		case MFIE_TYPE_IBSS_DFS:
+		case WLAN_EID_IBSS_DFS:
 			if (network->ibss_dfs)
 				break;
 			network->ibss_dfs = kmemdup(info_element->data,
@@ -1313,7 +1313,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			network->flags |= NETWORK_HAS_IBSS_DFS;
 			break;
 
-		case MFIE_TYPE_TPC_REPORT:
+		case WLAN_EID_TPC_REPORT:
 			network->tpc_report.transmit_power =
 			    info_element->data[0];
 			network->tpc_report.link_margin = info_element->data[1];
