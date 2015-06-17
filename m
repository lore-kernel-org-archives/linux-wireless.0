Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35220 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbbFQH3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 03:29:17 -0400
Received: by pacyx8 with SMTP id yx8so29010228pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 00:29:17 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 3/5] staging: wilc1000: remove the warnings on line over 80 characters
Date: Wed, 17 Jun 2015 16:28:53 +0900
Message-Id: <1503bdd8cdcbe5267b580ba958669f922ee2d86f.1434526056.git.ywhsbliss@gmail.com> (sfid-20150617_092920_219755_4209E536)
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl regarding
line over 80 chracters.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 33d70c6..438e2db2 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -185,7 +185,8 @@ typedef struct {
 	int (*wlan_firmware_download)(const uint8_t *, uint32_t);
 	int (*wlan_start)(void);
 	int (*wlan_stop)(void);
-	int (*wlan_add_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_add_to_tx_que)(void *, uint8_t *,
+				  uint32_t, wilc_tx_complete_func_t);
 	int (*wlan_handle_tx_que)(uint32_t *);
 	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
@@ -195,10 +196,12 @@ typedef struct {
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
 	/* Bug3959: transmitting mgmt frames received from host */
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-	int (*wlan_add_mgmt_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_add_mgmt_to_tx_que)(void *, uint8_t *,
+				       uint32_t, wilc_tx_complete_func_t);
 
 	#ifdef WILC_FULLY_HOSTING_AP
-	int (*wlan_add_data_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_add_data_to_tx_que)(void *, uint8_t *,
+				       uint32_t, wilc_tx_complete_func_t);
 	#endif
 
 	#endif
@@ -247,10 +250,14 @@ typedef enum {
 } TX_RATE_T;
 
 typedef enum {
-	B_ONLY_MODE = 0,                                /* basic rate: 1, 2 Mbps, otherwise: 5, 11 Mbps */
-	G_ONLY_MODE,                                    /* basic rate: 6, 12, 24 Mbps, otherwise: 9, 18, 36, 48, 54 Mbps */
-	G_MIXED_11B_1_MODE,             /* basic rate: 1, 2, 5.5, 11 Mbps, otherwise: all on */
-	G_MIXED_11B_2_MODE,             /* basic rate: 1, 2, 5, 11, 6, 12, 24 Mbps, otherwise: all on */
+	/* basic rate: 1, 2 Mbps, otherwise: 5, 11 Mbps */
+	B_ONLY_MODE = 0,
+	/* basic rate: 6, 12, 24 Mbps, otherwise: 9, 18, 36, 48, 54 Mbps */
+	G_ONLY_MODE,
+	/* basic rate: 1, 2, 5.5, 11 Mbps, otherwise: all on */
+	G_MIXED_11B_1_MODE,
+	/* basic rate: 1, 2, 5, 11, 6, 12, 24 Mbps, otherwise: all on */
+	G_MIXED_11B_2_MODE,
 } G_OPERATING_MODE_T;
 
 typedef enum {
@@ -660,7 +667,7 @@ typedef enum {
 	 */
 	WID_JOIN_REQ                       = 0x0020,
 
-	WID_LINKSPEED								= 0x0026,
+	WID_LINKSPEED				= 0x0026,
 
 	/*
 	 * Enable User Control of TX Power
@@ -707,7 +714,8 @@ typedef enum {
 	/*
 	 * Link Loss Threshold (measure in the beacon period)
 	 * --------------------------------------------------------------------
-	 * Configuration : Any value between 10 and 254 (Set to 255 to disable it)
+	 * Configuration : Any value between 10 and 254
+	 * (Set to 255 to disable it)
 	 * Values to set : Same value. Default is 10
 	 * --------------------------------------------------------------------
 	 */
@@ -982,9 +990,9 @@ typedef enum {
 	WID_ASSOC_REQ_INFO                 = 0x301F,
 	WID_ASSOC_RES_INFO                 = 0x3020,
 	WID_MANUFACTURER                   = 0x3026, /* Added for CAPI tool */
-	WID_MODEL_NAME                                     = 0x3027, /* Added for CAPI tool */
+	WID_MODEL_NAME                     = 0x3027, /* Added for CAPI tool */
 	WID_MODEL_NUM                      = 0x3028, /* Added for CAPI tool */
-	WID_DEVICE_NAME                                     = 0x3029, /* Added for CAPI tool */
+	WID_DEVICE_NAME                    = 0x3029, /* Added for CAPI tool */
 
 	/* NMAC String WID list */
 	WID_11N_P_ACTION_REQ               = 0x3080,
-- 
1.9.1

