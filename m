Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYIJQsU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 12:48:20 -0400
Subject: [PATCH] libertas: convert SNMP_MIB to a direct command
From: Dan Williams <dcbw@redhat.com>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 10 Sep 2008 12:49:00 -0400
Message-Id: <1221065341.24563.4.camel@localhost.localdomain> (sfid-20080910_184826_897840_EA9BF435)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And support setting both long and short retries independently.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 4ddf44b..92be604 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -823,11 +823,7 @@ static int assoc_helper_mode(struct lbs_private *priv,
 	}
 
 	priv->mode = assoc_req->mode;
-	ret = lbs_prepare_and_send_command(priv,
-				    CMD_802_11_SNMP_MIB,
-				    0, CMD_OPTION_WAITFORRSP,
-				    OID_802_11_INFRASTRUCTURE_MODE,
-		/* Shoot me now */  (void *) (size_t) assoc_req->mode);
+	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, assoc_req->mode);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 802547e..98237fd 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -494,124 +494,103 @@ static int lbs_cmd_802_11_reset(struct cmd_ds_command *cmd, int cmd_action)
 	return 0;
 }
 
-static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
-				    struct cmd_ds_command *cmd,
-				    int cmd_action,
-				    int cmd_oid, void *pdata_buf)
+/**
+ *  @brief Set an SNMP MIB value
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param oid  	The OID to set in the firmware
+ *  @param val  	Value to set the OID to
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_set_snmp_mib(struct lbs_private *priv, u32 oid, u16 val)
 {
-	struct cmd_ds_802_11_snmp_mib *pSNMPMIB = &cmd->params.smib;
-	u8 ucTemp;
+	struct cmd_ds_802_11_snmp_mib cmd;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	lbs_deb_cmd("SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
-
-	cmd->command = cpu_to_le16(CMD_802_11_SNMP_MIB);
-	cmd->size = cpu_to_le16(sizeof(*pSNMPMIB) + S_DS_GEN);
-
-	switch (cmd_oid) {
-	case OID_802_11_INFRASTRUCTURE_MODE:
-	{
-		u8 mode = (u8) (size_t) pdata_buf;
-		pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
-		pSNMPMIB->oid = cpu_to_le16((u16) DESIRED_BSSTYPE_I);
-		pSNMPMIB->bufsize = cpu_to_le16(sizeof(u8));
-		if (mode == IW_MODE_ADHOC) {
-			ucTemp = SNMP_MIB_VALUE_ADHOC;
-		} else {
-			/* Infra and Auto modes */
-			ucTemp = SNMP_MIB_VALUE_INFRA;
-		}
-
-		memmove(pSNMPMIB->value, &ucTemp, sizeof(u8));
+	memset(&cmd, 0, sizeof (cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.oid = cpu_to_le16((u16) oid);
 
+	switch (oid) {
+	case SNMP_MIB_OID_BSS_TYPE:
+		cmd.bufsize = cpu_to_le16(sizeof(u8));
+		cmd.value[0] = (val == IW_MODE_ADHOC) ? 2 : 1;
+		break;
+	case SNMP_MIB_OID_11D_ENABLE:
+	case SNMP_MIB_OID_FRAG_THRESHOLD:
+	case SNMP_MIB_OID_RTS_THRESHOLD:
+	case SNMP_MIB_OID_SHORT_RETRY_LIMIT:
+	case SNMP_MIB_OID_LONG_RETRY_LIMIT:
+		cmd.bufsize = cpu_to_le16(sizeof(u16));
+		*((__le16 *)(&cmd.value)) = cpu_to_le16(val);
 		break;
+	default:
+		lbs_deb_cmd("SNMP_CMD: (set) unhandled OID 0x%x\n", oid);
+		ret = -EINVAL;
+		goto out;
 	}
 
-	case OID_802_11D_ENABLE:
-		{
-			u32 ulTemp;
-
-			pSNMPMIB->oid = cpu_to_le16((u16) DOT11D_I);
-
-			if (cmd_action == CMD_ACT_SET) {
-				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
-				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
-				ulTemp = *(u32 *)pdata_buf;
-				*((__le16 *)(pSNMPMIB->value)) =
-				    cpu_to_le16((u16) ulTemp);
-			}
-			break;
-		}
-
-	case OID_802_11_FRAGMENTATION_THRESHOLD:
-		{
-			u32 ulTemp;
-
-			pSNMPMIB->oid = cpu_to_le16((u16) FRAGTHRESH_I);
+	lbs_deb_cmd("SNMP_CMD: (set) oid 0x%x, oid size 0x%x, value 0x%x\n",
+		    le16_to_cpu(cmd.oid), le16_to_cpu(cmd.bufsize), val);
 
-			if (cmd_action == CMD_ACT_GET) {
-				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_GET);
-			} else if (cmd_action == CMD_ACT_SET) {
-				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
-				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
-				ulTemp = *((u32 *) pdata_buf);
-				*((__le16 *)(pSNMPMIB->value)) =
-				    cpu_to_le16((u16) ulTemp);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SNMP_MIB, &cmd);
 
-			}
-
-			break;
-		}
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
 
-	case OID_802_11_RTS_THRESHOLD:
-		{
+/**
+ *  @brief Get an SNMP MIB value
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param oid  	The OID to retrieve from the firmware
+ *  @param out_val  	Location for the returned value
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val)
+{
+	struct cmd_ds_802_11_snmp_mib cmd;
+	int ret;
 
-			u32 ulTemp;
-			pSNMPMIB->oid = cpu_to_le16(RTSTHRESH_I);
+	lbs_deb_enter(LBS_DEB_CMD);
 
-			if (cmd_action == CMD_ACT_GET) {
-				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_GET);
-			} else if (cmd_action == CMD_ACT_SET) {
-				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
-				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
-				ulTemp = *((u32 *)pdata_buf);
-				*(__le16 *)(pSNMPMIB->value) =
-				    cpu_to_le16((u16) ulTemp);
+	memset(&cmd, 0, sizeof (cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_GET);
+	cmd.oid = cpu_to_le16(oid);
 
-			}
-			break;
-		}
-	case OID_802_11_TX_RETRYCOUNT:
-		pSNMPMIB->oid = cpu_to_le16((u16) SHORT_RETRYLIM_I);
-
-		if (cmd_action == CMD_ACT_GET) {
-			pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_GET);
-		} else if (cmd_action == CMD_ACT_SET) {
-			pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
-			pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
-			*((__le16 *)(pSNMPMIB->value)) =
-			    cpu_to_le16((u16) priv->txretrycount);
-		}
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SNMP_MIB, &cmd);
+	if (ret)
+		goto out;
 
+	switch (le16_to_cpu(cmd.bufsize)) {
+	case sizeof(u8):
+		if (oid == SNMP_MIB_OID_BSS_TYPE) {
+			if (cmd.value[0] == 2)
+				*out_val = IW_MODE_ADHOC;
+			else
+				*out_val = IW_MODE_INFRA;
+		} else
+			*out_val = cmd.value[0];
+		break;
+	case sizeof(u16):
+		*out_val = le16_to_cpu(*((__le16 *)(&cmd.value)));
 		break;
 	default:
+		lbs_deb_cmd("SNMP_CMD: (get) unhandled OID 0x%x size %d\n",
+		            oid, le16_to_cpu(cmd.bufsize));
 		break;
 	}
 
-	lbs_deb_cmd(
-	       "SNMP_CMD: command=0x%x, size=0x%x, seqnum=0x%x, result=0x%x\n",
-	       le16_to_cpu(cmd->command), le16_to_cpu(cmd->size),
-	       le16_to_cpu(cmd->seqnum), le16_to_cpu(cmd->result));
-
-	lbs_deb_cmd(
-	       "SNMP_CMD: action 0x%x, oid 0x%x, oidsize 0x%x, value 0x%x\n",
-	       le16_to_cpu(pSNMPMIB->querytype), le16_to_cpu(pSNMPMIB->oid),
-	       le16_to_cpu(pSNMPMIB->bufsize),
-	       le16_to_cpu(*(__le16 *) pSNMPMIB->value));
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
 }
 
 /**
@@ -1427,11 +1406,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_80211_authenticate(priv, cmdptr, pdata_buf);
 		break;
 
-	case CMD_802_11_SNMP_MIB:
-		ret = lbs_cmd_802_11_snmp_mib(priv, cmdptr,
-					       cmd_action, cmd_oid, pdata_buf);
-		break;
-
 	case CMD_MAC_REG_ACCESS:
 	case CMD_BBP_REG_ACCESS:
 	case CMD_RF_REG_ACCESS:
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 11ac996..9a35e15 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -67,4 +67,8 @@ int lbs_set_tx_power(struct lbs_private *priv, s16 dbm);
 
 int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
 
+int lbs_set_snmp_mib(struct lbs_private *priv, u32 oid, u16 val);
+
+int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 0371c83..f505552 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -146,48 +146,6 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 	return ret;
 }
 
-static int lbs_ret_802_11_snmp_mib(struct lbs_private *priv,
-				    struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_snmp_mib *smib = &resp->params.smib;
-	u16 oid = le16_to_cpu(smib->oid);
-	u16 querytype = le16_to_cpu(smib->querytype);
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	lbs_deb_cmd("SNMP_RESP: oid 0x%x, querytype 0x%x\n", oid,
-	       querytype);
-	lbs_deb_cmd("SNMP_RESP: Buf size %d\n", le16_to_cpu(smib->bufsize));
-
-	if (querytype == CMD_ACT_GET) {
-		switch (oid) {
-		case FRAGTHRESH_I:
-			priv->fragthsd =
-				le16_to_cpu(*((__le16 *)(smib->value)));
-			lbs_deb_cmd("SNMP_RESP: frag threshold %u\n",
-				    priv->fragthsd);
-			break;
-		case RTSTHRESH_I:
-			priv->rtsthsd =
-				le16_to_cpu(*((__le16 *)(smib->value)));
-			lbs_deb_cmd("SNMP_RESP: rts threshold %u\n",
-				    priv->rtsthsd);
-			break;
-		case SHORT_RETRYLIM_I:
-			priv->txretrycount =
-				le16_to_cpu(*((__le16 *)(smib->value)));
-			lbs_deb_cmd("SNMP_RESP: tx retry count %u\n",
-				    priv->rtsthsd);
-			break;
-		default:
-			break;
-		}
-	}
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_rssi(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
@@ -258,10 +216,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_80211_associate(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_SNMP_MIB):
-		ret = lbs_ret_802_11_snmp_mib(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_SET_AFC):
 	case CMD_RET(CMD_802_11_GET_AFC):
 		spin_lock_irqsave(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 4b2428a..c20fcf1 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -343,27 +343,6 @@ enum mv_ms_type {
 	MVMS_EVENT
 };
 
-/** SNMP_MIB_INDEX_e */
-enum SNMP_MIB_INDEX_e {
-	DESIRED_BSSTYPE_I = 0,
-	OP_RATESET_I,
-	BCNPERIOD_I,
-	DTIMPERIOD_I,
-	ASSOCRSP_TIMEOUT_I,
-	RTSTHRESH_I,
-	SHORT_RETRYLIM_I,
-	LONG_RETRYLIM_I,
-	FRAGTHRESH_I,
-	DOT11D_I,
-	DOT11H_I,
-	MANUFID_I,
-	PRODID_I,
-	MANUF_OUI_I,
-	MANUF_NAME_I,
-	MANUF_PRODNAME_I,
-	MANUF_PRODVER_I,
-};
-
 /** KEY_TYPE_ID */
 enum KEY_TYPE_ID {
 	KEY_TYPE_ID_WEP = 0,
@@ -378,12 +357,6 @@ enum KEY_INFO_WPA {
 	KEY_INFO_WPA_ENABLED = 0x04
 };
 
-/** SNMP_MIB_VALUE_e */
-enum SNMP_MIB_VALUE_e {
-	SNMP_MIB_VALUE_INFRA = 1,
-	SNMP_MIB_VALUE_ADHOC
-};
-
 /* Default values for fwt commands. */
 #define FWT_DEFAULT_METRIC 0
 #define FWT_DEFAULT_DIR 1
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index fd59e18..acb889e 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -240,9 +240,6 @@ struct lbs_private {
 	uint16_t enablehwauto;
 	uint16_t ratebitmap;
 
-	u32 fragthsd;
-	u32 rtsthsd;
-
 	u8 txretrycount;
 
 	/** Tx-related variables (for single packet tx) */
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index da618fc..d1d0666 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -9,17 +9,6 @@
 #define DEFAULT_AD_HOC_CHANNEL			6
 #define	DEFAULT_AD_HOC_CHANNEL_A		36
 
-/** IEEE 802.11 oids */
-#define OID_802_11_SSID				0x00008002
-#define OID_802_11_INFRASTRUCTURE_MODE		0x00008008
-#define OID_802_11_FRAGMENTATION_THRESHOLD	0x00008009
-#define OID_802_11_RTS_THRESHOLD		0x0000800A
-#define OID_802_11_TX_ANTENNA_SELECTED		0x0000800D
-#define OID_802_11_SUPPORTED_RATES		0x0000800E
-#define OID_802_11_STATISTICS			0x00008012
-#define OID_802_11_TX_RETRYCOUNT		0x0000801D
-#define OID_802_11D_ENABLE			0x00008020
-
 #define CMD_OPTION_WAITFORRSP			0x0002
 
 /** Host command IDs */
@@ -190,6 +179,19 @@
 #define CMD_WAKE_METHOD_COMMAND_INT	0x0001
 #define CMD_WAKE_METHOD_GPIO		0x0002
 
+/* Object IDs for CMD_802_11_SNMP_MIB */
+#define SNMP_MIB_OID_BSS_TYPE		0x0000
+#define SNMP_MIB_OID_OP_RATE_SET	0x0001
+#define SNMP_MIB_OID_BEACON_PERIOD	0x0002  /* Reserved on v9+ */
+#define SNMP_MIB_OID_DTIM_PERIOD	0x0003  /* Reserved on v9+ */
+#define SNMP_MIB_OID_ASSOC_TIMEOUT	0x0004  /* Reserved on v9+ */
+#define SNMP_MIB_OID_RTS_THRESHOLD	0x0005
+#define SNMP_MIB_OID_SHORT_RETRY_LIMIT	0x0006
+#define SNMP_MIB_OID_LONG_RETRY_LIMIT	0x0007
+#define SNMP_MIB_OID_FRAG_THRESHOLD	0x0008
+#define SNMP_MIB_OID_11D_ENABLE		0x0009
+#define SNMP_MIB_OID_11H_ENABLE		0x000A
+
 /* Define action or option for CMD_BT_ACCESS */
 enum cmd_bt_access_opts {
 	/* The bt commands start at 5 instead of 1 because the old dft commands
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index d27c276..4a439ce 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -301,7 +301,9 @@ struct cmd_ds_802_11_get_stat {
 };
 
 struct cmd_ds_802_11_snmp_mib {
-	__le16 querytype;
+	struct cmd_header hdr;
+
+	__le16 action;
 	__le16 oid;
 	__le16 bufsize;
 	u8 value[128];
@@ -707,7 +709,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_authenticate auth;
 		struct cmd_ds_802_11_get_stat gstat;
 		struct cmd_ds_802_3_get_stat gstat_8023;
-		struct cmd_ds_802_11_snmp_mib smib;
 		struct cmd_ds_802_11_rf_antenna rant;
 		struct cmd_ds_802_11_monitor_mode monitor;
 		struct cmd_ds_802_11_rssi rssi;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 426f1fe..37737f9 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -266,21 +266,17 @@ static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	u32 rthr = vwrq->value;
+	u32 val = vwrq->value;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (vwrq->disabled) {
-		priv->rtsthsd = rthr = MRVDRV_RTS_MAX_VALUE;
-	} else {
-		if (rthr < MRVDRV_RTS_MIN_VALUE || rthr > MRVDRV_RTS_MAX_VALUE)
-			return -EINVAL;
-		priv->rtsthsd = rthr;
-	}
+	if (vwrq->disabled)
+		val = MRVDRV_RTS_MAX_VALUE;
+
+	if (val < MRVDRV_RTS_MIN_VALUE || val > MRVDRV_RTS_MAX_VALUE)
+		return -EINVAL;
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
-				    CMD_ACT_SET, CMD_OPTION_WAITFORRSP,
-				    OID_802_11_RTS_THRESHOLD, &rthr);
+	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, (u16) val);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -289,21 +285,19 @@ static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
 static int lbs_get_rts(struct net_device *dev, struct iw_request_info *info,
 			struct iw_param *vwrq, char *extra)
 {
-	int ret = 0;
 	struct lbs_private *priv = dev->priv;
+	int ret = 0;
+	u16 val = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	priv->rtsthsd = 0;
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
-				    CMD_ACT_GET, CMD_OPTION_WAITFORRSP,
-				    OID_802_11_RTS_THRESHOLD, NULL);
+	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, &val);
 	if (ret)
 		goto out;
 
-	vwrq->value = priv->rtsthsd;
-	vwrq->disabled = ((vwrq->value < MRVDRV_RTS_MIN_VALUE)
-			  || (vwrq->value > MRVDRV_RTS_MAX_VALUE));
+	vwrq->value = val;
+	vwrq->disabled = ((val < MRVDRV_RTS_MIN_VALUE)
+			  || (val > MRVDRV_RTS_MAX_VALUE));
 	vwrq->fixed = 1;
 
 out:
@@ -314,24 +308,19 @@ out:
 static int lbs_set_frag(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_param *vwrq, char *extra)
 {
-	int ret = 0;
-	u32 fthr = vwrq->value;
 	struct lbs_private *priv = dev->priv;
+	int ret = 0;
+	u32 val = vwrq->value;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (vwrq->disabled) {
-		priv->fragthsd = fthr = MRVDRV_FRAG_MAX_VALUE;
-	} else {
-		if (fthr < MRVDRV_FRAG_MIN_VALUE
-		    || fthr > MRVDRV_FRAG_MAX_VALUE)
-			return -EINVAL;
-		priv->fragthsd = fthr;
-	}
+	if (vwrq->disabled)
+		val = MRVDRV_FRAG_MAX_VALUE;
+
+	if (val < MRVDRV_FRAG_MIN_VALUE || val > MRVDRV_FRAG_MAX_VALUE)
+		return -EINVAL;
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
-				    CMD_ACT_SET, CMD_OPTION_WAITFORRSP,
-				    OID_802_11_FRAGMENTATION_THRESHOLD, &fthr);
+	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_FRAG_THRESHOLD, (u16) val);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -340,22 +329,19 @@ static int lbs_set_frag(struct net_device *dev, struct iw_request_info *info,
 static int lbs_get_frag(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_param *vwrq, char *extra)
 {
-	int ret = 0;
 	struct lbs_private *priv = dev->priv;
+	int ret = 0;
+	u16 val = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	priv->fragthsd = 0;
-	ret = lbs_prepare_and_send_command(priv,
-				    CMD_802_11_SNMP_MIB,
-				    CMD_ACT_GET, CMD_OPTION_WAITFORRSP,
-				    OID_802_11_FRAGMENTATION_THRESHOLD, NULL);
+	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_FRAG_THRESHOLD, &val);
 	if (ret)
 		goto out;
 
-	vwrq->value = priv->fragthsd;
-	vwrq->disabled = ((vwrq->value < MRVDRV_FRAG_MIN_VALUE)
-			  || (vwrq->value > MRVDRV_FRAG_MAX_VALUE));
+	vwrq->value = val;
+	vwrq->disabled = ((val < MRVDRV_FRAG_MIN_VALUE)
+			  || (val > MRVDRV_FRAG_MAX_VALUE));
 	vwrq->fixed = 1;
 
 out:
@@ -382,7 +368,7 @@ static int mesh_wlan_get_mode(struct net_device *dev,
 {
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	*uwrq = IW_MODE_REPEAT ;
+	*uwrq = IW_MODE_REPEAT;
 
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
@@ -425,31 +411,44 @@ out:
 static int lbs_set_retry(struct net_device *dev, struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
-	int ret = 0;
 	struct lbs_private *priv = dev->priv;
+	int ret = 0;
+	u16 slimit = 0, llimit = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (vwrq->flags == IW_RETRY_LIMIT) {
-		/* The MAC has a 4-bit Total_Tx_Count register
-		   Total_Tx_Count = 1 + Tx_Retry_Count */
+        if ((vwrq->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
+                return -EOPNOTSUPP;
+
+	/* The MAC has a 4-bit Total_Tx_Count register
+	   Total_Tx_Count = 1 + Tx_Retry_Count */
 #define TX_RETRY_MIN 0
 #define TX_RETRY_MAX 14
-		if (vwrq->value < TX_RETRY_MIN || vwrq->value > TX_RETRY_MAX)
-			return -EINVAL;
+	if (vwrq->value < TX_RETRY_MIN || vwrq->value > TX_RETRY_MAX)
+		return -EINVAL;
 
-		/* Adding 1 to convert retry count to try count */
-		priv->txretrycount = vwrq->value + 1;
+	/* Add 1 to convert retry count to try count */
+	if (vwrq->flags & IW_RETRY_SHORT)
+		slimit = (u16) (vwrq->value + 1);
+	else if (vwrq->flags & IW_RETRY_LONG)
+		llimit = (u16) (vwrq->value + 1);
+	else
+		slimit = llimit = (u16) (vwrq->value + 1); /* set both */
 
-		ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
-					    CMD_ACT_SET,
-					    CMD_OPTION_WAITFORRSP,
-					    OID_802_11_TX_RETRYCOUNT, NULL);
+	if (llimit) {
+		ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_LONG_RETRY_LIMIT,
+				       llimit);
+		if (ret)
+			goto out;
+	}
 
+	if (slimit) {
+		/* txretrycount follows the short retry limit */
+		priv->txretrycount = slimit;
+		ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_SHORT_RETRY_LIMIT,
+				       slimit);
 		if (ret)
 			goto out;
-	} else {
-		return -EOPNOTSUPP;
 	}
 
 out:
@@ -462,22 +461,30 @@ static int lbs_get_retry(struct net_device *dev, struct iw_request_info *info,
 {
 	struct lbs_private *priv = dev->priv;
 	int ret = 0;
+	u16 val = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	priv->txretrycount = 0;
-	ret = lbs_prepare_and_send_command(priv,
-				    CMD_802_11_SNMP_MIB,
-				    CMD_ACT_GET, CMD_OPTION_WAITFORRSP,
-				    OID_802_11_TX_RETRYCOUNT, NULL);
-	if (ret)
-		goto out;
-
 	vwrq->disabled = 0;
-	if (!vwrq->flags) {
-		vwrq->flags = IW_RETRY_LIMIT;
+
+	if (vwrq->flags & IW_RETRY_LONG) {
+		ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_LONG_RETRY_LIMIT, &val);
+		if (ret)
+			goto out;
+
+		/* Subtract 1 to convert try count to retry count */
+		vwrq->value = val - 1;
+		vwrq->flags = IW_RETRY_LIMIT | IW_RETRY_LONG;
+	} else {
+		ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_SHORT_RETRY_LIMIT, &val);
+		if (ret)
+			goto out;
+
+		/* txretry count follows the short retry limit */
+		priv->txretrycount = val;
 		/* Subtract 1 to convert try count to retry count */
-		vwrq->value = priv->txretrycount - 1;
+		vwrq->value = val - 1;
+		vwrq->flags = IW_RETRY_LIMIT | IW_RETRY_SHORT;
 	}
 
 out:


