Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3551 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbbJAHEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:04:53 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/12] staging: wilc1000: remove function pointer wlan_cfg_set
Date: Thu, 1 Oct 2015 16:03:40 +0900
Message-ID: <1443683023-6498-9-git-send-email-tony.cho@atmel.com> (sfid-20151001_090456_500241_1BACE51F)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_cfg_set and just call
the function wilc_wlan_cfg_set. Remove static from the function also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 14 +++--
 drivers/staging/wilc1000/linux_wlan.c       | 91 ++++++++++++++---------------
 drivers/staging/wilc1000/wilc_wlan.c        |  4 +-
 drivers/staging/wilc1000/wilc_wlan.h        |  2 +
 drivers/staging/wilc1000/wilc_wlan_if.h     |  1 -
 5 files changed, 55 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b6b19fe..4e9feca 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -11,6 +11,7 @@
 
 #include "coreconfigurator.h"
 #include "wilc_wlan_if.h"
+#include "wilc_wlan.h"
 #include <linux/errno.h>
 #include <linux/slab.h>
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
@@ -613,8 +614,7 @@ s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
 	} else {
 		PRINT_D(CORECONFIG_DBG, "Net Dev is initialized\n");
 	}
-	if (gpstrWlanOps->wlan_cfg_set == NULL ||
-	    gpstrWlanOps->wlan_cfg_get == NULL)	{
+	if (gpstrWlanOps->wlan_cfg_get == NULL)	{
 		PRINT_D(CORECONFIG_DBG, "Set and Get is still not initialized\n");
 		return 1;
 	} else {
@@ -642,10 +642,12 @@ s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
 	} else if (u8Mode == SET_CFG) {
 		for (counter = 0; counter < u32WIDsCount; counter++) {
 			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", pstrWIDs[counter].u16WIDid);
-			if (!gpstrWlanOps->wlan_cfg_set(!counter,
-							pstrWIDs[counter].u16WIDid, pstrWIDs[counter].ps8WidVal,
-							pstrWIDs[counter].s32ValueSize,
-							(counter == u32WIDsCount - 1), drvHandler)) {
+			if (!wilc_wlan_cfg_set(!counter,
+					       pstrWIDs[counter].u16WIDid,
+					       pstrWIDs[counter].ps8WidVal,
+					       pstrWIDs[counter].s32ValueSize,
+					       (counter == u32WIDsCount - 1),
+					       drvHandler)) {
 				ret = -1;
 				printk("[Sendconfigpkt]Set Timed out\n");
 				break;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9e22247..ad4d64e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -700,60 +700,55 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n", mac_add[0], mac_add[1], mac_add[2], mac_add[3], mac_add[4], mac_add[5]);
 	wilc_get_chipid(0);
 
-	if (g_linux_wlan->oup.wlan_cfg_set == NULL) {
-		PRINT_D(INIT_DBG, "Null p[ointer\n");
-		goto _fail_;
-	}
-
 	*(int *)c_val = 1;
 
-	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
 		goto _fail_;
 
 	/*to tell fw that we are going to use PC test - WILC specific*/
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = INFRASTRUCTURE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/* c_val[0] = RATE_AUTO; */
 	c_val[0] = RATE_AUTO;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_MIXED_11B_2_MODE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11G_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11G_OPERATING_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_SHORT_PREAMBLE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_PREAMBLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_PREAMBLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = AUTO_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = ACTIVE_SCAN;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SCAN_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_SCAN_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = SITE_SURVEY_OFF;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SITE_SURVEY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_SITE_SURVEY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 0xffff; /* Never use RTS-CTS */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 2346;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	/*  SSID                                                                 */
@@ -764,23 +759,23 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*                      to enable Broadcast SSID suppport )              */
 	/*  --------------------------------------------------------------       */
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BCAST_SSID, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_BCAST_SSID, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_QOS_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_QOS_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_POWERSAVE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_ENCRYPT; /* NO_ENCRYPT, 0x79 */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = OPEN_SYSTEM;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_AUTH_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_AUTH_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/*  WEP/802 11I Configuration                                            */
@@ -792,7 +787,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  ------------------------------------------------------------------   */
 
 	strcpy(c_val, "123456790abcdef1234567890");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
 	/*  WEP/802 11I Configuration                                            */
@@ -802,7 +797,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*                  and less than 64 bytes                               */
 	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "12345678");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11I_PSK, c_val, (strlen(c_val)), 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11I_PSK, c_val, (strlen(c_val)), 0, 0))
 		goto _fail_;
 
 	/*  IEEE802.1X Key Configuration                                         */
@@ -812,7 +807,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*                  and less than 65 bytes                               */
 	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "password");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
 	/*   IEEE802.1X Server Address Configuration                             */
@@ -824,31 +819,31 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	c_val[1] = 168;
 	c_val[2] = 1;
 	c_val[3] = 112;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NORMAL_ACK;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_ACK_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_ACK_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 48;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 28;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/*  Beacon Interval                                                      */
@@ -858,11 +853,11 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  -------------------------------------------------------------------- */
 
 	*((int *)c_val) = 100;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
 		goto _fail_;
 
 	c_val[0] = REKEY_DISABLE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_REKEY_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/*  Rekey Time (s) (Used only when the Rekey policy is 2 or 4)           */
@@ -871,7 +866,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  Values to set : 32-bit value                                         */
 	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 84600;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
 		goto _fail_;
 
 	/*  Rekey Packet Count (in 1000s; used when Rekey Policy is 3)           */
@@ -880,59 +875,59 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  Values to set : 32-bit Value                                         */
 	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 500;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_SELF_CTS_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;  /* Enable N */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = HT_MIXED_MODE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_OPERATING_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;   /* TXOP Prot disable in N mode: No RTS-CTS on TX A-MPDUs to save air-time. */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	memcpy(c_val, mac_add, 6);
 
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_MAC_ADDR, c_val, 6, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_MAC_ADDR, c_val, 6, 0, 0))
 		goto _fail_;
 
 	/**
 	 *      AP only
 	 **/
 	c_val[0] = DETECT_PROTECT_REPORT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = RTS_CTS_NONHT_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = MIMO_MODE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 7;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1; /* Enable N with immediate block ack. */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, 1))
+	if (!wilc_wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, 1))
 		goto _fail_;
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d352f24..3687a06 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1748,7 +1748,8 @@ static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
 	return 0;
 }
 
-static int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size, int commit, u32 drvHandler)
+int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
+		      int commit, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	u32 offset;
@@ -2028,7 +2029,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_cfg_set = wilc_wlan_cfg_set;
 	oup->wlan_cfg_get = wilc_wlan_cfg_get;
 	oup->wlan_cfg_get_value = wilc_wlan_cfg_get_val;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index bf0c7c7..be589f0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -311,4 +311,6 @@ int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
 int wilc_wlan_handle_txq(u32 *pu32TxqCount);
 void wilc_handle_isr(void);
 void wilc_wlan_cleanup(void);
+int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
+		      int commit, u32 drvHandler);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 624b99f..8897910 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_cfg_set)(int, u32, u8 *, u32, int, u32);
 	int (*wlan_cfg_get)(int, u32, int, u32);
 	int (*wlan_cfg_get_value)(u32, u8 *, u32);
 	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32,
-- 
1.9.1

