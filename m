Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:45985 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZJSMBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 08:01:21 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: move association related commands into assoc.c
Date: Mon, 19 Oct 2009 13:15:32 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910191315.33005.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That's because the new cfg80211 implementation will provide cleaner
implementations.

No functional changes.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -154,6 +154,396 @@
 }
 
 
+int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
+			   struct assoc_request *assoc)
+{
+	struct cmd_ds_802_11_set_wep cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+
+	cmd.action = cpu_to_le16(cmd_action);
+
+	if (cmd_action == CMD_ACT_ADD) {
+		int i;
+
+		/* default tx key index */
+		cmd.keyindex = cpu_to_le16(assoc->wep_tx_keyidx &
+					   CMD_WEP_KEY_INDEX_MASK);
+
+		/* Copy key types and material to host command structure */
+		for (i = 0; i < 4; i++) {
+			struct enc_key *pkey = &assoc->wep_keys[i];
+
+			switch (pkey->len) {
+			case KEY_LEN_WEP_40:
+				cmd.keytype[i] = CMD_TYPE_WEP_40_BIT;
+				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
+				lbs_deb_cmd("SET_WEP: add key %d (40 bit)\n", i);
+				break;
+			case KEY_LEN_WEP_104:
+				cmd.keytype[i] = CMD_TYPE_WEP_104_BIT;
+				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
+				lbs_deb_cmd("SET_WEP: add key %d (104 bit)\n", i);
+				break;
+			case 0:
+				break;
+			default:
+				lbs_deb_cmd("SET_WEP: invalid key %d, length %d\n",
+					    i, pkey->len);
+				ret = -1;
+				goto done;
+				break;
+			}
+		}
+	} else if (cmd_action == CMD_ACT_REMOVE) {
+		/* ACT_REMOVE clears _all_ WEP keys */
+
+		/* default tx key index */
+		cmd.keyindex = cpu_to_le16(priv->wep_tx_keyidx &
+					   CMD_WEP_KEY_INDEX_MASK);
+		lbs_deb_cmd("SET_WEP: remove key %d\n", priv->wep_tx_keyidx);
+	}
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
+done:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
+			      uint16_t *enable)
+{
+	struct cmd_ds_802_11_enable_rsn cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(cmd_action);
+
+	if (cmd_action == CMD_ACT_GET)
+		cmd.enable = 0;
+	else {
+		if (*enable)
+			cmd.enable = cpu_to_le16(CMD_ENABLE_RSN);
+		else
+			cmd.enable = cpu_to_le16(CMD_DISABLE_RSN);
+		lbs_deb_cmd("ENABLE_RSN: %d\n", *enable);
+	}
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
+	if (!ret && cmd_action == CMD_ACT_GET)
+		*enable = le16_to_cpu(cmd.enable);
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+static void set_one_wpa_key(struct MrvlIEtype_keyParamSet *keyparam,
+		struct enc_key *key)
+{
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (key->flags & KEY_INFO_WPA_ENABLED)
+		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_ENABLED);
+	if (key->flags & KEY_INFO_WPA_UNICAST)
+		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_UNICAST);
+	if (key->flags & KEY_INFO_WPA_MCAST)
+		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_MCAST);
+
+	keyparam->type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+	keyparam->keytypeid = cpu_to_le16(key->type);
+	keyparam->keylen = cpu_to_le16(key->len);
+	memcpy(keyparam->key, key->key, key->len);
+
+	/* Length field doesn't include the {type,length} header */
+	keyparam->length = cpu_to_le16(sizeof(*keyparam) - 4);
+	lbs_deb_leave(LBS_DEB_CMD);
+}
+
+int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
+				struct assoc_request *assoc)
+{
+	struct cmd_ds_802_11_key_material cmd;
+	int ret = 0;
+	int index = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	cmd.action = cpu_to_le16(cmd_action);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+
+	if (cmd_action == CMD_ACT_GET) {
+		cmd.hdr.size = cpu_to_le16(S_DS_GEN + 2);
+	} else {
+		memset(cmd.keyParamSet, 0, sizeof(cmd.keyParamSet));
+
+		if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc->flags)) {
+			set_one_wpa_key(&cmd.keyParamSet[index],
+					&assoc->wpa_unicast_key);
+			index++;
+		}
+
+		if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc->flags)) {
+			set_one_wpa_key(&cmd.keyParamSet[index],
+					&assoc->wpa_mcast_key);
+			index++;
+		}
+
+		/* The common header and as many keys as we included */
+		cmd.hdr.size = cpu_to_le16(offsetof(typeof(cmd),
+						    keyParamSet[index]));
+	}
+	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
+	/* Copy the returned key to driver private data */
+	if (!ret && cmd_action == CMD_ACT_GET) {
+		void *buf_ptr = cmd.keyParamSet;
+		void *resp_end = &(&cmd)[1];
+
+		while (buf_ptr < resp_end) {
+			struct MrvlIEtype_keyParamSet *keyparam = buf_ptr;
+			struct enc_key *key;
+			uint16_t param_set_len = le16_to_cpu(keyparam->length);
+			uint16_t key_len = le16_to_cpu(keyparam->keylen);
+			uint16_t key_flags = le16_to_cpu(keyparam->keyinfo);
+			uint16_t key_type = le16_to_cpu(keyparam->keytypeid);
+			void *end;
+
+			end = (void *)keyparam + sizeof(keyparam->type)
+				+ sizeof(keyparam->length) + param_set_len;
+
+			/* Make sure we don't access past the end of the IEs */
+			if (end > resp_end)
+				break;
+
+			if (key_flags & KEY_INFO_WPA_UNICAST)
+				key = &priv->wpa_unicast_key;
+			else if (key_flags & KEY_INFO_WPA_MCAST)
+				key = &priv->wpa_mcast_key;
+			else
+				break;
+
+			/* Copy returned key into driver */
+			memset(key, 0, sizeof(struct enc_key));
+			if (key_len > sizeof(key->key))
+				break;
+			key->type = key_type;
+			key->flags = key_flags;
+			key->len = key_len;
+			memcpy(key->key, keyparam->key, key->len);
+
+			buf_ptr = end + 1;
+		}
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+static __le16 lbs_rate_to_fw_bitmap(int rate, int lower_rates_ok)
+{
+/*		Bit  	Rate
+*		15:13 Reserved
+*		12    54 Mbps
+*		11    48 Mbps
+*		10    36 Mbps
+*		9     24 Mbps
+*		8     18 Mbps
+*		7     12 Mbps
+*		6     9 Mbps
+*		5     6 Mbps
+*		4     Reserved
+*		3     11 Mbps
+*		2     5.5 Mbps
+*		1     2 Mbps
+*		0     1 Mbps
+**/
+
+	uint16_t ratemask;
+	int i = lbs_data_rate_to_fw_index(rate);
+	if (lower_rates_ok)
+		ratemask = (0x1fef >> (12 - i));
+	else
+		ratemask = (1 << i);
+	return cpu_to_le16(ratemask);
+}
+
+int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
+				      uint16_t cmd_action)
+{
+	struct cmd_ds_802_11_rate_adapt_rateset cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (!priv->cur_rate && !priv->enablehwauto)
+		return -EINVAL;
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+
+	cmd.action = cpu_to_le16(cmd_action);
+	cmd.enablehwauto = cpu_to_le16(priv->enablehwauto);
+	cmd.bitmap = lbs_rate_to_fw_bitmap(priv->cur_rate, priv->enablehwauto);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RATE_ADAPT_RATESET, &cmd);
+	if (!ret && cmd_action == CMD_ACT_GET) {
+		priv->ratebitmap = le16_to_cpu(cmd.bitmap);
+		priv->enablehwauto = le16_to_cpu(cmd.enablehwauto);
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief Set the data rate
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param rate  	The desired data rate, or 0 to clear a locked rate
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_set_data_rate(struct lbs_private *priv, u8 rate)
+{
+	struct cmd_ds_802_11_data_rate cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+
+	if (rate > 0) {
+		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_FIX_RATE);
+		cmd.rates[0] = lbs_data_rate_to_fw_index(rate);
+		if (cmd.rates[0] == 0) {
+			lbs_deb_cmd("DATA_RATE: invalid requested rate of"
+				" 0x%02X\n", rate);
+			ret = 0;
+			goto out;
+		}
+		lbs_deb_cmd("DATA_RATE: set fixed 0x%02X\n", cmd.rates[0]);
+	} else {
+		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_AUTO);
+		lbs_deb_cmd("DATA_RATE: setting auto\n");
+	}
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
+	if (ret)
+		goto out;
+
+	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof(cmd));
+
+	/* FIXME: get actual rates FW can do if this command actually returns
+	 * all data rates supported.
+	 */
+	priv->cur_rate = lbs_fw_index_to_data_rate(cmd.rates[0]);
+	lbs_deb_cmd("DATA_RATE: current rate is 0x%02x\n", priv->cur_rate);
+
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+
+int lbs_cmd_802_11_rssi(struct lbs_private *priv,
+				struct cmd_ds_command *cmd)
+{
+
+	lbs_deb_enter(LBS_DEB_CMD);
+	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rssi) + S_DS_GEN);
+	cmd->params.rssi.N = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
+
+	/* reset Beacon SNR/NF/RSSI values */
+	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->SNR[TYPE_BEACON][TYPE_AVG] = 0;
+	priv->NF[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->NF[TYPE_BEACON][TYPE_AVG] = 0;
+	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->RSSI[TYPE_BEACON][TYPE_AVG] = 0;
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
+int lbs_ret_802_11_rssi(struct lbs_private *priv,
+				struct cmd_ds_command *resp)
+{
+	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	/* store the non average value */
+	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->SNR);
+	priv->NF[TYPE_BEACON][TYPE_NOAVG] =
+		get_unaligned_le16(&rssirsp->noisefloor);
+
+	priv->SNR[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgSNR);
+	priv->NF[TYPE_BEACON][TYPE_AVG] =
+		get_unaligned_le16(&rssirsp->avgnoisefloor);
+
+	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] =
+	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
+		     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
+
+	priv->RSSI[TYPE_BEACON][TYPE_AVG] =
+	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_AVG] / AVG_SCALE,
+		     priv->NF[TYPE_BEACON][TYPE_AVG] / AVG_SCALE);
+
+	lbs_deb_cmd("RSSI: beacon %d, avg %d\n",
+	       priv->RSSI[TYPE_BEACON][TYPE_NOAVG],
+	       priv->RSSI[TYPE_BEACON][TYPE_AVG]);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
+
+int lbs_cmd_bcn_ctrl(struct lbs_private *priv,
+				struct cmd_ds_command *cmd,
+				u16 cmd_action)
+{
+	struct cmd_ds_802_11_beacon_control
+		*bcn_ctrl = &cmd->params.bcn_ctrl;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+	cmd->size =
+	    cpu_to_le16(sizeof(struct cmd_ds_802_11_beacon_control)
+			     + S_DS_GEN);
+	cmd->command = cpu_to_le16(CMD_802_11_BEACON_CTRL);
+
+	bcn_ctrl->action = cpu_to_le16(cmd_action);
+	bcn_ctrl->beacon_enable = cpu_to_le16(priv->beacon_enable);
+	bcn_ctrl->beacon_period = cpu_to_le16(priv->beacon_period);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
+int lbs_ret_802_11_bcn_ctrl(struct lbs_private *priv,
+					struct cmd_ds_command *resp)
+{
+	struct cmd_ds_802_11_beacon_control *bcn_ctrl =
+	    &resp->params.bcn_ctrl;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (bcn_ctrl->action == CMD_ACT_GET) {
+		priv->beacon_enable = (u8) le16_to_cpu(bcn_ctrl->beacon_enable);
+		priv->beacon_period = le16_to_cpu(bcn_ctrl->beacon_period);
+	}
+
+	lbs_deb_enter(LBS_DEB_CMD);
+	return 0;
+}
+
+
+
 static int lbs_assoc_post(struct lbs_private *priv,
 			  struct cmd_ds_802_11_associate_response *resp)
 {
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.h
+++ linux-wl/drivers/net/wireless/libertas/assoc.h
@@ -132,4 +132,15 @@
 int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 				 u8 bssid[ETH_ALEN], u16 reason);
 
+int lbs_cmd_802_11_rssi(struct lbs_private *priv,
+				struct cmd_ds_command *cmd);
+int lbs_ret_802_11_rssi(struct lbs_private *priv,
+				struct cmd_ds_command *resp);
+
+int lbs_cmd_bcn_ctrl(struct lbs_private *priv,
+				struct cmd_ds_command *cmd,
+				u16 cmd_action);
+int lbs_ret_802_11_bcn_ctrl(struct lbs_private *priv,
+					struct cmd_ds_command *resp);
+
 #endif /* _LBS_ASSOC_H */
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -365,197 +365,6 @@
 	return ret;
 }
 
-int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
-			   struct assoc_request *assoc)
-{
-	struct cmd_ds_802_11_set_wep cmd;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	cmd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_ADD) {
-		int i;
-
-		/* default tx key index */
-		cmd.keyindex = cpu_to_le16(assoc->wep_tx_keyidx &
-					   CMD_WEP_KEY_INDEX_MASK);
-
-		/* Copy key types and material to host command structure */
-		for (i = 0; i < 4; i++) {
-			struct enc_key *pkey = &assoc->wep_keys[i];
-
-			switch (pkey->len) {
-			case KEY_LEN_WEP_40:
-				cmd.keytype[i] = CMD_TYPE_WEP_40_BIT;
-				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
-				lbs_deb_cmd("SET_WEP: add key %d (40 bit)\n", i);
-				break;
-			case KEY_LEN_WEP_104:
-				cmd.keytype[i] = CMD_TYPE_WEP_104_BIT;
-				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
-				lbs_deb_cmd("SET_WEP: add key %d (104 bit)\n", i);
-				break;
-			case 0:
-				break;
-			default:
-				lbs_deb_cmd("SET_WEP: invalid key %d, length %d\n",
-					    i, pkey->len);
-				ret = -1;
-				goto done;
-				break;
-			}
-		}
-	} else if (cmd_action == CMD_ACT_REMOVE) {
-		/* ACT_REMOVE clears _all_ WEP keys */
-
-		/* default tx key index */
-		cmd.keyindex = cpu_to_le16(priv->wep_tx_keyidx &
-					   CMD_WEP_KEY_INDEX_MASK);
-		lbs_deb_cmd("SET_WEP: remove key %d\n", priv->wep_tx_keyidx);
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
-done:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
-			      uint16_t *enable)
-{
-	struct cmd_ds_802_11_enable_rsn cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_GET)
-		cmd.enable = 0;
-	else {
-		if (*enable)
-			cmd.enable = cpu_to_le16(CMD_ENABLE_RSN);
-		else
-			cmd.enable = cpu_to_le16(CMD_DISABLE_RSN);
-		lbs_deb_cmd("ENABLE_RSN: %d\n", *enable);
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
-	if (!ret && cmd_action == CMD_ACT_GET)
-		*enable = le16_to_cpu(cmd.enable);
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-static void set_one_wpa_key(struct MrvlIEtype_keyParamSet *keyparam,
-                            struct enc_key *key)
-{
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (key->flags & KEY_INFO_WPA_ENABLED)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_ENABLED);
-	if (key->flags & KEY_INFO_WPA_UNICAST)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_UNICAST);
-	if (key->flags & KEY_INFO_WPA_MCAST)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_MCAST);
-
-	keyparam->type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
-	keyparam->keytypeid = cpu_to_le16(key->type);
-	keyparam->keylen = cpu_to_le16(key->len);
-	memcpy(keyparam->key, key->key, key->len);
-
-	/* Length field doesn't include the {type,length} header */
-	keyparam->length = cpu_to_le16(sizeof(*keyparam) - 4);
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
-int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
-				struct assoc_request *assoc)
-{
-	struct cmd_ds_802_11_key_material cmd;
-	int ret = 0;
-	int index = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.action = cpu_to_le16(cmd_action);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	if (cmd_action == CMD_ACT_GET) {
-		cmd.hdr.size = cpu_to_le16(S_DS_GEN + 2);
-	} else {
-		memset(cmd.keyParamSet, 0, sizeof(cmd.keyParamSet));
-
-		if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc->flags)) {
-			set_one_wpa_key(&cmd.keyParamSet[index],
-					&assoc->wpa_unicast_key);
-			index++;
-		}
-
-		if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc->flags)) {
-			set_one_wpa_key(&cmd.keyParamSet[index],
-					&assoc->wpa_mcast_key);
-			index++;
-		}
-
-		/* The common header and as many keys as we included */
-		cmd.hdr.size = cpu_to_le16(offsetof(typeof(cmd),
-						    keyParamSet[index]));
-	}
-	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
-	/* Copy the returned key to driver private data */
-	if (!ret && cmd_action == CMD_ACT_GET) {
-		void *buf_ptr = cmd.keyParamSet;
-		void *resp_end = &(&cmd)[1];
-
-		while (buf_ptr < resp_end) {
-			struct MrvlIEtype_keyParamSet *keyparam = buf_ptr;
-			struct enc_key *key;
-			uint16_t param_set_len = le16_to_cpu(keyparam->length);
-			uint16_t key_len = le16_to_cpu(keyparam->keylen);
-			uint16_t key_flags = le16_to_cpu(keyparam->keyinfo);
-			uint16_t key_type = le16_to_cpu(keyparam->keytypeid);
-			void *end;
-
-			end = (void *)keyparam + sizeof(keyparam->type)
-				+ sizeof(keyparam->length) + param_set_len;
-
-			/* Make sure we don't access past the end of the IEs */
-			if (end > resp_end)
-				break;
-
-			if (key_flags & KEY_INFO_WPA_UNICAST)
-				key = &priv->wpa_unicast_key;
-			else if (key_flags & KEY_INFO_WPA_MCAST)
-				key = &priv->wpa_mcast_key;
-			else
-				break;
-
-			/* Copy returned key into driver */
-			memset(key, 0, sizeof(struct enc_key));
-			if (key_len > sizeof(key->key))
-				break;
-			key->type = key_type;
-			key->flags = key_flags;
-			key->len = key_len;
-			memcpy(key->key, keyparam->key, key->len);
-
-			buf_ptr = end + 1;
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
 /**
  *  @brief Set an SNMP MIB value
  *
@@ -737,111 +546,6 @@
 	return 0;
 }
 
-static __le16 lbs_rate_to_fw_bitmap(int rate, int lower_rates_ok)
-{
-/*		Bit  	Rate
-*		15:13 Reserved
-*		12    54 Mbps
-*		11    48 Mbps
-*		10    36 Mbps
-*		9     24 Mbps
-*		8     18 Mbps
-*		7     12 Mbps
-*		6     9 Mbps
-*		5     6 Mbps
-*		4     Reserved
-*		3     11 Mbps
-*		2     5.5 Mbps
-*		1     2 Mbps
-*		0     1 Mbps
-**/
-
-	uint16_t ratemask;
-	int i = lbs_data_rate_to_fw_index(rate);
-	if (lower_rates_ok)
-		ratemask = (0x1fef >> (12 - i));
-	else
-		ratemask = (1 << i);
-	return cpu_to_le16(ratemask);
-}
-
-int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
-				      uint16_t cmd_action)
-{
-	struct cmd_ds_802_11_rate_adapt_rateset cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (!priv->cur_rate && !priv->enablehwauto)
-		return -EINVAL;
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	cmd.action = cpu_to_le16(cmd_action);
-	cmd.enablehwauto = cpu_to_le16(priv->enablehwauto);
-	cmd.bitmap = lbs_rate_to_fw_bitmap(priv->cur_rate, priv->enablehwauto);
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RATE_ADAPT_RATESET, &cmd);
-	if (!ret && cmd_action == CMD_ACT_GET) {
-		priv->ratebitmap = le16_to_cpu(cmd.bitmap);
-		priv->enablehwauto = le16_to_cpu(cmd.enablehwauto);
-	}
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(lbs_cmd_802_11_rate_adapt_rateset);
-
-/**
- *  @brief Set the data rate
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param rate  	The desired data rate, or 0 to clear a locked rate
- *
- *  @return 	   	0 on success, error on failure
- */
-int lbs_set_data_rate(struct lbs_private *priv, u8 rate)
-{
-	struct cmd_ds_802_11_data_rate cmd;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	if (rate > 0) {
-		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_FIX_RATE);
-		cmd.rates[0] = lbs_data_rate_to_fw_index(rate);
-		if (cmd.rates[0] == 0) {
-			lbs_deb_cmd("DATA_RATE: invalid requested rate of"
-			            " 0x%02X\n", rate);
-			ret = 0;
-			goto out;
-		}
-		lbs_deb_cmd("DATA_RATE: set fixed 0x%02X\n", cmd.rates[0]);
-	} else {
-		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_AUTO);
-		lbs_deb_cmd("DATA_RATE: setting auto\n");
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
-	if (ret)
-		goto out;
-
-	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof (cmd));
-
-	/* FIXME: get actual rates FW can do if this command actually returns
-	 * all data rates supported.
-	 */
-	priv->cur_rate = lbs_fw_index_to_data_rate(cmd.rates[0]);
-	lbs_deb_cmd("DATA_RATE: current rate is 0x%02x\n", priv->cur_rate);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
 /**
  *  @brief Get the radio channel
  *
@@ -924,27 +628,6 @@
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
 static int lbs_cmd_reg_access(struct cmd_ds_command *cmdptr,
 			       u8 cmd_action, void *pdata_buf)
 {
@@ -1184,27 +867,6 @@
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
 
-static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
-				struct cmd_ds_command *cmd,
-				u16 cmd_action)
-{
-	struct cmd_ds_802_11_beacon_control
-		*bcn_ctrl = &cmd->params.bcn_ctrl;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_beacon_control)
-			     + S_DS_GEN);
-	cmd->command = cpu_to_le16(CMD_802_11_BEACON_CTRL);
-
-	bcn_ctrl->action = cpu_to_le16(cmd_action);
-	bcn_ctrl->beacon_enable = cpu_to_le16(priv->beacon_enable);
-	bcn_ctrl->beacon_period = cpu_to_le16(priv->beacon_period);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static void lbs_queue_cmd(struct lbs_private *priv,
 			  struct cmd_ctrl_node *cmdnode)
 {
@@ -2180,5 +1842,3 @@
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__lbs_cmd);
-
-
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -148,53 +148,6 @@
 	return ret;
 }
 
-static int lbs_ret_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	/* store the non average value */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->SNR);
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->noisefloor);
-
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgSNR);
-	priv->NF[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgnoisefloor);
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
-static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
-					struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_beacon_control *bcn_ctrl =
-	    &resp->params.bcn_ctrl;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (bcn_ctrl->action == CMD_ACT_GET) {
-		priv->beacon_enable = (u8) le16_to_cpu(bcn_ctrl->beacon_enable);
-		priv->beacon_period = le16_to_cpu(bcn_ctrl->beacon_period);
-	}
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	return 0;
-}
-
 static inline int handle_cmd_response(struct lbs_private *priv,
 				      struct cmd_header *cmd_response)
 {

-- 
http://www.holgerschurig.de
