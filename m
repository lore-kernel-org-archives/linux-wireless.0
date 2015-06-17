Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32922 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbbFQH3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 03:29:08 -0400
Received: by pdjn11 with SMTP id n11so32403492pdj.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 00:29:07 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 1/5] staging: wilc1000: change commenting styles.
Date: Wed, 17 Jun 2015 16:28:51 +0900
Message-Id: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com> (sfid-20150617_092913_364312_7A700A7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes commenting style to Linux preferred C89 style.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 721 ++++++++++++++++++--------------
 1 file changed, 397 insertions(+), 324 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index ea0ec41..c7143cd 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -1,17 +1,13 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_if.h */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) Atmel Corporation. All rights reserved.
+ * Module Name:  wilc_wlan_if.h
+ */
 
 
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
 
-/*bug 3887: [AP] Allow Management frames to be passed to the host*/
+/* bug 3887: [AP] Allow Management frames to be passed to the host */
 #define WILC_AP_EXTERNAL_MLME
 #define WILC_P2P
 #define TCP_ENHANCEMENTS
@@ -24,11 +20,7 @@
 #include "linux_wlan_common.h"
 
 
-/********************************************
- *
- *      Debug Flags
- *
- ********************************************/
+/* Debug Flags */
 
 #define N_INIT		0x00000001
 #define N_ERR		0x00000002
@@ -36,31 +28,19 @@
 #define N_INTR		0x00000008
 #define N_RXQ		0x00000010
 
-/********************************************
- *
- *      Host Interface Defines
- *
- ********************************************/
+/* Host Interface Defines */
 
 #define HIF_SDIO           (0)
 #define HIF_SPI            (1 << 0)
 #define HIF_SDIO_GPIO_IRQ  (1 << 2)
 
 
-/********************************************
- *
- *      Tx/Rx Buffer Size Defines
- *
- ********************************************/
+/* Tx/Rx Buffer Size Defines */
 
 #define CE_TX_BUFFER_SIZE (64 * 1024)
 #define CE_RX_BUFFER_SIZE (384 * 1024)
 
-/********************************************
- *
- *      Wlan Interface Defines
- *
- ********************************************/
+/* Wlan Interface Defines */
 
 typedef struct {
 	uint32_t read_write: 1;
@@ -97,7 +77,7 @@ typedef struct {
 	void (*os_enter_cs)(void *);
 	void (*os_leave_cs)(void *);
 
-	/*Added by Amr - BugID_4720*/
+	/* Added by Amr - BugID_4720 */
 	void (*os_spin_lock)(void *, unsigned long *);
 	void (*os_spin_unlock)(void *, unsigned long *);
 
@@ -146,7 +126,7 @@ typedef struct {
 	uint32_t tx_buffer_size;
 	void *txq_critical_section;
 
-	/*Added by Amr - BugID_4720*/
+	/* Added by Amr - BugID_4720 */
 	void *txq_add_to_head_critical_section;
 	void *txq_spin_lock;
 
@@ -218,7 +198,7 @@ typedef struct {
 	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
 	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
-	/*Bug3959: transmitting mgmt frames received from host*/
+	/* Bug3959: transmitting mgmt frames received from host */
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
 	int (*wlan_add_mgmt_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
 
@@ -229,11 +209,7 @@ typedef struct {
 	#endif
 } wilc_wlan_oup_t;
 
-/********************************************
- *
- *      Wlan Configuration ID
- *
- ********************************************/
+/* Wlan Configuration ID */
 
 #define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
@@ -283,15 +259,15 @@ typedef enum {
 } G_OPERATING_MODE_T;
 
 typedef enum {
-	G_SHORT_PREAMBLE = 0,   /* Short Preamble          */
-	G_LONG_PREAMBLE  = 1,           /* Long Preamble           */
-	G_AUTO_PREAMBLE  = 2,           /* Auto Preamble Selection */
+	G_SHORT_PREAMBLE = 0,	/* Short Preamble */
+	G_LONG_PREAMBLE  = 1,	/* Long Preamble */
+	G_AUTO_PREAMBLE  = 2,	/* Auto Preamble Selection */
 } G_PREAMBLE_T;
 
 #define MAC_CONNECTED    1
 #define MAC_DISCONNECTED 0
 
-/*bug3819: */
+/* bug3819: */
 #define SCAN_DONE		TRUE
 typedef enum {
 	PASSIVE_SCAN = 0,
@@ -328,10 +304,10 @@ typedef enum {
 	WEP_104 = 0x7,
 	WPA_AES = 0x29,
 	WPA_TKIP = 0x49,
-	WPA_AES_TKIP = 0x69,            /* Aes or Tkip */
+	WPA_AES_TKIP = 0x69,	/* Aes or Tkip */
 	WPA2_AES = 0x31,
 	WPA2_TKIP = 0x51,
-	WPA2_AES_TKIP = 0x71,   /* Aes or Tkip */
+	WPA2_AES_TKIP = 0x71,	/* Aes or Tkip */
 } SECURITY_T;
 
 typedef enum {
@@ -383,11 +359,11 @@ typedef enum {
 } CH_FILTER_T;
 
 typedef enum {
-	AUTO_PROT = 0,  /* Auto */
-	NO_PROT,                        /* Do not use any protection       */
-	ERP_PROT,                       /* Protect all ERP frame exchanges */
-	HT_PROT,                        /* Protect all HT frame exchanges  */
-	GF_PROT,                        /* Protect all GF frame exchanges  */
+	AUTO_PROT = 0,	/* Auto */
+	NO_PROT,	/* Do not use any protection */
+	ERP_PROT,	/* Protect all ERP frame exchanges */
+	HT_PROT,	/* Protect all HT frame exchanges  */
+	GF_PROT,	/* Protect all GF frame exchanges  */
 } N_PROTECTION_MODE_T;
 
 typedef enum {
@@ -409,16 +385,16 @@ typedef enum {
 } N_OBSS_DETECTION_T;
 
 typedef enum {
-	RTS_CTS_NONHT_PROT = 0,                 /* RTS-CTS at non-HT rate      */
-	FIRST_FRAME_NONHT_PROT,         /* First frame at non-HT rate  */
-	LSIG_TXOP_PROT,                                 /* LSIG TXOP Protection        */
-	FIRST_FRAME_MIXED_PROT,         /* First frame at Mixed format */
+	RTS_CTS_NONHT_PROT = 0,	/* RTS-CTS at non-HT rate */
+	FIRST_FRAME_NONHT_PROT,	/* First frame at non-HT rate */
+	LSIG_TXOP_PROT,		/* LSIG TXOP Protection */
+	FIRST_FRAME_MIXED_PROT,	/* First frame at Mixed format */
 } N_PROTECTION_TYPE_T;
 
 typedef enum {
 	STATIC_MODE   = 1,
 	DYNAMIC_MODE  = 2,
-	MIMO_MODE     = 3,              /* power save disable */
+	MIMO_MODE     = 3,	/* power save disable */
 } N_SMPS_MODE_T;
 
 typedef enum {
@@ -448,342 +424,428 @@ typedef enum {
 	WID_NIL                            = 0xffff,
 
 
-	/*  BSS Type                                                                                                                                                                            */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :  Infrastructure    Independent   Access Point                                                                               */
-	/*  Values to set :         0               1            2                                                                                                                      */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  BSS Type
+	 *  --------------------------------------------------------------
+	 *  Configuration :  Infrastructure    Independent   Access Point
+	 *  Values to set :         0               1            2
+	 *  --------------------------------------------------------------
+	 */
 	WID_BSS_TYPE						= 0x0000,
 
-	/*  Transmit Rate                                                                                                                                                                       */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :  1  2  5.5  11  6  9  12  18  24  36  48  54                                                                                */
-	/*  Values to set :  1  2  5  11  6  9  12  18  24  36  48  54                                                                                  */
-	/*  --------------------------------------------------------------      */
+	/*
+	 * Transmit Rate
+	 * --------------------------------------------------------------
+	 * Configuration :  1  2  5.5  11  6  9  12  18  24  36  48  54
+	 * Values to set :  1  2  5    11  6  9  12  18  24  36  48  54
+	 * --------------------------------------------------------------
+	 */
 	WID_CURRENT_TX_RATE			= 0x0001,
 
-	/*  Channel                                                                                                                                                                                                     */
-	/*  -------------------------------------------------------------------         */
-	/*  Configuration(g) :  1  2  3  4  5  6  7  8   9   10  11  12  13  14                                                                                         */
-	/*  Values to set    :  1  2  3  4  5  6  7  8   9   10  11  12  13  14                                                                                         */
-	/*  --------------------------------------------------------------------        */
+	/*
+	 * Channel
+	 * -------------------------------------------------------------------
+	 * Configuration(g) :  1  2  3  4  5  6  7  8   9   10  11  12  13  14
+	 * Values to set    :  1  2  3  4  5  6  7  8   9   10  11  12  13  14
+	 * -------------------------------------------------------------------
+	 */
 	WID_CURRENT_CHANNEL			= 0x0002,
 
-	/*  Preamble                                                                                                                                                                            */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :    short    long   Auto                                                                                                                             */
-	/*  Values to set :       0         1         2                                                                                                                                 */
-	/*  --------------------------------------------------------------      */
+	/*
+	 * Preamble
+	 * --------------------------------------------------------------
+	 * Configuration :    short    long   Auto
+	 * Values to set :       0      1      2
+	 * --------------------------------------------------------------
+	 */
 	WID_PREAMBLE						= 0x0003,
 
-	/*  11g operating mode (ignored if 11g not present)                                                                                                     */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   HighPerf  Compat(RSet #1) Compat(RSet #2)                                                                 */
-	/*  Values to set :          1               2               3                                                                                                                  */
-	/*  --------------------------------------------------------------      */
+	/*
+	 * 11g operating mode (ignored if 11g not present)
+	 * --------------------------------------------------------------
+	 * Configuration :   HighPerf  Compat(RSet #1) Compat(RSet #2)
+	 * Values to set :      1               2               3
+	 * --------------------------------------------------------------
+	 */
 	WID_11G_OPERATING_MODE            = 0x0004,
 
-	/*  Mac status (response only)                                                                                                                                                                  */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   disconnect  connect                                                                                                                                               */
-	/*  Values to get :          0               1                                                                                                                                          */
-	/*  --------------------------------------------------------------      */
+	/*
+	 * Mac status (response only)
+	 * --------------------------------------------------------------
+	 * Configuration :   disconnect  connect
+	 * Values to get :       0          1
+	 * --------------------------------------------------------------
+	 */
 	WID_STATUS						= 0x0005,
 
-	/*  Scan type                                                                                                                                                                           */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   Passive Scanning   Active Scanning                                                                                        */
-	/*  Values to set :                  0                 1                                                                                                                                */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  Scan type
+	 * --------------------------------------------------------------
+	 * Configuration :   Passive Scanning   Active Scanning
+	 * Values to set :                  0                 1
+	 * --------------------------------------------------------------
+	 */
 	WID_SCAN_TYPE                      = 0x0007,
 
-	/*  Key Id (WEP default key Id)                                                                                                                                                 */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   Any value between 0 to 3                                                                                                                  */
-	/*  Values to set :	Same value. Default is 0                                                                                                                                */
-	/*  --------------------------------------------------------------      */
+	/*
+	 * Key Id (WEP default key Id)
+	 * --------------------------------------------------------------
+	 * Configuration :   Any value between 0 to 3
+	 * Values to set :	Same value. Default is 0
+	 * --------------------------------------------------------------
+	 */
 	WID_KEY_ID                         = 0x0009,
 
-	/*  QoS Enable                                                                                                                                                                          */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration :   QoS Disable   WMM Enable                                                                                                          */
-	/*  Values to set :   0             1                                                                                                                                                   */
-	/*  --------------------------------------------------------------      */
+	/*
+	 *  QoS Enable
+	 *  --------------------------------------------------------------
+	 *  Configuration :   QoS Disable   WMM Enable
+	 *  Values to set :   0             1
+	 *  --------------------------------------------------------------
+	 */
 	WID_QOS_ENABLE                     = 0x000A,
 
-	/*  Power Management                                                                                                                                                                    */
-	/*  ------------------------------------------------------------------  */
-	/*  Configuration :   NO_POWERSAVE   MIN_POWERSAVE   MAX_POWERSAVE                                              */
-	/*  Values to set :   0              1               2                                                                                                                                  */
-	/*  ------------------------------------------------------------------   */
+	/*
+	 *  Power Management
+	 *  ----------------------------------------------------------------
+	 *  Configuration :   NO_POWERSAVE   MIN_POWERSAVE   MAX_POWERSAVE
+	 *  Values to set :   0              1               2
+	 *  ----------------------------------------------------------------
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
+	 *  ------------------------------------------------------------------
+	 *  Configuration : Disable WP40 WP104 WPA-AES WPA-TKIP RSN-AES RSN-TKIP
+	 *  Values (0x)   :   00     03   07     29       49      31      51
+	 *
+	 *  Configuration : WPA-AES+TKIP RSN-AES+TKIP
+	 *  Values (0x)   :      69          71
+	 *  ------------------------------------------------------------------
+	 */
 	WID_11I_MODE                       = 0x000C,
 
-	/*  WEP Configuration: Used in BSS STA mode only when WEP is enabled     */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration : Open System  Shared Key  Any Type  |   802.1x Auth   */
-	/*  Values (0x)   :    01             02         03    |      BIT2       */
-	/*  ------------------------------------------------------------------   */
+	/*
+	 *  WEP Configuration: Used in BSS STA mode only when WEP is enabled
+	 *  ------------------------------------------------------------------
+	 *  Configuration : Open System  Shared Key  Any Type  |   802.1x Auth
+	 *  Values (0x)   :    01             02         03    |      BIT2
+	 *  ------------------------------------------------------------------
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
+	 *  --------------------------------------------------------------
+	 *  Configuration       :  Values to set
+	 *  Survey 1 Channel    :  0
+	 *  survey all Channels :  1
+	 *  Disable Site Survey :  2
+	 *  --------------------------------------------------------------
+	 */
 	WID_SITE_SURVEY                    = 0x000E,
 
-	/*  Listen Interval                                                      */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 1 to 255                         */
-	/*  Values to set :   Same value. Default is 3                           */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Listen Interval
+	 *  --------------------------------------------------------------
+	 *  Configuration :   Any value between 1 to 255
+	 *  Values to set :   Same value. Default is 3
+	 *  --------------------------------------------------------------
+	 */
 	WID_LISTEN_INTERVAL                = 0x000F,
 
-	/*  DTIM Period                                                          */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 1 to 255                         */
-	/*  Values to set :   Same value. Default is 3                           */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  DTIM Period
+	 *  --------------------------------------------------------------
+	 *  Configuration :   Any value between 1 to 255
+	 *  Values to set :   Same value. Default is 3
+	 *  --------------------------------------------------------------
+	 */
 	WID_DTIM_PERIOD                    = 0x0010,
 
-	/*  ACK Policy                                                           */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Normal Ack            No Ack                       */
-	/*  Values to set :       0                   1                          */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * ACK Policy
+	 * --------------------------------------------------------------
+	 * Configuration :   Normal Ack            No Ack
+	 * Values to set :       0                   1
+	 * --------------------------------------------------------------
+	 */
 	WID_ACK_POLICY                     = 0x0011,
 
-	/*  Reset MAC (Set only)                                                           */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Don't Reset	Reset	No Request                       */
-	/*  Values to set :       0                   1			2                          */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * Reset MAC (Set only)
+	 * --------------------------------------------------------------
+	 * Configuration :   Don't Reset	Reset	No Request
+	 * Values to set :       0                   1			2
+	 * --------------------------------------------------------------
+	 */
 	WID_RESET                          = 0x0012,
 
-	/*  Broadcast SSID Option: Setting this will adhere to "" SSID element   */
-	/*  ------------------------------------------------------------------   */
-	/*  Configuration :   Enable             Disable                         */
-	/*  Values to set :   1                  0                               */
-	/*  ------------------------------------------------------------------   */
+	/*
+	 * Broadcast SSID Option: Setting this will adhere to "" SSID element
+	 * ------------------------------------------------------------------
+	 * Configuration :   Enable             Disable
+	 * Values to set :   1                  0
+	 * ------------------------------------------------------------------
+	 */
 	WID_BCAST_SSID                     = 0x0015,
 
-	/*  Disconnect (Station)                                                                                                                                                                                                                */
-	/*  ------------------------------------------------------------------  */
-	/*  Configuration :   Association ID                                                                                                                                                    */
-	/*  Values to set :   Association ID                                                                                                                                                    */
-	/*  ------------------------------------------------------------------  */
+	/*
+	 * Disconnect (Station)
+	 * ------------------------------------------------------------------
+	 * Configuration :   Association ID
+	 * Values to set :   Association ID
+	 * ------------------------------------------------------------------
+	 */
 	WID_DISCONNECT                     = 0x0016,
 
-	/*  11a Tx Power Level                                                   */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Sets TX Power (Higher the value greater the power)   */
-	/*  Values to set : Any value between 0 and 63 (inclusive; Default is 48)*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 * 11a Tx Power Level
+	 * --------------------------------------------------------------------
+	 * Configuration : Sets TX Power (Higher the value greater the power)
+	 * Values to set : Any value between 0 and 63 (inclusive; Default is 48)
+	 * --------------------------------------------------------------------
+	 */
 	WID_TX_POWER_LEVEL_11A             = 0x0018,
 
-	/*  Group Key Update Policy Selection                                    */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Disabled  timeBased  packetBased   timePacketBased   */
-	/*  Values to set :   1            2          3               4          */
-	/*  -------------------------------------------------------------------- */
+	/*
+	 * Group Key Update Policy Selection
+	 * --------------------------------------------------------------------
+	 * Configuration : Disabled  timeBased  packetBased   timePacketBased
+	 * Values to set :   1            2          3               4
+	 * --------------------------------------------------------------------
+	 */
 	WID_REKEY_POLICY                   = 0x0019,
 
-	/*  Allow Short Slot                                                     */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration : Disallow Short Slot      Allow Short Slot            */
-	/*              (Enable Only Long Slot) (Enable Short Slot if applicable)*/
-	/*  Values to set :    0         1                                       */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * Allow Short Slot
+	 * --------------------------------------------------------------
+	 * Configuration : Disallow Short Slot      Allow Short Slot
+	 *          (Enable Only Long Slot) (Enable Short Slot if applicable)
+	 * Values to set :         0                       1
+	 * --------------------------------------------------------------
+	 */
 	WID_SHORT_SLOT_ALLOWED             = 0x001A,
 
 	WID_PHY_ACTIVE_REG                 = 0x001B,
 
-	/*  11b Tx Power Level                                                   */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Sets TX Power (Higher the value greater the power)   */
-	/*  Values to set : Any value between 0 and 63 (inclusive; Default is 48)*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 * 11b Tx Power Level
+	 * --------------------------------------------------------------------
+	 * Configuration : Sets TX Power (Higher the value greater the power)
+	 * Values to set : Any value between 0 and 63 (inclusive; Default is 48)
+	 * --------------------------------------------------------------------
+	 */
 	WID_TX_POWER_LEVEL_11B             = 0x001D,
 
-	/*  Scan Request                                                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Request default scan                                                                                                                                                                        */
-	/*  Values to set : 0																													*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 * Scan Request
+	 * --------------------------------------------------------------------
+	 * Configuration : Request default scan
+	 * Values to set : 0
+	 * --------------------------------------------------------------------
+	 */
 	WID_START_SCAN_REQ                 = 0x001E,
 
-	/*  Rssi (get only)                                                                                                                                                                                     */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration :                                                                                                                                                                     */
-	/*  Values to get : Rssi value																													*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 * Rssi (get only)
+	 * --------------------------------------------------------------------
+	 * Configuration :
+	 * Values to get : Rssi value
+	 * --------------------------------------------------------------------
+	 */
 	WID_RSSI                           = 0x001F,
 
-	/*  Join Request                                                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Request to join                                                                                                                                                                     */
-	/*  Values to set : index of scan result																					*/
-	/*  -------------------------------------------------------------------- */
+	/*
+	 * Join Request
+	 * --------------------------------------------------------------------
+	 * Configuration : Request to join
+	 * Values to set : index of scan result
+	 * --------------------------------------------------------------------
+	 */
 	WID_JOIN_REQ                       = 0x0020,
 
 	WID_LINKSPEED								= 0x0026,
 
-	/*  Enable User Control of TX Power                                      */
-	/*  -------------------------------------------------------------------- */
-	/*  Configuration : Disable                  Enable                      */
-	/*  Values to set :    0                       1                         */
-	/*  -------------------------------------------------------------------- */
+	/*
+	 * Enable User Control of TX Power
+	 * --------------------------------------------------------------------
+	 * Configuration : Disable                  Enable
+	 * Values to set :    0                       1
+	 * --------------------------------------------------------------------
+	 */
 	WID_USER_CONTROL_ON_TX_POWER       = 0x0027,
 
 	WID_MEMORY_ACCESS_8BIT             = 0x0029,
 
-	/*  Enable Auto RX Sensitivity feature                                                                                                                                                          */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Disable                  Enable                                                                                                                                     */
-	/*  Values to set :    0                       1                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
+	/*
+	 * Enable Auto RX Sensitivity feature
+	 * --------------------------------------------------------------------
+	 * Configuration : Disable                  Enable
+	 * Values to set :    0                       1
+	 * --------------------------------------------------------------------
+	 */
 	WID_AUTO_RX_SENSITIVITY            = 0x0032,
 
-	/*  Receive Buffer Based Ack                                                                                                                                                                            */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Disable                  Enable                                                                                                                                     */
-	/*  Values to set :    0                       1                                                                                                                                                        */
-	/*  --------------------------------------------------------------------        */
+	/*
+	 * Receive Buffer Based Ack
+	 * --------------------------------------------------------------------
+	 * Configuration : Disable                  Enable
+	 * Values to set :    0                       1
+	 * --------------------------------------------------------------------
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
+	 * Scan Filter
+	 * --------------------------------------------------------------------
+	 * Configuration : Class  No filter  AP only  Station Only
+	 * Values to set :           0          1          2
+	 * Configuration : Priority  High Rssi  Low Rssi  Detect
+	 * Values to set :               0        0x4      0x08
+	 * Configuration : Channel  filter off  filter on
+	 * Values to set :               0        0x10
+	 * --------------------------------------------------------------------
+	 */
 	WID_SCAN_FILTER                    = 0x0036,
 
-	/*  Link Loss Threshold (measure in the beacon period)                                                                          */
-	/*  --------------------------------------------------------------------        */
-	/*  Configuration : Any value between 10 and 254 (Set to 255 to disable it)								*/
-	/*  Values to set : Same value. Default is 10																				*/
-	/*  --------------------------------------------------------------------        */
+	/*
+	 * Link Loss Threshold (measure in the beacon period)
+	 * --------------------------------------------------------------------
+	 * Configuration : Any value between 10 and 254 (Set to 255 to disable it)
+	 * Values to set : Same value. Default is 10
+	 * --------------------------------------------------------------------
+	 */
 	WID_LINK_LOSS_THRESHOLD            = 0x0037,
 
-	/*BugID_4978*/
+	/* BugID_4978 */
 	WID_ABORT_RUNNING_SCAN = 0x003E,
 
 	/* NMAC Character WID list */
 	WID_WPS_START                      = 0x0043,
 
-	/*  Protection mode for MAC                                              */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Auto  No protection  ERP    HT    GF                */
-	/*  Values to set :  0     1              2      3     4                 */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * Protection mode for MAC
+	 * --------------------------------------------------------------
+	 * Configuration :  Auto  No protection  ERP    HT    GF
+	 * Values to set :  0     1              2      3     4
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_PROT_MECH                  = 0x0080,
 
-	/*  ERP Protection type for MAC                                          */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Self-CTS   RTS-CTS                                  */
-	/*  Values to set :  0          1                                        */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * ERP Protection type for MAC
+	 * --------------------------------------------------------------
+	 * Configuration :  Self-CTS   RTS-CTS
+	 * Values to set :  0          1
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_ERP_PROT_TYPE              = 0x0081,
 
-	/*  HT Option Enable                                                     */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   HT Enable          HT Disable                       */
-	/*  Values to set :   1                  0                               */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * HT Option Enable
+	 * --------------------------------------------------------------
+	 * Configuration :   HT Enable          HT Disable
+	 * Values to set :   1                  0
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_ENABLE                     = 0x0082,
 
-	/*  11n Operating mode (Note that 11g operating mode will also be        */
-	/*  used in addition to this, if this is set to HT Mixed mode)           */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  HT Mixed  HT Only-20MHz   HT Only-20/40MHz          */
-	/*  Values to set :     1         2               3                         */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * 11n Operating mode (Note that 11g operating mode will also be
+	 * used in addition to this, if this is set to HT Mixed mode)
+	 * --------------------------------------------------------------
+	 * Configuration :  HT Mixed  HT Only-20MHz   HT Only-20/40MHz
+	 * Values to set :     1         2               3
+	 * --------------------------------------------------------------
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
+	 * 11n OBSS non-HT STA Detection flag
+	 * --------------------------------------------------------------
+	 * Configuration :  Do not detect
+	 * Values to set :  0
+	 * Configuration :  Detect, do not protect or report
+	 * Values to set :  1
+	 * Configuration :  Detect, protect and do not report
+	 * Values to set :  2
+	 * Configuration :  Detect, protect and report to other BSS
+	 * Values to set :  3
+	 * --------------------------------------------------------------
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
+	 * 11n HT Protection Type
+	 * --------------------------------------------------------------
+	 * Configuration :  RTS-CTS   First Frame Exchange at non-HT-rate
+	 * Values to set :  0         1
+	 * Configuration :  LSIG TXOP First Frame Exchange in Mixed Fmt
+	 * Values to set :  2         3
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_HT_PROT_TYPE               = 0x0085,
 
-	/*  11n RIFS Protection Enable Flag                                      */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Disable    Enable                                   */
-	/*  Values to set :  0          1                                        */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * 11n RIFS Protection Enable Flag
+	 * --------------------------------------------------------------
+	 * Configuration :  Disable    Enable
+	 * Values to set :  0          1
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_RIFS_PROT_ENABLE           = 0x0086,
 
-	/*  SMPS Mode                                                            */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Static   Dynamic   MIMO (Power Save Disabled)       */
-	/*  Values to set :  1        2         3                                */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * SMPS Mode
+	 * --------------------------------------------------------------
+	 * Configuration :  Static   Dynamic   MIMO (Power Save Disabled)
+	 * Values to set :  1        2         3
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_SMPS_MODE                  = 0x0087,
 
-	/*  Current transmit MCS                                                 */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  MCS Index for data rate                                                                                                                    */
-	/*  Values to set :  0 to 7                                                                                                                                                     */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * Current transmit MCS
+	 * --------------------------------------------------------------
+	 * Configuration :  MCS Index for data rate
+	 * Values to set :  0 to 7
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_CURRENT_TX_MCS             = 0x0088,
 
 	WID_11N_PRINT_STATS                = 0x0089,
 
-	/*  11n Short GI Enable Flag                                                                                                                                                    */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Disable    Enable                                                                                                                                  */
-	/*  Values to set :  0          1                                                                                                                                                       */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * 11n Short GI Enable Flag
+	 * --------------------------------------------------------------
+	 * Configuration :  Disable    Enable
+	 * Values to set :  0          1
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_SHORT_GI_ENABLE            = 0x008D,
 
-	/*  11n RIFS Enable Flag                                                                                                                                                */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :  Disable    Enable                                                                                                                                  */
-	/*  Values to set :  0          1                                                                                                                                                       */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * 11n RIFS Enable Flag
+	 * --------------------------------------------------------------
+	 * Configuration :  Disable    Enable
+	 * Values to set :  0          1
+	 * --------------------------------------------------------------
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
+	 * TX Abort Feature
+	 * --------------------------------------------------------------
+	 * Configuration :  Disable Self CTS    Enable Self CTS
+	 * Values to set :             0                                       1
+	 * Configuration :  Disable TX Abort    Enable TX Abort
+	 * Values to set :             2                                       3
+	 * Configuration :  Enable HW TX Abort Enable SW TX Abort
+	 * Values to set :             4                                       5
+	 * --------------------------------------------------------------
+	 */
 	WID_TX_ABORT_CONFIG                = 0x00A1,
 
 	WID_REG_TSSI_11B_VALUE             = 0x00A6,
@@ -794,18 +856,22 @@ typedef enum {
 	WID_DSCR_TSSI_11G_VALUE            = 0x00AB,
 	WID_DSCR_TSSI_11N_VALUE            = 0x00AC,
 
-	/*  Immediate Block-Ack Support                                          */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration : Disable                  Enable                      */
-	/*  Values to set :    0                       1                         */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * Immediate Block-Ack Support
+	 * --------------------------------------------------------------
+	 * Configuration : Disable                  Enable
+	 * Values to set :    0                       1
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_IMMEDIATE_BA_ENABLED       = 0x00AF,
 
-	/*  TXOP Disable Flag                                                                                                                                                                   */
-	/*  --------------------------------------------------------------      */
-	/*  Configuration : Disable                  Enable                                                                                                                     */
-	/*  Values to set :    1                        0                                                                                                                               */
-	/*  --------------------------------------------------------------      */
+	/*
+	 * TXOP Disable Flag
+	 * --------------------------------------------------------------
+	 * Configuration : Disable                  Enable
+	 * Values to set :    1                        0
+	 * --------------------------------------------------------------
+	 */
 	WID_11N_TXOP_PROT_DISABLE          = 0x00B0,
 
 
@@ -813,8 +879,8 @@ typedef enum {
 
 	/* Custom Character WID list */
 	WID_PC_TEST_MODE          = 0x00C8,
-	/*bug3819: */
-	/* SCAN Complete notification WID*/
+	/* bug3819: */
+	/* SCAN Complete notification WID */
 	WID_SCAN_COMPLETE		= 0x00C9,
 
 #ifdef WILC_AP_EXTERNAL_MLME
@@ -822,19 +888,23 @@ typedef enum {
 #endif
 
 	WID_LOGTerminal_Switch					= 0x00CD,
-	/* EMAC Short WID list */
-	/*  RTS Threshold                                                        */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 256 to 2347                      */
-	/*  Values to set :   Same value. Default is 2347                        */
-	/*  --------------------------------------------------------------       */
+	/*
+	 * EMAC Short WID list
+	 * RTS Threshold
+	 * --------------------------------------------------------------
+	 * Configuration :   Any value between 256 to 2347
+	 * Values to set :   Same value. Default is 2347
+	 * --------------------------------------------------------------
+	 */
 	WID_RTS_THRESHOLD                  = 0x1000,
 
-	/*  Fragmentation Threshold                                              */
-	/*  --------------------------------------------------------------       */
-	/*  Configuration :   Any value between 256 to 2346                      */
-	/*  Values to set :   Same value. Default is 2346                        */
-	/*  --------------------------------------------------------------       */
+	/*
+	 *  Fragmentation Threshold
+	 *  --------------------------------------------------------------
+	 *  Configuration :   Any value between 256 to 2346
+	 *  Values to set :   Same value. Default is 2346
+	 *  --------------------------------------------------------------
+	 */
 	WID_FRAG_THRESHOLD                 = 0x1001,
 
 	WID_SHORT_RETRY_LIMIT              = 0x1002,
@@ -919,10 +989,10 @@ typedef enum {
 	WID_REMOVE_KEY                     = 0x301E,
 	WID_ASSOC_REQ_INFO                 = 0x301F,
 	WID_ASSOC_RES_INFO                 = 0x3020,
-	WID_MANUFACTURER                   = 0x3026, /*Added for CAPI tool */
-	WID_MODEL_NAME                                     = 0x3027, /*Added for CAPI tool */
-	WID_MODEL_NUM                      = 0x3028, /*Added for CAPI tool */
-	WID_DEVICE_NAME                                     = 0x3029, /*Added for CAPI tool */
+	WID_MANUFACTURER                   = 0x3026, /* Added for CAPI tool */
+	WID_MODEL_NAME                                     = 0x3027, /* Added for CAPI tool */
+	WID_MODEL_NUM                      = 0x3028, /* Added for CAPI tool */
+	WID_DEVICE_NAME                                     = 0x3029, /* Added for CAPI tool */
 
 	/* NMAC String WID list */
 	WID_11N_P_ACTION_REQ               = 0x3080,
@@ -936,9 +1006,12 @@ typedef enum {
 	 #ifdef WILC_P2P
 	WID_REMAIN_ON_CHAN  = 0x3996,
 	#endif
-	/*BugID_4156*/
+	/* BugID_4156 */
 	WID_SSID_PROBE_REQ = 0x3997,
-	/*BugID_4124 WID to trigger modified Join Request using SSID and BSSID instead of bssListIdx (used by WID_JOIN_REQ)*/
+	/*
+	 * BugID_4124 WID to trigger modified Join Request using SSID and
+	 * BSSID instead of bssListIdx (used by WID_JOIN_REQ)
+	 */
 	WID_JOIN_REQ_EXTENDED		 = 0x3998,
 
 	/* BugID 4951: WID toset IP address in firmware */
@@ -961,12 +1034,12 @@ typedef enum {
 	WID_11N_AUTORATE_TABLE             = 0x4080,
 
 
-	/*Added here by Amr - BugID 4134*/
+	/* Added here by Amr - BugID 4134 */
 	WID_SCAN_CHANNEL_LIST                      = 0x4084,
 
-	/*BugID_3746 WID to add IE to be added in next probe request*/
+	/* BugID_3746 WID to add IE to be added in next probe request */
 	WID_INFO_ELEMENT_PROBE	 = 0x4085,
-	/*BugID_3746 WID to add IE to be added in next associate request*/
+	/* BugID_3746 WID to add IE to be added in next associate request */
 	WID_INFO_ELEMENT_ASSOCIATE	 = 0x4086,
 	WID_ADD_STA					 = 0X4087,
 	WID_REMOVE_STA				 = 0X4088,
-- 
1.9.1

