Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14601 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbXKWOjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 09:39:33 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: remove arbitrary typedefs
Date: Fri, 23 Nov 2007 15:39:48 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711231539.49372.hs4233@mail.mn-solutions.de> (sfid-20071123_143943_708295_D2193F4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[PATCH]: libertas: remove private typedef

New typedefs are usually frowned upon. This patch changes
libertas_adapter -> struct libertas_adapter
libertas_priv -> struct libertas_priv

While passing, make everything checkpatch.pl-clean that gets touches.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- wireless-2.6.orig/drivers/net/wireless/libertas/11d.c
+++ wireless-2.6/drivers/net/wireless/libertas/11d.c
@@ -438,7 +438,7 @@
 
 }
 
-void lbs_init_11d(lbs_private * priv)
+void lbs_init_11d(struct lbs_private *priv)
 {
 	priv->adapter->enable11d = 0;
 	memset(&(priv->adapter->parsed_region_chan), 0,
@@ -448,10 +448,10 @@
 
 /**
  *  @brief This function sets DOMAIN INFO to FW
- *  @param priv       pointer to lbs_private
+ *  @param priv       pointer to struct lbs_private
  *  @return 	      0; -1
 */
-static int set_domain_info_11d(lbs_private * priv)
+static int set_domain_info_11d(struct lbs_private *priv)
 {
 	int ret;
 
@@ -471,13 +471,13 @@
 
 /**
  *  @brief This function setups scan channels
- *  @param priv       pointer to lbs_private
+ *  @param priv       pointer to struct lbs_private
  *  @param band       band
  *  @return 	      0
 */
-int lbs_set_universaltable(lbs_private * priv, u8 band)
+int lbs_set_universaltable(struct lbs_private *priv, u8 band)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u16 size = sizeof(struct chan_freq_power);
 	u16 i = 0;
 
@@ -500,20 +500,20 @@
 
 /**
  *  @brief This function implements command CMD_802_11D_DOMAIN_INFO
- *  @param priv       pointer to lbs_private
+ *  @param priv       pointer to struct lbs_private
  *  @param cmd        pointer to cmd buffer
  *  @param cmdno      cmd ID
  *  @param cmdOption  cmd action
  *  @return 	      0
 */
-int lbs_cmd_802_11d_domain_info(lbs_private * priv,
+int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 				 struct cmd_ds_command *cmd, u16 cmdno,
 				 u16 cmdoption)
 {
 	struct cmd_ds_802_11d_domain_info *pdomaininfo =
 	    &cmd->params.domaininfo;
 	struct mrvlietypes_domainparamset *domain = &pdomaininfo->domain;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u8 nr_subband = adapter->domainreg.nr_subband;
 
 	lbs_deb_enter(LBS_DEB_11D);
@@ -560,11 +560,11 @@
 
 /**
  *  @brief This function parses countryinfo from AP and download country info to FW
- *  @param priv    pointer to lbs_private
+ *  @param priv    pointer to struct lbs_private
  *  @param resp    pointer to command response buffer
  *  @return 	   0; -1
  */
-int lbs_ret_802_11d_domain_info(lbs_private * priv,
+int lbs_ret_802_11d_domain_info(struct lbs_private *priv,
 				 struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11d_domain_info *domaininfo = &resp->params.domaininforesp;
@@ -606,14 +606,14 @@
 
 /**
  *  @brief This function parses countryinfo from AP and download country info to FW
- *  @param priv    pointer to lbs_private
+ *  @param priv    pointer to struct lbs_private
  *  @return 	   0; -1
  */
-int lbs_parse_dnld_countryinfo_11d(lbs_private * priv,
+int lbs_parse_dnld_countryinfo_11d(struct lbs_private *priv,
                                         struct bss_descriptor * bss)
 {
 	int ret;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_11D);
 	if (priv->adapter->enable11d) {
@@ -648,13 +648,13 @@
 
 /**
  *  @brief This function generates 11D info from user specified regioncode and download to FW
- *  @param priv    pointer to lbs_private
+ *  @param priv    pointer to struct lbs_private
  *  @return 	   0; -1
  */
-int lbs_create_dnld_countryinfo_11d(lbs_private * priv)
+int lbs_create_dnld_countryinfo_11d(struct lbs_private *priv)
 {
 	int ret;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct region_channel *region_chan;
 	u8 j;
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/11d.h
+++ wireless-2.6/drivers/net/wireless/libertas/11d.h
@@ -78,26 +78,28 @@
 	u8 code;
 };
 
+struct lbs_private;
+
 u8 lbs_get_scan_type_11d(u8 chan,
 			  struct parsed_region_chan_11d *parsed_region_chan);
 
 u32 lbs_chan_2_freq(u8 chan, u8 band);
 
-void lbs_init_11d(lbs_private * priv);
+void lbs_init_11d(struct lbs_private *priv);
 
-int lbs_set_universaltable(lbs_private * priv, u8 band);
+int lbs_set_universaltable(struct lbs_private *priv, u8 band);
 
-int lbs_cmd_802_11d_domain_info(lbs_private * priv,
+int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 				 struct cmd_ds_command *cmd, u16 cmdno,
 				 u16 cmdOption);
 
-int lbs_ret_802_11d_domain_info(lbs_private * priv,
+int lbs_ret_802_11d_domain_info(struct lbs_private *priv,
 				 struct cmd_ds_command *resp);
 
 struct bss_descriptor;
-int lbs_parse_dnld_countryinfo_11d(lbs_private * priv,
+int lbs_parse_dnld_countryinfo_11d(struct lbs_private *priv,
                                         struct bss_descriptor * bss);
 
-int lbs_create_dnld_countryinfo_11d(lbs_private * priv);
+int lbs_create_dnld_countryinfo_11d(struct lbs_private *priv);
 
 #endif
--- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.c
+++ wireless-2.6/drivers/net/wireless/libertas/assoc.c
@@ -14,10 +14,10 @@
 static const u8 bssid_any[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 static const u8 bssid_off[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
-static int assoc_helper_essid(lbs_private *priv,
+static int assoc_helper_essid(struct lbs_private *priv,
                               struct assoc_request * assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct bss_descriptor * bss;
 	int channel = -1;
@@ -74,10 +74,10 @@
 }
 
 
-static int assoc_helper_bssid(lbs_private *priv,
+static int assoc_helper_bssid(struct lbs_private *priv,
                               struct assoc_request * assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct bss_descriptor * bss;
 	DECLARE_MAC_BUF(mac);
@@ -108,7 +108,7 @@
 }
 
 
-static int assoc_helper_associate(lbs_private *priv,
+static int assoc_helper_associate(struct lbs_private *priv,
                                   struct assoc_request * assoc_req)
 {
 	int ret = 0, done = 0;
@@ -134,10 +134,10 @@
 }
 
 
-static int assoc_helper_mode(lbs_private *priv,
+static int assoc_helper_mode(struct lbs_private *priv,
                              struct assoc_request * assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
@@ -164,7 +164,7 @@
 }
 
 
-static int update_channel(lbs_private * priv)
+static int update_channel(struct lbs_private *priv)
 {
 	int ret;
 	/* the channel in f/w could be out of sync, get the current channel */
@@ -178,7 +178,8 @@
 
 void lbs_sync_channel(struct work_struct *work)
 {
-	lbs_private *priv = container_of(work, lbs_private, sync_channel);
+	struct lbs_private *priv = container_of(work, struct lbs_private,
+		sync_channel);
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 	if (update_channel(priv) != 0)
@@ -186,10 +187,10 @@
 	lbs_deb_leave(LBS_DEB_ASSOC);
 }
 
-static int assoc_helper_channel(lbs_private *priv,
+static int assoc_helper_channel(struct lbs_private *priv,
                                 struct assoc_request * assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
@@ -241,10 +242,10 @@
 }
 
 
-static int assoc_helper_wep_keys(lbs_private *priv,
+static int assoc_helper_wep_keys(struct lbs_private *priv,
                                  struct assoc_request * assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int i;
 	int ret = 0;
 
@@ -296,10 +297,10 @@
 	return ret;
 }
 
-static int assoc_helper_secinfo(lbs_private *priv,
+static int assoc_helper_secinfo(struct lbs_private *priv,
                                 struct assoc_request * assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u32 do_wpa;
 	u32 rsn = 0;
@@ -348,7 +349,7 @@
 }
 
 
-static int assoc_helper_wpa_keys(lbs_private *priv,
+static int assoc_helper_wpa_keys(struct lbs_private *priv,
                                  struct assoc_request * assoc_req)
 {
 	int ret = 0;
@@ -391,10 +392,10 @@
 }
 
 
-static int assoc_helper_wpa_ie(lbs_private *priv,
+static int assoc_helper_wpa_ie(struct lbs_private *priv,
                                struct assoc_request * assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
@@ -412,7 +413,7 @@
 }
 
 
-static int should_deauth_infrastructure(lbs_adapter *adapter,
+static int should_deauth_infrastructure(struct lbs_adapter *adapter,
                                         struct assoc_request * assoc_req)
 {
 	int ret = 0;
@@ -464,7 +465,7 @@
 }
 
 
-static int should_stop_adhoc(lbs_adapter *adapter,
+static int should_stop_adhoc(struct lbs_adapter *adapter,
                              struct assoc_request * assoc_req)
 {
 	lbs_deb_enter(LBS_DEB_ASSOC);
@@ -495,8 +496,9 @@
 
 void lbs_association_worker(struct work_struct *work)
 {
-	lbs_private *priv = container_of(work, lbs_private, assoc_work.work);
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = container_of(work, struct lbs_private,
+		assoc_work.work);
+	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req = NULL;
 	int ret = 0;
 	int find_any_ssid = 0;
@@ -683,7 +685,7 @@
 /*
  * Caller MUST hold any necessary locks
  */
-struct assoc_request *lbs_get_association_request(lbs_adapter *adapter)
+struct assoc_request *lbs_get_association_request(struct lbs_adapter *adapter)
 {
 	struct assoc_request * assoc_req;
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.h
+++ wireless-2.6/drivers/net/wireless/libertas/assoc.h
@@ -6,7 +6,7 @@
 #include "dev.h"
 
 void lbs_association_worker(struct work_struct *work);
-struct assoc_request *lbs_get_association_request(lbs_adapter *adapter);
+struct assoc_request *lbs_get_association_request(struct lbs_adapter *adapter);
 void lbs_sync_channel(struct work_struct *work);
 
 #endif
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c
+++ wireless-2.6/drivers/net/wireless/libertas/cmd.c
@@ -37,7 +37,7 @@
 	return 0;
 }
 
-static int lbs_cmd_hw_spec(lbs_private * priv, struct cmd_ds_command *cmd)
+static int lbs_cmd_hw_spec(struct lbs_private *priv, struct cmd_ds_command *cmd)
 {
 	struct cmd_ds_get_hw_spec *hwspec = &cmd->params.hwspec;
 
@@ -51,7 +51,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_ps_mode(lbs_private * priv,
+static int lbs_cmd_802_11_ps_mode(struct lbs_private *priv,
 				   struct cmd_ds_command *cmd,
 				   u16 cmd_action)
 {
@@ -90,7 +90,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_inactivity_timeout(lbs_private * priv,
+static int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
 					      struct cmd_ds_command *cmd,
 					      u16 cmd_action, void *pdata_buf)
 {
@@ -114,11 +114,11 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_sleep_params(lbs_private * priv,
+static int lbs_cmd_802_11_sleep_params(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					u16 cmd_action)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_sleep_params *sp = &cmd->params.sleep_params;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -145,13 +145,13 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_set_wep(lbs_private * priv,
+static int lbs_cmd_802_11_set_wep(struct lbs_private *priv,
                                    struct cmd_ds_command *cmd,
                                    u32 cmd_act,
                                    void * pdata_buf)
 {
 	struct cmd_ds_802_11_set_wep *wep = &cmd->params.wep;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct assoc_request * assoc_req = pdata_buf;
 
@@ -219,7 +219,7 @@
 	return ret;
 }
 
-static int lbs_cmd_802_11_enable_rsn(lbs_private * priv,
+static int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv,
 				      struct cmd_ds_command *cmd,
 				      u16 cmd_action,
 				      void * pdata_buf)
@@ -272,7 +272,7 @@
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
-static int lbs_cmd_802_11_key_material(lbs_private * priv,
+static int lbs_cmd_802_11_key_material(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					u16 cmd_action,
 					u32 cmd_oid, void *pdata_buf)
@@ -319,7 +319,7 @@
 	return ret;
 }
 
-static int lbs_cmd_802_11_reset(lbs_private * priv,
+static int lbs_cmd_802_11_reset(struct lbs_private *priv,
 				 struct cmd_ds_command *cmd, int cmd_action)
 {
 	struct cmd_ds_802_11_reset *reset = &cmd->params.reset;
@@ -334,7 +334,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_get_log(lbs_private * priv,
+static int lbs_cmd_802_11_get_log(struct lbs_private *priv,
 				   struct cmd_ds_command *cmd)
 {
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -346,7 +346,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_get_stat(lbs_private * priv,
+static int lbs_cmd_802_11_get_stat(struct lbs_private *priv,
 				    struct cmd_ds_command *cmd)
 {
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -358,13 +358,13 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_snmp_mib(lbs_private * priv,
+static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				    struct cmd_ds_command *cmd,
 				    int cmd_action,
 				    int cmd_oid, void *pdata_buf)
 {
 	struct cmd_ds_802_11_snmp_mib *pSNMPMIB = &cmd->params.smib;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u8 ucTemp;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -479,11 +479,11 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_radio_control(lbs_private * priv,
+static int lbs_cmd_802_11_radio_control(struct lbs_private *priv,
 					 struct cmd_ds_command *cmd,
 					 int cmd_action)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_radio_control *pradiocontrol = &cmd->params.radio;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -519,7 +519,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_rf_tx_power(lbs_private * priv,
+static int lbs_cmd_802_11_rf_tx_power(struct lbs_private *priv,
 				       struct cmd_ds_command *cmd,
 				       u16 cmd_action, void *pdata_buf)
 {
@@ -563,7 +563,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_monitor_mode(lbs_private * priv,
+static int lbs_cmd_802_11_monitor_mode(struct lbs_private *priv,
 				      struct cmd_ds_command *cmd,
 				      u16 cmd_action, void *pdata_buf)
 {
@@ -583,13 +583,13 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_rate_adapt_rateset(lbs_private * priv,
+static int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
 					      struct cmd_ds_command *cmd,
 					      u16 cmd_action)
 {
 	struct cmd_ds_802_11_rate_adapt_rateset
 	*rateadapt = &cmd->params.rateset;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->size =
@@ -605,12 +605,12 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_data_rate(lbs_private * priv,
+static int lbs_cmd_802_11_data_rate(struct lbs_private *priv,
 				     struct cmd_ds_command *cmd,
 				     u16 cmd_action)
 {
 	struct cmd_ds_802_11_data_rate *pdatarate = &cmd->params.drate;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -632,12 +632,12 @@
 	return 0;
 }
 
-static int lbs_cmd_mac_multicast_adr(lbs_private * priv,
+static int lbs_cmd_mac_multicast_adr(struct lbs_private *priv,
 				      struct cmd_ds_command *cmd,
 				      u16 cmd_action)
 {
 	struct cmd_ds_mac_multicast_adr *pMCastAdr = &cmd->params.madr;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mac_multicast_adr) +
@@ -655,7 +655,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_rf_channel(lbs_private * priv,
+static int lbs_cmd_802_11_rf_channel(struct lbs_private *priv,
 				      struct cmd_ds_command *cmd,
 				      int option, void *pdata_buf)
 {
@@ -676,10 +676,10 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_rssi(lbs_private * priv,
+static int lbs_cmd_802_11_rssi(struct lbs_private *priv,
 				struct cmd_ds_command *cmd)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
@@ -698,7 +698,7 @@
 	return 0;
 }
 
-static int lbs_cmd_reg_access(lbs_private * priv,
+static int lbs_cmd_reg_access(struct lbs_private *priv,
 			       struct cmd_ds_command *cmdptr,
 			       u8 cmd_action, void *pdata_buf)
 {
@@ -773,11 +773,11 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_mac_address(lbs_private * priv,
+static int lbs_cmd_802_11_mac_address(struct lbs_private *priv,
 				       struct cmd_ds_command *cmd,
 				       u16 cmd_action)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->command = cpu_to_le16(CMD_802_11_MAC_ADDRESS);
@@ -797,7 +797,7 @@
 	return 0;
 }
 
-static int lbs_cmd_802_11_eeprom_access(lbs_private * priv,
+static int lbs_cmd_802_11_eeprom_access(struct lbs_private *priv,
 					 struct cmd_ds_command *cmd,
 					 int cmd_action, void *pdata_buf)
 {
@@ -819,7 +819,7 @@
 	return 0;
 }
 
-static int lbs_cmd_bt_access(lbs_private * priv,
+static int lbs_cmd_bt_access(struct lbs_private *priv,
 			       struct cmd_ds_command *cmd,
 			       u16 cmd_action, void *pdata_buf)
 {
@@ -857,7 +857,7 @@
 	return 0;
 }
 
-static int lbs_cmd_fwt_access(lbs_private * priv,
+static int lbs_cmd_fwt_access(struct lbs_private *priv,
 			       struct cmd_ds_command *cmd,
 			       u16 cmd_action, void *pdata_buf)
 {
@@ -879,7 +879,7 @@
 	return 0;
 }
 
-static int lbs_cmd_mesh_access(lbs_private * priv,
+static int lbs_cmd_mesh_access(struct lbs_private *priv,
 				struct cmd_ds_command *cmd,
 				u16 cmd_action, void *pdata_buf)
 {
@@ -901,7 +901,7 @@
 	return 0;
 }
 
-static int lbs_cmd_set_boot2_ver(lbs_private * priv,
+static int lbs_cmd_set_boot2_ver(struct lbs_private *priv,
 				struct cmd_ds_command *cmd,
 				u16 cmd_action, void *pdata_buf)
 {
@@ -916,7 +916,9 @@
  * Note: NEVER use libertas_queue_cmd() with addtail==0 other than for
  * the command timer, because it does not account for queued commands.
  */
-void lbs_queue_cmd(lbs_adapter *adapter, struct cmd_ctrl_node *cmdnode, u8 addtail)
+void lbs_queue_cmd(struct lbs_adapter *adapter,
+	struct cmd_ctrl_node *cmdnode,
+	u8 addtail)
 {
 	unsigned long flags;
 	struct cmd_ds_command *cmdptr;
@@ -969,12 +971,12 @@
  * For now - we are not performing the endian conversion the second time - but
  * for PS and DEEP_SLEEP we need to worry
  */
-static int DownloadcommandToStation(lbs_private * priv,
+static int DownloadcommandToStation(struct lbs_private *priv,
 				    struct cmd_ctrl_node *cmdnode)
 {
 	unsigned long flags;
 	struct cmd_ds_command *cmdptr;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = -1;
 	u16 cmdsize;
 	u16 command;
@@ -1039,7 +1041,7 @@
 	return ret;
 }
 
-static int lbs_cmd_mac_control(lbs_private * priv,
+static int lbs_cmd_mac_control(struct lbs_private *priv,
 				struct cmd_ds_command *cmd)
 {
 	struct cmd_ds_mac_control *mac = &cmd->params.macctrl;
@@ -1061,9 +1063,10 @@
  *  This function inserts command node to cmdfreeq
  *  after cleans it. Requires adapter->driver_lock held.
  */
-void __lbs_cleanup_and_insert_cmd(lbs_private * priv, struct cmd_ctrl_node *ptempcmd)
+void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
+	struct cmd_ctrl_node *ptempcmd)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	if (!ptempcmd)
 		return;
@@ -1072,7 +1075,8 @@
 	list_add_tail((struct list_head *)ptempcmd, &adapter->cmdfreeq);
 }
 
-static void lbs_cleanup_and_insert_cmd(lbs_private * priv, struct cmd_ctrl_node *ptempcmd)
+static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
+	struct cmd_ctrl_node *ptempcmd)
 {
 	unsigned long flags;
 
@@ -1081,7 +1085,7 @@
 	spin_unlock_irqrestore(&priv->adapter->driver_lock, flags);
 }
 
-int lbs_set_radio_control(lbs_private * priv)
+int lbs_set_radio_control(struct lbs_private *priv)
 {
 	int ret = 0;
 
@@ -1099,7 +1103,7 @@
 	return ret;
 }
 
-int lbs_set_mac_packet_filter(lbs_private * priv)
+int lbs_set_mac_packet_filter(struct lbs_private *priv)
 {
 	int ret = 0;
 
@@ -1116,7 +1120,7 @@
 /**
  *  @brief This function prepare the command before send to firmware.
  *
- *  @param priv		A pointer to lbs_private structure
+ *  @param priv		A pointer to struct lbs_private structure
  *  @param cmd_no	command number
  *  @param cmd_action	command action: GET or SET
  *  @param wait_option	wait option: wait response or not
@@ -1124,13 +1128,13 @@
  *  @param pdata_buf	A pointer to informaion buffer
  *  @return 		0 or -1
  */
-int lbs_prepare_and_send_command(lbs_private * priv,
+int lbs_prepare_and_send_command(struct lbs_private *priv,
 			  u16 cmd_no,
 			  u16 cmd_action,
 			  u16 wait_option, u32 cmd_oid, void *pdata_buf)
 {
 	int ret = 0;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmdnode;
 	struct cmd_ds_command *cmdptr;
 	unsigned long flags;
@@ -1446,17 +1450,17 @@
  *  @brief This function allocates the command buffer and link
  *  it to command free queue.
  *
- *  @param priv		A pointer to lbs_private structure
+ *  @param priv		A pointer to struct lbs_private structure
  *  @return 		0 or -1
  */
-int lbs_allocate_cmd_buffer(lbs_private * priv)
+int lbs_allocate_cmd_buffer(struct lbs_private *priv)
 {
 	int ret = 0;
 	u32 ulbufsize;
 	u32 i;
 	struct cmd_ctrl_node *tempcmd_array;
 	u8 *ptempvirtualaddr;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -1498,15 +1502,15 @@
 /**
  *  @brief This function frees the command buffer.
  *
- *  @param priv		A pointer to lbs_private structure
+ *  @param priv		A pointer to struct lbs_private structure
  *  @return 		0 or -1
  */
-int lbs_free_cmd_buffer(lbs_private * priv)
+int lbs_free_cmd_buffer(struct lbs_private *priv)
 {
 	u32 ulbufsize; /* Someone needs to die for this. Slowly and painfully */
 	unsigned int i;
 	struct cmd_ctrl_node *tempcmd_array;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -1542,13 +1546,13 @@
  *  @brief This function gets a free command node if available in
  *  command free queue.
  *
- *  @param priv		A pointer to lbs_private structure
+ *  @param priv		A pointer to struct lbs_private structure
  *  @return cmd_ctrl_node A pointer to cmd_ctrl_node structure or NULL
  */
-struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(lbs_private * priv)
+struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(struct lbs_private *priv)
 {
 	struct cmd_ctrl_node *tempnode;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
 	lbs_deb_enter(LBS_DEB_HOST);
@@ -1603,14 +1607,14 @@
 /**
  *  @brief This function initializes the command node.
  *
- *  @param priv		A pointer to lbs_private structure
+ *  @param priv		A pointer to struct lbs_private structure
  *  @param ptempnode	A pointer to cmd_ctrl_node structure
  *  @param cmd_oid	cmd oid: treated as sub command
  *  @param wait_option	wait option: wait response or not
  *  @param pdata_buf	A pointer to informaion buffer
  *  @return 		0 or -1
  */
-void lbs_set_cmd_ctrl_node(lbs_private * priv,
+void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 		    struct cmd_ctrl_node *ptempnode,
 		    u32 cmd_oid, u16 wait_option, void *pdata_buf)
 {
@@ -1631,12 +1635,12 @@
  *  pending queue. It will put fimware back to PS mode
  *  if applicable.
  *
- *  @param priv     A pointer to lbs_private structure
+ *  @param priv     A pointer to struct lbs_private structure
  *  @return 	   0 or -1
  */
-int lbs_execute_next_command(lbs_private * priv)
+int lbs_execute_next_command(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmdnode = NULL;
 	struct cmd_ds_command *cmdptr;
 	unsigned long flags;
@@ -1782,7 +1786,7 @@
 	return ret;
 }
 
-void lbs_send_iwevcustom_event(lbs_private *priv, s8 *str)
+void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
 {
 	union iwreq_data iwrq;
 	u8 buf[50];
@@ -1806,10 +1810,10 @@
 	lbs_deb_leave(LBS_DEB_WEXT);
 }
 
-static int sendconfirmsleep(lbs_private *priv, u8 *cmdptr, u16 size)
+static int sendconfirmsleep(struct lbs_private *priv, u8 *cmdptr, u16 size)
 {
 	unsigned long flags;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_HOST);
@@ -1848,7 +1852,7 @@
 	return ret;
 }
 
-void lbs_ps_sleep(lbs_private * priv, int wait_option)
+void lbs_ps_sleep(struct lbs_private *priv, int wait_option)
 {
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -1866,11 +1870,11 @@
 /**
  *  @brief This function sends Exit_PS command to firmware.
  *
- *  @param priv    	A pointer to lbs_private structure
+ *  @param priv    	A pointer to struct lbs_private structure
  *  @param wait_option	wait response or not
  *  @return 	   	n/a
  */
-void lbs_ps_wakeup(lbs_private * priv, int wait_option)
+void lbs_ps_wakeup(struct lbs_private *priv, int wait_option)
 {
 	__le32 Localpsmode;
 
@@ -1889,14 +1893,14 @@
  *  @brief This function checks condition and prepares to
  *  send sleep confirm command to firmware if ok.
  *
- *  @param priv    	A pointer to lbs_private structure
+ *  @param priv    	A pointer to struct lbs_private structure
  *  @param psmode  	Power Saving mode
  *  @return 	   	n/a
  */
-void lbs_ps_confirm_sleep(lbs_private * priv, u16 psmode)
+void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
 {
 	unsigned long flags =0;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u8 allowed = 1;
 
 	lbs_deb_enter(LBS_DEB_HOST);
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c
+++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
@@ -20,12 +20,12 @@
  *  reports disconnect to upper layer, clean tx/rx packets,
  *  reset link state etc.
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @return 	   n/a
  */
-void lbs_mac_event_disconnected(lbs_private * priv)
+void lbs_mac_event_disconnected(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	union iwreq_data wrqu;
 
 	if (adapter->connect_status != LBS_CONNECTED)
@@ -85,11 +85,11 @@
 /**
  *  @brief This function handles MIC failure event.
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @para  event   the event id
  *  @return 	   n/a
  */
-static void handle_mic_failureevent(lbs_private * priv, u32 event)
+static void handle_mic_failureevent(struct lbs_private *priv, u32 event)
 {
 	char buf[50];
 
@@ -108,11 +108,11 @@
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
-static int lbs_ret_reg_access(lbs_private * priv,
+static int lbs_ret_reg_access(struct lbs_private *priv,
 			       u16 type, struct cmd_ds_command *resp)
 {
 	int ret = 0;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -152,12 +152,12 @@
 	return ret;
 }
 
-static int lbs_ret_get_hw_spec(lbs_private * priv,
+static int lbs_ret_get_hw_spec(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
 	u32 i;
 	struct cmd_ds_get_hw_spec *hwspec = &resp->params.hwspec;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	DECLARE_MAC_BUF(mac);
 
@@ -216,11 +216,11 @@
 	return ret;
 }
 
-static int lbs_ret_802_11_sleep_params(lbs_private * priv,
+static int lbs_ret_802_11_sleep_params(struct lbs_private *priv,
 					struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_sleep_params *sp = &resp->params.sleep_params;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -240,14 +240,14 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_stat(lbs_private * priv,
+static int lbs_ret_802_11_stat(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
 	lbs_deb_enter(LBS_DEB_CMD);
 /*	currently adapter->wlan802_11Stat is unused
 
 	struct cmd_ds_802_11_get_stat *p11Stat = &resp->params.gstat;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	// TODO Convert it to Big endian befor copy
 	memcpy(&adapter->wlan802_11Stat,
@@ -257,7 +257,7 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_snmp_mib(lbs_private * priv,
+static int lbs_ret_802_11_snmp_mib(struct lbs_private *priv,
 				    struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_snmp_mib *smib = &resp->params.smib;
@@ -299,12 +299,12 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_key_material(lbs_private * priv,
+static int lbs_ret_802_11_key_material(struct lbs_private *priv,
 					struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_key_material *pkeymaterial =
 	    &resp->params.keymaterial;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u16 action = le16_to_cpu(pkeymaterial->action);
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -355,11 +355,11 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_mac_address(lbs_private * priv,
+static int lbs_ret_802_11_mac_address(struct lbs_private *priv,
 				       struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_mac_address *macadd = &resp->params.macadd;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -369,11 +369,11 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_rf_tx_power(lbs_private * priv,
+static int lbs_ret_802_11_rf_tx_power(struct lbs_private *priv,
 				       struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rf_tx_power *rtp = &resp->params.txp;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -385,11 +385,11 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_rate_adapt_rateset(lbs_private * priv,
+static int lbs_ret_802_11_rate_adapt_rateset(struct lbs_private *priv,
 					      struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rate_adapt_rateset *rates = &resp->params.rateset;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -402,11 +402,11 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_data_rate(lbs_private * priv,
+static int lbs_ret_802_11_data_rate(struct lbs_private *priv,
 				     struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_data_rate *pdatarate = &resp->params.drate;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -423,11 +423,11 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_rf_channel(lbs_private * priv,
+static int lbs_ret_802_11_rf_channel(struct lbs_private *priv,
 				      struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rf_channel *rfchannel = &resp->params.rfchannel;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u16 action = le16_to_cpu(rfchannel->action);
 	u16 newchannel = le16_to_cpu(rfchannel->currentchannel);
 
@@ -446,11 +446,11 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_rssi(lbs_private * priv,
+static int lbs_ret_802_11_rssi(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -477,10 +477,10 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_eeprom_access(lbs_private * priv,
+static int lbs_ret_802_11_eeprom_access(struct lbs_private *priv,
 				  struct cmd_ds_command *resp)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_ioctl_regrdwr *pbuf;
 	pbuf = (struct lbs_ioctl_regrdwr *) adapter->prdeeprom;
 
@@ -503,11 +503,11 @@
 	return 0;
 }
 
-static int lbs_ret_get_log(lbs_private * priv,
+static int lbs_ret_get_log(struct lbs_private *priv,
 			    struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_get_log *logmessage = &resp->params.glog;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -518,11 +518,11 @@
 	return 0;
 }
 
-static int lbs_ret_802_11_enable_rsn(lbs_private * priv,
+static int lbs_ret_802_11_enable_rsn(struct lbs_private *priv,
                                           struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_enable_rsn *enable_rsn = &resp->params.enbrsn;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u32 * pdata_buf = adapter->cur_cmd->pdata_buf;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -538,11 +538,11 @@
 
 static inline int handle_cmd_response(u16 respcmd,
 				      struct cmd_ds_command *resp,
-				      lbs_private *priv)
+				      struct lbs_private *priv)
 {
 	int ret = 0;
 	unsigned long flags;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -713,11 +713,11 @@
 	return ret;
 }
 
-int lbs_process_rx_command(lbs_private * priv)
+int lbs_process_rx_command(struct lbs_private *priv)
 {
 	u16 respcmd;
 	struct cmd_ds_command *resp;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	ulong flags;
 	u16 result;
@@ -866,10 +866,10 @@
 	return ret;
 }
 
-int lbs_process_event(lbs_private * priv)
+int lbs_process_event(struct lbs_private *priv)
 {
 	int ret = 0;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	u32 eventcause;
 
 	lbs_deb_enter(LBS_DEB_CMD);
--- wireless-2.6.orig/drivers/net/wireless/libertas/debugfs.c
+++ wireless-2.6/drivers/net/wireless/libertas/debugfs.c
@@ -18,7 +18,7 @@
 };
 
 #ifdef PROC_DEBUG
-static void lbs_debug_init(lbs_private * priv, struct net_device *dev);
+static void lbs_debug_init(struct lbs_private *priv, struct net_device *dev);
 #endif
 
 static int open_file_generic(struct inode *inode, struct file *file)
@@ -38,7 +38,7 @@
 static ssize_t lbs_dev_info(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	size_t pos = 0;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
@@ -59,7 +59,7 @@
 static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	size_t pos = 0;
 	int numscansdone = 0, res;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
@@ -102,7 +102,7 @@
 				const char __user *user_buf, size_t count,
 				loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t buf_size, res;
 	int p1, p2, p3, p4, p5, p6;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
@@ -143,8 +143,8 @@
 static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res;
 	size_t pos = 0;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
@@ -174,7 +174,7 @@
 static ssize_t lbs_extscan(struct file *file, const char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	union iwreq_data wrqu;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
@@ -341,7 +341,7 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	struct lbs_ioctl_user_scan_cfg *scan_cfg;
 	union iwreq_data wrqu;
@@ -383,7 +383,7 @@
 	return count;
 }
 
-static int lbs_event_initcmd(lbs_private *priv, void **response_buf,
+static int lbs_event_initcmd(struct lbs_private *priv, void **response_buf,
 			struct cmd_ctrl_node **cmdnode,
 			struct cmd_ds_command **cmd)
 {
@@ -412,8 +412,8 @@
 static ssize_t lbs_lowrssi_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *pcmdnode;
 	struct cmd_ds_command *pcmdptr;
 	struct cmd_ds_802_11_subscribe_event *event;
@@ -479,9 +479,9 @@
 	return res;
 }
 
-static u16 lbs_get_events_bitmap(lbs_private *priv)
+static u16 lbs_get_events_bitmap(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *pcmdnode;
 	struct cmd_ds_command *pcmdptr;
 	struct cmd_ds_802_11_subscribe_event *event;
@@ -528,8 +528,8 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res, buf_size;
 	int value, freq, subscribed, cmd_len;
 	struct cmd_ctrl_node *pcmdnode;
@@ -608,8 +608,8 @@
 static ssize_t lbs_lowsnr_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *pcmdnode;
 	struct cmd_ds_command *pcmdptr;
 	struct cmd_ds_802_11_subscribe_event *event;
@@ -681,8 +681,8 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res, buf_size;
 	int value, freq, subscribed, cmd_len;
 	struct cmd_ctrl_node *pcmdnode;
@@ -761,8 +761,8 @@
 static ssize_t lbs_failcount_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *pcmdnode;
 	struct cmd_ds_command *pcmdptr;
 	struct cmd_ds_802_11_subscribe_event *event;
@@ -833,8 +833,8 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res, buf_size;
 	int value, freq, subscribed, cmd_len;
 	struct cmd_ctrl_node *pcmdnode;
@@ -912,8 +912,8 @@
 static ssize_t lbs_bcnmiss_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *pcmdnode;
 	struct cmd_ds_command *pcmdptr;
 	struct cmd_ds_802_11_subscribe_event *event;
@@ -984,8 +984,8 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res, buf_size;
 	int value, freq, subscribed, cmd_len;
 	struct cmd_ctrl_node *pcmdnode;
@@ -1062,8 +1062,8 @@
 static ssize_t lbs_highrssi_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *pcmdnode;
 	struct cmd_ds_command *pcmdptr;
 	struct cmd_ds_802_11_subscribe_event *event;
@@ -1135,8 +1135,8 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res, buf_size;
 	int value, freq, subscribed, cmd_len;
 	struct cmd_ctrl_node *pcmdnode;
@@ -1212,8 +1212,8 @@
 static ssize_t lbs_highsnr_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *pcmdnode;
 	struct cmd_ds_command *pcmdptr;
 	struct cmd_ds_802_11_subscribe_event *event;
@@ -1285,8 +1285,8 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res, buf_size;
 	int value, freq, subscribed, cmd_len;
 	struct cmd_ctrl_node *pcmdnode;
@@ -1364,8 +1364,8 @@
 static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
@@ -1391,7 +1391,7 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
@@ -1413,7 +1413,7 @@
 				    size_t count, loff_t *ppos)
 {
 
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	u32 offset, value;
 	struct lbs_offset_value offval;
@@ -1447,8 +1447,8 @@
 static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
@@ -1475,7 +1475,7 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
@@ -1497,7 +1497,7 @@
 				    size_t count, loff_t *ppos)
 {
 
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	u32 offset, value;
 	struct lbs_offset_value offval;
@@ -1531,8 +1531,8 @@
 static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = file->private_data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
@@ -1559,7 +1559,7 @@
 				    const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
@@ -1581,7 +1581,7 @@
 				    size_t count, loff_t *ppos)
 {
 
-	lbs_private *priv = file->private_data;
+	struct lbs_private *priv = file->private_data;
 	ssize_t res, buf_size;
 	u32 offset, value;
 	struct lbs_offset_value offval;
@@ -1674,7 +1674,7 @@
 	return;
 }
 
-void lbs_debugfs_init_one(lbs_private *priv, struct net_device *dev)
+void lbs_debugfs_init_one(struct lbs_private *priv, struct net_device *dev)
 {
 	int i;
 	struct lbs_debugfs_files *files;
@@ -1727,7 +1727,7 @@
 	return;
 }
 
-void lbs_debugfs_remove_one(lbs_private *priv)
+void lbs_debugfs_remove_one(struct lbs_private *priv)
 {
 	int i;
 
@@ -1754,8 +1754,8 @@
 
 #ifdef PROC_DEBUG
 
-#define item_size(n)	(FIELD_SIZEOF(lbs_adapter, n))
-#define item_addr(n)	(offsetof(lbs_adapter, n))
+#define item_size(n)	(FIELD_SIZEOF(struct lbs_adapter, n))
+#define item_addr(n)	(offsetof(struct lbs_adapter, n))
 
 
 struct debug_data {
@@ -1764,7 +1764,7 @@
 	size_t addr;
 };
 
-/* To debug any member of lbs_adapter, simply add one line here.
+/* To debug any member of struct lbs_adapter, simply add one line here.
  */
 static struct debug_data items[] = {
 	{"intcounter", item_size(intcounter), item_addr(intcounter)},
@@ -1891,11 +1891,11 @@
 /**
  *  @brief create debug proc file
  *
- *  @param priv	   pointer lbs_private
+ *  @param priv	   pointer struct lbs_private
  *  @param dev     pointer net_device
  *  @return 	   N/A
  */
-static void lbs_debug_init(lbs_private * priv, struct net_device *dev)
+static void lbs_debug_init(struct lbs_private *priv, struct net_device *dev)
 {
 	int i;
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/debugfs.h
+++ wireless-2.6/drivers/net/wireless/libertas/debugfs.h
@@ -4,7 +4,7 @@
 void lbs_debugfs_init(void);
 void lbs_debugfs_remove(void);
 
-void lbs_debugfs_init_one(lbs_private *priv, struct net_device *dev);
-void lbs_debugfs_remove_one(lbs_private *priv);
+void lbs_debugfs_init_one(struct lbs_private *priv, struct net_device *dev);
+void lbs_debugfs_remove_one(struct lbs_private *priv);
 
 #endif
--- wireless-2.6.orig/drivers/net/wireless/libertas/decl.h
+++ wireless-2.6/drivers/net/wireless/libertas/decl.h
@@ -12,71 +12,79 @@
 
 /** Function Prototype Declaration */
 struct lbs_private;
+struct lbs_adapter;
 struct sk_buff;
 struct net_device;
 
-int lbs_set_mac_packet_filter(lbs_private * priv);
+int lbs_set_mac_packet_filter(struct lbs_private *priv);
 
-void lbs_send_tx_feedback(lbs_private * priv);
+void lbs_send_tx_feedback(struct lbs_private *priv);
 
-int lbs_free_cmd_buffer(lbs_private * priv);
+int lbs_free_cmd_buffer(struct lbs_private *priv);
 struct cmd_ctrl_node;
-struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(lbs_private * priv);
+struct cmd_ctrl_node *lbs_get_free_cmd_ctrl_node(struct lbs_private *priv);
 
-void lbs_set_cmd_ctrl_node(lbs_private * priv,
-		    struct cmd_ctrl_node *ptempnode,
-		    u32 cmd_oid, u16 wait_option, void *pdata_buf);
+void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
+	struct cmd_ctrl_node *ptempnode,
+	u32 cmd_oid, u16 wait_option, void *pdata_buf);
 
-int lbs_prepare_and_send_command(lbs_private * priv,
-			  u16 cmd_no,
-			  u16 cmd_action,
-			  u16 wait_option, u32 cmd_oid, void *pdata_buf);
+int lbs_prepare_and_send_command(struct lbs_private *priv,
+	u16 cmd_no,
+	u16 cmd_action,
+	u16 wait_option, u32 cmd_oid, void *pdata_buf);
 
-void lbs_queue_cmd(lbs_adapter *adapter, struct cmd_ctrl_node *cmdnode, u8 addtail);
+void lbs_queue_cmd(struct lbs_adapter *adapter,
+	struct cmd_ctrl_node *cmdnode,
+	u8 addtail);
 
-int lbs_allocate_cmd_buffer(lbs_private * priv);
-int lbs_execute_next_command(lbs_private * priv);
-int lbs_process_event(lbs_private * priv);
+int lbs_allocate_cmd_buffer(struct lbs_private *priv);
+int lbs_execute_next_command(struct lbs_private *priv);
+int lbs_process_event(struct lbs_private *priv);
 void lbs_interrupt(struct net_device *);
-int lbs_set_radio_control(lbs_private * priv);
+int lbs_set_radio_control(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
-void lbs_get_fwversion(lbs_adapter *adapter, char *fwversion, int maxlen);
+void lbs_get_fwversion(struct lbs_adapter *adapter,
+	char *fwversion,
+	int maxlen);
 
-void lbs_upload_rx_packet(lbs_private * priv, struct sk_buff *skb);
+void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb);
 
 /** The proc fs interface */
-int lbs_process_rx_command(lbs_private * priv);
-int lbs_process_tx(lbs_private * priv, struct sk_buff *skb);
-void __lbs_cleanup_and_insert_cmd(lbs_private * priv,
-					struct cmd_ctrl_node *ptempcmd);
+int lbs_process_rx_command(struct lbs_private *priv);
+int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb);
+void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
+	struct cmd_ctrl_node *ptempcmd);
 
-int lbs_set_regiontable(lbs_private * priv, u8 region, u8 band);
+int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
 
-int lbs_process_rxed_packet(lbs_private * priv, struct sk_buff *);
+int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
-void lbs_ps_sleep(lbs_private * priv, int wait_option);
-void lbs_ps_confirm_sleep(lbs_private * priv, u16 psmode);
-void lbs_ps_wakeup(lbs_private * priv, int wait_option);
+void lbs_ps_sleep(struct lbs_private *priv, int wait_option);
+void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode);
+void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
 
-void lbs_tx_runqueue(lbs_private *priv);
+void lbs_tx_runqueue(struct lbs_private *priv);
 
 struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-				lbs_adapter *adapter, u8 band, u16 channel);
+	struct lbs_adapter *adapter,
+	u8 band,
+	u16 channel);
 
-void lbs_mac_event_disconnected(lbs_private * priv);
+void lbs_mac_event_disconnected(struct lbs_private *priv);
 
-void lbs_send_iwevcustom_event(lbs_private *priv, s8 *str);
+void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
 
 /* main.c */
-struct chan_freq_power *lbs_get_region_cfp_table(u8 region, u8 band,
-						             int *cfp_no);
-lbs_private *lbs_add_card(void *card, struct device *dmdev);
-int lbs_remove_card(lbs_private *priv);
-int lbs_start_card(lbs_private *priv);
-int lbs_stop_card(lbs_private *priv);
-int lbs_add_mesh(lbs_private *priv, struct device *dev);
-void lbs_remove_mesh(lbs_private *priv);
-int lbs_reset_device(lbs_private *priv);
+struct chan_freq_power *lbs_get_region_cfp_table(u8 region,
+	u8 band,
+	int *cfp_no);
+struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
+int lbs_remove_card(struct lbs_private *priv);
+int lbs_start_card(struct lbs_private *priv);
+int lbs_stop_card(struct lbs_private *priv);
+int lbs_add_mesh(struct lbs_private *priv, struct device *dev);
+void lbs_remove_mesh(struct lbs_private *priv);
+int lbs_reset_device(struct lbs_private *priv);
 
 #endif
--- wireless-2.6.orig/drivers/net/wireless/libertas/defs.h
+++ wireless-2.6/drivers/net/wireless/libertas/defs.h
@@ -262,8 +262,6 @@
 #define UNSET_MESH_FRAME(x) (x->cb[6]=0)
 
 /** Global Variable Declaration */
-typedef struct _lbs_private lbs_private;
-typedef struct _lbs_adapter lbs_adapter;
 extern const char lbs_driver_version[];
 extern u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE];
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/dev.h
+++ wireless-2.6/drivers/net/wireless/libertas/dev.h
@@ -1,7 +1,7 @@
 /**
   * This file contains definitions and data structures specific
   * to Marvell 802.11 NIC. It contains the Device Information
-  * structure lbs_adapter.
+  * structure struct lbs_adapter.
   */
 #ifndef _LBS_DEV_H_
 #define _LBS_DEV_H_
@@ -99,7 +99,7 @@
 };
 
 /** Private structure for the MV device */
-struct _lbs_private {
+struct lbs_private {
 	int open;
 	int mesh_open;
 	int infra_open;
@@ -109,7 +109,7 @@
 	char name[DEV_NAME_LEN];
 
 	void *card;
-	lbs_adapter *adapter;
+	struct lbs_adapter *adapter;
 	struct net_device *dev;
 
 	struct net_device_stats stats;
@@ -155,9 +155,9 @@
 	struct work_struct sync_channel;
 
 	/** Hardware access */
-	int (*hw_host_to_card) (lbs_private *priv, u8 type, u8 *payload, u16 nb);
-	int (*hw_get_int_status) (lbs_private *priv, u8 *);
-	int (*hw_read_event_cause) (lbs_private *);
+	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
+	int (*hw_get_int_status) (struct lbs_private *priv, u8 *);
+	int (*hw_read_event_cause) (struct lbs_private *);
 };
 
 /** Association request
@@ -205,7 +205,7 @@
 };
 
 /** Wlan adapter data structure*/
-struct _lbs_adapter {
+struct lbs_adapter {
 	/** STATUS variables */
 	u8 fwreleasenumber[4];
 	u32 fwcapinfo;
--- wireless-2.6.orig/drivers/net/wireless/libertas/ethtool.c
+++ wireless-2.6/drivers/net/wireless/libertas/ethtool.c
@@ -22,7 +22,7 @@
 static void lbs_ethtool_get_drvinfo(struct net_device *dev,
 					 struct ethtool_drvinfo *info)
 {
-	lbs_private *priv = (lbs_private *) dev->priv;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 	char fwver[32];
 
 	lbs_get_fwversion(priv->adapter, fwver, sizeof(fwver) - 1);
@@ -45,8 +45,8 @@
 static int lbs_ethtool_get_eeprom(struct net_device *dev,
                                   struct ethtool_eeprom *eeprom, u8 * bytes)
 {
-	lbs_private *priv = (lbs_private *) dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_ioctl_regrdwr regctrl;
 	char *ptr;
 	int ret;
@@ -108,7 +108,7 @@
 static void lbs_ethtool_get_stats(struct net_device * dev,
 				struct ethtool_stats * stats, u64 * data)
 {
-	lbs_private *priv = dev->priv;
+	struct lbs_private *priv = dev->priv;
 	struct cmd_ds_mesh_access mesh_access;
 	int ret;
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c
+++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c
@@ -57,7 +57,7 @@
 
 struct if_cs_card {
 	struct pcmcia_device *p_dev;
-	lbs_private *priv;
+	struct lbs_private *priv;
 	void __iomem *iobase;
 };
 
@@ -285,7 +285,7 @@
 /*
  * Called from if_cs_host_to_card to send a command to the hardware
  */
-static int if_cs_send_cmd(lbs_private *priv, u8 *buf, u16 nb)
+static int if_cs_send_cmd(struct lbs_private *priv, u8 *buf, u16 nb)
 {
 	struct if_cs_card *card = (struct if_cs_card *)priv->card;
 	int ret = -1;
@@ -330,7 +330,7 @@
 /*
  * Called from if_cs_host_to_card to send a data to the hardware
  */
-static void if_cs_send_data(lbs_private *priv, u8 *buf, u16 nb)
+static void if_cs_send_data(struct lbs_private *priv, u8 *buf, u16 nb)
 {
 	struct if_cs_card *card = (struct if_cs_card *)priv->card;
 
@@ -353,7 +353,7 @@
 /*
  * Get the command result out of the card.
  */
-static int if_cs_receive_cmdres(lbs_private *priv, u8 *data, u32 *len)
+static int if_cs_receive_cmdres(struct lbs_private *priv, u8 *data, u32 *len)
 {
 	int ret = -1;
 	u16 val;
@@ -385,7 +385,7 @@
 }
 
 
-static struct sk_buff *if_cs_receive_data(lbs_private *priv)
+static struct sk_buff *if_cs_receive_data(struct lbs_private *priv)
 {
 	struct sk_buff *skb = NULL;
 	u16 len;
@@ -615,7 +615,10 @@
 /********************************************************************/
 
 /* Send commands or data packets to the card */
-static int if_cs_host_to_card(lbs_private *priv, u8 type, u8 *buf, u16 nb)
+static int if_cs_host_to_card(struct lbs_private *priv,
+	u8 type,
+	u8 *buf,
+	u16 nb)
 {
 	int ret = -1;
 
@@ -640,10 +643,10 @@
 }
 
 
-static int if_cs_get_int_status(lbs_private *priv, u8 *ireg)
+static int if_cs_get_int_status(struct lbs_private *priv, u8 *ireg)
 {
 	struct if_cs_card *card = (struct if_cs_card *)priv->card;
-	/* lbs_adapter *adapter = priv->adapter; */
+	/* struct lbs_adapter *adapter = priv->adapter; */
 	int ret = 0;
 	u16 int_cause;
 	u8 *cmdbuf;
@@ -697,7 +700,7 @@
 }
 
 
-static int if_cs_read_event_cause(lbs_private *priv)
+static int if_cs_read_event_cause(struct lbs_private *priv)
 {
 	lbs_deb_enter(LBS_DEB_CS);
 
@@ -745,7 +748,7 @@
 static int if_cs_probe(struct pcmcia_device *p_dev)
 {
 	int ret = -ENOMEM;
-	lbs_private *priv;
+	struct lbs_private *priv;
 	struct if_cs_card *card;
 	/* CIS parsing */
 	tuple_t tuple;
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_usb.c
+++ wireless-2.6/drivers/net/wireless/libertas/if_usb.c
@@ -45,9 +45,12 @@
 static void if_usb_receive(struct urb *urb);
 static void if_usb_receive_fwload(struct urb *urb);
 static int if_usb_prog_firmware(struct usb_card_rec *cardp);
-static int if_usb_host_to_card(lbs_private *priv, u8 type, u8 *payload, u16 nb);
-static int if_usb_get_int_status(lbs_private *priv, u8 *);
-static int if_usb_read_event_cause(lbs_private *);
+static int if_usb_host_to_card(struct lbs_private *priv,
+	u8 type,
+	u8 *payload,
+	u16 nb);
+static int if_usb_get_int_status(struct lbs_private *priv, u8 *);
+static int if_usb_read_event_cause(struct lbs_private *);
 static int usb_tx_block(struct usb_card_rec *cardp, u8 *payload, u16 nb);
 static void if_usb_free(struct usb_card_rec *cardp);
 static int if_usb_submit_rx_urb(struct usb_card_rec *cardp);
@@ -65,7 +68,7 @@
 	/* handle the transmission complete validations */
 
 	if (urb->status == 0) {
-		lbs_private *priv = cardp->priv;
+		struct lbs_private *priv = cardp->priv;
 
 		/*
 		lbs_deb_usbd(&urb->dev->dev, "URB status is successfull\n");
@@ -77,7 +80,7 @@
 		 * valid at firmware load time.
 		 */
 		if (priv) {
-			lbs_adapter *adapter = priv->adapter;
+			struct lbs_adapter *adapter = priv->adapter;
 			struct net_device *dev = priv->dev;
 
 			priv->dnld_sent = DNLD_RES_RECEIVED;
@@ -136,7 +139,7 @@
 	struct usb_device *udev;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
-	lbs_private *priv;
+	struct lbs_private *priv;
 	struct usb_card_rec *cardp;
 	int i;
 
@@ -273,7 +276,7 @@
 static void if_usb_disconnect(struct usb_interface *intf)
 {
 	struct usb_card_rec *cardp = usb_get_intfdata(intf);
-	lbs_private *priv = (lbs_private *) cardp->priv;
+	struct lbs_private *priv = (struct lbs_private *) cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
@@ -283,7 +286,7 @@
 	list_del(&cardp->list);
 
 	if (priv) {
-		lbs_adapter *adapter = priv->adapter;
+		struct lbs_adapter *adapter = priv->adapter;
 
 		adapter->surpriseremoved = 1;
 		lbs_stop_card(priv);
@@ -302,7 +305,7 @@
 
 /**
  *  @brief  This function download FW
- *  @param priv		pointer to lbs_private
+ *  @param priv		pointer to struct lbs_private
  *  @return 	   	0
  */
 static int if_prog_firmware(struct usb_card_rec *cardp)
@@ -385,7 +388,7 @@
 static int if_usb_reset_device(struct usb_card_rec *cardp)
 {
 	int ret;
-	lbs_private * priv = cardp->priv;
+	struct lbs_private *priv = cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_USB);
 
@@ -406,7 +409,7 @@
 
 /**
  *  @brief This function transfer the data to the device.
- *  @param priv 	pointer to lbs_private
+ *  @param priv 	pointer to struct lbs_private
  *  @param payload	pointer to payload data
  *  @param nb		data length
  *  @return 	   	0 or -1
@@ -583,7 +586,7 @@
 
 static inline void process_cmdtypedata(int recvlength, struct sk_buff *skb,
 				       struct usb_card_rec *cardp,
-				       lbs_private *priv)
+				       struct lbs_private *priv)
 {
 	if (recvlength > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE +
 	    MESSAGE_HEADER_LEN || recvlength < MRVDRV_MIN_PKT_LEN) {
@@ -603,7 +606,7 @@
 static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 				      struct sk_buff *skb,
 				      struct usb_card_rec *cardp,
-				      lbs_private *priv)
+				      struct lbs_private *priv)
 {
 	u8 *cmdbuf;
 	if (recvlength > MRVDRV_SIZE_OF_CMD_BUFFER) {
@@ -652,7 +655,7 @@
 	struct read_cb_info *rinfo = (struct read_cb_info *)urb->context;
 	struct sk_buff *skb = rinfo->skb;
 	struct usb_card_rec *cardp = (struct usb_card_rec *) rinfo->cardp;
-	lbs_private * priv = cardp->priv;
+	struct lbs_private *priv = cardp->priv;
 
 	int recvlength = urb->actual_length;
 	u8 *recvbuff = NULL;
@@ -720,13 +723,16 @@
 
 /**
  *  @brief This function downloads data to FW
- *  @param priv		pointer to lbs_private structure
+ *  @param priv		pointer to struct lbs_private structure
  *  @param type		type of data
  *  @param buf		pointer to data buffer
  *  @param len		number of bytes
  *  @return 	   	0 or -1
  */
-static int if_usb_host_to_card(lbs_private *priv, u8 type, u8 *payload, u16 nb)
+static int if_usb_host_to_card(struct lbs_private *priv,
+	u8 type,
+	u8 *payload,
+	u16 nb)
 {
 	struct usb_card_rec *cardp = (struct usb_card_rec *)priv->card;
 
@@ -753,7 +759,7 @@
 }
 
 /* called with adapter->driver_lock held */
-static int if_usb_get_int_status(lbs_private *priv, u8 *ireg)
+static int if_usb_get_int_status(struct lbs_private *priv, u8 *ireg)
 {
 	struct usb_card_rec *cardp = priv->card;
 
@@ -765,7 +771,7 @@
 	return 0;
 }
 
-static int if_usb_read_event_cause(lbs_private * priv)
+static int if_usb_read_event_cause(struct lbs_private *priv)
 {
 	struct usb_card_rec *cardp = priv->card;
 
@@ -940,7 +946,7 @@
 static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usb_card_rec *cardp = usb_get_intfdata(intf);
-	lbs_private *priv = cardp->priv;
+	struct lbs_private *priv = cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_USB);
 
@@ -976,7 +982,7 @@
 static int if_usb_resume(struct usb_interface *intf)
 {
 	struct usb_card_rec *cardp = usb_get_intfdata(intf);
-	lbs_private *priv = cardp->priv;
+	struct lbs_private *priv = cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_USB);
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/join.c
+++ wireless-2.6/drivers/net/wireless/libertas/join.c
@@ -30,13 +30,15 @@
  * NOTE: Setting the MSB of the basic rates need to be taken
  *   care, either before or after calling this function
  *
- *  @param adapter     A pointer to lbs_adapter structure
+ *  @param adapter     A pointer to struct lbs_adapter structure
  *  @param rate1       the buffer which keeps input and output
  *  @param rate1_size  the size of rate1 buffer; new size of buffer on return
  *
  *  @return            0 or -1
  */
-static int get_common_rates(lbs_adapter *adapter, u8 *rates, u16 *rates_size)
+static int get_common_rates(struct lbs_adapter *adapter,
+	u8 *rates,
+	u16 *rates_size)
 {
 	u8 *card_rates = lbs_bg_rates;
 	size_t num_card_rates = sizeof(lbs_bg_rates);
@@ -116,14 +118,14 @@
 /**
  *  @brief Associate to a specific BSS discovered in a scan
  *
- *  @param priv      A pointer to lbs_private structure
+ *  @param priv      A pointer to struct lbs_private structure
  *  @param pbssdesc  Pointer to the BSS descriptor to associate with.
  *
  *  @return          0-success, otherwise fail
  */
-int lbs_associate(lbs_private *priv, struct assoc_request *assoc_req)
+int lbs_associate(struct lbs_private *priv, struct assoc_request *assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_JOIN);
@@ -155,13 +157,14 @@
 /**
  *  @brief Start an Adhoc Network
  *
- *  @param priv         A pointer to lbs_private structure
+ *  @param priv         A pointer to struct lbs_private structure
  *  @param adhocssid    The ssid of the Adhoc Network
  *  @return             0--success, -1--fail
  */
-int lbs_start_adhoc_network(lbs_private *priv, struct assoc_request *assoc_req)
+int lbs_start_adhoc_network(struct lbs_private *priv,
+	struct assoc_request *assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	adapter->adhoccreate = 1;
@@ -188,15 +191,16 @@
 /**
  *  @brief Join an adhoc network found in a previous scan
  *
- *  @param priv         A pointer to lbs_private structure
+ *  @param priv         A pointer to struct lbs_private structure
  *  @param pbssdesc     Pointer to a BSS descriptor found in a previous scan
  *                      to attempt to join
  *
  *  @return             0--success, -1--fail
  */
-int lbs_join_adhoc_network(lbs_private *priv, struct assoc_request *assoc_req)
+int lbs_join_adhoc_network(struct lbs_private *priv,
+	struct assoc_request *assoc_req)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct bss_descriptor * bss = &assoc_req->bss;
 	int ret = 0;
 
@@ -258,7 +262,7 @@
 	return ret;
 }
 
-int lbs_stop_adhoc_network(lbs_private * priv)
+int lbs_stop_adhoc_network(struct lbs_private *priv)
 {
 	return lbs_prepare_and_send_command(priv, CMD_802_11_AD_HOC_STOP,
 				     0, CMD_OPTION_WAITFORRSP, 0, NULL);
@@ -267,10 +271,10 @@
 /**
  *  @brief Send Deauthentication Request
  *
- *  @param priv      A pointer to lbs_private structure
+ *  @param priv      A pointer to struct lbs_private structure
  *  @return          0--success, -1--fail
  */
-int lbs_send_deauthentication(lbs_private *priv)
+int lbs_send_deauthentication(struct lbs_private *priv)
 {
 	return lbs_prepare_and_send_command(priv, CMD_802_11_DEAUTHENTICATE,
 				     0, CMD_OPTION_WAITFORRSP, 0, NULL);
@@ -279,17 +283,17 @@
 /**
  *  @brief This function prepares command of authenticate.
  *
- *  @param priv      A pointer to lbs_private structure
+ *  @param priv      A pointer to struct lbs_private structure
  *  @param cmd       A pointer to cmd_ds_command structure
  *  @param pdata_buf Void cast of pointer to a BSSID to authenticate with
  *
  *  @return         0 or -1
  */
-int lbs_cmd_80211_authenticate(lbs_private *priv,
+int lbs_cmd_80211_authenticate(struct lbs_private *priv,
 				 struct cmd_ds_command *cmd,
 				 void *pdata_buf)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_authenticate *pauthenticate = &cmd->params.auth;
 	int ret = -1;
 	u8 *bssid = pdata_buf;
@@ -329,10 +333,10 @@
 	return ret;
 }
 
-int lbs_cmd_80211_deauthenticate(lbs_private *priv,
+int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 				   struct cmd_ds_command *cmd)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_deauthenticate *dauth = &cmd->params.deauth;
 
 	lbs_deb_enter(LBS_DEB_JOIN);
@@ -352,10 +356,10 @@
 	return 0;
 }
 
-int lbs_cmd_80211_associate(lbs_private *priv,
+int lbs_cmd_80211_associate(struct lbs_private *priv,
 			      struct cmd_ds_command *cmd, void *pdata_buf)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_associate *passo = &cmd->params.associate;
 	int ret = 0;
 	struct assoc_request * assoc_req = pdata_buf;
@@ -468,10 +472,10 @@
 	return ret;
 }
 
-int lbs_cmd_80211_ad_hoc_start(lbs_private *priv,
+int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 				 struct cmd_ds_command *cmd, void *pdata_buf)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_ad_hoc_start *adhs = &cmd->params.ads;
 	int ret = 0;
 	int cmdappendsize = 0;
@@ -580,7 +584,7 @@
 	return ret;
 }
 
-int lbs_cmd_80211_ad_hoc_stop(lbs_private *priv,
+int lbs_cmd_80211_ad_hoc_stop(struct lbs_private *priv,
 				struct cmd_ds_command *cmd)
 {
 	cmd->command = cpu_to_le16(CMD_802_11_AD_HOC_STOP);
@@ -589,10 +593,10 @@
 	return 0;
 }
 
-int lbs_cmd_80211_ad_hoc_join(lbs_private *priv,
+int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
 				struct cmd_ds_command *cmd, void *pdata_buf)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_ad_hoc_join *join_cmd = &cmd->params.adj;
 	struct assoc_request * assoc_req = pdata_buf;
 	struct bss_descriptor *bss = &assoc_req->bss;
@@ -692,10 +696,10 @@
 	return ret;
 }
 
-int lbs_ret_80211_associate(lbs_private *priv,
+int lbs_ret_80211_associate(struct lbs_private *priv,
 			      struct cmd_ds_command *resp)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	union iwreq_data wrqu;
 	struct ieeetypes_assocrsp *passocrsp;
@@ -809,7 +813,7 @@
 	return ret;
 }
 
-int lbs_ret_80211_disassociate(lbs_private *priv,
+int lbs_ret_80211_disassociate(struct lbs_private *priv,
 				 struct cmd_ds_command *resp)
 {
 	lbs_deb_enter(LBS_DEB_JOIN);
@@ -820,10 +824,10 @@
 	return 0;
 }
 
-int lbs_ret_80211_ad_hoc_start(lbs_private *priv,
+int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 				 struct cmd_ds_command *resp)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u16 command = le16_to_cpu(resp->command);
 	u16 result = le16_to_cpu(resp->result);
@@ -904,7 +908,7 @@
 	return ret;
 }
 
-int lbs_ret_80211_ad_hoc_stop(lbs_private *priv,
+int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
 	lbs_deb_enter(LBS_DEB_JOIN);
--- wireless-2.6.orig/drivers/net/wireless/libertas/join.h
+++ wireless-2.6/drivers/net/wireless/libertas/join.h
@@ -12,41 +12,41 @@
 #include "dev.h"
 
 struct cmd_ds_command;
-int lbs_cmd_80211_authenticate(lbs_private *priv,
+int lbs_cmd_80211_authenticate(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					void *pdata_buf);
-int lbs_cmd_80211_ad_hoc_join(lbs_private *priv,
+int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
 				       struct cmd_ds_command *cmd,
 				       void *pdata_buf);
-int lbs_cmd_80211_ad_hoc_stop(lbs_private *priv,
+int lbs_cmd_80211_ad_hoc_stop(struct lbs_private *priv,
 				       struct cmd_ds_command *cmd);
-int lbs_cmd_80211_ad_hoc_start(lbs_private *priv,
+int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					void *pdata_buf);
-int lbs_cmd_80211_deauthenticate(lbs_private *priv,
+int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 					  struct cmd_ds_command *cmd);
-int lbs_cmd_80211_associate(lbs_private *priv,
+int lbs_cmd_80211_associate(struct lbs_private *priv,
 				     struct cmd_ds_command *cmd,
 				     void *pdata_buf);
 
-int lbs_ret_80211_ad_hoc_start(lbs_private *priv,
+int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 					struct cmd_ds_command *resp);
-int lbs_ret_80211_ad_hoc_stop(lbs_private *priv,
+int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv,
 				       struct cmd_ds_command *resp);
-int lbs_ret_80211_disassociate(lbs_private *priv,
+int lbs_ret_80211_disassociate(struct lbs_private *priv,
 					struct cmd_ds_command *resp);
-int lbs_ret_80211_associate(lbs_private *priv,
+int lbs_ret_80211_associate(struct lbs_private *priv,
 				     struct cmd_ds_command *resp);
 
-int lbs_start_adhoc_network(lbs_private *priv,
+int lbs_start_adhoc_network(struct lbs_private *priv,
 			     struct assoc_request * assoc_req);
-int lbs_join_adhoc_network(lbs_private *priv,
+int lbs_join_adhoc_network(struct lbs_private *priv,
 				struct assoc_request * assoc_req);
-int lbs_stop_adhoc_network(lbs_private *priv);
+int lbs_stop_adhoc_network(struct lbs_private *priv);
 
-int lbs_send_deauthentication(lbs_private *priv);
+int lbs_send_deauthentication(struct lbs_private *priv);
 
-int lbs_associate(lbs_private *priv, struct assoc_request *assoc_req);
+int lbs_associate(struct lbs_private *priv, struct assoc_request *assoc_req);
 
 void lbs_unset_basic_rate_flags(u8 *rates, size_t len);
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/main.c
+++ wireless-2.6/drivers/net/wireless/libertas/main.c
@@ -247,8 +247,8 @@
 	return strlen(buf);
 }
 
-int lbs_add_rtap(lbs_private *priv);
-void lbs_remove_rtap(lbs_private *priv);
+int lbs_add_rtap(struct lbs_private *priv);
+void lbs_remove_rtap(struct lbs_private *priv);
 
 /**
  * Get function for sysfs attribute rtap
@@ -256,8 +256,9 @@
 static ssize_t lbs_rtap_get(struct device *dev,
 		struct device_attribute *attr, char * buf)
 {
-	lbs_private *priv = (lbs_private *) (to_net_dev(dev))->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = (struct lbs_private *)
+		(to_net_dev(dev))->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	return snprintf(buf, 5, "0x%X\n", adapter->monitormode);
 }
 
@@ -268,8 +269,9 @@
 		struct device_attribute *attr, const char * buf, size_t count)
 {
 	int monitor_mode;
-	lbs_private *priv = (lbs_private *) (to_net_dev(dev))->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = (struct lbs_private *)
+		(to_net_dev(dev))->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	sscanf(buf, "%x", &monitor_mode);
 	if (monitor_mode != LBS_MONITOR_OFF) {
@@ -332,7 +334,7 @@
 {
 	struct cmd_ds_mesh_access mesh_access;
 	uint32_t datum;
-	lbs_private *priv = (to_net_dev(dev))->priv;
+	struct lbs_private *priv = (to_net_dev(dev))->priv;
 	int ret;
 
 	memset(&mesh_access, 0, sizeof(mesh_access));
@@ -375,8 +377,8 @@
  */
 static int pre_open_check(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int i = 0;
 
 	while (!adapter->fw_ready && i < 20) {
@@ -399,8 +401,8 @@
  */
 static int lbs_dev_open(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
@@ -427,7 +429,7 @@
  */
 static int lbs_mesh_open(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) dev->priv ;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
 
 	if (pre_open_check(dev) == -1)
 		return -1;
@@ -446,7 +448,7 @@
  */
 static int lbs_open(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) dev->priv ;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
 
 	if(pre_open_check(dev) == -1)
 		return -1;
@@ -459,7 +461,7 @@
 
 static int lbs_dev_close(struct net_device *dev)
 {
-	lbs_private *priv = dev->priv;
+	struct lbs_private *priv = dev->priv;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
@@ -478,7 +480,7 @@
  */
 static int lbs_mesh_close(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) (dev->priv);
+	struct lbs_private *priv = (struct lbs_private *) (dev->priv);
 
 	priv->mesh_open = 0;
 	netif_stop_queue(priv->mesh_dev);
@@ -496,7 +498,7 @@
  */
 static int lbs_close(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) dev->priv;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 
 	netif_stop_queue(dev);
 	priv->infra_open = 0;
@@ -510,7 +512,7 @@
 static int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
+	struct lbs_private *priv = dev->priv;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
@@ -537,7 +539,7 @@
 static int lbs_mesh_pre_start_xmit(struct sk_buff *skb,
 		struct net_device *dev)
 {
-	lbs_private *priv = dev->priv;
+	struct lbs_private *priv = dev->priv;
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_MESH);
@@ -559,7 +561,7 @@
  */
 static int lbs_pre_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	lbs_private *priv = dev->priv;
+	struct lbs_private *priv = dev->priv;
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_NET);
@@ -578,7 +580,7 @@
 
 static void lbs_tx_timeout(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) dev->priv;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 
 	lbs_deb_enter(LBS_DEB_TX);
 
@@ -607,12 +609,12 @@
 /**
  *  @brief This function returns the network statistics
  *
- *  @param dev     A pointer to lbs_private structure
+ *  @param dev     A pointer to struct lbs_private structure
  *  @return 	   A pointer to net_device_stats structure
  */
 static struct net_device_stats *lbs_get_stats(struct net_device *dev)
 {
-	lbs_private *priv = (lbs_private *) dev->priv;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 
 	return &priv->stats;
 }
@@ -620,8 +622,8 @@
 static int lbs_set_mac_address(struct net_device *dev, void *addr)
 {
 	int ret = 0;
-	lbs_private *priv = (lbs_private *) dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct sockaddr *phwaddr = addr;
 
 	lbs_deb_enter(LBS_DEB_NET);
@@ -657,7 +659,7 @@
 	return ret;
 }
 
-static int lbs_copy_multicast_address(lbs_adapter *adapter,
+static int lbs_copy_multicast_address(struct lbs_adapter *adapter,
 				     struct net_device *dev)
 {
 	int i = 0;
@@ -674,8 +676,8 @@
 
 static void lbs_set_multicast_list(struct net_device *dev)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int oldpacketfilter;
 	DECLARE_MAC_BUF(mac);
 
@@ -755,8 +757,8 @@
 static int lbs_thread(void *data)
 {
 	struct net_device *dev = data;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	wait_queue_t wait;
 	u8 ireg = 0;
 
@@ -918,13 +920,13 @@
  *  HW spec from firmware and set basic parameters to
  *  firmware.
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @return 	   0 or -1
  */
-static int lbs_setup_firmware(lbs_private *priv)
+static int lbs_setup_firmware(struct lbs_private *priv)
 {
 	int ret = -1;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_mesh_access mesh_access;
 
 	lbs_deb_enter(LBS_DEB_FW);
@@ -985,8 +987,8 @@
  */
 static void command_timer_fn(unsigned long data)
 {
-	lbs_private *priv = (lbs_private *)data;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = (struct lbs_private *)data;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *ptempnode;
 	struct cmd_ds_command *cmd;
 	unsigned long flags;
@@ -1020,9 +1022,9 @@
 	return;
 }
 
-static int lbs_init_adapter(lbs_private *priv)
+static int lbs_init_adapter(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	size_t bufsize;
 	int i, ret = 0;
 
@@ -1090,9 +1092,9 @@
 	return ret;
 }
 
-static void lbs_free_adapter(lbs_private *priv)
+static void lbs_free_adapter(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	if (!adapter) {
 		lbs_deb_fw("why double free adapter?\n");
@@ -1120,25 +1122,27 @@
  * card, allocate the lbs_priv and initialize the device.
  *
  *  @param card    A pointer to card
- *  @return 	   A pointer to lbs_private structure
+ *  @return 	   A pointer to struct lbs_private structure
  */
-lbs_private *lbs_add_card(void *card, struct device *dmdev)
+struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 {
 	struct net_device *dev = NULL;
-	lbs_private *priv = NULL;
+	struct lbs_private *priv = NULL;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
 	/* Allocate an Ethernet device and register it */
-	if (!(dev = alloc_etherdev(sizeof(lbs_private)))) {
+	dev = alloc_etherdev(sizeof(struct lbs_private));
+	if (!dev) {
 		lbs_pr_err("init ethX device failed\n");
 		goto done;
 	}
 	priv = dev->priv;
 
-	/* allocate buffer for lbs_adapter */
-	if (!(priv->adapter = kzalloc(sizeof(lbs_adapter), GFP_KERNEL))) {
-		lbs_pr_err("allocate buffer for lbs_adapter failed\n");
+	/* allocate buffer for struct lbs_adapter */
+	priv->adapter = kzalloc(sizeof(struct lbs_adapter), GFP_KERNEL);
+	if (!priv->adapter) {
+		lbs_pr_err("allocate buffer for struct lbs_adapter failed\n");
 		goto err_kzalloc;
 	}
 
@@ -1208,9 +1212,9 @@
 EXPORT_SYMBOL_GPL(lbs_add_card);
 
 
-int lbs_remove_card(lbs_private *priv)
+int lbs_remove_card(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct net_device *dev = priv->dev;
 	union iwreq_data wrqu;
 
@@ -1249,7 +1253,7 @@
 EXPORT_SYMBOL_GPL(lbs_remove_card);
 
 
-int lbs_start_card(lbs_private *priv)
+int lbs_start_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
 	int ret = -1;
@@ -1282,7 +1286,7 @@
 EXPORT_SYMBOL_GPL(lbs_start_card);
 
 
-int lbs_stop_card(lbs_private *priv)
+int lbs_stop_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
 	int ret = -1;
@@ -1315,10 +1319,10 @@
 /**
  * @brief This function adds mshX interface
  *
- *  @param priv    A pointer to the lbs_private structure
+ *  @param priv    A pointer to the struct lbs_private structure
  *  @return 	   0 if successful, -X otherwise
  */
-int lbs_add_mesh(lbs_private *priv, struct device *dev)
+int lbs_add_mesh(struct lbs_private *priv, struct device *dev)
 {
 	struct net_device *mesh_dev = NULL;
 	int ret = 0;
@@ -1378,7 +1382,7 @@
 EXPORT_SYMBOL_GPL(lbs_add_mesh);
 
 
-void lbs_remove_mesh(lbs_private *priv)
+void lbs_remove_mesh(struct lbs_private *priv)
 {
 	struct net_device *mesh_dev;
 
@@ -1434,9 +1438,9 @@
 	return NULL;
 }
 
-int lbs_set_regiontable(lbs_private *priv, u8 region, u8 band)
+int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	int i = 0;
 
@@ -1478,7 +1482,7 @@
  */
 void lbs_interrupt(struct net_device *dev)
 {
-	lbs_private *priv = dev->priv;
+	struct lbs_private *priv = dev->priv;
 
 	lbs_deb_enter(LBS_DEB_THREAD);
 
@@ -1500,7 +1504,7 @@
 }
 EXPORT_SYMBOL_GPL(lbs_interrupt);
 
-int lbs_reset_device(lbs_private *priv)
+int lbs_reset_device(struct lbs_private *priv)
 {
 	int ret;
 
@@ -1555,12 +1559,12 @@
 
 static struct net_device_stats *lbs_rtap_get_stats(struct net_device *dev)
 {
-	lbs_private *priv = dev->priv;
+	struct lbs_private *priv = dev->priv;
 	return &priv->ieee->stats;
 }
 
 
-void lbs_remove_rtap(lbs_private *priv)
+void lbs_remove_rtap(struct lbs_private *priv)
 {
 	if (priv->rtap_net_dev == NULL)
 		return;
@@ -1569,7 +1573,7 @@
 	priv->rtap_net_dev = NULL;
 }
 
-int lbs_add_rtap(lbs_private *priv)
+int lbs_add_rtap(struct lbs_private *priv)
 {
 	int rc = 0;
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/rx.c
+++ wireless-2.6/drivers/net/wireless/libertas/rx.c
@@ -35,19 +35,20 @@
 	void *eth80211_hdr;
 } __attribute__ ((packed));
 
-static int process_rxed_802_11_packet(lbs_private *priv, struct sk_buff *skb);
+static int process_rxed_802_11_packet(struct lbs_private *priv,
+	struct sk_buff *skb);
 
 /**
  *  @brief This function computes the avgSNR .
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @return 	   avgSNR
  */
-static u8 lbs_getavgsnr(lbs_private *priv)
+static u8 lbs_getavgsnr(struct lbs_private *priv)
 {
 	u8 i;
 	u16 temp = 0;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	if (adapter->numSNRNF == 0)
 		return 0;
 	for (i = 0; i < adapter->numSNRNF; i++)
@@ -59,14 +60,14 @@
 /**
  *  @brief This function computes the AvgNF
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @return 	   AvgNF
  */
-static u8 lbs_getavgnf(lbs_private *priv)
+static u8 lbs_getavgnf(struct lbs_private *priv)
 {
 	u8 i;
 	u16 temp = 0;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	if (adapter->numSNRNF == 0)
 		return 0;
 	for (i = 0; i < adapter->numSNRNF; i++)
@@ -78,13 +79,13 @@
 /**
  *  @brief This function save the raw SNR/NF to our internel buffer
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @param prxpd   A pointer to rxpd structure of received packet
  *  @return 	   n/a
  */
-static void lbs_save_rawSNRNF(lbs_private *priv, struct rxpd *p_rx_pd)
+static void lbs_save_rawSNRNF(struct lbs_private *priv, struct rxpd *p_rx_pd)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	if (adapter->numSNRNF < DEFAULT_DATA_AVG_FACTOR)
 		adapter->numSNRNF++;
 	adapter->rawSNR[adapter->nextSNRNF] = p_rx_pd->snr;
@@ -98,13 +99,13 @@
 /**
  *  @brief This function computes the RSSI in received packet.
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @param prxpd   A pointer to rxpd structure of received packet
  *  @return 	   n/a
  */
-static void lbs_compute_rssi(lbs_private *priv, struct rxpd *p_rx_pd)
+static void lbs_compute_rssi(struct lbs_private *priv, struct rxpd *p_rx_pd)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_RX);
 
@@ -134,7 +135,7 @@
 	lbs_deb_leave(LBS_DEB_RX);
 }
 
-void lbs_upload_rx_packet(lbs_private *priv, struct sk_buff *skb)
+void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb)
 {
 	lbs_deb_rx("skb->data %p\n", skb->data);
 
@@ -154,13 +155,13 @@
  *  @brief This function processes received packet and forwards it
  *  to kernel/upper layer
  *
- *  @param priv    A pointer to lbs_private
+ *  @param priv    A pointer to struct lbs_private
  *  @param skb     A pointer to skb which includes the received packet
  *  @return 	   0 or -1
  */
-int lbs_process_rxed_packet(lbs_private *priv, struct sk_buff *skb)
+int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	struct rxpackethdr *p_rx_pkt;
@@ -319,13 +320,14 @@
  *  @brief This function processes a received 802.11 packet and forwards it
  *  to kernel/upper layer
  *
- *  @param priv    A pointer to lbs_private
+ *  @param priv    A pointer to struct lbs_private
  *  @param skb     A pointer to skb which includes the received packet
  *  @return 	   0 or -1
  */
-static int process_rxed_802_11_packet(lbs_private *priv, struct sk_buff *skb)
+static int process_rxed_802_11_packet(struct lbs_private *priv,
+	struct sk_buff *skb)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	struct rx80211packethdr *p_rx_pkt;
--- wireless-2.6.orig/drivers/net/wireless/libertas/scan.c
+++ wireless-2.6/drivers/net/wireless/libertas/scan.c
@@ -163,13 +163,13 @@
  *    0       0        0       0     !=NONE     1      0    0   yes Dynamic WEP
  *
  *
- *  @param adapter A pointer to lbs_adapter
+ *  @param adapter A pointer to struct lbs_adapter
  *  @param index   Index in scantable to check against current driver settings
  *  @param mode    Network mode: Infrastructure or IBSS
  *
  *  @return        Index in scantable, or error code if negative
  */
-static int is_network_compatible(lbs_adapter *adapter,
+static int is_network_compatible(struct lbs_adapter *adapter,
 		struct bss_descriptor * bss, u8 mode)
 {
 	int matched = 0;
@@ -262,7 +262,7 @@
  *    of channels to scan.  This routine is used for any scan that is not
  *    provided a specific channel list to scan.
  *
- *  @param priv          A pointer to lbs_private structure
+ *  @param priv          A pointer to struct lbs_private structure
  *  @param scanchanlist  Output parameter: resulting channel list to scan
  *  @param filteredscan  Flag indicating whether or not a BSSID or SSID filter
  *                       is being sent in the command to firmware.  Used to
@@ -272,12 +272,12 @@
  *
  *  @return              void
  */
-static void lbs_scan_create_channel_list(lbs_private *priv,
+static void lbs_scan_create_channel_list(struct lbs_private *priv,
 					  struct chanscanparamset * scanchanlist,
 					  u8 filteredscan)
 {
 
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct region_channel *scanregion;
 	struct chan_freq_power *cfp;
 	int rgnidx;
@@ -359,7 +359,9 @@
 /* Delayed partial scan worker */
 void lbs_scan_worker(struct work_struct *work)
 {
-	lbs_private *priv = container_of(work, lbs_private, scan_work.work);
+	struct lbs_private *priv = container_of(work,
+		struct lbs_private,
+		scan_work.work);
 
 	lbs_scan_networks(priv, NULL, 0);
 }
@@ -385,7 +387,7 @@
  *  If the number of probes is not set, use the adapter default setting
  *  Qualify the channel
  *
- *  @param priv             A pointer to lbs_private structure
+ *  @param priv             A pointer to struct lbs_private structure
  *  @param puserscanin      NULL or pointer to scan configuration parameters
  *  @param ppchantlvout     Output parameter: Pointer to the start of the
  *                          channel TLV portion of the output scan config
@@ -404,7 +406,7 @@
  *  @return                 resulting scan configuration
  */
 static struct lbs_scan_cmd_config *
-lbs_scan_setup_scan_config(lbs_private *priv,
+lbs_scan_setup_scan_config(struct lbs_private *priv,
 			    const struct lbs_ioctl_user_scan_cfg *puserscanin,
 			    struct mrvlietypes_chanlistparamset ** ppchantlvout,
 			    struct chanscanparamset * pscanchanlist,
@@ -586,7 +588,7 @@
  *   and sends the portion of the channel TLV along with the other TLVs
  *   to the lbs_cmd routines for execution in the firmware.
  *
- *  @param priv            A pointer to lbs_private structure
+ *  @param priv            A pointer to struct lbs_private structure
  *  @param maxchanperscan  Maximum number channels to be included in each
  *                         scan command sent to firmware
  *  @param filteredscan    Flag indicating whether or not a BSSID or SSID
@@ -600,7 +602,7 @@
  *
  *  @return                0 or error return otherwise
  */
-static int lbs_scan_channel_list(lbs_private *priv,
+static int lbs_scan_channel_list(struct lbs_private *priv,
 				  int maxchanperscan,
 				  u8 filteredscan,
 				  struct lbs_scan_cmd_config *pscancfgout,
@@ -753,7 +755,7 @@
 /*
  * Only used from lbs_scan_networks()
 */
-static void clear_selected_scan_list_entries(lbs_adapter *adapter,
+static void clear_selected_scan_list_entries(struct lbs_adapter *adapter,
 	const struct lbs_ioctl_user_scan_cfg *scan_cfg)
 {
 	struct bss_descriptor *bss;
@@ -812,18 +814,18 @@
  *    order to send the appropriate scan commands to firmware to populate or
  *    update the internal driver scan table
  *
- *  @param priv          A pointer to lbs_private structure
+ *  @param priv          A pointer to struct lbs_private structure
  *  @param puserscanin   Pointer to the input configuration for the requested
  *                       scan.
  *  @param full_scan     ???
  *
  *  @return              0 or < 0 if error
  */
-int lbs_scan_networks(lbs_private *priv,
+int lbs_scan_networks(struct lbs_private *priv,
 	const struct lbs_ioctl_user_scan_cfg *puserscanin,
                        int full_scan)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct mrvlietypes_chanlistparamset *pchantlvout;
 	struct chanscanparamset * scan_chan_list = NULL;
 	struct lbs_scan_cmd_config *scan_cfg = NULL;
@@ -1153,13 +1155,13 @@
  *
  *  Used in association code
  *
- *  @param adapter  A pointer to lbs_adapter
+ *  @param adapter  A pointer to struct lbs_adapter
  *  @param bssid    BSSID to find in the scan list
  *  @param mode     Network mode: Infrastructure or IBSS
  *
  *  @return         index in BSSID list, or error return code (< 0)
  */
-struct bss_descriptor *lbs_find_bssid_in_list(lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_adapter *adapter,
 		u8 * bssid, u8 mode)
 {
 	struct bss_descriptor * iter_bss;
@@ -1205,14 +1207,14 @@
  *
  *  Used in association code
  *
- *  @param adapter  A pointer to lbs_adapter
+ *  @param adapter  A pointer to struct lbs_adapter
  *  @param ssid     SSID to find in the list
  *  @param bssid    BSSID to qualify the SSID selection (if provided)
  *  @param mode     Network mode: Infrastructure or IBSS
  *
  *  @return         index in BSSID list
  */
-struct bss_descriptor *lbs_find_ssid_in_list(lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_adapter *adapter,
 		   u8 *ssid, u8 ssid_len, u8 * bssid, u8 mode,
 		   int channel)
 {
@@ -1277,12 +1279,13 @@
  *  Search the scan table for the best SSID that also matches the current
  *   adapter network preference (infrastructure or adhoc)
  *
- *  @param adapter  A pointer to lbs_adapter
+ *  @param adapter  A pointer to struct lbs_adapter
  *
  *  @return         index in BSSID list
  */
-static struct bss_descriptor *lbs_find_best_ssid_in_list(lbs_adapter *adapter,
-		u8 mode)
+static struct bss_descriptor *lbs_find_best_ssid_in_list(
+	struct lbs_adapter *adapter,
+	u8 mode)
 {
 	u8 bestrssi = 0;
 	struct bss_descriptor * iter_bss;
@@ -1323,15 +1326,15 @@
  *
  *  Used from association worker.
  *
- *  @param priv         A pointer to lbs_private structure
+ *  @param priv         A pointer to struct lbs_private structure
  *  @param pSSID        A pointer to AP's ssid
  *
  *  @return             0--success, otherwise--fail
  */
-int lbs_find_best_network_ssid(lbs_private *priv,
+int lbs_find_best_network_ssid(struct lbs_private *priv,
 		u8 *out_ssid, u8 *out_ssid_len, u8 preferred_mode, u8 *out_mode)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = -1;
 	struct bss_descriptor * found;
 
@@ -1369,8 +1372,8 @@
 int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
@@ -1392,7 +1395,7 @@
  *
  *  Used in association code and from debugfs
  *
- *  @param priv             A pointer to lbs_private structure
+ *  @param priv             A pointer to struct lbs_private structure
  *  @param ssid             A pointer to the SSID to scan for
  *  @param ssid_len         Length of the SSID
  *  @param clear_ssid       Should existing scan results with this SSID
@@ -1402,10 +1405,10 @@
  *
  *  @return                0-success, otherwise fail
  */
-int lbs_send_specific_ssid_scan(lbs_private *priv,
+int lbs_send_specific_ssid_scan(struct lbs_private *priv,
 			u8 *ssid, u8 ssid_len, u8 clear_ssid)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_ioctl_user_scan_cfg scancfg;
 	int ret = 0;
 
@@ -1443,11 +1446,11 @@
 
 #define MAX_CUSTOM_LEN 64
 
-static inline char *lbs_translate_scan(lbs_private *priv,
+static inline char *lbs_translate_scan(struct lbs_private *priv,
 					char *start, char *stop,
 					struct bss_descriptor *bss)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct chan_freq_power *cfp;
 	char *current_val;	/* For rates */
 	struct iw_event iwe;	/* Temporary buffer */
@@ -1610,8 +1613,8 @@
 		  struct iw_point *dwrq, char *extra)
 {
 #define SCAN_ITEM_SIZE 128
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int err = 0;
 	char *ev = extra;
 	char *stop = ev + dwrq->length;
@@ -1682,7 +1685,7 @@
  *  Sends a fixed lenght data part (specifying the BSS type and BSSID filters)
  *  as well as a variable number/length of TLVs to the firmware.
  *
- *  @param priv       A pointer to lbs_private structure
+ *  @param priv       A pointer to struct lbs_private structure
  *  @param cmd        A pointer to cmd_ds_command structure to be sent to
  *                    firmware with the cmd_DS_801_11_SCAN structure
  *  @param pdata_buf  Void pointer cast of a lbs_scan_cmd_config struct used
@@ -1690,7 +1693,7 @@
  *
  *  @return           0 or -1
  */
-int lbs_cmd_80211_scan(lbs_private *priv,
+int lbs_cmd_80211_scan(struct lbs_private *priv,
 			 struct cmd_ds_command *cmd, void *pdata_buf)
 {
 	struct cmd_ds_802_11_scan *pscan = &cmd->params.scan;
@@ -1750,14 +1753,14 @@
  *     |            bufsize and sizeof the fixed fields above)     |
  *     .-----------------------------------------------------------.
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @param resp    A pointer to cmd_ds_command
  *
  *  @return        0 or -1
  */
-int lbs_ret_80211_scan(lbs_private *priv, struct cmd_ds_command *resp)
+int lbs_ret_80211_scan(struct lbs_private *priv, struct cmd_ds_command *resp)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_scan_rsp *pscan;
 	struct bss_descriptor * iter_bss;
 	struct bss_descriptor * safe;
--- wireless-2.6.orig/drivers/net/wireless/libertas/scan.h
+++ wireless-2.6/drivers/net/wireless/libertas/scan.h
@@ -10,6 +10,8 @@
 #include <net/ieee80211.h>
 #include "hostcmd.h"
 
+struct lbs_adapter;
+
 /**
  *  @brief Maximum number of channels that can be sent in a setuserscan ioctl
  *
@@ -176,27 +178,27 @@
 
 int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len);
 
-struct bss_descriptor *lbs_find_ssid_in_list(lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_adapter *adapter,
 		u8 *ssid, u8 ssid_len, u8 *bssid, u8 mode,
 		int channel);
 
-struct bss_descriptor *lbs_find_bssid_in_list(lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_adapter *adapter,
 	u8 *bssid, u8 mode);
 
-int lbs_find_best_network_ssid(lbs_private *priv, u8 *out_ssid,
+int lbs_find_best_network_ssid(struct lbs_private *priv, u8 *out_ssid,
 			u8 *out_ssid_len, u8 preferred_mode, u8 *out_mode);
 
-int lbs_send_specific_ssid_scan(lbs_private *priv, u8 *ssid,
+int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
 				u8 ssid_len, u8 clear_ssid);
 
-int lbs_cmd_80211_scan(lbs_private *priv,
+int lbs_cmd_80211_scan(struct lbs_private *priv,
 				struct cmd_ds_command *cmd,
 				void *pdata_buf);
 
-int lbs_ret_80211_scan(lbs_private *priv,
+int lbs_ret_80211_scan(struct lbs_private *priv,
 				struct cmd_ds_command *resp);
 
-int lbs_scan_networks(lbs_private *priv,
+int lbs_scan_networks(struct lbs_private *priv,
 	const struct lbs_ioctl_user_scan_cfg *puserscanin,
                 int full_scan);
 
--- wireless-2.6.orig/drivers/net/wireless/libertas/tx.c
+++ wireless-2.6/drivers/net/wireless/libertas/tx.c
@@ -52,11 +52,11 @@
  *  @brief This function processes a single packet and sends
  *  to IF layer
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @param skb     A pointer to skb which includes TX packet
  *  @return 	   0 or -1
  */
-static int SendSinglePacket(lbs_private *priv, struct sk_buff *skb)
+static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
 {
 	int ret = 0;
 	struct txpd localtxpd;
@@ -164,9 +164,9 @@
 }
 
 
-void lbs_tx_runqueue(lbs_private *priv)
+void lbs_tx_runqueue(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	int i;
 
 	spin_lock(&adapter->txqueue_lock);
@@ -180,9 +180,9 @@
 	spin_unlock(&adapter->txqueue_lock);
 }
 
-static void lbs_tx_queue(lbs_private *priv, struct sk_buff *skb)
+static void lbs_tx_queue(struct lbs_private *priv, struct sk_buff *skb)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	spin_lock(&adapter->txqueue_lock);
 
@@ -205,10 +205,10 @@
  *  @brief This function checks the conditions and sends packet to IF
  *  layer if everything is ok.
  *
- *  @param priv    A pointer to lbs_private structure
+ *  @param priv    A pointer to struct lbs_private structure
  *  @return 	   n/a
  */
-int lbs_process_tx(lbs_private *priv, struct sk_buff *skb)
+int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
 {
 	int ret = -1;
 
@@ -239,14 +239,14 @@
  *  @brief This function sends to the host the last transmitted packet,
  *  filling the radiotap headers with transmission information.
  *
- *  @param priv     A pointer to lbs_private structure
+ *  @param priv     A pointer to struct lbs_private structure
  *  @param status   A 32 bit value containing transmission status.
  *
  *  @returns void
  */
-void lbs_send_tx_feedback(lbs_private *priv)
+void lbs_send_tx_feedback(struct lbs_private *priv)
 {
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct tx_radiotap_hdr *radiotap_hdr;
 	u32 status = adapter->eventcause;
 	int txfail;
--- wireless-2.6.orig/drivers/net/wireless/libertas/wext.c
+++ wireless-2.6/drivers/net/wireless/libertas/wext.c
@@ -21,7 +21,7 @@
 #include "assoc.h"
 
 
-static inline void lbs_postpone_association_work(lbs_private *priv)
+static inline void lbs_postpone_association_work(struct lbs_private *priv)
 {
 	if (priv->adapter->surpriseremoved)
 		return;
@@ -29,7 +29,7 @@
 	queue_delayed_work(priv->work_thread, &priv->assoc_work, HZ / 2);
 }
 
-static inline void lbs_cancel_association_work(lbs_private *priv)
+static inline void lbs_cancel_association_work(struct lbs_private *priv)
 {
 	cancel_delayed_work(&priv->assoc_work);
 	if (priv->adapter->pending_assoc_req) {
@@ -42,13 +42,15 @@
 /**
  *  @brief Find the channel frequency power info with specific channel
  *
- *  @param adapter 	A pointer to lbs_adapter structure
+ *  @param adapter 	A pointer to struct lbs_adapter structure
  *  @param band		it can be BAND_A, BAND_G or BAND_B
  *  @param channel      the channel for looking
  *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
  */
-struct chan_freq_power *lbs_find_cfp_by_band_and_channel(lbs_adapter *adapter,
-						 u8 band, u16 channel)
+struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
+	struct lbs_adapter *adapter,
+	u8 band,
+	u16 channel)
 {
 	struct chan_freq_power *cfp = NULL;
 	struct region_channel *rc;
@@ -83,13 +85,15 @@
 /**
  *  @brief Find the channel frequency power info with specific frequency
  *
- *  @param adapter 	A pointer to lbs_adapter structure
+ *  @param adapter 	A pointer to struct lbs_adapter structure
  *  @param band		it can be BAND_A, BAND_G or BAND_B
  *  @param freq	        the frequency for looking
  *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
  */
-static struct chan_freq_power *find_cfp_by_band_and_freq(lbs_adapter *adapter,
-						     u8 band, u32 freq)
+static struct chan_freq_power *find_cfp_by_band_and_freq(
+	struct lbs_adapter *adapter,
+	u8 band,
+	u32 freq)
 {
 	struct chan_freq_power *cfp = NULL;
 	struct region_channel *rc;
@@ -125,14 +129,14 @@
 /**
  *  @brief Set Radio On/OFF
  *
- *  @param priv                 A pointer to lbs_private structure
+ *  @param priv                 A pointer to struct lbs_private structure
  *  @option 			Radio Option
  *  @return 	   		0 --success, otherwise fail
  */
-static int lbs_radio_ioctl(lbs_private *priv, u8 option)
+static int lbs_radio_ioctl(struct lbs_private *priv, u8 option)
 {
 	int ret = 0;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -153,10 +157,10 @@
 /**
  *  @brief Copy active data rates based on adapter mode and status
  *
- *  @param adapter              A pointer to lbs_adapter structure
+ *  @param adapter              A pointer to struct lbs_adapter structure
  *  @param rate		        The buf to return the active rates
  */
-static void copy_active_data_rates(lbs_adapter *adapter, u8 *rates)
+static void copy_active_data_rates(struct lbs_adapter *adapter, u8 *rates)
 {
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -184,8 +188,8 @@
 static int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_freq *fwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct chan_freq_power *cfp;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
@@ -211,8 +215,8 @@
 static int lbs_get_wap(struct net_device *dev, struct iw_request_info *info,
 			struct sockaddr *awrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -230,8 +234,8 @@
 static int lbs_set_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -255,8 +259,8 @@
 static int lbs_get_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -273,8 +277,8 @@
 static int mesh_get_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -299,8 +303,8 @@
 			struct iw_param *vwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	u32 rthr = vwrq->value;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
@@ -325,8 +329,8 @@
 			struct iw_param *vwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -352,8 +356,8 @@
 {
 	int ret = 0;
 	u32 fthr = vwrq->value;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -378,8 +382,8 @@
 			 struct iw_param *vwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -404,8 +408,8 @@
 static int lbs_get_mode(struct net_device *dev,
 			 struct iw_request_info *info, u32 * uwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -432,8 +436,8 @@
 			  struct iw_param *vwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -464,8 +468,8 @@
 			  struct iw_param *vwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -499,8 +503,8 @@
 static int lbs_get_retry(struct net_device *dev, struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
@@ -568,8 +572,8 @@
 			  struct iw_point *dwrq, char *extra)
 {
 	int i, j;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct iw_range *range = (struct iw_range *)extra;
 	struct chan_freq_power *cfp;
 	u8 rates[MAX_RATES + 1];
@@ -745,8 +749,8 @@
 static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -789,8 +793,8 @@
 static int lbs_get_power(struct net_device *dev, struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int mode;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
@@ -820,8 +824,8 @@
 		EXCELLENT = 95,
 		PERFECT = 100
 	};
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	u32 rssi_qual;
 	u32 tx_qual;
 	u32 quality = 0;
@@ -923,8 +927,8 @@
 		  struct iw_freq *fwrq, char *extra)
 {
 	int ret = -EINVAL;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct chan_freq_power *cfp;
 	struct assoc_request * assoc_req;
 
@@ -980,8 +984,8 @@
 static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	u32 new_rate;
 	u16 action;
 	int ret = -EINVAL;
@@ -1024,8 +1028,8 @@
 static int lbs_get_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -1050,8 +1054,8 @@
 		  struct iw_request_info *info, u32 * uwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
@@ -1096,8 +1100,8 @@
 			   struct iw_request_info *info,
 			   struct iw_point *dwrq, u8 * extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
@@ -1301,8 +1305,8 @@
 		    struct iw_point *dwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 	u16 is_default = 0, index = 0, set_tx_key = 0;
 
@@ -1378,8 +1382,8 @@
 			      char *extra)
 {
 	int ret = -EINVAL;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int index, max_key_len;
 
@@ -1485,8 +1489,8 @@
 			      char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int alg = ext->alg;
 	struct assoc_request * assoc_req;
@@ -1610,8 +1614,8 @@
 			  struct iw_point *dwrq,
 			  char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct assoc_request * assoc_req;
 
@@ -1657,8 +1661,8 @@
 			  char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -1686,8 +1690,8 @@
 			 struct iw_param *dwrq,
 			 char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 	int ret = 0;
 	int updated = 0;
@@ -1786,8 +1790,8 @@
 			 char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -1824,8 +1828,8 @@
 		   struct iw_param *vwrq, char *extra)
 {
 	int ret = 0;
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	u16 dbm;
 
@@ -1866,8 +1870,8 @@
 static int lbs_get_essid(struct net_device *dev, struct iw_request_info *info,
 		   struct iw_point *dwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -1902,8 +1906,8 @@
 static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 		   struct iw_point *dwrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u8 ssid[IW_ESSID_MAX_SIZE];
 	u8 ssid_len = 0;
@@ -1974,8 +1978,8 @@
 static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
 		 struct sockaddr *awrq, char *extra)
 {
-	lbs_private *priv = dev->priv;
-	lbs_adapter *adapter = priv->adapter;
+	struct lbs_private *priv = dev->priv;
+	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 	int ret = 0;
 	DECLARE_MAC_BUF(mac);
@@ -2006,7 +2010,7 @@
 	return ret;
 }
 
-void lbs_get_fwversion(lbs_adapter *adapter, char *fwversion, int maxlen)
+void lbs_get_fwversion(struct lbs_adapter *adapter, char *fwversion, int maxlen)
 {
 	char fwver[32];
 
