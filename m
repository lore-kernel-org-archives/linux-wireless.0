Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4466 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbbIQIuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 04:50:23 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/4] staging: wilc1000: remove warnings line over 80 characters
Date: Thu, 17 Sep 2015 17:50:05 +0900
Message-ID: <1442479806-10737-3-git-send-email-tony.cho@atmel.com> (sfid-20150917_105033_760712_DC6C7582)
In-Reply-To: <1442479806-10737-1-git-send-email-tony.cho@atmel.com>
References: <1442479806-10737-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl
for line over 80 characters.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 650 ++++++++++++++++++--------------
 1 file changed, 374 insertions(+), 276 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 9111491..0da748a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -1,4 +1,4 @@
-/* ////////////////////////////////////////////////////////////////////////// */
+/* ///////////////////////////////////////////////////////////////////////// */
 /*  */
 /* Copyright (c) Atmel Corporation.  All rights reserved. */
 /*  */
@@ -168,7 +168,8 @@ typedef struct {
 	int (*wlan_cfg_get)(int, u32, int, u32);
 	int (*wlan_cfg_get_value)(u32, u8 *, u32);
 	/*Bug3959: transmitting mgmt frames received from host*/
-	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
+	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32,
+				       wilc_tx_complete_func_t);
 } wilc_wlan_oup_t;
 
 /********************************************
@@ -216,16 +217,16 @@ typedef enum {
 } TX_RATE_T;
 
 typedef enum {
-	B_ONLY_MODE = 0,                                /* basic rate: 1, 2 Mbps, otherwise: 5, 11 Mbps */
-	G_ONLY_MODE,                                    /* basic rate: 6, 12, 24 Mbps, otherwise: 9, 18, 36, 48, 54 Mbps */
-	G_MIXED_11B_1_MODE,             /* basic rate: 1, 2, 5.5, 11 Mbps, otherwise: all on */
-	G_MIXED_11B_2_MODE,             /* basic rate: 1, 2, 5, 11, 6, 12, 24 Mbps, otherwise: all on */
+	B_ONLY_MODE = 0,    /* 1, 2 M, otherwise: 5, 11 M */
+	G_ONLY_MODE,        /* 6, 12, 24 M, otherwise: 9, 18, 36, 48, 54 M */
+	G_MIXED_11B_1_MODE, /* 1, 2, 5.5, 11 M, otherwise: all on */
+	G_MIXED_11B_2_MODE, /* 1, 2, 5, 11, 6, 12, 24 M, otherwise: all on */
 } G_OPERATING_MODE_T;
 
 typedef enum {
-	G_SHORT_PREAMBLE = 0,   /* Short Preamble          */
-	G_LONG_PREAMBLE  = 1,           /* Long Preamble           */
-	G_AUTO_PREAMBLE  = 2,           /* Auto Preamble Selection */
+	G_SHORT_PREAMBLE = 0,   /* Short Preamble */
+	G_LONG_PREAMBLE  = 1,   /* Long Preamble */
+	G_AUTO_PREAMBLE  = 2,   /* Auto Preamble Selection */
 } G_PREAMBLE_T;
 
 #define MAC_CONNECTED    1
@@ -349,10 +350,10 @@ typedef enum {
 } N_OBSS_DETECTION_T;
 
 typedef enum {
-	RTS_CTS_NONHT_PROT = 0,                 /* RTS-CTS at non-HT rate      */
-	FIRST_FRAME_NONHT_PROT,         /* First frame at non-HT rate  */
-	LSIG_TXOP_PROT,                                 /* LSIG TXOP Protection        */
-	FIRST_FRAME_MIXED_PROT,         /* First frame at Mixed format */
+	RTS_CTS_NONHT_PROT = 0,    /* RTS-CTS at non-HT rate */
+	FIRST_FRAME_NONHT_PROT, /* First frame at non-HT rate */
+	LSIG_TXOP_PROT,                    /* LSIG TXOP Protection */
+	FIRST_FRAME_MIXED_PROT,  /* First frame at Mixed format */
 } N_PROTECTION_TYPE_T;
 
 typedef enum {
@@ -387,237 +388,299 @@ typedef enum {
 typedef enum {
 	WID_NIL                            = 0xffff,
 
-	/*  BSS Type                                                                                                                                                                            */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :  Infrastructure    Independent   Access Point                                                                               */
-	/*  Values to set :         0               1            2                                                                                                                      */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  BSS Type
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Infrastructure    Independent   Access Point
+	 *  Values to set :         0               1            2
+	 *  -----------------------------------------------------------
+	*/
 	WID_BSS_TYPE						= 0x0000,
 
-	/*  Transmit Rate                                                                                                                                                                       */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :  1  2  5.5  11  6  9  12  18  24  36  48  54                                                                                */
-	/*  Values to set :  1  2  5  11  6  9  12  18  24  36  48  54                                                                                  */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  Transmit Rate
+	 *  -----------------------------------------------------------
+	 *  Configuration :  1  2  5.5  11  6  9  12  18  24  36  48  54
+	 *  Values to set :  1  2     5  11  6  9  12  18  24  36  48  54
+	 *  -----------------------------------------------------------
+	 */
 	WID_CURRENT_TX_RATE			= 0x0001,
 
-	/*  Channel                                                                                                                                                                                                     */
-	/*  -------------------------------------------------------------------         */
-	/*  Configuration(g) :  1  2  3  4  5  6  7  8   9   10  11  12  13  14                                                                                         */
-	/*  Values to set    :  1  2  3  4  5  6  7  8   9   10  11  12  13  14                                                                                         */
-	/*  --------------------------------------------------------------------        */
+	/*
+	 *  Channel
+	 *  -----------------------------------------------------------
+	 *  Configuration(g) :  1  2  3  4  5  6  7  8   9   10  11  12  13  14
+	 *  Values to set    :  1  2  3  4  5  6  7  8   9   10  11  12  13  14
+	 *  -----------------------------------------------------------
+	 */
 	WID_CURRENT_CHANNEL			= 0x0002,
 
-	/*  Preamble                                                                                                                                                                            */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :    short    long   Auto                                                                                                                             */
-	/*  Values to set :       0         1         2                                                                                                                                 */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  Preamble
+	 *  -----------------------------------------------------------
+	 *  Configuration :    short    long   Auto
+	 *  Values to set :       0         1         2
+	 *  -----------------------------------------------------------
+	 */
 	WID_PREAMBLE						= 0x0003,
 
-	/*  11g operating mode (ignored if 11g not present)                                                                                                     */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   HighPerf  Compat(RSet #1) Compat(RSet #2)                                                                 */
-	/*  Values to set :          1               2               3                                                                                                                  */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  11g operating mode (ignored if 11g not present)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   HighPerf  Compat(RSet #1) Compat(RSet #2)
+	 *  Values to set :          1               2               3
+	 *  -----------------------------------------------------------
+	 */
 	WID_11G_OPERATING_MODE            = 0x0004,
 
-	/*  Mac status (response only)                                                                                                                                                                  */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   disconnect  connect                                                                                                                                               */
-	/*  Values to get :          0               1                                                                                                                                          */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  Mac status (response only)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   disconnect  connect
+	 *  Values to get :          0               1
+	 *  -----------------------------------------------------------
+	 */
 	WID_STATUS						= 0x0005,
 
-	/*  Scan type                                                                                                                                                                           */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   Passive Scanning   Active Scanning                                                                                        */
-	/*  Values to set :                  0                 1                                                                                                                                */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  Scan type
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Passive Scanning   Active Scanning
+	 *  Values to set :                  0                 1
+	 *  -----------------------------------------------------------
+	 */
 	WID_SCAN_TYPE                      = 0x0007,
 
-	/*  Key Id (WEP default key Id)                                                                                                                                                 */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   Any value between 0 to 3                                                                                                                  */
-	/*  Values to set :	Same value. Default is 0                                                                                                                                */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  Key Id (WEP default key Id)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 0 to 3
+	 *  Values to set :	Same value. Default is 0
+	 *  -----------------------------------------------------------
+	 */
 	WID_KEY_ID                         = 0x0009,
 
-	/*  QoS Enable                                                                                                                                                                          */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   QoS Disable   WMM Enable                                                                                                          */
-	/*  Values to set :   0             1                                                                                                                                                   */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  QoS Enable
+	 *  -----------------------------------------------------------
+	 *  Configuration :   QoS Disable   WMM Enable
+	 *  Values to set :   0             1
+	 *  -----------------------------------------------------------
+	 */
 	WID_QOS_ENABLE                     = 0x000A,
 
-	/*  Power Management                                                                                                                                                                    */
-	/*  ------------------------------------------------------------------  */
-	/*  Configuration :   NO_POWERSAVE   MIN_POWERSAVE   MAX_POWERSAVE                                              */
-	/*  Values to set :   0              1               2                                                                                                                                  */
-	/*  ------------------------------------------------------------------   */
+	/*
+	 *  Power Management
+	 *  -----------------------------------------------------------
+	 *  Configuration :   NO_POWERSAVE   MIN_POWERSAVE   MAX_POWERSAVE
+	 *  Values to set :   0              1               2
+	 *  -----------------------------------------------------------
+	 */
 	WID_POWER_MANAGEMENT               = 0x000B,
 
-	/*  WEP/802 11I Configuration                                            */
-	/*  ------------------------------------------------------------------  */
-	/*  Configuration : Disable WP40 WP104 WPA-AES WPA-TKIP RSN-AES RSN-TKIP                                */
-	/*  Values (0x)   :   00                03    07        29                      49                      31                      51                                      */
-	/*                                                                                                                                                                                                              */
-	/*  Configuration : WPA-AES+TKIP RSN-AES+TKIP                                                                                                                   */
-	/*  Values (0x)   :      69                             71                                                                                                                              */
-	/*  ------------------------------------------------------------------   */
+	/*
+	 *  WEP/802 11I Configuration
+	 *  -----------------------------------------------------------
+	 *  Conf : Disable WP40 WP104 WPA-AES WPA-TKIP RSN-AES RSN-TKIP
+	 *  Val(0x) : 00    03     07        29        49          31       51
+	 *  -----------------------------------------------------------
+	 *  Configuration : WPA-AES+TKIP RSN-AES+TKIP
+	 *  Values (0x)   :      69                             71
+	 *  -----------------------------------------------------------
+	 */
 	WID_11I_MODE                       = 0x000C,
 
-	/*  WEP Configuration: Used in BSS STA mode only when WEP is enabled     */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration : Open System  Shared Key  Any Type  |   802.1x Auth   */
-	/*  Values (0x)   :    01             02         03    |      BIT2       */
-	/*  ------------------------------------------------------------------   */
+	/*
+	 *  WEP Configuration: Used in BSS STA mode only when WEP is enabled
+	 *  -----------------------------------------------------------
+	 *  Configuration : Open System  Shared Key  Any Type  |   802.1x Auth
+	 *  Values (0x)   :    01             02         03     |      BIT2
+	 *  -----------------------------------------------------------
+	 */
 	WID_AUTH_TYPE                      = 0x000D,
 
-	/*  Site Survey Type                                                                                                                                                                    */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration       :  Values to set                                                                                                                                */
-	/*  Survey 1 Channel    :  0                                                                                                                                                    */
-	/*  survey all Channels :  1                                                                                                                                                    */
-	/*  Disable Site Survey :  2                                                                                                                                                    */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  Site Survey Type
+	 *  -----------------------------------------------------------
+	 *  Configuration       :  Values to set
+	 *  Survey 1 Channel    :  0
+	 *  survey all Channels :  1
+	 *  Disable Site Survey :  2
+	 *  -----------------------------------------------------------
+	 */
 	WID_SITE_SURVEY                    = 0x000E,
 
-	/*  Listen Interval                                                      */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 1 to 255                         */
-	/*  Values to set :   Same value. Default is 3                           */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Listen Interval
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 1 to 255
+	 *  Values to set :   Same value. Default is 3
+	 *  -----------------------------------------------------------
+	 */
 	WID_LISTEN_INTERVAL                = 0x000F,
 
-	/*  DTIM Period                                                          */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 1 to 255                         */
-	/*  Values to set :   Same value. Default is 3                           */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  DTIM Period
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 1 to 255
+	 *  Values to set :   Same value. Default is 3
+	 *  -----------------------------------------------------------
+	 */
 	WID_DTIM_PERIOD                    = 0x0010,
 
-	/*  ACK Policy                                                           */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Normal Ack            No Ack                       */
-	/*  Values to set :       0                   1                          */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  ACK Policy
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Normal Ack            No Ack
+	 *  Values to set :       0                   1
+	 *  -----------------------------------------------------------
+	 */
 	WID_ACK_POLICY                     = 0x0011,
 
-	/*  Reset MAC (Set only)                                                           */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Don't Reset	Reset	No Request                       */
-	/*  Values to set :       0                   1			2                          */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Reset MAC (Set only)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Don't Reset	Reset	No Request
+	 *  Values to set :       0                   1              2
+	 *  -----------------------------------------------------------
+	 */
 	WID_RESET                          = 0x0012,
 
-	/*  Broadcast SSID Option: Setting this will adhere to "" SSID element   */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration :   Enable             Disable                         */
-	/*  Values to set :   1                  0                               */
-	/*  ------------------------------------------------------------------   */
+	/*
+	 *  Broadcast SSID Option: Setting this will adhere to "" SSID element
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Enable             Disable
+	 *  Values to set :   1                  0
+	 *  -----------------------------------------------------------
+	 */
 	WID_BCAST_SSID                     = 0x0015,
 
-	/*  Disconnect (Station)                                                                                                                                                                                                                */
-	/*  ------------------------------------------------------------------  */
-	/*  Configuration :   Association ID                                                                                                                                                    */
-	/*  Values to set :   Association ID                                                                                                                                                    */
-	/*  ------------------------------------------------------------------  */
+	/*
+	 *  Disconnect (Station)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Association ID
+	 *  Values to set :   Association ID
+	 *  -----------------------------------------------------------
+	 */
 	WID_DISCONNECT                     = 0x0016,
 
-	/*  11a Tx Power Level                                                   */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Sets TX Power (Higher the value greater the power)   */
-	/*  Values to set : Any value between 0 and 63 (inclusive; Default is 48)*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 *  11a Tx Power Level
+	 *  -----------------------------------------------------------
+	 *  Conf : Sets TX Power (Higher the value greater the power)
+	 *  Values : Any value between 0 and 63 (inclusive; Default is 48)
+	 *  -----------------------------------------------------------
+	 */
 	WID_TX_POWER_LEVEL_11A             = 0x0018,
 
-	/*  Group Key Update Policy Selection                                    */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Disabled  timeBased  packetBased   timePacketBased   */
-	/*  Values to set :   1            2          3               4          */
-	/*  -------------------------------------------------------------------- */
+	/*
+	 *  Group Key Update Policy Selection
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disabled  timeBased  packetBased   timePacketBased
+	 *  Values to set :   1            2          3               4
+	 *  -----------------------------------------------------------
+	 */
 	WID_REKEY_POLICY                   = 0x0019,
 
-	/*  Allow Short Slot                                                     */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration : Disallow Short Slot      Allow Short Slot            */
-	/*              (Enable Only Long Slot) (Enable Short Slot if applicable)*/
-	/*  Values to set :    0         1                                       */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Allow Short Slot
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disallow Short Slot      Allow Short Slot
+	 *      (Enable Only Long Slot) (Enable Short Slot if applicable)
+	 *  Values to set :    0         1
+	 *  -----------------------------------------------------------
+	 */
 	WID_SHORT_SLOT_ALLOWED             = 0x001A,
 
 	WID_PHY_ACTIVE_REG                 = 0x001B,
 
-	/*  11b Tx Power Level                                                   */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Sets TX Power (Higher the value greater the power)   */
-	/*  Values to set : Any value between 0 and 63 (inclusive; Default is 48)*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 *  11b Tx Power Level
+	 *  -----------------------------------------------------------
+	 *  Configuration : Sets TX Power (Higher the value greater the power)
+	 *  Values to set : Any value between 0 and 63 (inclusive; Default 48)
+	 *  -----------------------------------------------------------
+	 */
 	WID_TX_POWER_LEVEL_11B             = 0x001D,
 
-	/*  Scan Request                                                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Request default scan                                                                                                                                                                        */
-	/*  Values to set : 0																													*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 *  Scan Request
+	 *  -----------------------------------------------------------
+	 *  Configuration : Request default scan
+	 *  Values to set : 0
+	 *  -----------------------------------------------------------
+	 */
 	WID_START_SCAN_REQ                 = 0x001E,
 
-	/*  Rssi (get only)                                                                                                                                                                                     */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration :                                                                                                                                                                     */
-	/*  Values to get : Rssi value																													*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 *  Rssi (get only)
+	 *  -----------------------------------------------------------
+	 *  Configuration :
+	 *  Values to get : Rssi value
+	 *  -----------------------------------------------------------
+	 */
 	WID_RSSI                           = 0x001F,
 
-	/*  Join Request                                                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Request to join                                                                                                                                                                     */
-	/*  Values to set : index of scan result																					*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 *  Join Request
+	 *  -----------------------------------------------------------
+	 *  Configuration : Request to join
+	 *  Values to set : index of scan result
+	 *  -----------------------------------------------------------
+	 */
 	WID_JOIN_REQ                       = 0x0020,
 
-	WID_LINKSPEED								= 0x0026,
+	WID_LINKSPEED			  = 0x0026,
 
-	/*  Enable User Control of TX Power                                      */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Disable                  Enable                      */
-	/*  Values to set :    0                       1                         */
-	/*  -------------------------------------------------------------------- */
+	/*
+	 *  Enable User Control of TX Power
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
 	WID_USER_CONTROL_ON_TX_POWER       = 0x0027,
 
 	WID_MEMORY_ACCESS_8BIT             = 0x0029,
 
-	/*  Enable Auto RX Sensitivity feature                                                                                                                                                          */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Disable                  Enable                                                                                                                                     */
-	/*  Values to set :    0                       1                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
+	/*
+	 *  Enable Auto RX Sensitivity feature
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
 	WID_AUTO_RX_SENSITIVITY            = 0x0032,
 
-	/*  Receive Buffer Based Ack                                                                                                                                                                            */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Disable                  Enable                                                                                                                                     */
-	/*  Values to set :    0                       1                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
+	/*
+	 *  Receive Buffer Based Ack
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
 	WID_DATAFLOW_CONTROL               = 0x0033,
 
-	/*  Scan Filter                                                                                                                                                                                 */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Class		No filter       AP only			Station Only                                                                            */
-	/*  Values to set :                                     0                     1                     2                                                                                           */
-	/*  Configuration : Priority    High Rssi       Low Rssi		Detect													*/
-	/*  Values to set :                                     0                  0x4                  0x08                                                                                    */
-	/*  Configuration : Channel     filter off              filter on																	*/
-	/*  Values to set :                                     0                  0x10                                                                                                                 */
-	/*  --------------------------------------------------------------------        */
+	/*
+	 *  Scan Filter
+	 *  -----------------------------------------------------------
+	 *  Configuration : Class No filter   AP only  Station Only
+	 *  Values to set :             0             1               2
+	 *  Configuration : Priority   High Rssi   Low Rssi   Detect
+	 *  Values to set :                 0              0x4        0x08
+	 *  Configuration : Channel  filter off        filter on
+	 *  Values to set :                 0                  0x10
+	 *  -----------------------------------------------------------
+	 */
 	WID_SCAN_FILTER                    = 0x0036,
 
-	/*  Link Loss Threshold (measure in the beacon period)                                                                          */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Any value between 10 and 254 (Set to 255 to disable it)								*/
-	/*  Values to set : Same value. Default is 10																				*/
-	/*  --------------------------------------------------------------------        */
+	/*
+	 *  Link Loss Threshold (measure in the beacon period)
+	 *  -----------------------------------------------------------
+	 *  Configuration : Any value 10 ~ 254 (Set to 255 to disable it)
+	 *  Values to set : Same value. Default is 10
+	 *  -----------------------------------------------------------
+	 */
 	WID_LINK_LOSS_THRESHOLD            = 0x0037,
 
 	/*BugID_4978*/
@@ -626,103 +689,127 @@ typedef enum {
 	/* NMAC Character WID list */
 	WID_WPS_START                      = 0x0043,
 
-	/*  Protection mode for MAC                                              */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Auto  No protection  ERP    HT    GF                */
-	/*  Values to set :  0     1              2      3     4                 */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Protection mode for MAC
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Auto  No protection  ERP    HT    GF
+	 *  Values to set :  0     1              2      3     4
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_PROT_MECH                  = 0x0080,
 
-	/*  ERP Protection type for MAC                                          */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Self-CTS   RTS-CTS                                  */
-	/*  Values to set :  0          1                                        */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  ERP Protection type for MAC
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Self-CTS   RTS-CTS
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_ERP_PROT_TYPE              = 0x0081,
 
-	/*  HT Option Enable                                                     */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   HT Enable          HT Disable                       */
-	/*  Values to set :   1                  0                               */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  HT Option Enable
+	 *  -----------------------------------------------------------
+	 *  Configuration :   HT Enable          HT Disable
+	 *  Values to set :   1                  0
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_ENABLE                     = 0x0082,
 
-	/*  11n Operating mode (Note that 11g operating mode will also be        */
-	/*  used in addition to this, if this is set to HT Mixed mode)           */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  HT Mixed  HT Only-20MHz   HT Only-20/40MHz          */
-	/*  Values to set :     1         2               3                         */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  11n Operating mode (Note that 11g operating mode will also be
+	 *  used in addition to this, if this is set to HT Mixed mode)
+	 *  -----------------------------------------------------------
+	 *   Configuration :  HT Mixed  HT Only-20MHz   HT Only-20/40MHz
+	 *  Values to set :     1         2               3
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_OPERATING_MODE             = 0x0083,
 
-	/*  11n OBSS non-HT STA Detection flag                                   */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Do not detect                                       */
-	/*  Values to set :  0                                                   */
-	/*  Configuration :  Detect, do not protect or report                    */
-	/*  Values to set :  1                                                   */
-	/*  Configuration :  Detect, protect and do not report                   */
-	/*  Values to set :  2                                                   */
-	/*  Configuration :  Detect, protect and report to other BSS             */
-	/*  Values to set :  3                                                   */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  11n OBSS non-HT STA Detection flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Do not detect
+	 *  Values to set :  0
+	 *  Configuration :  Detect, do not protect or report
+	 *  Values to set :  1
+	 *  Configuration :  Detect, protect and do not report
+	 *  Values to set :  2
+	 *  Configuration :  Detect, protect and report to other BSS
+	 *  Values to set :  3
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_OBSS_NONHT_DETECTION       = 0x0084,
 
-	/*  11n HT Protection Type                                               */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  RTS-CTS   First Frame Exchange at non-HT-rate       */
-	/*  Values to set :  0         1                                         */
-	/*  Configuration :  LSIG TXOP First Frame Exchange in Mixed Fmt         */
-	/*  Values to set :  2         3                                         */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  11n HT Protection Type
+	 *  -----------------------------------------------------------
+	 *  Configuration :  RTS-CTS   First Frame Exchange at non-HT-rate
+	 *  Values to set :  0         1
+	 *  Configuration :  LSIG TXOP First Frame Exchange in Mixed Fmt
+	 *  Values to set :  2         3
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_HT_PROT_TYPE               = 0x0085,
 
-	/*  11n RIFS Protection Enable Flag                                      */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Disable    Enable                                   */
-	/*  Values to set :  0          1                                        */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  11n RIFS Protection Enable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable    Enable
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_RIFS_PROT_ENABLE           = 0x0086,
 
-	/*  SMPS Mode                                                            */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Static   Dynamic   MIMO (Power Save Disabled)       */
-	/*  Values to set :  1        2         3                                */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  SMPS Mode
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Static   Dynamic   MIMO (Power Save Disabled)
+	 *  Values to set :  1        2         3
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_SMPS_MODE                  = 0x0087,
 
-	/*  Current transmit MCS                                                 */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  MCS Index for data rate                                                                                                                    */
-	/*  Values to set :  0 to 7                                                                                                                                                     */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Current transmit MCS
+	 *  -----------------------------------------------------------
+	 *  Configuration :  MCS Index for data rate
+	 *  Values to set :  0 to 7
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_CURRENT_TX_MCS             = 0x0088,
 
 	WID_11N_PRINT_STATS                = 0x0089,
 
-	/*  11n Short GI Enable Flag                                                                                                                                                    */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Disable    Enable                                                                                                                                  */
-	/*  Values to set :  0          1                                                                                                                                                       */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  11n Short GI Enable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable    Enable
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_SHORT_GI_ENABLE            = 0x008D,
 
-	/*  11n RIFS Enable Flag                                                                                                                                                */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Disable    Enable                                                                                                                                  */
-	/*  Values to set :  0          1                                                                                                                                                       */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  11n RIFS Enable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable    Enable
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
 	WID_RIFS_MODE                      = 0x0094,
 
-	/*  TX Abort Feature                                                                                                                                                    */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Disable Self CTS    Enable Self CTS                                                                                                        */
-	/*  Values to set :             0                                       1                                                                                                                               */
-	/*  Configuration :  Disable TX Abort    Enable TX Abort                                                                                                        */
-	/*  Values to set :             2                                       3                                                                                                                               */
-	/*  Configuration :  Enable HW TX Abort Enable SW TX Abort                                                                                              */
-	/*  Values to set :             4                                       5                                                                                                                               */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  TX Abort Feature
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable Self CTS    Enable Self CTS
+	 *  Values to set :             0                      1
+	 *  Configuration :  Disable TX Abort    Enable TX Abort
+	 *  Values to set :             2                      3
+	 *  Configuration :  Enable HW TX Abort Enable SW TX Abort
+	 *  Values to set :             4                      5
+	 *  -----------------------------------------------------------
+	 */
 	WID_TX_ABORT_CONFIG                = 0x00A1,
 
 	WID_REG_TSSI_11B_VALUE             = 0x00A6,
@@ -733,18 +820,22 @@ typedef enum {
 	WID_DSCR_TSSI_11G_VALUE            = 0x00AB,
 	WID_DSCR_TSSI_11N_VALUE            = 0x00AC,
 
-	/*  Immediate Block-Ack Support                                          */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration : Disable                  Enable                      */
-	/*  Values to set :    0                       1                         */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Immediate Block-Ack Support
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_IMMEDIATE_BA_ENABLED       = 0x00AF,
 
-	/*  TXOP Disable Flag                                                                                                                                                                   */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration : Disable                  Enable                                                                                                                     */
-	/*  Values to set :    1                        0                                                                                                                               */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  TXOP Disable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    1                        0
+	 *  -----------------------------------------------------------
+	 */
 	WID_11N_TXOP_PROT_DISABLE          = 0x00B0,
 
 	WID_TX_POWER_LEVEL_11N             = 0x00B1,
@@ -758,19 +849,23 @@ typedef enum {
 	WID_DEL_BEACON					= 0x00CA,
 
 	WID_LOGTerminal_Switch					= 0x00CD,
-	/* EMAC Short WID list */
-	/*  RTS Threshold                                                        */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 256 to 2347                      */
-	/*  Values to set :   Same value. Default is 2347                        */
-	/*  --------------------------------------------------------------       */
+	/*  EMAC Short WID list */
+	/*  RTS Threshold */
+	/*
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 256 to 2347
+	 *  Values to set :   Same value. Default is 2347
+	 *  -----------------------------------------------------------
+	 */
 	WID_RTS_THRESHOLD                  = 0x1000,
 
-	/*  Fragmentation Threshold                                              */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 256 to 2346                      */
-	/*  Values to set :   Same value. Default is 2346                        */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Fragmentation Threshold
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 256 to 2346
+	 *  Values to set :   Same value. Default is 2346
+	 *  -----------------------------------------------------------
+	 */
 	WID_FRAG_THRESHOLD                 = 0x1001,
 
 	WID_SHORT_RETRY_LIMIT              = 0x1002,
@@ -855,9 +950,9 @@ typedef enum {
 	WID_ASSOC_REQ_INFO                 = 0x301F,
 	WID_ASSOC_RES_INFO                 = 0x3020,
 	WID_MANUFACTURER                   = 0x3026, /*Added for CAPI tool */
-	WID_MODEL_NAME                                     = 0x3027, /*Added for CAPI tool */
+	WID_MODEL_NAME                       = 0x3027, /*Added for CAPI tool */
 	WID_MODEL_NUM                      = 0x3028, /*Added for CAPI tool */
-	WID_DEVICE_NAME                                     = 0x3029, /*Added for CAPI tool */
+	WID_DEVICE_NAME                      = 0x3029, /*Added for CAPI tool */
 
 	/* NMAC String WID list */
 	WID_11N_P_ACTION_REQ               = 0x3080,
@@ -869,7 +964,10 @@ typedef enum {
 	WID_REMAIN_ON_CHAN  = 0x3996,
 	/*BugID_4156*/
 	WID_SSID_PROBE_REQ = 0x3997,
-	/*BugID_4124 WID to trigger modified Join Request using SSID and BSSID instead of bssListIdx (used by WID_JOIN_REQ)*/
+	/*
+	 * BugID_4124 WID to trigger modified Join Request using
+	 * SSID and BSSID instead of bssListIdx (used by WID_JOIN_REQ)
+	 */
 	WID_JOIN_REQ_EXTENDED		 = 0x3998,
 
 	/* BugID 4951: WID toset IP address in firmware */
-- 
1.9.1

