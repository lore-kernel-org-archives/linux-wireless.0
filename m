Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53918 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155AbZEWAHJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 20:07:09 -0400
Subject: [PATCH 4/5] libertas: convert CMD_802_11_ASSOCIATE to a direct
 command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 22 May 2009 20:07:14 -0400
Message-Id: <1243037234.2495.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index d004170..cb73720 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -12,8 +12,6 @@
 #include "scan.h"
 #include "cmd.h"
 
-static int lbs_adhoc_post(struct lbs_private *priv, struct cmd_header *resp);
-
 static const u8 bssid_any[ETH_ALEN]  __attribute__ ((aligned (2))) =
 	{ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
@@ -149,6 +147,249 @@ static int lbs_set_authentication(struct lbs_private *priv, u8 bssid[6], u8 auth
 	return ret;
 }
 
+
+static int lbs_assoc_post(struct lbs_private *priv,
+			  struct cmd_ds_802_11_associate_response *resp)
+{
+	int ret = 0;
+	union iwreq_data wrqu;
+	struct bss_descriptor *bss;
+	u16 status_code;
+
+	lbs_deb_enter(LBS_DEB_ASSOC);
+
+	if (!priv->in_progress_assoc_req) {
+		lbs_deb_assoc("ASSOC_RESP: no in-progress assoc request\n");
+		ret = -1;
+		goto done;
+	}
+	bss = &priv->in_progress_assoc_req->bss;
+
+	/*
+	 * Older FW versions map the IEEE 802.11 Status Code in the association
+	 * response to the following values returned in resp->statuscode:
+	 *
+	 *    IEEE Status Code                Marvell Status Code
+	 *    0                       ->      0x0000 ASSOC_RESULT_SUCCESS
+	 *    13                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    14                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    15                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    16                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
+	 *    others                  ->      0x0003 ASSOC_RESULT_REFUSED
+	 *
+	 * Other response codes:
+	 *    0x0001 -> ASSOC_RESULT_INVALID_PARAMETERS (unused)
+	 *    0x0002 -> ASSOC_RESULT_TIMEOUT (internal timer expired waiting for
+	 *                                    association response from the AP)
+	 */
+
+	status_code = le16_to_cpu(resp->statuscode);
+	if (priv->fwrelease < 0x09000000) {
+		switch (status_code) {
+		case 0x00:
+			break;
+		case 0x01:
+			lbs_deb_assoc("ASSOC_RESP: invalid parameters\n");
+			break;
+		case 0x02:
+			lbs_deb_assoc("ASSOC_RESP: internal timer "
+				"expired while waiting for the AP\n");
+			break;
+		case 0x03:
+			lbs_deb_assoc("ASSOC_RESP: association "
+				"refused by AP\n");
+			break;
+		case 0x04:
+			lbs_deb_assoc("ASSOC_RESP: authentication "
+				"refused by AP\n");
+			break;
+		default:
+			lbs_deb_assoc("ASSOC_RESP: failure reason 0x%02x "
+				" unknown\n", status_code);
+			break;
+		}
+	} else {
+		/* v9+ returns the AP's association response */
+		lbs_deb_assoc("ASSOC_RESP: failure reason 0x%02x\n", status_code);
+	}
+
+	if (status_code) {
+		lbs_mac_event_disconnected(priv);
+		ret = -1;
+		goto done;
+	}
+
+	lbs_deb_hex(LBS_DEB_ASSOC, "ASSOC_RESP",
+		    (void *) (resp + sizeof (resp->hdr)),
+		    le16_to_cpu(resp->hdr.size) - sizeof (resp->hdr));
+
+	/* Send a Media Connected event, according to the Spec */
+	priv->connect_status = LBS_CONNECTED;
+
+	/* Update current SSID and BSSID */
+	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
+	priv->curbssparams.ssid_len = bss->ssid_len;
+	memcpy(priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
+
+	priv->SNR[TYPE_RXPD][TYPE_AVG] = 0;
+	priv->NF[TYPE_RXPD][TYPE_AVG] = 0;
+
+	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
+	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
+	priv->nextSNRNF = 0;
+	priv->numSNRNF = 0;
+
+	netif_carrier_on(priv->dev);
+	if (!priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
+
+	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+
+done:
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief This function prepares an association-class command.
+ *
+ *  @param priv      A pointer to struct lbs_private structure
+ *  @param assoc_req The association request describing the BSS to associate
+ *                   or reassociate with
+ *  @param command   The actual command, either CMD_802_11_ASSOCIATE or
+ *                   CMD_802_11_REASSOCIATE
+ *
+ *  @return         0 or -1
+ */
+static int lbs_associate(struct lbs_private *priv,
+			 struct assoc_request *assoc_req,
+			 u16 command)
+{
+	struct cmd_ds_802_11_associate cmd;
+	int ret = 0;
+	struct bss_descriptor *bss = &assoc_req->bss;
+	u8 *pos = &(cmd.iebuf[0]);
+	u16 tmpcap, tmplen, tmpauth;
+	struct mrvl_ie_ssid_param_set *ssid;
+	struct mrvl_ie_ds_param_set *ds;
+	struct mrvl_ie_cf_param_set *cf;
+	struct mrvl_ie_rates_param_set *rates;
+	struct mrvl_ie_rsn_param_set *rsn;
+	struct mrvl_ie_auth_type *auth;
+
+	lbs_deb_enter(LBS_DEB_ASSOC);
+
+	BUG_ON((command != CMD_802_11_ASSOCIATE) &&
+		(command != CMD_802_11_REASSOCIATE));
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.command = cpu_to_le16(command);
+
+	/* Fill in static fields */
+	memcpy(cmd.bssid, bss->bssid, ETH_ALEN);
+	cmd.listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
+
+	/* Capability info */
+	tmpcap = (bss->capability & CAPINFO_MASK);
+	if (bss->mode == IW_MODE_INFRA)
+		tmpcap |= WLAN_CAPABILITY_ESS;
+	cmd.capability = cpu_to_le16(tmpcap);
+	lbs_deb_assoc("ASSOC_CMD: capability 0x%04x\n", tmpcap);
+
+	/* SSID */
+	ssid = (struct mrvl_ie_ssid_param_set *) pos;
+	ssid->header.type = cpu_to_le16(TLV_TYPE_SSID);
+	tmplen = bss->ssid_len;
+	ssid->header.len = cpu_to_le16(tmplen);
+	memcpy(ssid->ssid, bss->ssid, tmplen);
+	pos += sizeof(ssid->header) + tmplen;
+
+	ds = (struct mrvl_ie_ds_param_set *) pos;
+	ds->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
+	ds->header.len = cpu_to_le16(1);
+	ds->channel = bss->phy.ds.channel;
+	pos += sizeof(ds->header) + 1;
+
+	cf = (struct mrvl_ie_cf_param_set *) pos;
+	cf->header.type = cpu_to_le16(TLV_TYPE_CF);
+	tmplen = sizeof(*cf) - sizeof (cf->header);
+	cf->header.len = cpu_to_le16(tmplen);
+	/* IE payload should be zeroed, firmware fills it in for us */
+	pos += sizeof(*cf);
+
+	rates = (struct mrvl_ie_rates_param_set *) pos;
+	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	memcpy(&rates->rates, &bss->rates, MAX_RATES);
+	tmplen = MAX_RATES;
+	if (get_common_rates(priv, rates->rates, &tmplen)) {
+		ret = -1;
+		goto done;
+	}
+	pos += sizeof(rates->header) + tmplen;
+	rates->header.len = cpu_to_le16(tmplen);
+	lbs_deb_assoc("ASSOC_CMD: num rates %u\n", tmplen);
+
+	/* Copy the infra. association rates into Current BSS state structure */
+	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
+	memcpy(&priv->curbssparams.rates, &rates->rates, tmplen);
+
+	/* Set MSB on basic rates as the firmware requires, but _after_
+	 * copying to current bss rates.
+	 */
+	lbs_set_basic_rate_flags(rates->rates, tmplen);
+
+	/* Firmware v9+ indicate authentication suites as a TLV */
+	if (priv->fwrelease >= 0x09000000) {
+		DECLARE_MAC_BUF(mac);
+
+		auth = (struct mrvl_ie_auth_type *) pos;
+		auth->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
+		auth->header.len = cpu_to_le16(2);
+		tmpauth = iw_auth_to_ieee_auth(priv->secinfo.auth_mode);
+		auth->auth = cpu_to_le16(tmpauth);
+		pos += sizeof(auth->header) + 2;
+
+		lbs_deb_join("AUTH_CMD: BSSID %s, auth 0x%x\n",
+			print_mac(mac, bss->bssid), priv->secinfo.auth_mode);
+	}
+
+	/* WPA/WPA2 IEs */
+	if (assoc_req->secinfo.WPAenabled || assoc_req->secinfo.WPA2enabled) {
+		rsn = (struct mrvl_ie_rsn_param_set *) pos;
+		/* WPA_IE or WPA2_IE */
+		rsn->header.type = cpu_to_le16((u16) assoc_req->wpa_ie[0]);
+		tmplen = (u16) assoc_req->wpa_ie[1];
+		rsn->header.len = cpu_to_le16(tmplen);
+		memcpy(rsn->rsnie, &assoc_req->wpa_ie[2], tmplen);
+		lbs_deb_hex(LBS_DEB_JOIN, "ASSOC_CMD: WPA/RSN IE", (u8 *) rsn,
+			sizeof(rsn->header) + tmplen);
+		pos += sizeof(rsn->header) + tmplen;
+	}
+
+	cmd.hdr.size = cpu_to_le16((sizeof(cmd) - sizeof(cmd.iebuf)) +
+				   (u16)(pos - (u8 *) &cmd.iebuf));
+
+	/* update curbssparams */
+	priv->curbssparams.channel = bss->phy.ds.channel;
+
+	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
+		ret = -1;
+		goto done;
+	}
+
+	ret = lbs_cmd_with_response(priv, command, &cmd);
+	if (ret == 0) {
+		ret = lbs_assoc_post(priv,
+			(struct cmd_ds_802_11_associate_response *) &cmd);
+	}
+
+done:
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
+	return ret;
+}
+
 /**
  *  @brief Associate to a specific BSS discovered in a scan
  *
@@ -157,7 +398,7 @@ static int lbs_set_authentication(struct lbs_private *priv, u8 bssid[6], u8 auth
  *
  *  @return          0-success, otherwise fail
  */
-static int lbs_associate(struct lbs_private *priv,
+static int lbs_try_associate(struct lbs_private *priv,
 	struct assoc_request *assoc_req)
 {
 	int ret;
@@ -184,14 +425,78 @@ static int lbs_associate(struct lbs_private *priv,
 	if (ret)
 		goto out;
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_ASSOCIATE,
-				    0, CMD_OPTION_WAITFORRSP, 0, assoc_req);
+	ret = lbs_associate(priv, assoc_req, CMD_802_11_ASSOCIATE);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
+static int lbs_adhoc_post(struct lbs_private *priv,
+			  struct cmd_ds_802_11_ad_hoc_result *resp)
+{
+	int ret = 0;
+	u16 command = le16_to_cpu(resp->hdr.command);
+	u16 result = le16_to_cpu(resp->hdr.result);
+	union iwreq_data wrqu;
+	struct bss_descriptor *bss;
+	DECLARE_SSID_BUF(ssid);
+
+	lbs_deb_enter(LBS_DEB_JOIN);
+
+	if (!priv->in_progress_assoc_req) {
+		lbs_deb_join("ADHOC_RESP: no in-progress association "
+			"request\n");
+		ret = -1;
+		goto done;
+	}
+	bss = &priv->in_progress_assoc_req->bss;
+
+	/*
+	 * Join result code 0 --> SUCCESS
+	 */
+	if (result) {
+		lbs_deb_join("ADHOC_RESP: failed (result 0x%X)\n", result);
+		if (priv->connect_status == LBS_CONNECTED)
+			lbs_mac_event_disconnected(priv);
+		ret = -1;
+		goto done;
+	}
+
+	/* Send a Media Connected event, according to the Spec */
+	priv->connect_status = LBS_CONNECTED;
+
+	if (command == CMD_RET(CMD_802_11_AD_HOC_START)) {
+		/* Update the created network descriptor with the new BSSID */
+		memcpy(bss->bssid, resp->bssid, ETH_ALEN);
+	}
+
+	/* Set the BSSID from the joined/started descriptor */
+	memcpy(&priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
+
+	/* Set the new SSID to current SSID */
+	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
+	priv->curbssparams.ssid_len = bss->ssid_len;
+
+	netif_carrier_on(priv->dev);
+	if (!priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
+
+	memset(&wrqu, 0, sizeof(wrqu));
+	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+
+	lbs_deb_join("ADHOC_RESP: Joined/started '%s', BSSID %pM, channel %d\n",
+		     print_ssid(ssid, bss->ssid, bss->ssid_len),
+		     priv->curbssparams.bssid,
+		     priv->curbssparams.channel);
+
+done:
+	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
+	return ret;
+}
+
 /**
  *  @brief Join an adhoc network found in a previous scan
  *
@@ -337,8 +642,10 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 	}
 
 	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_JOIN, &cmd);
-	if (ret == 0)
-		ret = lbs_adhoc_post(priv, (struct cmd_header *) &cmd);
+	if (ret == 0) {
+		ret = lbs_adhoc_post(priv,
+				     (struct cmd_ds_802_11_ad_hoc_result *)&cmd);
+	}
 
 out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -445,7 +752,8 @@ static int lbs_adhoc_start(struct lbs_private *priv,
 
 	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_START, &cmd);
 	if (ret == 0)
-		ret = lbs_adhoc_post(priv, (struct cmd_header *) &cmd);
+		ret = lbs_adhoc_post(priv,
+				     (struct cmd_ds_802_11_ad_hoc_result *)&cmd);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -770,7 +1078,7 @@ static int assoc_helper_essid(struct lbs_private *priv,
 				assoc_req->ssid_len, NULL, IW_MODE_INFRA, channel);
 		if (bss != NULL) {
 			memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
-			ret = lbs_associate(priv, assoc_req);
+			ret = lbs_try_associate(priv, assoc_req);
 		} else {
 			lbs_deb_assoc("SSID not found; cannot associate\n");
 		}
@@ -822,8 +1130,9 @@ static int assoc_helper_bssid(struct lbs_private *priv,
 
 	memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
 	if (assoc_req->mode == IW_MODE_INFRA) {
-		ret = lbs_associate(priv, assoc_req);
-		lbs_deb_assoc("ASSOC: lbs_associate(bssid) returned %d\n", ret);
+		ret = lbs_try_associate(priv, assoc_req);
+		lbs_deb_assoc("ASSOC: lbs_try_associate(bssid) returned %d\n",
+			      ret);
 	} else if (assoc_req->mode == IW_MODE_ADHOC) {
 		lbs_adhoc_join(priv, assoc_req);
 	}
@@ -1549,299 +1858,3 @@ int lbs_cmd_80211_deauthenticate(struct lbs_private *priv, u8 bssid[ETH_ALEN],
 	return ret;
 }
 
-int lbs_cmd_80211_associate(struct lbs_private *priv,
-			      struct cmd_ds_command *cmd, void *pdata_buf)
-{
-	struct cmd_ds_802_11_associate *passo = &cmd->params.associate;
-	int ret = 0;
-	struct assoc_request *assoc_req = pdata_buf;
-	struct bss_descriptor *bss = &assoc_req->bss;
-	u8 *pos;
-	u16 tmpcap, tmplen, tmpauth;
-	struct mrvl_ie_ssid_param_set *ssid;
-	struct mrvl_ie_ds_param_set *ds;
-	struct mrvl_ie_cf_param_set *cf;
-	struct mrvl_ie_rates_param_set *rates;
-	struct mrvl_ie_rsn_param_set *rsn;
-	struct mrvl_ie_auth_type *auth;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	pos = (u8 *) passo;
-
-	if (!priv) {
-		ret = -1;
-		goto done;
-	}
-
-	cmd->command = cpu_to_le16(CMD_802_11_ASSOCIATE);
-
-	memcpy(passo->peerstaaddr, bss->bssid, sizeof(passo->peerstaaddr));
-	pos += sizeof(passo->peerstaaddr);
-
-	/* set the listen interval */
-	passo->listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
-
-	pos += sizeof(passo->capability);
-	pos += sizeof(passo->listeninterval);
-	pos += sizeof(passo->bcnperiod);
-	pos += sizeof(passo->dtimperiod);
-
-	ssid = (struct mrvl_ie_ssid_param_set *) pos;
-	ssid->header.type = cpu_to_le16(TLV_TYPE_SSID);
-	tmplen = bss->ssid_len;
-	ssid->header.len = cpu_to_le16(tmplen);
-	memcpy(ssid->ssid, bss->ssid, tmplen);
-	pos += sizeof(ssid->header) + tmplen;
-
-	ds = (struct mrvl_ie_ds_param_set *) pos;
-	ds->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
-	ds->header.len = cpu_to_le16(1);
-	ds->channel = bss->phy.ds.channel;
-	pos += sizeof(ds->header) + 1;
-
-	cf = (struct mrvl_ie_cf_param_set *) pos;
-	cf->header.type = cpu_to_le16(TLV_TYPE_CF);
-	tmplen = sizeof(*cf) - sizeof (cf->header);
-	cf->header.len = cpu_to_le16(tmplen);
-	/* IE payload should be zeroed, firmware fills it in for us */
-	pos += sizeof(*cf);
-
-	rates = (struct mrvl_ie_rates_param_set *) pos;
-	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
-	memcpy(&rates->rates, &bss->rates, MAX_RATES);
-	tmplen = MAX_RATES;
-	if (get_common_rates(priv, rates->rates, &tmplen)) {
-		ret = -1;
-		goto done;
-	}
-	pos += sizeof(rates->header) + tmplen;
-	rates->header.len = cpu_to_le16(tmplen);
-	lbs_deb_assoc("ASSOC_CMD: num rates %u\n", tmplen);
-
-	/* Copy the infra. association rates into Current BSS state structure */
-	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
-	memcpy(&priv->curbssparams.rates, &rates->rates, tmplen);
-
-	/* Set MSB on basic rates as the firmware requires, but _after_
-	 * copying to current bss rates.
-	 */
-	lbs_set_basic_rate_flags(rates->rates, tmplen);
-
-	/* Firmware v9+ indicate authentication suites as a TLV */
-	if (priv->fwrelease >= 0x09000000) {
-		DECLARE_MAC_BUF(mac);
-
-		auth = (struct mrvl_ie_auth_type *) pos;
-		auth->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
-		auth->header.len = cpu_to_le16(2);
-		tmpauth = iw_auth_to_ieee_auth(priv->secinfo.auth_mode);
-		auth->auth = cpu_to_le16(tmpauth);
-		pos += sizeof(auth->header) + 2;
-
-		lbs_deb_join("AUTH_CMD: BSSID %s, auth 0x%x\n",
-			print_mac(mac, bss->bssid), priv->secinfo.auth_mode);
-	}
-
-	if (assoc_req->secinfo.WPAenabled || assoc_req->secinfo.WPA2enabled) {
-		rsn = (struct mrvl_ie_rsn_param_set *) pos;
-		/* WPA_IE or WPA2_IE */
-		rsn->header.type = cpu_to_le16((u16) assoc_req->wpa_ie[0]);
-		tmplen = (u16) assoc_req->wpa_ie[1];
-		rsn->header.len = cpu_to_le16(tmplen);
-		memcpy(rsn->rsnie, &assoc_req->wpa_ie[2], tmplen);
-		lbs_deb_hex(LBS_DEB_JOIN, "ASSOC_CMD: RSN IE", (u8 *) rsn,
-			sizeof(rsn->header) + tmplen);
-		pos += sizeof(rsn->header) + tmplen;
-	}
-
-	/* update curbssparams */
-	priv->curbssparams.channel = bss->phy.ds.channel;
-
-	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
-		ret = -1;
-		goto done;
-	}
-
-	cmd->size = cpu_to_le16((u16) (pos - (u8 *) passo) + S_DS_GEN);
-
-	/* set the capability info */
-	tmpcap = (bss->capability & CAPINFO_MASK);
-	if (bss->mode == IW_MODE_INFRA)
-		tmpcap |= WLAN_CAPABILITY_ESS;
-	passo->capability = cpu_to_le16(tmpcap);
-	lbs_deb_assoc("ASSOC_CMD: capability 0x%04x\n", tmpcap);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-int lbs_ret_80211_associate(struct lbs_private *priv,
-			      struct cmd_ds_command *resp)
-{
-	int ret = 0;
-	union iwreq_data wrqu;
-	struct ieee_assoc_response *passocrsp;
-	struct bss_descriptor *bss;
-	u16 status_code;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	if (!priv->in_progress_assoc_req) {
-		lbs_deb_assoc("ASSOC_RESP: no in-progress assoc request\n");
-		ret = -1;
-		goto done;
-	}
-	bss = &priv->in_progress_assoc_req->bss;
-
-	passocrsp = (struct ieee_assoc_response *) &resp->params;
-
-	/*
-	 * Older FW versions map the IEEE 802.11 Status Code in the association
-	 * response to the following values returned in passocrsp->statuscode:
-	 *
-	 *    IEEE Status Code                Marvell Status Code
-	 *    0                       ->      0x0000 ASSOC_RESULT_SUCCESS
-	 *    13                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    14                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    15                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    16                      ->      0x0004 ASSOC_RESULT_AUTH_REFUSED
-	 *    others                  ->      0x0003 ASSOC_RESULT_REFUSED
-	 *
-	 * Other response codes:
-	 *    0x0001 -> ASSOC_RESULT_INVALID_PARAMETERS (unused)
-	 *    0x0002 -> ASSOC_RESULT_TIMEOUT (internal timer expired waiting for
-	 *                                    association response from the AP)
-	 */
-
-	status_code = le16_to_cpu(passocrsp->statuscode);
-	switch (status_code) {
-	case 0x00:
-		break;
-	case 0x01:
-		lbs_deb_assoc("ASSOC_RESP: invalid parameters\n");
-		break;
-	case 0x02:
-		lbs_deb_assoc("ASSOC_RESP: internal timer "
-			"expired while waiting for the AP\n");
-		break;
-	case 0x03:
-		lbs_deb_assoc("ASSOC_RESP: association "
-			"refused by AP\n");
-		break;
-	case 0x04:
-		lbs_deb_assoc("ASSOC_RESP: authentication "
-			"refused by AP\n");
-		break;
-	default:
-		lbs_deb_assoc("ASSOC_RESP: failure reason 0x%02x "
-			" unknown\n", status_code);
-		break;
-	}
-
-	if (status_code) {
-		lbs_mac_event_disconnected(priv);
-		ret = -1;
-		goto done;
-	}
-
-	lbs_deb_hex(LBS_DEB_ASSOC, "ASSOC_RESP", (void *)&resp->params,
-		le16_to_cpu(resp->size) - S_DS_GEN);
-
-	/* Send a Media Connected event, according to the Spec */
-	priv->connect_status = LBS_CONNECTED;
-
-	/* Update current SSID and BSSID */
-	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
-	priv->curbssparams.ssid_len = bss->ssid_len;
-	memcpy(priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
-
-	priv->SNR[TYPE_RXPD][TYPE_AVG] = 0;
-	priv->NF[TYPE_RXPD][TYPE_AVG] = 0;
-
-	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
-	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
-	priv->nextSNRNF = 0;
-	priv->numSNRNF = 0;
-
-	netif_carrier_on(priv->dev);
-	if (!priv->tx_pending_len)
-		netif_wake_queue(priv->dev);
-
-	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
-static int lbs_adhoc_post(struct lbs_private *priv, struct cmd_header *resp)
-{
-	int ret = 0;
-	u16 command = le16_to_cpu(resp->command);
-	u16 result = le16_to_cpu(resp->result);
-	struct cmd_ds_802_11_ad_hoc_result *adhoc_resp;
-	union iwreq_data wrqu;
-	struct bss_descriptor *bss;
-	DECLARE_SSID_BUF(ssid);
-
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	adhoc_resp = (struct cmd_ds_802_11_ad_hoc_result *) resp;
-
-	if (!priv->in_progress_assoc_req) {
-		lbs_deb_join("ADHOC_RESP: no in-progress association "
-			"request\n");
-		ret = -1;
-		goto done;
-	}
-	bss = &priv->in_progress_assoc_req->bss;
-
-	/*
-	 * Join result code 0 --> SUCCESS
-	 */
-	if (result) {
-		lbs_deb_join("ADHOC_RESP: failed (result 0x%X)\n", result);
-		if (priv->connect_status == LBS_CONNECTED)
-			lbs_mac_event_disconnected(priv);
-		ret = -1;
-		goto done;
-	}
-
-	/* Send a Media Connected event, according to the Spec */
-	priv->connect_status = LBS_CONNECTED;
-
-	if (command == CMD_RET(CMD_802_11_AD_HOC_START)) {
-		/* Update the created network descriptor with the new BSSID */
-		memcpy(bss->bssid, adhoc_resp->bssid, ETH_ALEN);
-	}
-
-	/* Set the BSSID from the joined/started descriptor */
-	memcpy(&priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
-
-	/* Set the new SSID to current SSID */
-	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
-	priv->curbssparams.ssid_len = bss->ssid_len;
-
-	netif_carrier_on(priv->dev);
-	if (!priv->tx_pending_len)
-		netif_wake_queue(priv->dev);
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-
-	lbs_deb_join("ADHOC_RESP: Joined/started '%s', BSSID %pM, channel %d\n",
-		     print_ssid(ssid, bss->ssid, bss->ssid_len),
-		     priv->curbssparams.bssid,
-		     priv->curbssparams.channel);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
-	return ret;
-}
-
diff --git a/drivers/net/wireless/libertas/assoc.h b/drivers/net/wireless/libertas/assoc.h
index 8b7336d..6e765e9 100644
--- a/drivers/net/wireless/libertas/assoc.h
+++ b/drivers/net/wireless/libertas/assoc.h
@@ -8,22 +8,9 @@
 void lbs_association_worker(struct work_struct *work);
 struct assoc_request *lbs_get_association_request(struct lbs_private *priv);
 
-struct cmd_ds_command;
-int lbs_cmd_80211_authenticate(struct lbs_private *priv,
-					struct cmd_ds_command *cmd,
-					void *pdata_buf);
-
 int lbs_adhoc_stop(struct lbs_private *priv);
 
 int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 				 u8 bssid[ETH_ALEN], u16 reason);
-int lbs_cmd_80211_associate(struct lbs_private *priv,
-				     struct cmd_ds_command *cmd,
-				     void *pdata_buf);
-
-int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
-					struct cmd_ds_command *resp);
-int lbs_ret_80211_associate(struct lbs_private *priv,
-				     struct cmd_ds_command *resp);
 
 #endif /* _LBS_ASSOC_H */
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index bd740fc..01db705 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1414,11 +1414,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_802_11_ps_mode(cmdptr, cmd_action);
 		break;
 
-	case CMD_802_11_ASSOCIATE:
-	case CMD_802_11_REASSOCIATE:
-		ret = lbs_cmd_80211_associate(priv, cmdptr, pdata_buf);
-		break;
-
 	case CMD_MAC_REG_ACCESS:
 	case CMD_BBP_REG_ACCESS:
 	case CMD_RF_REG_ACCESS:
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index a830eca..14b3d56 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -210,12 +210,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_reg_access(priv, respcmd, resp);
 		break;
 
-	case CMD_RET_802_11_ASSOCIATE:
-	case CMD_RET(CMD_802_11_ASSOCIATE):
-	case CMD_RET(CMD_802_11_REASSOCIATE):
-		ret = lbs_ret_80211_associate(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_SET_AFC):
 	case CMD_RET(CMD_802_11_GET_AFC):
 		spin_lock_irqsave(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 4c930bd..0a2e291 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -265,22 +265,23 @@ struct cmd_ds_802_11_deauthenticate {
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_associate {
-	u8 peerstaaddr[6];
+	struct cmd_header hdr;
+
+	u8 bssid[6];
 	__le16 capability;
 	__le16 listeninterval;
 	__le16 bcnperiod;
 	u8 dtimperiod;
-
-#if 0
-	mrvlietypes_ssidparamset_t ssidParamSet;
-	mrvlietypes_phyparamset_t phyparamset;
-	mrvlietypes_ssparamset_t ssparamset;
-	mrvlietypes_ratesparamset_t ratesParamSet;
-#endif
+	u8 iebuf[512];    /* Enough for required and most optional IEs */
 } __attribute__ ((packed));
 
-struct cmd_ds_802_11_associate_rsp {
-	struct ieee_assoc_response response;
+struct cmd_ds_802_11_associate_response {
+	struct cmd_header hdr;
+
+	__le16 capability;
+	__le16 statuscode;
+	__le16 aid;
+	u8 iebuf[512];
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_set_wep {
@@ -771,7 +772,6 @@ struct cmd_ds_command {
 	/* command Body */
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
-		struct cmd_ds_802_11_associate associate;
 		struct cmd_ds_802_11_get_stat gstat;
 		struct cmd_ds_802_3_get_stat gstat_8023;
 		struct cmd_ds_802_11_rf_antenna rant;
diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
index 4ad3bb6..99905df 100644
--- a/drivers/net/wireless/libertas/types.h
+++ b/drivers/net/wireless/libertas/types.h
@@ -54,13 +54,6 @@ union ieee_phy_param_set {
 	struct ieee_ie_ds_param_set ds;
 } __attribute__ ((packed));
 
-struct ieee_assoc_response {
-	__le16 capability;
-	__le16 statuscode;
-	__le16 aid;
-	u8 iebuffer[1];
-} __attribute__ ((packed));
-
 /** TLV  type ID definition */
 #define PROPRIETARY_TLV_BASE_ID		0x0100
 

