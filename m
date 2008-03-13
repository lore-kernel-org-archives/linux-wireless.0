Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5460 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYCMKCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 06:02:42 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: convert RSSI to a direct command
Date: Thu, 13 Mar 2008 10:59:44 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803131059.44330.hs4233@mail.mn-solutions.de> (sfid-20080313_100253_335871_59CE3195)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use __lbs_cmd() to get the RSSI values.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-13 09:50:26.000000000 +0100
@@ -454,6 +454,65 @@ static int lbs_cmd_802_11_reset(struct l
 	return 0;
 }
 
+static int lbs_get_rssi_callback(struct lbs_private *priv,
+	unsigned long dummy, struct cmd_header *resp)
+{
+	int ret;
+	struct cmd_ds_802_11_rssi_rsp *rssirsp = (void *) resp;
+
+	ret = le16_to_cpu(rssirsp->hdr.result);
+
+	/* store the non average value */
+	if (!ret) {
+		priv->SNR[TYPE_BEACON][TYPE_NOAVG] =
+			le16_to_cpu(rssirsp->SNR);
+		priv->NF[TYPE_BEACON][TYPE_NOAVG] =
+			le16_to_cpu(rssirsp->noisefloor);
+		priv->SNR[TYPE_BEACON][TYPE_AVG] =
+			le16_to_cpu(rssirsp->avgSNR);
+		priv->NF[TYPE_BEACON][TYPE_AVG] =
+			le16_to_cpu(rssirsp->avgnoisefloor);
+		priv->RSSI[TYPE_BEACON][TYPE_NOAVG] = CAL_RSSI(
+			priv->SNR[TYPE_BEACON][TYPE_NOAVG],
+			priv->NF[TYPE_BEACON][TYPE_NOAVG]);
+		priv->RSSI[TYPE_BEACON][TYPE_AVG] = CAL_RSSI(
+			priv->SNR[TYPE_BEACON][TYPE_AVG] / AVG_SCALE,
+			priv->NF[TYPE_BEACON][TYPE_AVG] / AVG_SCALE);
+		lbs_deb_cmd("RSSI: beacon %d, avg %d\n",
+			priv->RSSI[TYPE_BEACON][TYPE_NOAVG],
+			priv->RSSI[TYPE_BEACON][TYPE_AVG]);
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+int lbs_get_rssi(struct lbs_private *priv)
+{
+	struct cmd_ds_802_11_rssi cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	memset(&cmd, sizeof(cmd), 0);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.N        = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
+
+	/* reset Beacon SNR/NF/RSSI values */
+	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->SNR[TYPE_BEACON][TYPE_AVG] = 0;
+	priv->NF[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->NF[TYPE_BEACON][TYPE_AVG] = 0;
+	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->RSSI[TYPE_BEACON][TYPE_AVG] = 0;
+
+	ret = __lbs_cmd(priv, CMD_802_11_RSSI, &cmd.hdr,
+		sizeof(struct cmd_ds_802_11_rssi_rsp),
+		lbs_get_rssi_callback, 0);
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
 static int lbs_get_log_callback(struct lbs_private *priv, unsigned long dummy,
 	struct cmd_header *resp)
 {
@@ -484,7 +543,6 @@ int lbs_get_log(struct lbs_private *priv
 	return ret;
 }
 
-
 static int lbs_cmd_802_11_get_stat(struct lbs_private *priv,
 				    struct cmd_ds_command *cmd)
 {
@@ -868,27 +926,6 @@ out:
 	return ret;
 }
 
-static int lbs_cmd_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *cmd)
-{
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rssi) + S_DS_GEN);
-	cmd->params.rssi.N = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
-
-	/* reset Beacon SNR/NF/RSSI values */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = 0;
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->NF[TYPE_BEACON][TYPE_AVG] = 0;
-	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->RSSI[TYPE_BEACON][TYPE_AVG] = 0;
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_reg_access(struct lbs_private *priv,
 			       struct cmd_ds_command *cmdptr,
 			       u8 cmd_action, void *pdata_buf)
@@ -1445,10 +1482,6 @@ int lbs_prepare_and_send_command(struct 
 		ret = lbs_cmd_80211_ad_hoc_join(priv, cmdptr, pdata_buf);
 		break;
 
-	case CMD_802_11_RSSI:
-		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
-		break;
-
 	case CMD_802_11_AD_HOC_STOP:
 		ret = lbs_cmd_80211_ad_hoc_stop(priv, cmdptr);
 		break;
Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-13 09:49:57.000000000 +0100
@@ -248,36 +248,6 @@ static int lbs_ret_802_11_rate_adapt_rat
 	return 0;
 }
 
-static int lbs_ret_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	/* store the non average value */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->SNR);
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->noisefloor);
-
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgSNR);
-	priv->NF[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgnoisefloor);
-
-	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
-		     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-
-	priv->RSSI[TYPE_BEACON][TYPE_AVG] =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_AVG] / AVG_SCALE,
-		     priv->NF[TYPE_BEACON][TYPE_AVG] / AVG_SCALE);
-
-	lbs_deb_cmd("RSSI: beacon %d, avg %d\n",
-	       priv->RSSI[TYPE_BEACON][TYPE_NOAVG],
-	       priv->RSSI[TYPE_BEACON][TYPE_AVG]);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_eeprom_access(struct lbs_private *priv,
 				  struct cmd_ds_command *resp)
 {
@@ -385,10 +355,6 @@ static inline int handle_cmd_response(st
 		ret = lbs_ret_802_11_rate_adapt_rateset(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_RSSI):
-		ret = lbs_ret_802_11_rssi(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_MAC_ADDRESS):
 		ret = lbs_ret_802_11_mac_address(priv, resp);
 		break;
Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-03-13 09:49:57.000000000 +0100
@@ -625,10 +625,7 @@ void lbs_association_worker(struct work_
 		if (success) {
 			lbs_deb_assoc("associated to %s\n",
 				print_mac(mac, priv->curbssparams.bssid));
-			lbs_prepare_and_send_command(priv,
-				CMD_802_11_RSSI,
-				0, CMD_OPTION_WAITFORRSP, 0, NULL);
-
+			lbs_get_rssi(priv);
 			lbs_get_log(priv);
 		} else {
 			ret = -1;
Index: wireless-testing/drivers/net/wireless/libertas/cmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-03-13 09:49:57.000000000 +0100
@@ -34,6 +34,7 @@ int lbs_cmd_copyback(struct lbs_private 
 
 int lbs_update_hw_spec(struct lbs_private *priv);
 
+int lbs_get_rssi(struct lbs_private *priv);
 int lbs_get_log(struct lbs_private *priv);
 
 int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
Index: wireless-testing/drivers/net/wireless/libertas/hostcmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h	2008-03-13 09:49:57.000000000 +0100
@@ -398,6 +398,8 @@ struct cmd_ds_802_11_rf_channel {
 };
 
 struct cmd_ds_802_11_rssi {
+	struct cmd_header hdr;
+
 	/* weighting factor */
 	__le16 N;
 
@@ -407,6 +409,8 @@ struct cmd_ds_802_11_rssi {
 };
 
 struct cmd_ds_802_11_rssi_rsp {
+	struct cmd_header hdr;
+
 	__le16 SNR;
 	__le16 noisefloor;
 	__le16 avgSNR;
@@ -700,8 +704,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_rate_adapt_rateset rateset;
 		struct cmd_ds_mac_multicast_adr madr;
 		struct cmd_ds_802_11_ad_hoc_join adj;
-		struct cmd_ds_802_11_rssi rssi;
-		struct cmd_ds_802_11_rssi_rsp rssirsp;
 		struct cmd_ds_802_11_disassociate dassociate;
 		struct cmd_ds_802_11_mac_address macadd;
 		struct cmd_ds_mac_reg_access macreg;
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-13 09:49:57.000000000 +0100
@@ -487,9 +487,7 @@ static void lbs_tx_timeout(struct net_de
 	   firmware has crapped itself -- rather than just a very
 	   busy medium. So send a harmless command, and if/when
 	   _that_ times out, we'll kick it in the head. */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-				     0, 0, NULL);
-
+	lbs_get_rssi(priv);
 	lbs_deb_leave(LBS_DEB_TX);
 }
 
@@ -908,8 +906,7 @@ int lbs_resume(struct lbs_private *priv)
 
 	/* Firmware doesn't seem to give us RX packets any more
 	   until we send it some command. Might as well update */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-				     0, 0, NULL);
+	lbs_get_rssi(priv);
 
 	netif_device_attach(priv->dev);
 	if (priv->mesh_dev)
Index: wireless-testing/drivers/net/wireless/libertas/scan.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-03-13 09:49:57.000000000 +0100
@@ -1371,8 +1371,7 @@ int lbs_get_scan(struct net_device *dev,
 
 	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
 	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate)
-		lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-					     CMD_OPTION_WAITFORRSP, 0, NULL);
+		lbs_get_rssi(priv);
 
 	mutex_lock(&priv->lock);
 	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
Index: wireless-testing/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-03-13 09:48:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-03-13 09:49:57.000000000 +0100
@@ -890,8 +890,7 @@ static struct iw_statistics *lbs_get_wir
 	stats_valid = 1;
 
 	/* update stats asynchronously for future calls */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-					0, 0, NULL);
+	lbs_get_rssi(priv);
 	lbs_get_log(priv);
 out:
 	if (!stats_valid) {
