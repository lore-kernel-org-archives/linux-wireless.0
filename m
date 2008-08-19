Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYHSTOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 15:14:32 -0400
Subject: [PATCH] libertas: convert CMD_802_11_RF_TX_POWER to a direct
	command
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johan Adolfsson <Johan.Adolfsson@axis.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 15:15:35 -0400
Message-Id: <1219173335.23157.13.camel@localhost.localdomain> (sfid-20080819_211437_011152_E90582C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And while we're at it, grab min/max TX power from the firmware and use
that to validate incoming TX power requests from WEXT.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index af5fd70..c0db988 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -614,47 +614,67 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_cmd_802_11_rf_tx_power(struct cmd_ds_command *cmd,
-				       u16 cmd_action, void *pdata_buf)
+/**
+ *  @brief Get the min, max, and current TX power
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param curlevel  	Current power level in dBm
+ *  @param minlevel  	Minimum supported power level in dBm (optional)
+ *  @param maxlevel  	Maximum supported power level in dBm (optional)
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
+		     s16 *maxlevel)
 {
-
-	struct cmd_ds_802_11_rf_tx_power *prtp = &cmd->params.txp;
+	struct cmd_ds_802_11_rf_tx_power cmd;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	cmd->size =
-	    cpu_to_le16((sizeof(struct cmd_ds_802_11_rf_tx_power)) + S_DS_GEN);
-	cmd->command = cpu_to_le16(CMD_802_11_RF_TX_POWER);
-	prtp->action = cpu_to_le16(cmd_action);
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_GET);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_TX_POWER, &cmd);
+	if (ret == 0) {
+		*curlevel = le16_to_cpu(cmd.curlevel);
+		if (minlevel)
+			*minlevel = le16_to_cpu(cmd.minlevel);
+		if (maxlevel)
+			*maxlevel = le16_to_cpu(cmd.maxlevel);
+	}
 
-	lbs_deb_cmd("RF_TX_POWER_CMD: size:%d cmd:0x%x Act:%d\n",
-		    le16_to_cpu(cmd->size), le16_to_cpu(cmd->command),
-		    le16_to_cpu(prtp->action));
+	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
+}
 
-	switch (cmd_action) {
-	case CMD_ACT_TX_POWER_OPT_GET:
-		prtp->action = cpu_to_le16(CMD_ACT_GET);
-		prtp->currentlevel = 0;
-		break;
+/**
+ *  @brief Set the TX power
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param dbm  	The desired power level in dBm
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_set_tx_power(struct lbs_private *priv, s16 dbm)
+{
+	struct cmd_ds_802_11_rf_tx_power cmd;
+	int ret;
 
-	case CMD_ACT_TX_POWER_OPT_SET_HIGH:
-		prtp->action = cpu_to_le16(CMD_ACT_SET);
-		prtp->currentlevel = cpu_to_le16(CMD_ACT_TX_POWER_INDEX_HIGH);
-		break;
+	lbs_deb_enter(LBS_DEB_CMD);
 
-	case CMD_ACT_TX_POWER_OPT_SET_MID:
-		prtp->action = cpu_to_le16(CMD_ACT_SET);
-		prtp->currentlevel = cpu_to_le16(CMD_ACT_TX_POWER_INDEX_MID);
-		break;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.curlevel = cpu_to_le16(dbm);
 
-	case CMD_ACT_TX_POWER_OPT_SET_LOW:
-		prtp->action = cpu_to_le16(CMD_ACT_SET);
-		prtp->currentlevel = cpu_to_le16(*((u16 *) pdata_buf));
-		break;
-	}
+	lbs_deb_cmd("SET_RF_TX_POWER: %d dBm\n", dbm);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_TX_POWER, &cmd);
 
 	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+	return ret;
 }
 
 static int lbs_cmd_802_11_monitor_mode(struct cmd_ds_command *cmd,
@@ -1420,11 +1440,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_RF_TX_POWER:
-		ret = lbs_cmd_802_11_rf_tx_power(cmdptr,
-						 cmd_action, pdata_buf);
-		break;
-
 	case CMD_802_11_MONITOR_MODE:
 		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
 				          cmd_action, pdata_buf);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index a53b51f..6fba8ef 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -61,4 +61,8 @@ int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
 int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
 				struct assoc_request *assoc);
 
+int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
+		     s16 *maxlevel);
+int lbs_set_tx_power(struct lbs_private *priv, s16 dbm);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 24de3c3..dfaf03a 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -188,21 +188,6 @@ static int lbs_ret_802_11_snmp_mib(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_ret_802_11_rf_tx_power(struct lbs_private *priv,
-				       struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rf_tx_power *rtp = &resp->params.txp;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	priv->txpowerlevel = le16_to_cpu(rtp->currentlevel);
-
-	lbs_deb_cmd("TX power currently %d\n", priv->txpowerlevel);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_rssi(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
@@ -287,10 +272,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_802_11_snmp_mib(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_RF_TX_POWER):
-		ret = lbs_ret_802_11_rf_tx_power(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_SET_AFC):
 	case CMD_RET(CMD_802_11_GET_AFC):
 		spin_lock_irqsave(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index f5bb40c..560d4d3 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -253,7 +253,9 @@ struct lbs_private {
 	u32 connect_status;
 	u32 mesh_connect_status;
 	u16 regioncode;
-	u16 txpowerlevel;
+	s16 txpower_cur;
+	s16 txpower_min;
+	s16 txpower_max;
 
 	/** POWER MANAGEMENT AND PnP SUPPORT */
 	u8 surpriseremoved;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index c92e41b..413030f 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -178,16 +178,6 @@
 #define CMD_OPT_802_11_RF_CHANNEL_GET	0x00
 #define CMD_OPT_802_11_RF_CHANNEL_SET	0x01
 
-/* Define action or option for CMD_802_11_RF_TX_POWER */
-#define CMD_ACT_TX_POWER_OPT_GET	0x0000
-#define CMD_ACT_TX_POWER_OPT_SET_HIGH	0x8007
-#define CMD_ACT_TX_POWER_OPT_SET_MID	0x8004
-#define CMD_ACT_TX_POWER_OPT_SET_LOW	0x8000
-
-#define CMD_ACT_TX_POWER_INDEX_HIGH	0x0007
-#define CMD_ACT_TX_POWER_INDEX_MID	0x0004
-#define CMD_ACT_TX_POWER_INDEX_LOW	0x0000
-
 /* Define action or option for CMD_802_11_DATA_RATE */
 #define CMD_ACT_SET_TX_AUTO		0x0000
 #define CMD_ACT_SET_TX_FIX_RATE		0x0001
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 913b480..7f155cd 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -435,8 +435,12 @@ struct cmd_ds_802_11_mac_address {
 };
 
 struct cmd_ds_802_11_rf_tx_power {
+	struct cmd_header hdr;
+
 	__le16 action;
-	__le16 currentlevel;
+	__le16 curlevel;
+	s8 maxlevel;
+	s8 minlevel;
 };
 
 struct cmd_ds_802_11_rf_antenna {
@@ -701,7 +705,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_get_stat gstat;
 		struct cmd_ds_802_3_get_stat gstat_8023;
 		struct cmd_ds_802_11_snmp_mib smib;
-		struct cmd_ds_802_11_rf_tx_power txp;
 		struct cmd_ds_802_11_rf_antenna rant;
 		struct cmd_ds_802_11_monitor_mode monitor;
 		struct cmd_ds_802_11_ad_hoc_join adj;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index bd32ac0..3c13619 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -956,17 +956,24 @@ EXPORT_SYMBOL_GPL(lbs_resume);
 static int lbs_setup_firmware(struct lbs_private *priv)
 {
 	int ret = -1;
+	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
-	/*
-	 * Read MAC address from HW
-	 */
+	/* Read MAC address from firmware */
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 	ret = lbs_update_hw_spec(priv);
 	if (ret)
 		goto done;
 
+	/* Read power levels if available */
+	ret = lbs_get_tx_power(priv, &curlevel, &minlevel, &maxlevel);
+	if (ret == 0) {
+		priv->txpower_cur = curlevel;
+		priv->txpower_min = minlevel;
+		priv->txpower_max = maxlevel;
+	}
+
 	lbs_set_mac_control(priv);
 done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 8b3ed77..10a8066 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -422,26 +422,24 @@ static int lbs_get_txpow(struct net_device *dev,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
+	s16 curlevel = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	ret = lbs_prepare_and_send_command(priv,
-				    CMD_802_11_RF_TX_POWER,
-				    CMD_ACT_TX_POWER_OPT_GET,
-				    CMD_OPTION_WAITFORRSP, 0, NULL);
-
+	ret = lbs_get_tx_power(priv, &curlevel, NULL, NULL);
 	if (ret)
 		goto out;
 
-	lbs_deb_wext("tx power level %d dbm\n", priv->txpowerlevel);
-	vwrq->value = priv->txpowerlevel;
+	lbs_deb_wext("tx power level %d dbm\n", curlevel);
+
+	priv->txpower_cur = curlevel;
+	vwrq->value = curlevel;
 	vwrq->fixed = 1;
 	if (priv->radioon) {
 		vwrq->disabled = 0;
 		vwrq->flags = IW_TXPOW_DBM;
-	} else {
+	} else
 		vwrq->disabled = 1;
-	}
 
 out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
@@ -693,22 +691,12 @@ static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
 
 	range->sensitivity = 0;
 
-	/*
-	 * Setup the supported power level ranges
-	 */
+	/* Setup the supported power level ranges */
 	memset(range->txpower, 0, sizeof(range->txpower));
-	range->txpower[0] = 5;
-	range->txpower[1] = 7;
-	range->txpower[2] = 9;
-	range->txpower[3] = 11;
-	range->txpower[4] = 13;
-	range->txpower[5] = 15;
-	range->txpower[6] = 17;
-	range->txpower[7] = 19;
-
-	range->num_txpower = 8;
-	range->txpower_capa = IW_TXPOW_DBM;
-	range->txpower_capa |= IW_TXPOW_RANGE;
+	range->txpower_capa = IW_TXPOW_DBM | IW_TXPOW_RANGE;
+	range->txpower[0] = priv->txpower_min;
+	range->txpower[1] = priv->txpower_max;
+	range->num_txpower = 2;
 
 	range->event_capa[0] = (IW_EVENT_CAPA_K_0 |
 				IW_EVENT_CAPA_MASK(SIOCGIWAP) |
@@ -1844,39 +1832,46 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-
-	u16 dbm;
+	s16 dbm = (s16) vwrq->value;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	if (vwrq->disabled) {
 		lbs_radio_ioctl(priv, RADIO_OFF);
-		return 0;
+		goto out;
 	}
 
-	priv->preamble = CMD_TYPE_AUTO_PREAMBLE;
-
-	lbs_radio_ioctl(priv, RADIO_ON);
+	if (vwrq->fixed == 0) {
+		/* Auto power control */
+		priv->preamble = CMD_TYPE_AUTO_PREAMBLE;
+		dbm = priv->txpower_max;
+	} else {
+		/* Userspace check in iwrange if it should use dBm or mW,
+		 * therefore this should never happen... Jean II */
+		if ((vwrq->flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
 
-	/* Userspace check in iwrange if it should use dBm or mW,
-	 * therefore this should never happen... Jean II */
-	if ((vwrq->flags & IW_TXPOW_TYPE) == IW_TXPOW_MWATT) {
-		return -EOPNOTSUPP;
-	} else
-		dbm = (u16) vwrq->value;
+		/* Validate requested power level against firmware allowed levels */
+		if (priv->txpower_min && (dbm < priv->txpower_min)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-	/* auto tx power control */
+		if (priv->txpower_max && (dbm > priv->txpower_max)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
 
-	if (vwrq->fixed == 0)
-		dbm = 0xffff;
+	lbs_radio_ioctl(priv, RADIO_ON);
 
-	lbs_deb_wext("txpower set %d dbm\n", dbm);
+	lbs_deb_wext("txpower set %d dBm\n", dbm);
 
-	ret = lbs_prepare_and_send_command(priv,
-				    CMD_802_11_RF_TX_POWER,
-				    CMD_ACT_TX_POWER_OPT_SET_LOW,
-				    CMD_OPTION_WAITFORRSP, 0, (void *)&dbm);
+	ret = lbs_set_tx_power(priv, dbm);
 
+out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
 }

