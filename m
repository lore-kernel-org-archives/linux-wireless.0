Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40748 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMGc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:06:32 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 15/29] staging: wilc1000: remove unused wid from cfg struct
Date: Thu, 20 Sep 2018 11:53:26 +0530
Message-ID: <1537424620-6982-16-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_085424_758915_9C5B8B97)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unused element stored in cfg struct.
Removed those wid from the cfg variables whose value is not
fetched(GET_CFG) from the code. In case the wid is only set to the
firmware then there is need to store them as part of cfg variables, so
removed the unused code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 107 -------------------------------
 1 file changed, 107 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 2c463a3..541251b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -20,131 +20,36 @@ enum cfg_cmd_type {
 struct wilc_mac_cfg {
 	int mac_status;
 	u8 mac_address[7];
-	u8 ip_address[5];
-	u8 bssid[7];
-	u8 ssid[34];
 	u8 firmware_version[129];
-	u8 supp_rate[24];
-	u8 wep_key[28];
-	u8 i_psk[66];
-	u8 hw_product_version[33];
-	u8 phyversion[17];
-	u8 supp_username[21];
-	u8 supp_password[64];
-	u8 assoc_req[256];
 	u8 assoc_rsp[256];
-	u8 firmware_info[8];
-	u8 scan_result[256];
-	u8 scan_result1[256];
 };
 
 static struct wilc_mac_cfg g_mac;
 
 static struct wilc_cfg_byte g_cfg_byte[] = {
-	{WID_BSS_TYPE, 0},
-	{WID_CURRENT_TX_RATE, 0},
-	{WID_CURRENT_CHANNEL, 0},
-	{WID_PREAMBLE, 0},
-	{WID_11G_OPERATING_MODE, 0},
 	{WID_STATUS, 0},
-	{WID_SCAN_TYPE, 0},
-	{WID_KEY_ID, 0},
-	{WID_QOS_ENABLE, 0},
-	{WID_POWER_MANAGEMENT, 0},
-	{WID_11I_MODE, 0},
-	{WID_AUTH_TYPE, 0},
-	{WID_SITE_SURVEY, 0},
-	{WID_LISTEN_INTERVAL, 0},
-	{WID_DTIM_PERIOD, 0},
-	{WID_ACK_POLICY, 0},
-	{WID_BCAST_SSID, 0},
-	{WID_REKEY_POLICY, 0},
-	{WID_SHORT_SLOT_ALLOWED, 0},
-	{WID_START_SCAN_REQ, 0},
 	{WID_RSSI, 0},
 	{WID_LINKSPEED, 0},
-	{WID_AUTO_RX_SENSITIVITY, 0},
-	{WID_DATAFLOW_CONTROL, 0},
-	{WID_SCAN_FILTER, 0},
-	{WID_11N_PROT_MECH, 0},
-	{WID_11N_ERP_PROT_TYPE, 0},
-	{WID_11N_ENABLE, 0},
-	{WID_11N_OPERATING_MODE, 0},
-	{WID_11N_OBSS_NONHT_DETECTION, 0},
-	{WID_11N_HT_PROT_TYPE, 0},
-	{WID_11N_RIFS_PROT_ENABLE, 0},
-	{WID_11N_SMPS_MODE, 0},
-	{WID_11N_CURRENT_TX_MCS, 0},
-	{WID_11N_SHORT_GI_ENABLE, 0},
-	{WID_RIFS_MODE, 0},
-	{WID_TX_ABORT_CONFIG, 0},
-	{WID_11N_IMMEDIATE_BA_ENABLED, 0},
-	{WID_11N_TXOP_PROT_DISABLE, 0},
 	{WID_NIL, 0}
 };
 
 static struct wilc_cfg_hword g_cfg_hword[] = {
-	{WID_LINK_LOSS_THRESHOLD, 0},
-	{WID_RTS_THRESHOLD, 0},
-	{WID_FRAG_THRESHOLD, 0},
-	{WID_SHORT_RETRY_LIMIT, 0},
-	{WID_LONG_RETRY_LIMIT, 0},
-	{WID_BEACON_INTERVAL, 0},
-	{WID_RX_SENSE, 0},
-	{WID_ACTIVE_SCAN_TIME, 0},
-	{WID_PASSIVE_SCAN_TIME, 0},
-	{WID_SITE_SURVEY_SCAN_TIME, 0},
-	{WID_JOIN_START_TIMEOUT, 0},
-	{WID_AUTH_TIMEOUT, 0},
-	{WID_ASOC_TIMEOUT, 0},
-	{WID_11I_PROTOCOL_TIMEOUT, 0},
-	{WID_EAPOL_RESPONSE_TIMEOUT, 0},
-	{WID_11N_SIG_QUAL_VAL, 0},
-	{WID_CCA_THRESHOLD, 0},
 	{WID_NIL, 0}
 };
 
 static struct wilc_cfg_word g_cfg_word[] = {
 	{WID_FAILED_COUNT, 0},
-	{WID_RETRY_COUNT, 0},
-	{WID_MULTIPLE_RETRY_COUNT, 0},
-	{WID_FRAME_DUPLICATE_COUNT, 0},
-	{WID_ACK_FAILURE_COUNT, 0},
 	{WID_RECEIVED_FRAGMENT_COUNT, 0},
-	{WID_MCAST_RECEIVED_FRAME_COUNT, 0},
-	{WID_FCS_ERROR_COUNT, 0},
 	{WID_SUCCESS_FRAME_COUNT, 0},
-	{WID_TX_FRAGMENT_COUNT, 0},
-	{WID_TX_MULTICAST_FRAME_COUNT, 0},
-	{WID_RTS_SUCCESS_COUNT, 0},
-	{WID_RTS_FAILURE_COUNT, 0},
-	{WID_WEP_UNDECRYPTABLE_COUNT, 0},
-	{WID_REKEY_PERIOD, 0},
-	{WID_REKEY_PACKET_COUNT, 0},
-	{WID_HW_RX_COUNT, 0},
 	{WID_GET_INACTIVE_TIME, 0},
 	{WID_NIL, 0}
 
 };
 
 static struct wilc_cfg_str g_cfg_str[] = {
-	{WID_SSID, g_mac.ssid},	/* 33 + 1 bytes */
 	{WID_FIRMWARE_VERSION, g_mac.firmware_version},
-	{WID_OPERATIONAL_RATE_SET, g_mac.supp_rate},
-	{WID_BSSID, g_mac.bssid},	/* 6 bytes */
-	{WID_WEP_KEY_VALUE, g_mac.wep_key},	/* 27 bytes */
-	{WID_11I_PSK, g_mac.i_psk},	/* 65 bytes */
-	{WID_HARDWARE_VERSION, g_mac.hw_product_version},
 	{WID_MAC_ADDR, g_mac.mac_address},
-	{WID_PHY_VERSION, g_mac.phyversion},
-	{WID_SUPP_USERNAME, g_mac.supp_username},
-	{WID_SUPP_PASSWORD, g_mac.supp_password},
-	{WID_SITE_SURVEY_RESULTS, g_mac.scan_result},
-	{WID_SITE_SURVEY_RESULTS, g_mac.scan_result1},
-	{WID_ASSOC_REQ_INFO, g_mac.assoc_req},
 	{WID_ASSOC_RES_INFO, g_mac.assoc_rsp},
-	{WID_FIRMWARE_INFO, g_mac.firmware_version},
-	{WID_IP_ADDRESS, g_mac.ip_address},
 	{WID_NIL, NULL}
 };
 
@@ -327,12 +232,6 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_str[i].id == wid) {
-					if (wid == WID_SITE_SURVEY_RESULTS) {
-						static int toggle;
-
-						i += toggle;
-						toggle ^= 1;
-					}
 					memcpy(g_cfg_str[i].str, &info[2],
 					       (info[2] + 2));
 					break;
@@ -478,12 +377,6 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 						(g_cfg_str[i].str[1] << 8);
 
 				if (buffer_size >= size) {
-					if (id == WID_SITE_SURVEY_RESULTS) {
-						static int toggle;
-
-						i += toggle;
-						toggle ^= 1;
-					}
 					memcpy(buffer,  &g_cfg_str[i].str[2],
 					       size);
 					ret = size;
-- 
2.7.4
