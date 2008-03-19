Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19626 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575AbYCSTxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: remove lots of unused stuff
Date: Wed, 19 Mar 2008 14:25:58 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803191425.58199.hs4233@mail.mn-solutions.de> (sfid-20080319_195435_962388_261F864D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes many unused function parameters as well as some not-implemented
functions, e.g. CMD_802_11_GET_STATS. The silly lbs_set_cmd_ctrl_node()
function is now also gone.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/decl.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-03-19 12:50:56.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-03-19 12:51:00.000000000 +0100
@@ -63,7 +63,6 @@ void lbs_send_iwevcustom_event(struct lb
 
 /* main.c */
 struct chan_freq_power *lbs_get_region_cfp_table(u8 region,
-	u8 band,
 	int *cfp_no);
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
 int lbs_remove_card(struct lbs_private *priv);
Index: wireless-testing/drivers/net/wireless/libertas/join.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/join.h	2008-03-19 12:59:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/join.h	2008-03-19 13:00:21.000000000 +0100
@@ -18,8 +18,7 @@ int lbs_cmd_80211_authenticate(struct lb
 int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
 				       struct cmd_ds_command *cmd,
 				       void *pdata_buf);
-int lbs_cmd_80211_ad_hoc_stop(struct lbs_private *priv,
-				       struct cmd_ds_command *cmd);
+int lbs_cmd_80211_ad_hoc_stop(struct cmd_ds_command *cmd);
 int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					void *pdata_buf);
@@ -31,10 +30,8 @@ int lbs_cmd_80211_associate(struct lbs_p
 
 int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 					struct cmd_ds_command *resp);
-int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv,
-				       struct cmd_ds_command *resp);
-int lbs_ret_80211_disassociate(struct lbs_private *priv,
-					struct cmd_ds_command *resp);
+int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv);
+int lbs_ret_80211_disassociate(struct lbs_private *priv);
 int lbs_ret_80211_associate(struct lbs_private *priv,
 				     struct cmd_ds_command *resp);
 
Index: wireless-testing/drivers/net/wireless/libertas/11d.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/11d.h	2008-03-19 13:12:04.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/11d.h	2008-03-19 13:12:35.000000000 +0100
@@ -83,7 +83,7 @@ struct lbs_private;
 u8 lbs_get_scan_type_11d(u8 chan,
 			  struct parsed_region_chan_11d *parsed_region_chan);
 
-u32 lbs_chan_2_freq(u8 chan, u8 band);
+u32 lbs_chan_2_freq(u8 chan);
 
 void lbs_init_11d(struct lbs_private *priv);
 
@@ -93,8 +93,7 @@ int lbs_cmd_802_11d_domain_info(struct l
 				 struct cmd_ds_command *cmd, u16 cmdno,
 				 u16 cmdOption);
 
-int lbs_ret_802_11d_domain_info(struct lbs_private *priv,
-				 struct cmd_ds_command *resp);
+int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp);
 
 struct bss_descriptor;
 int lbs_parse_dnld_countryinfo_11d(struct lbs_private *priv,
Index: wireless-testing/drivers/net/wireless/libertas/11d.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/11d.c	2008-03-19 12:51:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/11d.c	2008-03-19 13:11:48.000000000 +0100
@@ -79,7 +79,7 @@ static u8 *lbs_code_2_region(u8 code)
  *  @param nrchan   number of channels
  *  @return 	      the nrchan-th chan number
 */
-static u8 lbs_get_chan_11d(u8 band, u8 firstchan, u8 nrchan, u8 *chan)
+static u8 lbs_get_chan_11d(u8 firstchan, u8 nrchan, u8 *chan)
 /*find the nrchan-th chan after the firstchan*/
 {
 	u8 i;
@@ -134,7 +134,7 @@ static u8 lbs_channel_known_11d(u8 chan,
 	return 0;
 }
 
-u32 lbs_chan_2_freq(u8 chan, u8 band)
+u32 lbs_chan_2_freq(u8 chan)
 {
 	struct chan_freq_power *cf;
 	u16 i;
@@ -264,7 +264,7 @@ static void lbs_generate_parsed_region_c
  *  @param chan                 chan
  *  @return 	                TRUE;FALSE
 */
-static u8 lbs_region_chan_supported_11d(u8 region, u8 band, u8 chan)
+static u8 lbs_region_chan_supported_11d(u8 region, u8 chan)
 {
 	struct chan_freq_power *cfp;
 	int cfp_no;
@@ -273,7 +273,7 @@ static u8 lbs_region_chan_supported_11d(
 
 	lbs_deb_enter(LBS_DEB_11D);
 
-	cfp = lbs_get_region_cfp_table(region, band, &cfp_no);
+	cfp = lbs_get_region_cfp_table(region, &cfp_no);
 	if (cfp == NULL)
 		return 0;
 
@@ -367,7 +367,7 @@ static int parse_domain_info_11d(struct 
 		for (i = 0; idx < MAX_NO_OF_CHAN && i < nrchan; i++) {
 			/*step4: channel is supported? */
 
-			if (!lbs_get_chan_11d(band, firstchan, i, &curchan)) {
+			if (!lbs_get_chan_11d(firstchan, i, &curchan)) {
 				/* Chan is not found in UN table */
 				lbs_deb_11d("chan is not supported: %d \n", i);
 				break;
@@ -375,8 +375,7 @@ static int parse_domain_info_11d(struct 
 
 			lastchan = curchan;
 
-			if (lbs_region_chan_supported_11d
-			    (region, band, curchan)) {
+			if (lbs_region_chan_supported_11d(region, curchan)) {
 				/*step5: Check if curchan is supported by mrvl in region */
 				parsed_region_chan->chanpwr[idx].chan = curchan;
 				parsed_region_chan->chanpwr[idx].pwr =
@@ -554,8 +553,7 @@ done:
  *  @param resp    pointer to command response buffer
  *  @return 	   0; -1
  */
-int lbs_ret_802_11d_domain_info(struct lbs_private *priv,
-				 struct cmd_ds_command *resp)
+int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11d_domain_info *domaininfo = &resp->params.domaininforesp;
 	struct mrvlietypes_domainparamset *domain = &domaininfo->domain;
Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-19 12:56:38.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-19 13:08:51.000000000 +0100
@@ -14,9 +14,6 @@
 #include "cmd.h"
 
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
-static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
-		    struct cmd_ctrl_node *ptempnode,
-		    void *pdata_buf);
 
 
 /**
@@ -183,8 +180,7 @@ int lbs_host_sleep_cfg(struct lbs_privat
 }
 EXPORT_SYMBOL_GPL(lbs_host_sleep_cfg);
 
-static int lbs_cmd_802_11_ps_mode(struct lbs_private *priv,
-				   struct cmd_ds_command *cmd,
+static int lbs_cmd_802_11_ps_mode(struct cmd_ds_command *cmd,
 				   u16 cmd_action)
 {
 	struct cmd_ds_802_11_ps_mode *psm = &cmd->params.psmode;
@@ -479,8 +475,7 @@ int lbs_cmd_802_11_key_material(struct l
 	return ret;
 }
 
-static int lbs_cmd_802_11_reset(struct lbs_private *priv,
-				 struct cmd_ds_command *cmd, int cmd_action)
+static int lbs_cmd_802_11_reset(struct cmd_ds_command *cmd, int cmd_action)
 {
 	struct cmd_ds_802_11_reset *reset = &cmd->params.reset;
 
@@ -494,18 +489,6 @@ static int lbs_cmd_802_11_reset(struct l
 	return 0;
 }
 
-static int lbs_cmd_802_11_get_stat(struct lbs_private *priv,
-				    struct cmd_ds_command *cmd)
-{
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_GET_STAT);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_get_stat) + S_DS_GEN);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				    struct cmd_ds_command *cmd,
 				    int cmd_action,
@@ -626,8 +609,7 @@ static int lbs_cmd_802_11_snmp_mib(struc
 	return 0;
 }
 
-static int lbs_cmd_802_11_rf_tx_power(struct lbs_private *priv,
-				       struct cmd_ds_command *cmd,
+static int lbs_cmd_802_11_rf_tx_power(struct cmd_ds_command *cmd,
 				       u16 cmd_action, void *pdata_buf)
 {
 
@@ -670,8 +652,7 @@ static int lbs_cmd_802_11_rf_tx_power(st
 	return 0;
 }
 
-static int lbs_cmd_802_11_monitor_mode(struct lbs_private *priv,
-				      struct cmd_ds_command *cmd,
+static int lbs_cmd_802_11_monitor_mode(struct cmd_ds_command *cmd,
 				      u16 cmd_action, void *pdata_buf)
 {
 	struct cmd_ds_802_11_monitor_mode *monitor = &cmd->params.monitor;
@@ -915,8 +896,7 @@ out:
 	return ret;
 }
 
-static int lbs_cmd_reg_access(struct lbs_private *priv,
-			       struct cmd_ds_command *cmdptr,
+static int lbs_cmd_reg_access(struct cmd_ds_command *cmdptr,
 			       u8 cmd_action, void *pdata_buf)
 {
 	struct lbs_offset_value *offval;
@@ -1013,9 +993,8 @@ static int lbs_cmd_802_11_mac_address(st
 	return 0;
 }
 
-static int lbs_cmd_802_11_eeprom_access(struct lbs_private *priv,
-					 struct cmd_ds_command *cmd,
-					 int cmd_action, void *pdata_buf)
+static int lbs_cmd_802_11_eeprom_access(struct cmd_ds_command *cmd,
+					void *pdata_buf)
 {
 	struct lbs_ioctl_regrdwr *ea = pdata_buf;
 
@@ -1035,8 +1014,7 @@ static int lbs_cmd_802_11_eeprom_access(
 	return 0;
 }
 
-static int lbs_cmd_bt_access(struct lbs_private *priv,
-			       struct cmd_ds_command *cmd,
+static int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
 			       u16 cmd_action, void *pdata_buf)
 {
 	struct cmd_ds_bt_access *bt_access = &cmd->params.bt;
@@ -1073,8 +1051,7 @@ static int lbs_cmd_bt_access(struct lbs_
 	return 0;
 }
 
-static int lbs_cmd_fwt_access(struct lbs_private *priv,
-			       struct cmd_ds_command *cmd,
+static int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
 			       u16 cmd_action, void *pdata_buf)
 {
 	struct cmd_ds_fwt_access *fwt_access = &cmd->params.fwt;
@@ -1393,7 +1370,8 @@ int lbs_prepare_and_send_command(struct 
 		goto done;
 	}
 
-	lbs_set_cmd_ctrl_node(priv, cmdnode, pdata_buf);
+	cmdnode->callback = NULL;
+	cmdnode->callback_arg = (unsigned long)pdata_buf;
 
 	cmdptr = (struct cmd_ds_command *)cmdnode->cmdbuf;
 
@@ -1408,7 +1386,7 @@ int lbs_prepare_and_send_command(struct 
 
 	switch (cmd_no) {
 	case CMD_802_11_PS_MODE:
-		ret = lbs_cmd_802_11_ps_mode(priv, cmdptr, cmd_action);
+		ret = lbs_cmd_802_11_ps_mode(cmdptr, cmd_action);
 		break;
 
 	case CMD_802_11_ASSOCIATE:
@@ -1425,17 +1403,13 @@ int lbs_prepare_and_send_command(struct 
 		break;
 
 	case CMD_802_11_RESET:
-		ret = lbs_cmd_802_11_reset(priv, cmdptr, cmd_action);
+		ret = lbs_cmd_802_11_reset(cmdptr, cmd_action);
 		break;
 
 	case CMD_802_11_AUTHENTICATE:
 		ret = lbs_cmd_80211_authenticate(priv, cmdptr, pdata_buf);
 		break;
 
-	case CMD_802_11_GET_STAT:
-		ret = lbs_cmd_802_11_get_stat(priv, cmdptr);
-		break;
-
 	case CMD_802_11_SNMP_MIB:
 		ret = lbs_cmd_802_11_snmp_mib(priv, cmdptr,
 					       cmd_action, cmd_oid, pdata_buf);
@@ -1444,12 +1418,12 @@ int lbs_prepare_and_send_command(struct 
 	case CMD_MAC_REG_ACCESS:
 	case CMD_BBP_REG_ACCESS:
 	case CMD_RF_REG_ACCESS:
-		ret = lbs_cmd_reg_access(priv, cmdptr, cmd_action, pdata_buf);
+		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
 	case CMD_802_11_RF_TX_POWER:
-		ret = lbs_cmd_802_11_rf_tx_power(priv, cmdptr,
-						  cmd_action, pdata_buf);
+		ret = lbs_cmd_802_11_rf_tx_power(cmdptr,
+						 cmd_action, pdata_buf);
 		break;
 
 	case CMD_802_11_RATE_ADAPT_RATESET:
@@ -1462,7 +1436,7 @@ int lbs_prepare_and_send_command(struct 
 		break;
 
 	case CMD_802_11_MONITOR_MODE:
-		ret = lbs_cmd_802_11_monitor_mode(priv, cmdptr,
+		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
 				          cmd_action, pdata_buf);
 		break;
 
@@ -1471,7 +1445,7 @@ int lbs_prepare_and_send_command(struct 
 		break;
 
 	case CMD_802_11_AD_HOC_STOP:
-		ret = lbs_cmd_80211_ad_hoc_stop(priv, cmdptr);
+		ret = lbs_cmd_80211_ad_hoc_stop(cmdptr);
 		break;
 
 	case CMD_802_11_MAC_ADDRESS:
@@ -1479,8 +1453,7 @@ int lbs_prepare_and_send_command(struct 
 		break;
 
 	case CMD_802_11_EEPROM_ACCESS:
-		ret = lbs_cmd_802_11_eeprom_access(priv, cmdptr,
-						    cmd_action, pdata_buf);
+		ret = lbs_cmd_802_11_eeprom_access(cmdptr, pdata_buf);
 		break;
 
 	case CMD_802_11_SET_AFC:
@@ -1547,11 +1520,11 @@ int lbs_prepare_and_send_command(struct 
 		ret = 0;
 		break;
 	case CMD_BT_ACCESS:
-		ret = lbs_cmd_bt_access(priv, cmdptr, cmd_action, pdata_buf);
+		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
 	case CMD_FWT_ACCESS:
-		ret = lbs_cmd_fwt_access(priv, cmdptr, cmd_action, pdata_buf);
+		ret = lbs_cmd_fwt_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
 	case CMD_GET_TSF:
@@ -1724,36 +1697,6 @@ static struct cmd_ctrl_node *lbs_get_cmd
 }
 
 /**
- *  @brief This function cleans command node.
- *
- *  @param ptempnode	A pointer to cmdCtrlNode structure
- *  @return 		n/a
- */
-
-/**
- *  @brief This function initializes the command node.
- *
- *  @param priv		A pointer to struct lbs_private structure
- *  @param ptempnode	A pointer to cmd_ctrl_node structure
- *  @param pdata_buf	A pointer to informaion buffer
- *  @return 		0 or -1
- */
-static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
-				  struct cmd_ctrl_node *ptempnode,
-				  void *pdata_buf)
-{
-	lbs_deb_enter(LBS_DEB_HOST);
-
-	if (!ptempnode)
-		return;
-
-	ptempnode->callback = NULL;
-	ptempnode->callback_arg = (unsigned long)pdata_buf;
-
-	lbs_deb_leave(LBS_DEB_HOST);
-}
-
-/**
  *  @brief This function executes next command in command
  *  pending queue. It will put fimware back to PS mode
  *  if applicable.
Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 12:58:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 13:12:43.000000000 +0100
@@ -137,22 +137,6 @@ static int lbs_ret_reg_access(struct lbs
 	return ret;
 }
 
-static int lbs_ret_802_11_stat(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
-{
-	lbs_deb_enter(LBS_DEB_CMD);
-/*	currently priv->wlan802_11Stat is unused
-
-	struct cmd_ds_802_11_get_stat *p11Stat = &resp->params.gstat;
-
-	// TODO Convert it to Big endian befor copy
-	memcpy(&priv->wlan802_11Stat,
-	       p11Stat, sizeof(struct cmd_ds_802_11_get_stat));
-*/
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_snmp_mib(struct lbs_private *priv,
 				    struct cmd_ds_command *resp)
 {
@@ -282,7 +266,6 @@ static int lbs_ret_802_11_bcn_ctrl(struc
 }
 
 static inline int handle_cmd_response(struct lbs_private *priv,
-				      unsigned long dummy,
 				      struct cmd_header *cmd_response)
 {
 	struct cmd_ds_command *resp = (struct cmd_ds_command *) cmd_response;
@@ -307,7 +290,7 @@ static inline int handle_cmd_response(st
 
 	case CMD_RET(CMD_802_11_DISASSOCIATE):
 	case CMD_RET(CMD_802_11_DEAUTHENTICATE):
-		ret = lbs_ret_80211_disassociate(priv, resp);
+		ret = lbs_ret_80211_disassociate(priv);
 		break;
 
 	case CMD_RET(CMD_802_11_AD_HOC_START):
@@ -315,10 +298,6 @@ static inline int handle_cmd_response(st
 		ret = lbs_ret_80211_ad_hoc_start(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_GET_STAT):
-		ret = lbs_ret_802_11_stat(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_SNMP_MIB):
 		ret = lbs_ret_802_11_snmp_mib(priv, resp);
 		break;
@@ -351,7 +330,7 @@ static inline int handle_cmd_response(st
 		break;
 
 	case CMD_RET(CMD_802_11_AD_HOC_STOP):
-		ret = lbs_ret_80211_ad_hoc_stop(priv, resp);
+		ret = lbs_ret_80211_ad_hoc_stop(priv);
 		break;
 
 	case CMD_RET(CMD_802_11_EEPROM_ACCESS):
@@ -359,7 +338,7 @@ static inline int handle_cmd_response(st
 		break;
 
 	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
-		ret = lbs_ret_802_11d_domain_info(priv, resp);
+		ret = lbs_ret_802_11d_domain_info(resp);
 		break;
 
 	case CMD_RET(CMD_802_11_TPC_CFG):
@@ -562,7 +541,7 @@ int lbs_process_rx_command(struct lbs_pr
 		ret = priv->cur_cmd->callback(priv, priv->cur_cmd->callback_arg,
 				resp);
 	} else
-		ret = handle_cmd_response(priv, 0, resp);
+		ret = handle_cmd_response(priv, resp);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
Index: wireless-testing/drivers/net/wireless/libertas/join.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/join.c	2008-03-19 12:58:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/join.c	2008-03-19 13:00:14.000000000 +0100
@@ -561,8 +561,7 @@ done:
 	return ret;
 }
 
-int lbs_cmd_80211_ad_hoc_stop(struct lbs_private *priv,
-				struct cmd_ds_command *cmd)
+int lbs_cmd_80211_ad_hoc_stop(struct cmd_ds_command *cmd)
 {
 	cmd->command = cpu_to_le16(CMD_802_11_AD_HOC_STOP);
 	cmd->size = cpu_to_le16(S_DS_GEN);
@@ -765,8 +764,7 @@ done:
 	return ret;
 }
 
-int lbs_ret_80211_disassociate(struct lbs_private *priv,
-				 struct cmd_ds_command *resp)
+int lbs_ret_80211_disassociate(struct lbs_private *priv)
 {
 	lbs_deb_enter(LBS_DEB_JOIN);
 
@@ -855,8 +853,7 @@ done:
 	return ret;
 }
 
-int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
+int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv)
 {
 	lbs_deb_enter(LBS_DEB_JOIN);
 
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-19 12:49:16.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-19 12:51:24.000000000 +0100
@@ -1389,7 +1389,7 @@ static void lbs_remove_mesh(struct lbs_p
  *  @param cfp_no  A pointer to CFP number
  *  @return 	   A pointer to CFP
  */
-struct chan_freq_power *lbs_get_region_cfp_table(u8 region, u8 band, int *cfp_no)
+struct chan_freq_power *lbs_get_region_cfp_table(u8 region, int *cfp_no)
 {
 	int i, end;
 
@@ -1423,7 +1423,7 @@ int lbs_set_regiontable(struct lbs_priva
 
 	memset(priv->region_channel, 0, sizeof(priv->region_channel));
 
-	cfp = lbs_get_region_cfp_table(region, band, &cfp_no);
+	cfp = lbs_get_region_cfp_table(region, &cfp_no);
 	if (cfp != NULL) {
 		priv->region_channel[i].nrcfp = cfp_no;
 		priv->region_channel[i].CFP = cfp;
Index: wireless-testing/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/debugfs.c	2008-03-19 13:14:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/debugfs.c	2008-03-19 13:16:28.000000000 +0100
@@ -19,7 +19,7 @@ static char *szStates[] = {
 };
 
 #ifdef PROC_DEBUG
-static void lbs_debug_init(struct lbs_private *priv, struct net_device *dev);
+static void lbs_debug_init(struct lbs_private *priv);
 #endif
 
 static int open_file_generic(struct inode *inode, struct file *file)
@@ -778,7 +778,7 @@ void lbs_debugfs_init_one(struct lbs_pri
 	}
 
 #ifdef PROC_DEBUG
-	lbs_debug_init(priv, dev);
+	lbs_debug_init(priv);
 #endif
 exit:
 	return;
@@ -952,7 +952,7 @@ static struct file_operations lbs_debug_
  *  @param dev     pointer net_device
  *  @return 	   N/A
  */
-static void lbs_debug_init(struct lbs_private *priv, struct net_device *dev)
+static void lbs_debug_init(struct lbs_private *priv)
 {
 	int i;
 
Index: wireless-testing/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-03-19 12:53:57.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-03-19 13:11:57.000000000 +0100
@@ -605,7 +605,7 @@ static int lbs_get_range(struct net_devi
 			lbs_deb_wext("chan_no %d\n", chan_no);
 			range->freq[range->num_frequency].i = (long)chan_no;
 			range->freq[range->num_frequency].m =
-			    (long)lbs_chan_2_freq(chan_no, band) * 100000;
+			    (long)lbs_chan_2_freq(chan_no) * 100000;
 			range->freq[range->num_frequency].e = 1;
 			range->num_frequency++;
 		}
