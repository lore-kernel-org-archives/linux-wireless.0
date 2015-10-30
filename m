Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20710 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbbJ3DIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:08:04 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/17] staging: wilc1000: wilc_wlan_cfg_set: add argument struct net_device
Date: Fri, 30 Oct 2015 12:10:29 +0900
Message-ID: <1446174642-28570-4-git-send-email-glen.lee@atmel.com> (sfid-20151030_040809_765047_80315865)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument net_device and use netdev private data member
wilc instead of g_linux_wlan, pass dev to the functions also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  3 +-
 drivers/staging/wilc1000/linux_wlan.c       | 86 ++++++++++++++---------------
 drivers/staging/wilc1000/wilc_wlan.c        |  9 ++-
 drivers/staging/wilc1000/wilc_wlan.h        |  4 +-
 4 files changed, 53 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 530d64a..74fb556 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -616,7 +616,8 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 	} else if (mode == SET_CFG) {
 		for (counter = 0; counter < count; counter++) {
 			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].id);
-			if (!wilc_wlan_cfg_set(!counter,
+			if (!wilc_wlan_cfg_set(dev,
+					       !counter,
 					       wids[counter].id,
 					       wids[counter].val,
 					       wids[counter].size,
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4ed324c..6ffa2a1 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -662,53 +662,53 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 
 	*(int *)c_val = 1;
 
-	if (!wilc_wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
 		goto _fail_;
 
 	/*to tell fw that we are going to use PC test - WILC specific*/
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = INFRASTRUCTURE;
-	if (!wilc_wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/* c_val[0] = RATE_AUTO; */
 	c_val[0] = RATE_AUTO;
-	if (!wilc_wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_MIXED_11B_2_MODE;
-	if (!wilc_wlan_cfg_set(0, WID_11G_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11G_OPERATING_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_SHORT_PREAMBLE;
-	if (!wilc_wlan_cfg_set(0, WID_PREAMBLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_PREAMBLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = AUTO_PROT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = ACTIVE_SCAN;
-	if (!wilc_wlan_cfg_set(0, WID_SCAN_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_SCAN_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = SITE_SURVEY_OFF;
-	if (!wilc_wlan_cfg_set(0, WID_SITE_SURVEY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 0xffff; /* Never use RTS-CTS */
-	if (!wilc_wlan_cfg_set(0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 2346;
-	if (!wilc_wlan_cfg_set(0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	/*  SSID                                                                 */
@@ -719,23 +719,23 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	/*                      to enable Broadcast SSID suppport )              */
 	/*  --------------------------------------------------------------       */
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_BCAST_SSID, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_BCAST_SSID, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_QOS_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_QOS_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_POWERSAVE;
-	if (!wilc_wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_ENCRYPT; /* NO_ENCRYPT, 0x79 */
-	if (!wilc_wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = OPEN_SYSTEM;
-	if (!wilc_wlan_cfg_set(0, WID_AUTH_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/*  WEP/802 11I Configuration                                            */
@@ -747,7 +747,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	/*  ------------------------------------------------------------------   */
 
 	strcpy(c_val, "123456790abcdef1234567890");
-	if (!wilc_wlan_cfg_set(0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
 	/*  WEP/802 11I Configuration                                            */
@@ -757,7 +757,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	/*                  and less than 64 bytes                               */
 	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "12345678");
-	if (!wilc_wlan_cfg_set(0, WID_11I_PSK, c_val, (strlen(c_val)), 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11I_PSK, c_val, (strlen(c_val)), 0, 0))
 		goto _fail_;
 
 	/*  IEEE802.1X Key Configuration                                         */
@@ -767,7 +767,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	/*                  and less than 65 bytes                               */
 	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "password");
-	if (!wilc_wlan_cfg_set(0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
 	/*   IEEE802.1X Server Address Configuration                             */
@@ -779,31 +779,31 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	c_val[1] = 168;
 	c_val[2] = 1;
 	c_val[3] = 112;
-	if (!wilc_wlan_cfg_set(0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!wilc_wlan_cfg_set(0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!wilc_wlan_cfg_set(0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NORMAL_ACK;
-	if (!wilc_wlan_cfg_set(0, WID_ACK_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_ACK_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 48;
-	if (!wilc_wlan_cfg_set(0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 28;
-	if (!wilc_wlan_cfg_set(0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/*  Beacon Interval                                                      */
@@ -813,11 +813,11 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	/*  -------------------------------------------------------------------- */
 
 	*((int *)c_val) = 100;
-	if (!wilc_wlan_cfg_set(0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
 		goto _fail_;
 
 	c_val[0] = REKEY_DISABLE;
-	if (!wilc_wlan_cfg_set(0, WID_REKEY_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	/*  Rekey Time (s) (Used only when the Rekey policy is 2 or 4)           */
@@ -826,7 +826,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	/*  Values to set : 32-bit value                                         */
 	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 84600;
-	if (!wilc_wlan_cfg_set(0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
 		goto _fail_;
 
 	/*  Rekey Packet Count (in 1000s; used when Rekey Policy is 3)           */
@@ -835,59 +835,59 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	/*  Values to set : 32-bit Value                                         */
 	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 500;
-	if (!wilc_wlan_cfg_set(0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_SELF_CTS_PROT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;  /* Enable N */
-	if (!wilc_wlan_cfg_set(0, WID_11N_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = HT_MIXED_MODE;
-	if (!wilc_wlan_cfg_set(0, WID_11N_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_OPERATING_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;   /* TXOP Prot disable in N mode: No RTS-CTS on TX A-MPDUs to save air-time. */
-	if (!wilc_wlan_cfg_set(0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	memcpy(c_val, mac_add, 6);
 
-	if (!wilc_wlan_cfg_set(0, WID_MAC_ADDR, c_val, 6, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_MAC_ADDR, c_val, 6, 0, 0))
 		goto _fail_;
 
 	/**
 	 *      AP only
 	 **/
 	c_val[0] = DETECT_PROTECT_REPORT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = RTS_CTS_NONHT_PROT;
-	if (!wilc_wlan_cfg_set(0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = MIMO_MODE;
-	if (!wilc_wlan_cfg_set(0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 7;
-	if (!wilc_wlan_cfg_set(0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1; /* Enable N with immediate block ack. */
-	if (!wilc_wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, 1))
+	if (!wilc_wlan_cfg_set(dev, 0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, 1))
 		goto _fail_;
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 768fd30..a72fa8c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1768,13 +1768,16 @@ static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
 	return 0;
 }
 
-int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-		      int commit, u32 drvHandler)
+int wilc_wlan_cfg_set(struct net_device *dev, int start, u32 wid, u8 *buffer,
+		      u32 buffer_size, int commit, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
 	int ret_size;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
 
+	wilc = nic->wilc;
 
 	if (p->cfg_frame_in_use)
 		return 0;
@@ -1796,7 +1799,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
 			ret_size = 0;
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wilc->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2879a93..519f352 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -303,8 +303,8 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount);
 void wilc_handle_isr(void *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
-int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-		      int commit, u32 drvHandler);
+int wilc_wlan_cfg_set(struct net_device *dev, int start, u32 wid, u8 *buffer,
+		      u32 buffer_size, int commit, u32 drvHandler);
 int wilc_wlan_cfg_get(struct net_device *dev, int start, u32 wid, int commit,
 		      u32 drvHandler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
-- 
1.9.1

