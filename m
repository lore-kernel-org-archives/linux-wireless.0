Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbYHUVpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 17:45:14 -0400
Subject: [PATCH 1/3] libertas: convert CMD_802_11_DEAUTHENTICATE to a
	direct command
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1219173335.23157.13.camel@localhost.localdomain>
References: <1219173335.23157.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 17:46:18 -0400
Message-Id: <1219355178.13058.4.camel@localhost.localdomain> (sfid-20080821_234520_796587_9BA6D469)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and remove DISASSOCIATE because it's not in any of the specs and has
never been used.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index a267d6e..5072a89 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1029,7 +1029,9 @@ void lbs_association_worker(struct work_struct *work)
 	 */
 	if (priv->mode == IW_MODE_INFRA) {
 		if (should_deauth_infrastructure(priv, assoc_req)) {
-			ret = lbs_send_deauthentication(priv);
+			ret = lbs_cmd_80211_deauthenticate(priv,
+							   priv->curbssparams.bssid,
+							   WLAN_REASON_DEAUTH_LEAVING);
 			if (ret) {
 				lbs_deb_assoc("Deauthentication due to new "
 					"configuration request failed: %d\n",
@@ -1290,18 +1292,6 @@ static void lbs_set_basic_rate_flags(u8 *rates, size_t len)
 }
 
 /**
- *  @brief Send Deauthentication Request
- *
- *  @param priv      A pointer to struct lbs_private structure
- *  @return          0--success, -1--fail
- */
-int lbs_send_deauthentication(struct lbs_private *priv)
-{
-	return lbs_prepare_and_send_command(priv, CMD_802_11_DEAUTHENTICATE,
-				     0, CMD_OPTION_WAITFORRSP, 0, NULL);
-}
-
-/**
  *  @brief This function prepares command of authenticate.
  *
  *  @param priv      A pointer to struct lbs_private structure
@@ -1353,26 +1343,37 @@ out:
 	return ret;
 }
 
-int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
-				   struct cmd_ds_command *cmd)
+/**
+ *  @brief Deauthenticate from a specific BSS
+ *
+ *  @param priv        A pointer to struct lbs_private structure
+ *  @param bssid       The specific BSS to deauthenticate from
+ *  @param reason      The 802.11 sec. 7.3.1.7 Reason Code for deauthenticating
+ *
+ *  @return            0 on success, error on failure
+ */
+int lbs_cmd_80211_deauthenticate(struct lbs_private *priv, u8 bssid[ETH_ALEN],
+				 u16 reason)
 {
-	struct cmd_ds_802_11_deauthenticate *dauth = &cmd->params.deauth;
+	struct cmd_ds_802_11_deauthenticate cmd;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_JOIN);
 
-	cmd->command = cpu_to_le16(CMD_802_11_DEAUTHENTICATE);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_deauthenticate) +
-			     S_DS_GEN);
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	memcpy(cmd.macaddr, &bssid[0], ETH_ALEN);
+	cmd.reasoncode = cpu_to_le16(reason);
 
-	/* set AP MAC address */
-	memmove(dauth->macaddr, priv->curbssparams.bssid, ETH_ALEN);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_DEAUTHENTICATE, &cmd);
 
-	/* Reason code 3 = Station is leaving */
-#define REASON_CODE_STA_LEAVING 3
-	dauth->reasoncode = cpu_to_le16(REASON_CODE_STA_LEAVING);
+	/* Clean up everything even if there was an error; can't assume that
+	 * we're still authenticated to the AP after trying to deauth.
+	 */
+	lbs_mac_event_disconnected(priv);
 
 	lbs_deb_leave(LBS_DEB_JOIN);
-	return 0;
+	return ret;
 }
 
 int lbs_cmd_80211_associate(struct lbs_private *priv,
@@ -1815,16 +1816,6 @@ done:
 	return ret;
 }
 
-int lbs_ret_80211_disassociate(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	lbs_mac_event_disconnected(priv);
-
-	lbs_deb_leave(LBS_DEB_JOIN);
-	return 0;
-}
-
 int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 				 struct cmd_ds_command *resp)
 {
diff --git a/drivers/net/wireless/libertas/assoc.h b/drivers/net/wireless/libertas/assoc.h
index c516fbe..92ba2c2 100644
--- a/drivers/net/wireless/libertas/assoc.h
+++ b/drivers/net/wireless/libertas/assoc.h
@@ -20,7 +20,7 @@ int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					void *pdata_buf);
 int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
-					  struct cmd_ds_command *cmd);
+				 u8 bssid[ETH_ALEN], u16 reason);
 int lbs_cmd_80211_associate(struct lbs_private *priv,
 				     struct cmd_ds_command *cmd,
 				     void *pdata_buf);
@@ -28,12 +28,9 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 					struct cmd_ds_command *resp);
 int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv);
-int lbs_ret_80211_disassociate(struct lbs_private *priv);
 int lbs_ret_80211_associate(struct lbs_private *priv,
 				     struct cmd_ds_command *resp);
 
 int lbs_stop_adhoc_network(struct lbs_private *priv);
 
-int lbs_send_deauthentication(struct lbs_private *priv);
-
 #endif /* _LBS_ASSOC_H */
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c0db988..8364a2f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1413,10 +1413,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_80211_associate(priv, cmdptr, pdata_buf);
 		break;
 
-	case CMD_802_11_DEAUTHENTICATE:
-		ret = lbs_cmd_80211_deauthenticate(priv, cmdptr);
-		break;
-
 	case CMD_802_11_AD_HOC_START:
 		ret = lbs_cmd_80211_ad_hoc_start(priv, cmdptr, pdata_buf);
 		break;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index dfaf03a..c94604c 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -258,11 +258,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_80211_associate(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_DISASSOCIATE):
-	case CMD_RET(CMD_802_11_DEAUTHENTICATE):
-		ret = lbs_ret_80211_disassociate(priv);
-		break;
-
 	case CMD_RET(CMD_802_11_AD_HOC_START):
 	case CMD_RET(CMD_802_11_AD_HOC_JOIN):
 		ret = lbs_ret_80211_ad_hoc_start(priv, resp);
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 413030f..caebb9b 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -61,7 +61,6 @@
 #define CMD_RF_REG_MAP				0x0023
 #define CMD_802_11_DEAUTHENTICATE		0x0024
 #define CMD_802_11_REASSOCIATE			0x0025
-#define CMD_802_11_DISASSOCIATE			0x0026
 #define CMD_MAC_CONTROL				0x0028
 #define CMD_802_11_AD_HOC_START			0x002b
 #define CMD_802_11_AD_HOC_JOIN			0x002c
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 7f155cd..342c2e3 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -232,7 +232,9 @@ struct cmd_ds_802_11_authenticate {
 };
 
 struct cmd_ds_802_11_deauthenticate {
-	u8 macaddr[6];
+	struct cmd_header hdr;
+
+	u8 macaddr[ETH_ALEN];
 	__le16 reasoncode;
 };
 
@@ -251,11 +253,6 @@ struct cmd_ds_802_11_associate {
 #endif
 } __attribute__ ((packed));
 
-struct cmd_ds_802_11_disassociate {
-	u8 destmacaddr[6];
-	__le16 reasoncode;
-};
-
 struct cmd_ds_802_11_associate_rsp {
 	struct ieeetypes_assocrsp assocRsp;
 };
@@ -697,7 +694,6 @@ struct cmd_ds_command {
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
 		struct cmd_ds_802_11_associate associate;
-		struct cmd_ds_802_11_deauthenticate deauth;
 		struct cmd_ds_802_11_ad_hoc_start ads;
 		struct cmd_ds_802_11_reset reset;
 		struct cmd_ds_802_11_ad_hoc_result result;
@@ -710,7 +706,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_ad_hoc_join adj;
 		struct cmd_ds_802_11_rssi rssi;
 		struct cmd_ds_802_11_rssi_rsp rssirsp;
-		struct cmd_ds_802_11_disassociate dassociate;
 		struct cmd_ds_mac_reg_access macreg;
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 3c13619..5e4c4e4 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -291,7 +291,9 @@ static ssize_t lbs_rtap_set(struct device *dev,
 			if (priv->infra_open || priv->mesh_open)
 				return -EBUSY;
 			if (priv->mode == IW_MODE_INFRA)
-				lbs_send_deauthentication(priv);
+				lbs_cmd_80211_deauthenticate(priv,
+							     priv->curbssparams.bssid,
+							     WLAN_REASON_DEAUTH_LEAVING);
 			else if (priv->mode == IW_MODE_ADHOC)
 				lbs_stop_adhoc_network(priv);
 			lbs_add_rtap(priv);
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 10a8066..38295ee 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -986,7 +986,9 @@ static int lbs_mesh_set_freq(struct net_device *dev,
 	if (fwrq->m != priv->curbssparams.channel) {
 		lbs_deb_wext("mesh channel change forces eth disconnect\n");
 		if (priv->mode == IW_MODE_INFRA)
-			lbs_send_deauthentication(priv);
+			lbs_cmd_80211_deauthenticate(priv,
+						     priv->curbssparams.bssid,
+						     WLAN_REASON_DEAUTH_LEAVING);
 		else if (priv->mode == IW_MODE_ADHOC)
 			lbs_stop_adhoc_network(priv);
 	}


