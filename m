Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbYHUVt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 17:49:58 -0400
Subject: [PATCH 2/3] libertas: convert CMD_802_11_RADIO_CONTROL to a direct
	command
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1219355178.13058.4.camel@localhost.localdomain>
References: <1219173335.23157.13.camel@localhost.localdomain>
	 <1219355178.13058.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 17:51:07 -0400
Message-Id: <1219355467.13058.8.camel@localhost.localdomain> (sfid-20080821_235002_992772_11477337)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and return errors for operations like join & scan that aren't possible
when the radio is turned off.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 5072a89..d47e4d5 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -25,7 +25,7 @@ static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
  *  @brief Associate to a specific BSS discovered in a scan
  *
  *  @param priv      A pointer to struct lbs_private structure
- *  @param pbssdesc  Pointer to the BSS descriptor to associate with.
+ *  @param assoc_req The association request describing the BSS to associate with
  *
  *  @return          0-success, otherwise fail
  */
@@ -33,29 +33,29 @@ static int lbs_associate(struct lbs_private *priv,
 	struct assoc_request *assoc_req)
 {
 	int ret;
+	u8 preamble = RADIO_PREAMBLE_LONG;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_AUTHENTICATE,
 				    0, CMD_OPTION_WAITFORRSP,
 				    0, assoc_req->bss.bssid);
-
 	if (ret)
-		goto done;
+		goto out;
 
-	/* set preamble to firmware */
+	/* Use short preamble only when both the BSS and firmware support it */
 	if ((priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) &&
 	    (assoc_req->bss.capability & WLAN_CAPABILITY_SHORT_PREAMBLE))
-		priv->preamble = CMD_TYPE_SHORT_PREAMBLE;
-	else
-		priv->preamble = CMD_TYPE_LONG_PREAMBLE;
+		preamble = RADIO_PREAMBLE_SHORT;
 
-	lbs_set_radio_control(priv);
+	ret = lbs_set_radio(priv, preamble, 1);
+	if (ret)
+		goto out;
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_ASSOCIATE,
 				    0, CMD_OPTION_WAITFORRSP, 0, assoc_req);
 
-done:
+out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
@@ -64,8 +64,7 @@ done:
  *  @brief Join an adhoc network found in a previous scan
  *
  *  @param priv         A pointer to struct lbs_private structure
- *  @param pbssdesc     Pointer to a BSS descriptor found in a previous scan
- *                      to attempt to join
+ *  @param assoc_req    The association request describing the BSS to join
  *
  *  @return             0--success, -1--fail
  */
@@ -74,6 +73,9 @@ static int lbs_join_adhoc_network(struct lbs_private *priv,
 {
 	struct bss_descriptor *bss = &assoc_req->bss;
 	int ret = 0;
+	u8 preamble = RADIO_PREAMBLE_LONG;
+
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	lbs_deb_join("current SSID '%s', ssid length %u\n",
 		escape_essid(priv->curbssparams.ssid,
@@ -106,18 +108,16 @@ static int lbs_join_adhoc_network(struct lbs_private *priv,
 		goto out;
 	}
 
-	/* Use shortpreamble only when both creator and card supports
-	   short preamble */
-	if (!(bss->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) ||
-	    !(priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)) {
-		lbs_deb_join("AdhocJoin: Long preamble\n");
-		priv->preamble = CMD_TYPE_LONG_PREAMBLE;
-	} else {
+	/* Use short preamble only when both the BSS and firmware support it */
+	if ((priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) &&
+	    (bss->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)) {
 		lbs_deb_join("AdhocJoin: Short preamble\n");
-		priv->preamble = CMD_TYPE_SHORT_PREAMBLE;
+		preamble = RADIO_PREAMBLE_SHORT;
 	}
 
-	lbs_set_radio_control(priv);
+	ret = lbs_set_radio(priv, preamble, 1);
+	if (ret)
+		goto out;
 
 	lbs_deb_join("AdhocJoin: channel = %d\n", assoc_req->channel);
 	lbs_deb_join("AdhocJoin: band = %c\n", assoc_req->band);
@@ -129,6 +129,7 @@ static int lbs_join_adhoc_network(struct lbs_private *priv,
 				    OID_802_11_SSID, assoc_req);
 
 out:
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
@@ -136,25 +137,27 @@ out:
  *  @brief Start an Adhoc Network
  *
  *  @param priv         A pointer to struct lbs_private structure
- *  @param adhocssid    The ssid of the Adhoc Network
+ *  @param assoc_req    The association request describing the BSS to start
  *  @return             0--success, -1--fail
  */
 static int lbs_start_adhoc_network(struct lbs_private *priv,
 	struct assoc_request *assoc_req)
 {
 	int ret = 0;
+	u8 preamble = RADIO_PREAMBLE_LONG;
+
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	priv->adhoccreate = 1;
 
 	if (priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) {
 		lbs_deb_join("AdhocStart: Short preamble\n");
-		priv->preamble = CMD_TYPE_SHORT_PREAMBLE;
-	} else {
-		lbs_deb_join("AdhocStart: Long preamble\n");
-		priv->preamble = CMD_TYPE_LONG_PREAMBLE;
+		preamble = RADIO_PREAMBLE_SHORT;
 	}
 
-	lbs_set_radio_control(priv);
+	ret = lbs_set_radio(priv, preamble, 1);
+	if (ret)
+		goto out;
 
 	lbs_deb_join("AdhocStart: channel = %d\n", assoc_req->channel);
 	lbs_deb_join("AdhocStart: band = %d\n", assoc_req->band);
@@ -162,6 +165,8 @@ static int lbs_start_adhoc_network(struct lbs_private *priv,
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_AD_HOC_START,
 				    0, CMD_OPTION_WAITFORRSP, 0, assoc_req);
 
+out:
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 8364a2f..f3073a5 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1289,41 +1289,47 @@ void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 	priv->cur_cmd = NULL;
 }
 
-int lbs_set_radio_control(struct lbs_private *priv)
+int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on)
 {
-	int ret = 0;
 	struct cmd_ds_802_11_radio_control cmd;
+	int ret = -EINVAL;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
 
-	switch (priv->preamble) {
-	case CMD_TYPE_SHORT_PREAMBLE:
-		cmd.control = cpu_to_le16(SET_SHORT_PREAMBLE);
-		break;
-
-	case CMD_TYPE_LONG_PREAMBLE:
-		cmd.control = cpu_to_le16(SET_LONG_PREAMBLE);
-		break;
+	/* Only v8 and below support setting the preamble */
+	if (priv->fwrelease < 0x09000000) {
+		switch (preamble) {
+		case RADIO_PREAMBLE_SHORT:
+			if (!(priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE))
+				goto out;
+			/* Fall through */
+		case RADIO_PREAMBLE_AUTO:
+		case RADIO_PREAMBLE_LONG:
+			cmd.control = cpu_to_le16(preamble);
+			break;
+		default:
+			goto out;
+		}
+	}
 
-	case CMD_TYPE_AUTO_PREAMBLE:
-	default:
-		cmd.control = cpu_to_le16(SET_AUTO_PREAMBLE);
-		break;
+	if (radio_on)
+		cmd.control |= cpu_to_le16(0x1);
+	else {
+		cmd.control &= cpu_to_le16(~0x1);
+		priv->txpower_cur = 0;
 	}
 
-	if (priv->radioon)
-		cmd.control |= cpu_to_le16(TURN_ON_RF);
-	else
-		cmd.control &= cpu_to_le16(~TURN_ON_RF);
+	lbs_deb_cmd("RADIO_CONTROL: radio %s, preamble %d\n",
+		    radio_on ? "ON" : "OFF", preamble);
 
-	lbs_deb_cmd("RADIO_SET: radio %d, preamble %d\n", priv->radioon,
-		    priv->preamble);
+	priv->radio_on = radio_on;
 
 	ret = lbs_cmd_with_response(priv, CMD_802_11_RADIO_CONTROL, &cmd);
 
+out:
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 6fba8ef..11ac996 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -65,4 +65,6 @@ int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
 		     s16 *maxlevel);
 int lbs_set_tx_power(struct lbs_private *priv, s16 dbm);
 
+int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index a8ac974..1a8888c 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -34,7 +34,6 @@ int lbs_process_event(struct lbs_private *priv, u32 event);
 void lbs_queue_event(struct lbs_private *priv, u32 event);
 void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
 
-int lbs_set_radio_control(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 560d4d3..fd59e18 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -293,8 +293,7 @@ struct lbs_private {
 	u16 nextSNRNF;
 	u16 numSNRNF;
 
-	u8 radioon;
-	u32 preamble;
+	u8 radio_on;
 
 	/** data rate stuff */
 	u8 cur_rate;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index caebb9b..da618fc 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -152,11 +152,6 @@
 #define CMD_ACT_MAC_ALL_MULTICAST_ENABLE	0x0100
 #define CMD_ACT_MAC_STRICT_PROTECTION_ENABLE	0x0400
 
-/* Define action or option for CMD_802_11_RADIO_CONTROL */
-#define CMD_TYPE_AUTO_PREAMBLE		0x0001
-#define CMD_TYPE_SHORT_PREAMBLE		0x0002
-#define CMD_TYPE_LONG_PREAMBLE		0x0003
-
 /* Event flags for CMD_802_11_SUBSCRIBE_EVENT */
 #define CMD_SUBSCRIBE_RSSI_LOW		0x0001
 #define CMD_SUBSCRIBE_SNR_LOW		0x0002
@@ -165,13 +160,9 @@
 #define CMD_SUBSCRIBE_RSSI_HIGH		0x0010
 #define CMD_SUBSCRIBE_SNR_HIGH		0x0020
 
-#define TURN_ON_RF			0x01
-#define RADIO_ON			0x01
-#define RADIO_OFF			0x00
-
-#define SET_AUTO_PREAMBLE		0x05
-#define SET_SHORT_PREAMBLE		0x03
-#define SET_LONG_PREAMBLE		0x01
+#define RADIO_PREAMBLE_LONG	0x00
+#define RADIO_PREAMBLE_SHORT	0x02
+#define RADIO_PREAMBLE_AUTO	0x04
 
 /* Define action or option for CMD_802_11_RF_CHANNEL */
 #define CMD_OPT_802_11_RF_CHANNEL_GET	0x00
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 5e4c4e4..dafe62e 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1051,7 +1051,7 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	priv->mode = IW_MODE_INFRA;
 	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
-	priv->radioon = RADIO_ON;
+	priv->radio_on = 1;
 	priv->enablehwauto = 1;
 	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->psmode = LBS802_11POWERMODECAM;
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 4b27456..8f66903 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -944,6 +944,11 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!priv->radio_on) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		ret = -ENETDOWN;
 		goto out;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 38295ee..4307090 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -120,34 +120,6 @@ static struct chan_freq_power *find_cfp_by_band_and_freq(
 	return cfp;
 }
 
-
-/**
- *  @brief Set Radio On/OFF
- *
- *  @param priv                 A pointer to struct lbs_private structure
- *  @option 			Radio Option
- *  @return 	   		0 --success, otherwise fail
- */
-static int lbs_radio_ioctl(struct lbs_private *priv, u8 option)
-{
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (priv->radioon != option) {
-		lbs_deb_wext("switching radio %s\n", option ? "on" : "off");
-		priv->radioon = option;
-
-		ret = lbs_prepare_and_send_command(priv,
-					    CMD_802_11_RADIO_CONTROL,
-					    CMD_ACT_SET,
-					    CMD_OPTION_WAITFORRSP, 0, NULL);
-	}
-
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
 /**
  *  @brief Copy active data rates based on adapter mode and status
  *
@@ -420,26 +392,30 @@ static int lbs_get_txpow(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
-	int ret = 0;
 	struct lbs_private *priv = dev->priv;
 	s16 curlevel = 0;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!priv->radio_on) {
+		lbs_deb_wext("tx power off\n");
+		vwrq->value = 0;
+		vwrq->disabled = 1;
+		goto out;
+	}
+
 	ret = lbs_get_tx_power(priv, &curlevel, NULL, NULL);
 	if (ret)
 		goto out;
 
 	lbs_deb_wext("tx power level %d dbm\n", curlevel);
-
 	priv->txpower_cur = curlevel;
+
 	vwrq->value = curlevel;
 	vwrq->fixed = 1;
-	if (priv->radioon) {
-		vwrq->disabled = 0;
-		vwrq->flags = IW_TXPOW_DBM;
-	} else
-		vwrq->disabled = 1;
+	vwrq->disabled = 0;
+	vwrq->flags = IW_TXPOW_DBM;
 
 out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
@@ -1839,13 +1815,12 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	if (vwrq->disabled) {
-		lbs_radio_ioctl(priv, RADIO_OFF);
+		lbs_set_radio(priv, RADIO_PREAMBLE_AUTO, 0);
 		goto out;
 	}
 
 	if (vwrq->fixed == 0) {
 		/* Auto power control */
-		priv->preamble = CMD_TYPE_AUTO_PREAMBLE;
 		dbm = priv->txpower_max;
 	} else {
 		/* Userspace check in iwrange if it should use dBm or mW,
@@ -1867,7 +1842,12 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 		}
 	}
 
-	lbs_radio_ioctl(priv, RADIO_ON);
+	/* If the radio was off, turn it on */
+	if (!priv->radio_on) {
+		ret = lbs_set_radio(priv, RADIO_PREAMBLE_AUTO, 1);
+		if (ret)
+			goto out;
+	}
 
 	lbs_deb_wext("txpower set %d dBm\n", dbm);
 
@@ -1925,6 +1905,11 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!priv->radio_on) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* Check the size of the string */
 	if (in_ssid_len > IW_ESSID_MAX_SIZE) {
 		ret = -E2BIG;
@@ -2002,6 +1987,11 @@ static int lbs_mesh_set_essid(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!priv->radio_on) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* Check the size of the string */
 	if (dwrq->length > IW_ESSID_MAX_SIZE) {
 		ret = -E2BIG;
@@ -2043,6 +2033,9 @@ static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!priv->radio_on)
+		return -EINVAL;
+
 	if (awrq->sa_family != ARPHRD_ETHER)
 		return -EINVAL;
 

