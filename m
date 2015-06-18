Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36774 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbFRFqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 01:46:21 -0400
Received: by paceq1 with SMTP id eq1so28865550pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 22:46:20 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2] staging: wilc1000: remove commented code
Date: Thu, 18 Jun 2015 14:46:05 +0900
Message-Id: <1434606365-11172-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150618_074626_331882_FE1933AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the commented codes using #if 0.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: revert commented code using typedef and rebase latest staging-testing.

 drivers/staging/wilc1000/coreconfigurator.c   |  30 ---
 drivers/staging/wilc1000/coreconfigurator.h   | 300 --------------------------
 drivers/staging/wilc1000/host_interface.c     |  76 -------
 drivers/staging/wilc1000/host_interface.h     |  65 +-----
 drivers/staging/wilc1000/linux_mon.c          |  45 ----
 drivers/staging/wilc1000/linux_wlan.c         |  22 --
 drivers/staging/wilc1000/wilc_sdio.c          |  44 ----
 drivers/staging/wilc1000/wilc_spi.c           |  70 +-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.c |   9 -
 drivers/staging/wilc1000/wilc_wlan.c          |  31 ---
 drivers/staging/wilc1000/wilc_wlan_cfg.c      |  26 ---
 drivers/staging/wilc1000/wilc_wlan_if.h       |  22 --
 12 files changed, 2 insertions(+), 738 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 523c863..ed6ac45 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -210,9 +210,6 @@ static tstrWID gastrWIDs[] = {
 	{WID_REKEY_POLICY,              WID_CHAR},
 	{WID_REKEY_PERIOD,              WID_INT},
 	{WID_REKEY_PACKET_COUNT,        WID_INT},
-#if 0
-	{WID_WEP_KEY_VALUE0,            WID_STR},
-#endif
 	{WID_11I_PSK,                   WID_STR},
 	{WID_1X_KEY,                    WID_STR},
 	{WID_1X_SERV_ADDR,              WID_IP},
@@ -1619,26 +1616,6 @@ s32 further_process_response(u8 *resp,
 		break;
 
 	case WID_BIN_DATA:
-		#if 0
-		/* FILE    *fp_bin = NULL; */
-		u8 first_bin_wid = 1;
-		if (first_bin_wid) {
-			/* fp_bin = fopen("wid_response.bin","wb"); */
-			first_bin_wid = 0;
-		} else {
-			/* fp_bin = fopen("wid_response.bin","ab"); */
-		}
-
-		if (/*fp_bin == NULL*/ 0) {
-			PRINT_ER("Error: Could not open wid_response.bin for write\n");
-			return -2;
-		}
-
-		/* fwrite(resp + idx, cfg_len, 1, fp_bin); */
-
-		/* fclose(fp_bin); */
-		#endif
-
 		if (pstrWIDresult->s32ValueSize >= cfg_len) {
 			WILC_memcpy(pstrWIDresult->ps8WidVal, resp + idx, cfg_len);
 			pstrWIDresult->s32ValueSize = cfg_len;
@@ -1884,13 +1861,6 @@ s32 CreateConfigPacket(s8 *ps8packet, s32 *ps32PacketLength,
 				      pstrWIDs[u32idx].ps8WidVal, pstrWIDs[u32idx].s32ValueSize);
 			break;
 
-		#if 0
-		case WID_ADR:
-			ProcessAdrWid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
-				      pstrWIDs[u32idx].ps8WidVal);
-			break;
-
-		#endif
 		case WID_IP:
 			ProcessIPwid(ps8packet, ps32PacketLength, &pstrWIDs[u32idx],
 				     pstrWIDs[u32idx].ps8WidVal);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 3ca067e..9059c8d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -71,306 +71,6 @@ extern u16 g_num_total_switches;
 /*****************************************************************************/
 /* Type Definitions                                                                                                                       */
 /*****************************************************************************/
-/* WID Data Types */
-#if 0
-typedef enum {
-	WID_CHAR  = 0,
-	WID_SHORT = 1,
-	WID_INT   = 2,
-	WID_STR   = 3,
-	WID_ADR   = 4,
-	WID_BIN   = 5,
-	WID_IP    = 6,
-	WID_UNDEF = 7,
-	WID_TYPE_FORCE_32BIT  = 0xFFFFFFFF
-} tenuWIDtype;
-
-/* WLAN Identifiers */
-typedef enum {
-	WID_NIL                            = -1,
-	/* EMAC Character WID list */
-	WID_BSS_TYPE                       = 0x0000,
-	WID_CURRENT_TX_RATE                = 0x0001,
-	WID_CURRENT_CHANNEL                = 0x0002,
-	WID_PREAMBLE                       = 0x0003,
-	WID_11G_OPERATING_MODE             = 0x0004,
-	WID_STATUS                         = 0x0005,
-	WID_11G_PROT_MECH                  = 0x0006,
-	WID_SCAN_TYPE                      = 0x0007,
-	WID_PRIVACY_INVOKED                = 0x0008,
-	WID_KEY_ID                         = 0x0009,
-	WID_QOS_ENABLE                     = 0x000A,
-	WID_POWER_MANAGEMENT               = 0x000B,
-	WID_11I_MODE                       = 0x000C,
-	WID_AUTH_TYPE                      = 0x000D,
-	WID_SITE_SURVEY                    = 0x000E,
-	WID_LISTEN_INTERVAL                = 0x000F,
-	WID_DTIM_PERIOD                    = 0x0010,
-	WID_ACK_POLICY                     = 0x0011,
-	WID_RESET                          = 0x0012,
-	WID_PCF_MODE                       = 0x0013,
-	WID_CFP_PERIOD                     = 0x0014,
-	WID_BCAST_SSID                     = 0x0015,
-	WID_PHY_TEST_PATTERN               = 0x0016,
-	WID_DISCONNECT                     = 0x0016,
-	WID_READ_ADDR_SDRAM                = 0x0017,
-	WID_TX_POWER_LEVEL_11A             = 0x0018,
-	WID_REKEY_POLICY                   = 0x0019,
-	WID_SHORT_SLOT_ALLOWED             = 0x001A,
-	WID_PHY_ACTIVE_REG                 = 0x001B,
-	WID_PHY_ACTIVE_REG_VAL             = 0x001C,
-	WID_TX_POWER_LEVEL_11B             = 0x001D,
-	WID_START_SCAN_REQ                 = 0x001E,
-	WID_RSSI                           = 0x001F,
-	WID_JOIN_REQ                       = 0x0020,
-	WID_ANTENNA_SELECTION              = 0x0021,
-	WID_USER_CONTROL_ON_TX_POWER       = 0x0027,
-	WID_MEMORY_ACCESS_8BIT             = 0x0029,
-	WID_UAPSD_SUPPORT_AP               = 0x002A,
-	WID_CURRENT_MAC_STATUS             = 0x0031,
-	WID_AUTO_RX_SENSITIVITY            = 0x0032,
-	WID_DATAFLOW_CONTROL               = 0x0033,
-	WID_SCAN_FILTER                    = 0x0036,
-	WID_LINK_LOSS_THRESHOLD            = 0x0037,
-	WID_AUTORATE_TYPE                  = 0x0038,
-	WID_CCA_THRESHOLD                  = 0x0039,
-	WID_802_11H_DFS_MODE               = 0x003B,
-	WID_802_11H_TPC_MODE               = 0x003C,
-	WID_DEVICE_READY                   = 0x003D,
-	WID_PM_NULL_FRAME_INTERVAL         = 0x003E,
-	WID_PM_ACTIVITY_TIMER              = 0x003F,
-	WID_PM_NULL_FRAME_WAIT_ENABLE      = 0x0040,
-	WID_SCAN_WAIT_TIME                 = 0x0041,
-	WID_WSC_IE_EN                      = 0x0042,
-	WID_WPS_START                      = 0x0043,
-	WID_WPS_DEV_MODE                   = 0x0044,
-	WID_BT_COEXISTENCE                 = 0x0050,
-	WID_TRACKING_ROAMING               = 0x0070,
-	WID_NUM_PKTS_FOR_RSSI_AVG          = 0x0071,
-	WID_FHSS_SCAN_CHAN_INDEX           = 0x0072,
-	WID_FHSS_SCAN_STEP_INDEX           = 0x0073,
-
-	/* NMAC Character WID list */
-	WID_11N_PROT_MECH                  = 0x0080,
-	WID_11N_ERP_PROT_TYPE              = 0x0081,
-	WID_11N_ENABLE                     = 0x0082,
-	WID_11N_OPERATING_MODE             = 0x0083,
-	WID_11N_OBSS_NONHT_DETECTION       = 0x0084,
-	WID_11N_HT_PROT_TYPE               = 0x0085,
-	WID_11N_RIFS_PROT_ENABLE           = 0x0086,
-	WID_11N_SMPS_MODE                  = 0x0087,
-	WID_11N_CURRENT_TX_MCS             = 0x0088,
-	WID_11N_PRINT_STATS                = 0x0089,
-	WID_HUT_FCS_CORRUPT_MODE           = 0x008A,
-	WID_HUT_RESTART                    = 0x008B,
-	WID_HUT_TX_FORMAT                  = 0x008C,
-	WID_11N_SHORT_GI_20MHZ_ENABLE      = 0x008D,
-	WID_HUT_BANDWIDTH                  = 0x008E,
-	WID_HUT_OP_BAND                    = 0x008F,
-	WID_HUT_STBC                       = 0x0090,
-	WID_HUT_ESS                        = 0x0091,
-	WID_HUT_ANTSET                     = 0x0092,
-	WID_HUT_HT_OP_MODE                 = 0x0093,
-	WID_HUT_RIFS_MODE                  = 0x0094,
-	WID_HUT_SMOOTHING_REC              = 0x0095,
-	WID_HUT_SOUNDING_PKT               = 0x0096,
-	WID_HUT_HT_CODING                  = 0x0097,
-	WID_HUT_TEST_DIR                   = 0x0098,
-	WID_HUT_CAPTURE_MODE               = 0x0099,
-	WID_HUT_PHY_TEST_MODE              = 0x009A,
-	WID_HUT_PHY_TEST_RATE_HI           = 0x009B,
-	WID_HUT_PHY_TEST_RATE_LO           = 0x009C,
-	WID_HUT_DISABLE_RXQ_REPLENISH      = 0x009D,
-	WID_HUT_KEY_ORIGIN                 = 0x009E,
-	WID_HUT_BCST_PERCENT               = 0x009F,
-	WID_HUT_GROUP_CIPHER_TYPE          = 0x00A0,
-	WID_TX_ABORT_CONFIG                = 0x00A1,
-	WID_HOST_DATA_IF_TYPE              = 0x00A2,
-	WID_HOST_CONFIG_IF_TYPE            = 0x00A3,
-	WID_HUT_TSF_TEST_MODE              = 0x00A4,
-	WID_HUT_TSSI_VALUE                 = 0x00A5,
-	WID_HUT_PKT_TSSI_VALUE             = 0x00A5,
-	WID_REG_TSSI_11B_VALUE             = 0x00A6,
-	WID_REG_TSSI_11G_VALUE             = 0x00A7,
-	WID_REG_TSSI_11N_VALUE             = 0x00A8,
-	WID_TX_CALIBRATION                 = 0x00A9,
-	WID_DSCR_TSSI_11B_VALUE            = 0x00AA,
-	WID_DSCR_TSSI_11G_VALUE            = 0x00AB,
-	WID_DSCR_TSSI_11N_VALUE            = 0x00AC,
-	WID_HUT_RSSI_EX                    = 0x00AD,
-	WID_HUT_ADJ_RSSI_EX                = 0x00AE,
-	WID_11N_IMMEDIATE_BA_ENABLED       = 0x00AF,
-	WID_11N_TXOP_PROT_DISABLE          = 0x00B0,
-	WID_TX_POWER_LEVEL_11N             = 0x00B1,
-	WID_HUT_MGMT_PERCENT               = 0x00B3,
-	WID_HUT_MGMT_BCST_PERCENT          = 0x00B4,
-	WID_HUT_MGMT_ALLOW_HT              = 0x00B5,
-	WID_HUT_UC_MGMT_TYPE               = 0x00B6,
-	WID_HUT_BC_MGMT_TYPE               = 0x00B7,
-	WID_HUT_11W_MFP_REQUIRED_TX        = 0x00B8,
-	WID_HUT_11W_MFP_PEER_CAPABLE       = 0x00B9,
-	WID_HUT_11W_TX_IGTK_ID             = 0x00BA,
-	WID_11W_ENABLE                     = 0x00BB,
-	WID_11W_MGMT_PROT_REQ              = 0x00BC,
-	WID_USER_SEC_CHANNEL_OFFSET        = 0x00C0,
-	WID_2040_COEXISTENCE               = 0x00C1,
-	WID_HUT_FC_TXOP_MOD                = 0x00C2,
-	WID_HUT_FC_PROT_TYPE               = 0x00C3,
-	WID_HUT_SEC_CCA_ASSERT             = 0x00C4,
-	WID_2040_ENABLE                    = 0x00C5,
-	WID_2040_CURR_CHANNEL_OFFSET       = 0x00C6,
-	WID_2040_40MHZ_INTOLERANT          = 0x00C7,
-
-
-	/* Custom Character WID list */
-	WID_POWER_SAVE                     = 0x0100,
-	WID_WAKE_STATUS                    = 0x0101,
-	WID_WAKE_CONTROL                   = 0x0102,
-	WID_CCA_BUSY_START                 = 0x0103,
-
-	/* EMAC Short WID list */
-	WID_RTS_THRESHOLD                  = 0x1000,
-	WID_FRAG_THRESHOLD                 = 0x1001,
-	WID_SHORT_RETRY_LIMIT              = 0x1002,
-	WID_LONG_RETRY_LIMIT               = 0x1003,
-	WID_CFP_MAX_DUR                    = 0x1004,
-	WID_PHY_TEST_FRAME_LEN             = 0x1005,
-	WID_BEACON_INTERVAL                = 0x1006,
-	WID_MEMORY_ACCESS_16BIT            = 0x1008,
-	WID_RX_SENSE                       = 0x100B,
-	WID_ACTIVE_SCAN_TIME               = 0x100C,
-	WID_PASSIVE_SCAN_TIME              = 0x100D,
-	WID_SITE_SURVEY_SCAN_TIME          = 0x100E,
-	WID_JOIN_START_TIMEOUT             = 0x100F,
-	WID_AUTH_TIMEOUT                   = 0x1010,
-	WID_ASOC_TIMEOUT                   = 0x1011,
-	WID_11I_PROTOCOL_TIMEOUT           = 0x1012,
-	WID_EAPOL_RESPONSE_TIMEOUT         = 0x1013,
-	WID_WPS_PASS_ID                    = 0x1017,
-	WID_WPS_CONFIG_METHOD              = 0x1018,
-	WID_FHSS_INIT_SCAN_TIME            = 0x1070,
-	WID_FHSS_ROAM_SCAN_TIME            = 0x1071,
-
-	/* NMAC Short WID list */
-	WID_11N_RF_REG_VAL                 = 0x1080,
-	WID_HUT_FRAME_LEN                  = 0x1081,
-	WID_HUT_TXOP_LIMIT                 = 0x1082,
-	WID_HUT_SIG_QUAL_AVG               = 0x1083,
-	WID_HUT_SIG_QUAL_AVG_CNT           = 0x1084,
-	WID_11N_SIG_QUAL_VAL               = 0x1085,
-	WID_HUT_RSSI_EX_COUNT              = 0x1086,
-	WID_HUT_UC_MGMT_FRAME_LEN          = 0x1088,
-	WID_HUT_BC_MGMT_FRAME_LEN          = 0x1089,
-
-	/* Custom Short WID list */
-
-	WID_CCA_BUSY_STATUS                = 0x1100,
-
-	/* EMAC Integer WID list */
-	WID_FAILED_COUNT                   = 0x2000,
-	WID_RETRY_COUNT                    = 0x2001,
-	WID_MULTIPLE_RETRY_COUNT           = 0x2002,
-	WID_FRAME_DUPLICATE_COUNT          = 0x2003,
-	WID_ACK_FAILURE_COUNT              = 0x2004,
-	WID_RECEIVED_FRAGMENT_COUNT        = 0x2005,
-	WID_MCAST_RECEIVED_FRAME_COUNT     = 0x2006,
-	WID_FCS_ERROR_COUNT                = 0x2007,
-	WID_SUCCESS_FRAME_COUNT            = 0x2008,
-	WID_PHY_TEST_PKT_CNT               = 0x2009,
-	WID_HUT_TX_COUNT                   = 0x200A,
-	WID_TX_FRAGMENT_COUNT              = 0x200B,
-	WID_TX_MULTICAST_FRAME_COUNT       = 0x200C,
-	WID_RTS_SUCCESS_COUNT              = 0x200D,
-	WID_RTS_FAILURE_COUNT              = 0x200E,
-	WID_WEP_UNDECRYPTABLE_COUNT        = 0x200F,
-	WID_REKEY_PERIOD                   = 0x2010,
-	WID_REKEY_PACKET_COUNT             = 0x2011,
-	WID_1X_SERV_ADDR                   = 0x2012,
-	WID_STACK_IP_ADDR                  = 0x2013,
-	WID_STACK_NETMASK_ADDR             = 0x2014,
-	WID_HW_RX_COUNT                    = 0x2015,
-	WID_MEMORY_ADDRESS                 = 0x201E,
-	WID_MEMORY_ACCESS_32BIT            = 0x201F,
-	WID_RF_REG_VAL                     = 0x2021,
-	WID_FIRMWARE_INFO                  = 0x2023,
-	WID_DEV_OS_VERSION                 = 0x2025,
-	WID_ROAM_RSSI_THESHOLDS            = 0x2070,
-	WID_TRACK_INTERVAL_SEC             = 0x2071,
-	WID_FHSS_HOPPING_PARAMS            = 0x2072,
-	WID_FHSS_HOP_DWELL_TIME            = 0x2073,
-
-	/* NMAC Integer WID list */
-	WID_11N_PHY_ACTIVE_REG_VAL         = 0x2080,
-	WID_HUT_NUM_TX_PKTS                = 0x2081,
-	WID_HUT_TX_TIME_TAKEN              = 0x2082,
-	WID_HUT_TX_TEST_TIME               = 0x2083,
-	WID_HUT_LOG_INTERVAL               = 0x2084,
-
-	/* EMAC String WID list */
-	WID_SSID                           = 0x3000,
-	WID_FIRMWARE_VERSION               = 0x3001,
-	WID_OPERATIONAL_RATE_SET           = 0x3002,
-	WID_BSSID                          = 0x3003,
-	#if 0
-	WID_WEP_KEY_VALUE0                 = 0x3004,
-	#endif
-	WID_11I_PSK                        = 0x3008,
-	WID_11E_P_ACTION_REQ               = 0x3009,
-	WID_1X_KEY                         = 0x300A,
-	WID_HARDWARE_VERSION               = 0x300B,
-	WID_MAC_ADDR                       = 0x300C,
-	WID_HUT_DEST_ADDR                  = 0x300D,
-	/*WID_HUT_STATS                      = 0x300E,*/
-	WID_PHY_VERSION                    = 0x300F,
-	WID_SUPP_USERNAME                  = 0x3010,
-	WID_SUPP_PASSWORD                  = 0x3011,
-	WID_SITE_SURVEY_RESULTS            = 0x3012,
-	WID_RX_POWER_LEVEL                 = 0x3013,
-	WID_MANUFACTURER                   = 0x3026,    /*Added for CAPI tool */
-	WID_MODEL_NAME                     = 0x3027,    /*Added for CAPI tool */
-	WID_MODEL_NUM                      = 0x3028,    /*Added for CAPI tool */
-	WID_DEVICE_NAME                    = 0x3029,    /*Added for CAPI tool */
-
-	WID_ASSOC_RES_INFO                 = 0x3020,
-
-	/* NMAC String WID list */
-	WID_11N_P_ACTION_REQ               = 0x3080,
-	WID_HUT_TEST_ID                    = 0x3081,
-	WID_PMKID_INFO                     = 0x3082,
-
-	/* Custom String WID list */
-	WID_FLASH_DATA                     = 0x3100,
-	WID_EEPROM_DATA                    = 0x3101,
-	WID_SERIAL_NUMBER                  = 0x3102,
-
-	/* EMAC Binary WID list */
-	WID_UAPSD_CONFIG                   = 0x4001,
-	WID_UAPSD_STATUS                   = 0x4002,
-	WID_AC_PARAMS_AP                   = 0x4003,
-	WID_AC_PARAMS_STA                  = 0x4004,
-	WID_NEWORK_INFO                    = 0x4005,
-	WID_WPS_CRED_LIST                  = 0x4006,
-	WID_PRIM_DEV_TYPE                  = 0x4007,
-	WID_STA_JOIN_INFO                  = 0x4008,
-	WID_CONNECTED_STA_LIST             = 0x4009,
-
-	/* NMAC Binary WID list */
-	WID_11N_AUTORATE_TABLE             = 0x4080,
-	WID_HUT_TX_PATTERN                 = 0x4081,
-	WID_HUT_STATS                      = 0x4082,
-	WID_HUT_LOG_STATS                  = 0x4083,
-
-	/*BugID_3746 WID to add IE to be added in next probe request*/
-	WID_INFO_ELEMENT_PROBE             = 0x4085,
-	/*BugID_3746 WID to add IE to be added in next associate request*/
-	WID_INFO_ELEMENT_ASSOCIATE         = 0x4086,
-
-	/* Miscellaneous WIDs */
-	WID_ALL                            = 0x7FFE,
-	WID_MAX                            = 0xFFFF
-} tenuWIDid;
-#endif
-
 /* Status Codes for Authentication and Association Frames */
 typedef enum {
 	SUCCESSFUL_STATUSCODE    = 0,
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3228824..808b61b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1261,13 +1261,6 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 	pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->pvUserArg;
 
 	#ifdef WILC_P2P
-	#if 0
-	if (pstrWFIDrv->enuHostIFstate == HOST_IF_P2P_LISTEN || (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED && pstrWFIDrv->u8P2PConnect)) {
-		PRINT_INFO(GENERIC_DBG, "Busy: State: %d\n", pstrWFIDrv->enuHostIFstate);
-		PRINT_INFO(GENERIC_DBG, "Current Jiffies: %lu Timeout:%llu\n", jiffies, pstrWFIDrv->u64P2p_MgmtTimeout);
-		WILC_ERRORREPORT(s32Error, WILC_BUSY);
-	}
-	#endif
 	#endif
 
 	if ((pstrWFIDrv->enuHostIFstate >= HOST_IF_SCANNING) && (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTED)) {
@@ -1682,17 +1675,6 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	}
 	#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
-#if 0
-	/* if we try to connect to an already connected AP then discard the request */
-	PRINT_D(GENERIC_DBG, "Bssid = %x:%x:%x:%x:%x:%x\n", (pstrHostIFconnectAttr->pu8bssid[0]), (pstrHostIFconnectAttr->pu8bssid[1]), (pstrHostIFconnectAttr->pu8bssid[2]), (pstrHostIFconnectAttr->pu8bssid[3]), (pstrHostIFconnectAttr->pu8bssid[4]), (pstrHostIFconnectAttr->pu8bssid[5]));
-	PRINT_D(GENERIC_DBG, "bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
-	if (WILC_memcmp(pstrHostIFconnectAttr->pu8bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
-		PRINT_ER("Discard connect request\n");
-		s32Error = WILC_FAIL;
-		return s32Error;
-	}
-#endif
-
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
 		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = (u8 *)WILC_MALLOC(6);
 		WILC_memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
@@ -5101,65 +5083,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
 	}
 	return s32Error;
 }
-#if 0
-/**
- *  @brief                      host_int_add_tx_gtk
- *  @details            adds Tx GTk Key
- *  @param[in,out] handle to the wifi driver
- *  @param[in]  message containing Tx GTK Key in the following format
- *|----------------------------------------------------|
- | KeyID | Key Length | Temporal Key	| Tx Michael Key |
- ||-------|------------|--------------|----------------|
- ||1 byte |  1 byte	 |   16 bytes	|	  8 bytes	 |
- ||----------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-s32 host_int_add_tx_gtk(WILC_WFIDrvHandle hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx)
-{
-	s32 s32Error = WILC_SUCCESS;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	tstrHostIFmsg strHostIFmsg;
-
-	if (pstrWFIDrv == NULL) {
-		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
-	/* prepare the Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
-
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPATxGtk;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
-
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = (u8 *)WILC_MALLOC(u8KeyLen);
-
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
-		    pu8TxGtk, u8KeyLen);
-
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
-
-	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error)
-		PRINT_ER("Error in sending message queue: TX GTK\n");
-
-	/* ////////////// */
-	down(&hSemTestKeyBlock);
-	WILC_Sleep(100);
-	/* /////// */
-
-	WILC_CATCH(s32Error)
-	{
-
-	}
-	return s32Error;
-}
-#endif
 /**
  *  @brief              host_int_set_pmkid_info
  *  @details    caches the pmkid valid only in BSS STA mode if External Supplicant
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index dcd1275..38db740 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -15,48 +15,6 @@
 /*****************************************************************************/
 /*								Macros                                       */
 /*****************************************************************************/
-#if 0
-#define WID_BSS_TYPE				0x0000
-#define WID_CURRENT_TX_RATE			0x0001
-#define WID_CURRENT_CHANNEL			0x0002
-#define WID_PREAMBLE				0x0003
-#define WID_STATUS					0x0005
-#define WID_SCAN_TYPE				0x0007
-#define WID_KEY_ID					0x0009
-#define	WID_DTIM_PERIOD				0x0010
-#define	WID_POWER_MANAGEMENT		0x000B
-#define WID_AUTH_TYPE				0x000D
-#define WID_SITE_SURVEY				0x000E
-#define WID_DTIM_PERIOD				0x0010
-#define WID_DISCONNECT				0x0016
-#define WID_SHORT_SLOT_ALLOWED		0x001A
-#define WID_START_SCAN_REQ			0x001E
-#define WID_RSSI					0x001F
-#define WID_JOIN_REQ				0x0020
-#define WID_11N_TXOP_PROT_DISABLE	0x00B0
-#define WID_RTS_THRESHOLD			0x1000
-#define WID_FRAG_THRESHOLD			0x1001
-#define WID_SHORT_RETRY_LIMIT		0x1002
-#define WID_LONG_RETRY_LIMIT		0x1003
-#define WID_BEACON_INTERVAL			0x1006
-#define WID_ACTIVE_SCAN_TIME		0x100C
-#define WID_PASSIVE_SCAN_TIME		0x100D
-#define WID_SITE_SURVEY_SCAN_TIME	0x100E
-#define WID_AUTH_TIMEOUT			0x1010
-#define WID_11I_PSK					0x3008
-#define WID_SITE_SURVEY_RESULTS		0x3012
-#define WID_ADD_PTK					0x301B
-#define WID_ADD_RX_GTK				0x301C
-#define WID_ADD_TX_GTK				0x301D
-#define WID_ADD_WEP_KEY				0x3019
-#define	WID_REMOVE_WEP_KEY			0x301A
-#define WID_REMOVE_KEY				0x301E
-#define WID_ASSOC_REQ_INFO			0x301F
-#define WID_ASSOC_RES_INFO			0x3020
-#define WID_PMKID_INFO				0x3082
-#define WID_SCAN_CHANNEL_LIST		0x4084
-#define WID_11I_MODE                        0x000C
-#endif
 #define FAIL		0x0000
 #define SUCCESS		0x0001
 
@@ -115,16 +73,6 @@
 /* typedef unsigned long   uint32; */
 /* typedef uint32   Bool; */
 
-#if 0
-typedef enum {WID_CHAR  = 0,
-	      WID_SHORT = 1,
-	      WID_INT   = 2,
-	      WID_STR   = 3,
-	      WID_ADR   = 4,
-	      WID_BIN   = 5,
-	      WID_IP    = 6,
-	      WID_UNDEF = 7} WID_TYPE_T;
-#endif
 typedef struct {
 	u16 cfg_wid;
 	WID_TYPE_T cfg_type;
@@ -160,18 +108,7 @@ typedef struct _tstrHostIFpmkidAttr {
 	u8 numpmkid;
 	tstrHostIFpmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
 } tstrHostIFpmkidAttr;
-#if 0
-/* Scan type parameter for scan request */
-typedef enum {
-	PASSIVE_SCAN = 0,
-	ACTIVE_SCAN  = 1,
-	NUM_SCANTYPE
-} tenuScanType;
-
-typedef enum {SITE_SURVEY_1CH    = 0,
-	      SITE_SURVEY_ALL_CH = 1,
-	      SITE_SURVEY_OFF    = 2} SITE_SURVEY_T;
-#endif
+
 typedef enum {
 	AUTORATE	 = 0,
 	MBPS_1	     = 1,
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 30d1c76..f5296f5 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -533,51 +533,6 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 	if (wilc_wfi_mon) {
 		return wilc_wfi_mon;
 	}
-#if 0
-	wilc_wfi_mon = alloc_netdev(sizeof(struct WILC_WFI_mon_priv), name, WILC_WFI_mon_setup);
-	if (wilc_wfi_mon == NULL) {
-		PRINT_ER("Failed to allocate netdevice\n");
-		goto failed;
-	}
-
-	/* rtnl_lock(); */
-	PRINT_INFO(HOSTAPD_DBG, "Monitor interface name %s\n", wilc_wfi_mon->name);
-
-
-	ret = dev_alloc_name(wilc_wfi_mon, wilc_wfi_mon->name);
-	if (ret < 0)
-		goto failed_mon;
-
-
-	priv = netdev_priv(wilc_wfi_mon);
-	if (priv == NULL) {
-		PRINT_ER("private structure is NULL\n");
-		return WILC_FAIL;
-	}
-
-	priv->real_ndev = real_dev;
-
-
-	ret = register_netdevice(wilc_wfi_mon);
-
-
-	if (ret < 0) {
-		PRINT_ER("Failed to register netdevice\n");
-		goto failed_mon;
-	}
-
-
-	return WILC_SUCCESS;
-	/* rtnl_unlock(); */
-
-failed:
-	return ret;
-
-failed_mon:
-	/* rtnl_unlock(); */
-	free_netdev(wilc_wfi_mon);
-	return ret;
-#endif
 
 	wilc_wfi_mon = alloc_etherdev(sizeof(struct WILC_WFI_mon_priv));
 	if (!wilc_wfi_mon) {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8ecbb2d..c46f088 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -756,28 +756,6 @@ static void linux_wlan_mac_indicate(int flag)
 		}
 
 		if (pd->mac_status == WILC_MAC_STATUS_CONNECT) {        /* Connect */
-#if 0
-			/**
-			 *      get the mac and bssid address
-			 **/
-			PRINT_D(RX_DBG, "Calling cfg_get to get MAC_ADDR\n");
-			pd->oup.wlan_cfg_get(1, WID_MAC_ADDR, 0);
-			PRINT_D(RX_DBG, "Calling cfg_get to get BSSID\n");
-			pd->oup.wlan_cfg_get(0, WID_BSSID, 1);
-
-			/**
-			 *      get the value
-			 **/
-			pd->oup.wlan_cfg_get_value(WID_MAC_ADDR, pd->eth_src_address, 6);
-			pd->oup.wlan_cfg_get_value(WID_BSSID, pd->eth_dst_address, 6);
-
-			PRINT_D(GENERIC_DBG, "Source Address = %s", pd->eth_src_address);
-			PRINT_D(GENERIC_DBG, "Destiation Address = %s", pd->eth_dst_address);
-
-			/**
-			 *      launch ndis
-			 **/
-#endif
 		}
 
 	} else if (flag == WILC_MAC_INDICATE_SCAN) {
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index d96abb0..897e47e 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -294,13 +294,6 @@ static int sdio_write_reg(uint32_t addr, uint32_t data)
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, write reg (%08x)...\n", addr);
 			goto _fail_;
 		}
-
-#if 0
-		if (!sdio_check_bs())
-			goto _fail_;
-#else
-		/* g_sdio.os_func.os_sleep(1); */
-#endif
 	}
 
 	return 1;
@@ -463,14 +456,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 		buf += nblk * block_size;
 
 #endif /* platform */
-
-#if 0
-		if (!sdio_check_bs())
-			goto _fail_;
-#else
-		/* g_sdio.os_func.os_sleep(1); */
-#endif
-
 	}
 
 
@@ -490,13 +475,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes send...\n", addr);
 			goto _fail_;
 		}
-
-#if 0
-		if (!sdio_check_bs())
-			goto _fail_;
-#else
-		/* g_sdio.os_func.os_sleep(1); */
-#endif
 	}
 
 	return 1;
@@ -539,13 +517,6 @@ static int sdio_read_reg(uint32_t addr, uint32_t *data)
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, read reg (%08x)...\n", addr);
 			goto _fail_;
 		}
-
-#if 0
-		if (!sdio_check_bs())
-			goto _fail_;
-#else
-		/* g_sdio.os_func.os_sleep(1); */
-#endif
 	}
 
 #ifdef BIG_ENDIAN
@@ -712,14 +683,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 		buf += nblk * block_size;
 
 #endif /* platform */
-
-#if 0
-		if (!sdio_check_bs())
-			goto _fail_;
-#else
-		/* g_sdio.os_func.os_sleep(1); */
-#endif
-
 	}       /* if (nblk > 0) */
 
 	if (nleft > 0) {
@@ -738,13 +701,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes read...\n", addr);
 			goto _fail_;
 		}
-
-#if 0
-		if (!sdio_check_bs())
-			goto _fail_;
-#else
-		/* g_sdio.os_func.os_sleep(1); */
-#endif
 	}
 
 	return 1;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index ba9b30a..abea5df 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -421,42 +421,6 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 		return result;
 	}
 
-#if 0
-	{
-		int jj;
-		PRINT_D(BUS_DBG, "--- cnd = %x, len=%d, len2=%d\n", cmd, len, len2);
-		for (jj = 0; jj < sizeof(wb) / sizeof(wb[0]); jj++) {
-
-			if (jj >= len2)
-				break;
-			if (((jj + 1) % 16) != 0) {
-				if ((jj % 16) == 0) {
-					PRINT_D(BUS_DBG, "wb[%02x]: %02x ", jj, wb[jj]);
-				} else {
-					PRINT_D(BUS_DBG, "%02x ", wb[jj]);
-				}
-			} else {
-				PRINT_D(BUS_DBG, "%02x\n", wb[jj]);
-			}
-		}
-
-		for (jj = 0; jj < sizeof(rb) / sizeof(rb[0]); jj++) {
-
-			if (jj >= len2)
-				break;
-			if (((jj + 1) % 16) != 0) {
-				if ((jj % 16) == 0) {
-					PRINT_D(BUS_DBG, "rb[%02x]: %02x ", jj, rb[jj]);
-				} else {
-					PRINT_D(BUS_DBG, "%02x ", rb[jj]);
-				}
-			} else {
-				PRINT_D(BUS_DBG, "%02x\n", rb[jj]);
-			}
-		}
-	}
-#endif
-
 	/**
 	 * Command/Control response
 	 **/
@@ -552,10 +516,7 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 			for (ix = 0; (rix < len2) && (ix < sz); ) {
 				b[ix++] = rb[rix++];
 			}
-#if 0
-			if (ix)
-				PRINT_D(BUS_DBG, "ttt %d %d\n", sz, ix);
-#endif
+
 			sz -= ix;
 
 			if (sz > 0) {
@@ -596,9 +557,6 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 			while (sz > 0) {
 				int nbytes;
 
-#if 0
-				PRINT_INFO(BUS_DBG, "rrr %d %d\n", sz, ix);
-#endif
 				if (sz <= DATA_PKT_SZ) {
 					nbytes = sz;
 				} else {
@@ -788,32 +746,6 @@ static int spi_data_write(uint8_t *b, uint32_t sz)
 		/**
 		 *      No need to wait for response
 		 **/
-#if 0
-		/**
-		 *      Respnose
-		 **/
-		if (!g_spi.spi_rx(&rsp, 1)) {
-			PRINT_ER("[wilc spi]: Failed data block write, response read, bus error...\n");
-			result = N_FAIL;
-			break;
-		}
-
-		if (((rsp >> 4) & 0xf) != 0xc) {
-			result = N_FAIL;
-			PRINT_ER("[wilc spi]: Failed data block write response...(%02x)\n", rsp);
-			break;
-		}
-
-		/**
-		 *      State
-		 **/
-		if (!g_spi.spi_rx(&rsp, 1)) {
-			PRINT_ER("[wilc spi]: Failed data block write, read state, bus error...\n");
-			result = N_FAIL;
-			break;
-		}
-#endif
-
 		ix += nbytes;
 		sz -= nbytes;
 	} while (sz);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index f6974a6..ab66ce4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -332,15 +332,6 @@ void WILC_WFI_Rx(struct net_device *dev, struct WILC_WFI_packet *pkt)
 		WILC_WFI_monitor_rx(dev, skb);
 		return;
 	}
-#if 0
-	PRINT_D(RX_DBG, "In RX NORMAl Device name %s\n", dev->name);
-	/* Write metadata, and then pass to the receive level */
-	skb->dev = dev;
-	skb->protocol = eth_type_trans(skb, dev);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;  /* don't check it */
-	WILC_WFI_update_stats(priv->dev->ieee80211_ptr->wiphy, pkt->datalen, WILC_WFI_RX_PKT);
-	netif_rx(skb);
-#endif
 out:
 	return;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index db9e717..3af91f7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2044,37 +2044,6 @@ uint32_t init_chip(void)
 		}
 	}
 
-
-	#if 0
-	if ((chipid & 0xfff) < 0xf0) {
-		/* Setting MUX to probe sleep signal on pin 6 of J216*/
-		g_wlan.hif_func.hif_write_reg(0x1060, 0x1);
-		g_wlan.hif_func.hif_write_reg(0x1180, 0x33333333);
-		g_wlan.hif_func.hif_write_reg(0x1184, 0x33333333);
-		g_wlan.hif_func.hif_read_reg(0x1408, &reg);
-		/* set MUX for GPIO_4 (pin 4) to cortus GPIO*/
-		reg &= ~((0x7 << 16));
-		g_wlan.hif_func.hif_write_reg(0x1408, (reg | (0x7 << 12)));
-	} else {
-		/* Enable test bus*/
-		g_wlan.hif_func.hif_write_reg(0x1060, 0x1);
-		/* Rotate bus signals to get sleep signal on pin 6 like it was on previous chips*/
-		g_wlan.hif_func.hif_write_reg(0x1188, 0x70);
-		/* Set output of pin 6 to test bus 0x1*/
-		/* Set output of pin 9 to test bus 0x2*/
-		g_wlan.hif_func.hif_write_reg(0x1180, 0x200100);
-		g_wlan.hif_func.hif_read_reg(0x1408, &reg);
-
-		/* set MUX for GPIO_4 (pin 4) to cortus GPIO*/
-		reg &= ~((0x7 << 16));
-		/* set MUX for GPIO_3 (pin 6) to test bus*/
-		reg |= (0x7 << 12) | (0x7 << 24);
-		g_wlan.hif_func.hif_write_reg(0x1408, reg);
-	}
-	#endif
-
-
-
 	release_bus(RELEASE_ONLY);
 
 	return ret;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 9631b18..3cffe55 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -374,11 +374,6 @@ static int wilc_wlan_parse_info_frame(uint8_t *info, int size)
 	int type = WILC_CFG_RSP_STATUS;
 
 	wid = info[0] | (info[1] << 8);
-#if 0
-#ifdef BIG_ENDIAN
-	wid = BYTE_SWAP(wid);
-#endif
-#endif
 
 	len = info[2];
 	PRINT_INFO(GENERIC_DBG, "Status Len = %d Id= %d\n", len, wid);
@@ -390,27 +385,6 @@ static int wilc_wlan_parse_info_frame(uint8_t *info, int size)
 	return type;
 }
 
-#if 0
-static int wilc_wlan_parse_network_frame(uint8_t *info, int size)
-{
-	wilc_mac_cfg_t *priv = (wilc_mac_cfg_t *)&g_mac;
-	uint32_t wid, len;
-
-	wid = info[0] | (info[1] << 8);
-	len = info[2] | (info[3] << 8);
-
-	/**
-	 *      Review: this message is only for AP mode.
-	 *      TBD
-	 **/
-	if (wid == WID_NETWORK_INFO) {  /* not send by the firmware */
-
-	}
-
-	return;
-}
-#endif
-
 /********************************************
  *
  *      Configuration Exported Functions
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index ea0ec41..8ed51e3 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -169,28 +169,6 @@ typedef struct {
 	wilc_wlan_indicate_func_t indicate_func;
 } wilc_wlan_inp_t;
 
-#if 0
-typedef struct {
-	int start;
-	uint32_t id;
-	void *buffer;
-	uint32_t buffer_size;
-	int commit;
-} wilc_wlan_cfg_set_t;
-
-typedef struct {
-	int start;
-	uint32_t id;
-	int commit;
-} wilc_wlan_cfg_get_t;
-
-typedef struct {
-	uint32_t id;
-	void *buffer;
-	uint32_t buffer_size;
-} wilc_wlan_cfg_val_t;
-#endif
-
 struct tx_complete_data {
 	#ifdef WILC_FULLY_HOSTING_AP
 	struct tx_complete_data *next;
-- 
1.9.1

