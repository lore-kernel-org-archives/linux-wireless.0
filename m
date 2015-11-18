Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20793 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbKRGJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:39 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/16] staging: wilc1000: wilc_wlan_cfg_set: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:34 +0900
Message-ID: <1447827097-9436-14-git-send-email-glen.lee@atmel.com> (sfid-20151118_071410_417244_B857D24A)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch pass struct wilc to the function and use it instead of global
variable wilc_dev.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   2 +-
 drivers/staging/wilc1000/linux_wlan.c       | 101 ++++++++++++++++------------
 drivers/staging/wilc1000/wilc_wlan.c        |   5 +-
 drivers/staging/wilc1000/wilc_wlan.h        |   4 +-
 4 files changed, 63 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index dc290d1..6278aec 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -616,7 +616,7 @@ s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 	} else if (mode == SET_CFG) {
 		for (counter = 0; counter < count; counter++) {
 			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].id);
-			if (!wilc_wlan_cfg_set(!counter,
+			if (!wilc_wlan_cfg_set(wilc, !counter,
 					       wids[counter].id,
 					       wids[counter].val,
 					       wids[counter].size,
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 43458e6..792cc0b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -537,179 +537,194 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 
 	*(int *)c_val = 1;
 
-	if (!wilc_wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = INFRASTRUCTURE;
-	if (!wilc_wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = RATE_AUTO;
-	if (!wilc_wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_MIXED_11B_2_MODE;
-	if (!wilc_wlan_cfg_set(0, WID_11G_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11G_OPERATING_MODE, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_SHORT_PREAMBLE;
-	if (!wilc_wlan_cfg_set(0, WID_PREAMBLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_PREAMBLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = AUTO_PROT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = ACTIVE_SCAN;
-	if (!wilc_wlan_cfg_set(0, WID_SCAN_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_SCAN_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = SITE_SURVEY_OFF;
-	if (!wilc_wlan_cfg_set(0, WID_SITE_SURVEY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 0xffff;
-	if (!wilc_wlan_cfg_set(0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 2346;
-	if (!wilc_wlan_cfg_set(0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_BCAST_SSID, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_BCAST_SSID, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_QOS_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_QOS_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_POWERSAVE;
-	if (!wilc_wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_SECURITY; /* NO_ENCRYPT, 0x79 */
-	if (!wilc_wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = OPEN_SYSTEM;
-	if (!wilc_wlan_cfg_set(0, WID_AUTH_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	strcpy(c_val, "123456790abcdef1234567890");
-	if (!wilc_wlan_cfg_set(0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_WEP_KEY_VALUE, c_val,
+			       (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
 	strcpy(c_val, "12345678");
-	if (!wilc_wlan_cfg_set(0, WID_11I_PSK, c_val, (strlen(c_val)), 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11I_PSK, c_val, (strlen(c_val)), 0,
+			       0))
 		goto _fail_;
 
 	strcpy(c_val, "password");
-	if (!wilc_wlan_cfg_set(0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_1X_KEY, c_val, (strlen(c_val) + 1),
+			       0, 0))
 		goto _fail_;
 
 	c_val[0] = 192;
 	c_val[1] = 168;
 	c_val[2] = 1;
 	c_val[3] = 112;
-	if (!wilc_wlan_cfg_set(0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!wilc_wlan_cfg_set(0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!wilc_wlan_cfg_set(0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NORMAL_ACK;
-	if (!wilc_wlan_cfg_set(0, WID_ACK_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_ACK_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1,
+			       0, 0))
 		goto _fail_;
 
 	c_val[0] = 48;
-	if (!wilc_wlan_cfg_set(0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	c_val[0] = 28;
-	if (!wilc_wlan_cfg_set(0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	*((int *)c_val) = 100;
-	if (!wilc_wlan_cfg_set(0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
 		goto _fail_;
 
 	c_val[0] = REKEY_DISABLE;
-	if (!wilc_wlan_cfg_set(0, WID_REKEY_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 84600;
-	if (!wilc_wlan_cfg_set(0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 500;
-	if (!wilc_wlan_cfg_set(0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_REKEY_PACKET_COUNT, c_val, 4, 0,
+			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	c_val[0] = G_SELF_CTS_PROT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_11N_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = HT_MIXED_MODE;
-	if (!wilc_wlan_cfg_set(0, WID_11N_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_OPERATING_MODE, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	memcpy(c_val, mac_add, 6);
 
-	if (!wilc_wlan_cfg_set(0, WID_MAC_ADDR, c_val, 6, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_MAC_ADDR, c_val, 6, 0, 0))
 		goto _fail_;
 
 	c_val[0] = DETECT_PROTECT_REPORT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1,
+			       0, 0))
 		goto _fail_;
 
 	c_val[0] = RTS_CTS_NONHT_PROT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	c_val[0] = MIMO_MODE;
-	if (!wilc_wlan_cfg_set(0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 7;
-	if (!wilc_wlan_cfg_set(0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0,
+			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, 1))
+	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1,
+			       1, 1))
 		goto _fail_;
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9ac6ad7..03c707b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1499,11 +1499,10 @@ static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
 	return 0;
 }
 
-int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-		      int commit, u32 drv_handler)
+int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
+		      u32 buffer_size, int commit, u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
-	struct wilc *wilc = wilc_dev;
 	u32 offset;
 	int ret_size;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index c3f13aa..e1a8c73 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -289,8 +289,8 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
 void wilc_handle_isr(struct wilc *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
-int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-		      int commit, u32 drv_handler);
+int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
+		      u32 buffer_size, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
-- 
1.9.1

