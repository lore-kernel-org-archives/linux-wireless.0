Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37775 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbbIKHxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2015 03:53:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 7/7] staging: wilc1000: remove unused variables
Date: Fri, 11 Sep 2015 16:53:03 +0900
Message-ID: <1441957983-17726-8-git-send-email-tony.cho@atmel.com> (sfid-20150911_095357_431465_6CA67DC5)
In-Reply-To: <1441957983-17726-1-git-send-email-tony.cho@atmel.com>
References: <1441957983-17726-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Variable g_num_total_switches is never used so just remove it.
gastrWIDs is also not used because g_num_total_switches is deleted.
Remove gastrWIDs also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 127 ----------------------------
 1 file changed, 127 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ac97830..e0dd4820 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -140,133 +140,6 @@ typedef struct {
 /*****************************************************************************/
 /* Global Variables                                                          */
 /*****************************************************************************/
-/* WID Switches */
-static tstrWID gastrWIDs[] = {
-	{WID_FIRMWARE_VERSION,          WID_STR},
-	{WID_PHY_VERSION,               WID_STR},
-	{WID_HARDWARE_VERSION,          WID_STR},
-	{WID_BSS_TYPE,                  WID_CHAR},
-	{WID_QOS_ENABLE,                WID_CHAR},
-	{WID_11I_MODE,                  WID_CHAR},
-	{WID_CURRENT_TX_RATE,           WID_CHAR},
-	{WID_LINKSPEED,                 WID_CHAR},
-	{WID_RTS_THRESHOLD,             WID_SHORT},
-	{WID_FRAG_THRESHOLD,            WID_SHORT},
-	{WID_SSID,                      WID_STR},
-	{WID_BSSID,                     WID_ADR},
-	{WID_BEACON_INTERVAL,           WID_SHORT},
-	{WID_POWER_MANAGEMENT,          WID_CHAR},
-	{WID_LISTEN_INTERVAL,           WID_CHAR},
-	{WID_DTIM_PERIOD,               WID_CHAR},
-	{WID_CURRENT_CHANNEL,           WID_CHAR},
-	{WID_TX_POWER_LEVEL_11A,        WID_CHAR},
-	{WID_TX_POWER_LEVEL_11B,        WID_CHAR},
-	{WID_PREAMBLE,                  WID_CHAR},
-	{WID_11G_OPERATING_MODE,        WID_CHAR},
-	{WID_MAC_ADDR,                  WID_ADR},
-	{WID_IP_ADDRESS,                WID_ADR},
-	{WID_ACK_POLICY,                WID_CHAR},
-	{WID_PHY_ACTIVE_REG,            WID_CHAR},
-	{WID_AUTH_TYPE,                 WID_CHAR},
-	{WID_REKEY_POLICY,              WID_CHAR},
-	{WID_REKEY_PERIOD,              WID_INT},
-	{WID_REKEY_PACKET_COUNT,        WID_INT},
-	{WID_11I_PSK,                   WID_STR},
-	{WID_1X_KEY,                    WID_STR},
-	{WID_1X_SERV_ADDR,              WID_IP},
-	{WID_SUPP_USERNAME,             WID_STR},
-	{WID_SUPP_PASSWORD,             WID_STR},
-	{WID_USER_CONTROL_ON_TX_POWER,  WID_CHAR},
-	{WID_MEMORY_ADDRESS,            WID_INT},
-	{WID_MEMORY_ACCESS_32BIT,       WID_INT},
-	{WID_MEMORY_ACCESS_16BIT,       WID_SHORT},
-	{WID_MEMORY_ACCESS_8BIT,        WID_CHAR},
-	{WID_SITE_SURVEY_RESULTS,       WID_STR},
-	{WID_PMKID_INFO,                WID_STR},
-	{WID_ASSOC_RES_INFO,            WID_STR},
-	{WID_MANUFACTURER,              WID_STR}, /* 4 Wids added for the CAPI tool*/
-	{WID_MODEL_NAME,                WID_STR},
-	{WID_MODEL_NUM,                 WID_STR},
-	{WID_DEVICE_NAME,               WID_STR},
-	{WID_SSID_PROBE_REQ,            WID_STR},
-
-#ifdef MAC_802_11N
-	{WID_11N_ENABLE,                WID_CHAR},
-	{WID_11N_CURRENT_TX_MCS,        WID_CHAR},
-	{WID_TX_POWER_LEVEL_11N,        WID_CHAR},
-	{WID_11N_OPERATING_MODE,        WID_CHAR},
-	{WID_11N_SMPS_MODE,             WID_CHAR},
-	{WID_11N_PROT_MECH,             WID_CHAR},
-	{WID_11N_ERP_PROT_TYPE,         WID_CHAR},
-	{WID_11N_HT_PROT_TYPE,          WID_CHAR},
-	{WID_11N_PHY_ACTIVE_REG_VAL,    WID_INT},
-	{WID_11N_PRINT_STATS,           WID_CHAR},
-	{WID_11N_AUTORATE_TABLE,        WID_BIN_DATA},
-	{WID_HOST_CONFIG_IF_TYPE,       WID_CHAR},
-	{WID_HOST_DATA_IF_TYPE,         WID_CHAR},
-	{WID_11N_SIG_QUAL_VAL,          WID_SHORT},
-	{WID_11N_IMMEDIATE_BA_ENABLED,  WID_CHAR},
-	{WID_11N_TXOP_PROT_DISABLE,     WID_CHAR},
-	{WID_11N_SHORT_GI_20MHZ_ENABLE, WID_CHAR},
-	{WID_SHORT_SLOT_ALLOWED,        WID_CHAR},
-	{WID_11W_ENABLE,                WID_CHAR},
-	{WID_11W_MGMT_PROT_REQ,         WID_CHAR},
-	{WID_2040_ENABLE,               WID_CHAR},
-	{WID_2040_COEXISTENCE,          WID_CHAR},
-	{WID_USER_SEC_CHANNEL_OFFSET,   WID_CHAR},
-	{WID_2040_CURR_CHANNEL_OFFSET,  WID_CHAR},
-	{WID_2040_40MHZ_INTOLERANT,     WID_CHAR},
-	{WID_HUT_RESTART,               WID_CHAR},
-	{WID_HUT_NUM_TX_PKTS,           WID_INT},
-	{WID_HUT_FRAME_LEN,             WID_SHORT},
-	{WID_HUT_TX_FORMAT,             WID_CHAR},
-	{WID_HUT_BANDWIDTH,             WID_CHAR},
-	{WID_HUT_OP_BAND,               WID_CHAR},
-	{WID_HUT_STBC,                  WID_CHAR},
-	{WID_HUT_ESS,                   WID_CHAR},
-	{WID_HUT_ANTSET,                WID_CHAR},
-	{WID_HUT_HT_OP_MODE,            WID_CHAR},
-	{WID_HUT_RIFS_MODE,             WID_CHAR},
-	{WID_HUT_SMOOTHING_REC,         WID_CHAR},
-	{WID_HUT_SOUNDING_PKT,          WID_CHAR},
-	{WID_HUT_HT_CODING,             WID_CHAR},
-	{WID_HUT_TEST_DIR,              WID_CHAR},
-	{WID_HUT_TXOP_LIMIT,            WID_SHORT},
-	{WID_HUT_DEST_ADDR,             WID_ADR},
-	{WID_HUT_TX_PATTERN,            WID_BIN_DATA},
-	{WID_HUT_TX_TIME_TAKEN,         WID_INT},
-	{WID_HUT_PHY_TEST_MODE,         WID_CHAR},
-	{WID_HUT_PHY_TEST_RATE_HI,      WID_CHAR},
-	{WID_HUT_PHY_TEST_RATE_LO,      WID_CHAR},
-	{WID_HUT_TX_TEST_TIME,          WID_INT},
-	{WID_HUT_LOG_INTERVAL,          WID_INT},
-	{WID_HUT_DISABLE_RXQ_REPLENISH, WID_CHAR},
-	{WID_HUT_TEST_ID,               WID_STR},
-	{WID_HUT_KEY_ORIGIN,            WID_CHAR},
-	{WID_HUT_BCST_PERCENT,          WID_CHAR},
-	{WID_HUT_GROUP_CIPHER_TYPE,     WID_CHAR},
-	{WID_HUT_STATS,                 WID_BIN_DATA},
-	{WID_HUT_TSF_TEST_MODE,         WID_CHAR},
-	{WID_HUT_SIG_QUAL_AVG,          WID_SHORT},
-	{WID_HUT_SIG_QUAL_AVG_CNT,      WID_SHORT},
-	{WID_HUT_TSSI_VALUE,            WID_CHAR},
-	{WID_HUT_MGMT_PERCENT,          WID_CHAR},
-	{WID_HUT_MGMT_BCST_PERCENT,     WID_CHAR},
-	{WID_HUT_MGMT_ALLOW_HT,         WID_CHAR},
-	{WID_HUT_UC_MGMT_TYPE,          WID_CHAR},
-	{WID_HUT_BC_MGMT_TYPE,          WID_CHAR},
-	{WID_HUT_UC_MGMT_FRAME_LEN,     WID_SHORT},
-	{WID_HUT_BC_MGMT_FRAME_LEN,     WID_SHORT},
-	{WID_HUT_11W_MFP_REQUIRED_TX,   WID_CHAR},
-	{WID_HUT_11W_MFP_PEER_CAPABLE,  WID_CHAR},
-	{WID_HUT_11W_TX_IGTK_ID,        WID_CHAR},
-	{WID_HUT_FC_TXOP_MOD,           WID_CHAR},
-	{WID_HUT_FC_PROT_TYPE,          WID_CHAR},
-	{WID_HUT_SEC_CCA_ASSERT,        WID_CHAR},
-#endif /* MAC_802_11N */
-};
-
-u16 g_num_total_switches = (sizeof(gastrWIDs) / sizeof(tstrWID));
 /*****************************************************************************/
 /* Static Function Declarations                                              */
 /*****************************************************************************/
-- 
1.9.1

