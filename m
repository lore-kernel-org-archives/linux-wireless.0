Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53476 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030428Ab2CNCXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 22:23:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 7/9] mwifiex: fix checkpatch --strict warnings/errors Part 7
Date: Tue, 13 Mar 2012 19:22:40 -0700
Message-Id: <1331691762-5514-8-git-send-email-bzhao@marvell.com> (sfid-20120314_032325_520165_83B10F50)
In-Reply-To: <1331691762-5514-1-git-send-email-bzhao@marvell.com>
References: <1331691762-5514-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For sta_cmd.c and sta_cmdresp.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c     |  175 ++++++++++++++--------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   60 +++++-----
 2 files changed, 114 insertions(+), 121 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 324c651..6c8e459 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -110,7 +110,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
-		- 1 + S_DS_GEN);
+				- 1 + S_DS_GEN);
 
 	snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
@@ -127,8 +127,8 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev,
 		"cmd: SNMP_CMD: Action=0x%x, OID=0x%x, OIDSize=0x%x,"
 		" Value=0x%x\n",
-	       cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
-	       le16_to_cpu(*(__le16 *) snmp_mib->value));
+		cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
+		le16_to_cpu(*(__le16 *) snmp_mib->value));
 	return 0;
 }
 
@@ -174,8 +174,8 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 	rate_scope = (struct mwifiex_rate_scope *) ((u8 *) rate_cfg +
 		      sizeof(struct host_cmd_ds_tx_rate_cfg));
 	rate_scope->type = cpu_to_le16(TLV_TYPE_RATE_SCOPE);
-	rate_scope->length = cpu_to_le16(sizeof(struct mwifiex_rate_scope) -
-			sizeof(struct mwifiex_ie_types_header));
+	rate_scope->length = cpu_to_le16
+		(sizeof(*rate_scope) - sizeof(struct mwifiex_ie_types_header));
 	if (pbitmap_rates != NULL) {
 		rate_scope->hr_dsss_rate_bitmap = cpu_to_le16(pbitmap_rates[0]);
 		rate_scope->ofdm_rate_bitmap = cpu_to_le16(pbitmap_rates[1]);
@@ -197,7 +197,7 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 	}
 
 	rate_drop = (struct mwifiex_rate_drop_pattern *) ((u8 *) rate_scope +
-			sizeof(struct mwifiex_rate_scope));
+					     sizeof(struct mwifiex_rate_scope));
 	rate_drop->type = cpu_to_le16(TLV_TYPE_RATE_DROP_CONTROL);
 	rate_drop->length = cpu_to_le16(sizeof(rate_drop->rate_drop_mode));
 	rate_drop->rate_drop_mode = 0;
@@ -284,22 +284,22 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH);
 
 	if (!hs_activate &&
-	    (hscfg_param->conditions
-	    != cpu_to_le32(HOST_SLEEP_CFG_CANCEL))
-	    && ((adapter->arp_filter_size > 0)
-		&& (adapter->arp_filter_size <= ARP_FILTER_MAX_BUF_SIZE))) {
+	    (hscfg_param->conditions != cpu_to_le32(HOST_SLEEP_CFG_CANCEL)) &&
+	    ((adapter->arp_filter_size > 0) &&
+	     (adapter->arp_filter_size <= ARP_FILTER_MAX_BUF_SIZE))) {
 		dev_dbg(adapter->dev,
 			"cmd: Attach %d bytes ArpFilter to HSCfg cmd\n",
-		       adapter->arp_filter_size);
+			adapter->arp_filter_size);
 		memcpy(((u8 *) hs_cfg) +
 		       sizeof(struct host_cmd_ds_802_11_hs_cfg_enh),
 		       adapter->arp_filter, adapter->arp_filter_size);
-		cmd->size = cpu_to_le16(adapter->arp_filter_size +
-				    sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
-				    + S_DS_GEN);
+		cmd->size = cpu_to_le16
+				(adapter->arp_filter_size +
+				 sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
+				+ S_DS_GEN);
 	} else {
 		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(struct
-					   host_cmd_ds_802_11_hs_cfg_enh));
+						host_cmd_ds_802_11_hs_cfg_enh));
 	}
 	if (hs_activate) {
 		hs_cfg->action = cpu_to_le16(HS_ACTIVATE);
@@ -467,7 +467,7 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 			key_param_set =
 				(struct mwifiex_ie_type_key_param_set *)
 						((u8 *)key_param_set +
-						cur_key_param_len);
+						 cur_key_param_len);
 		} else if (!priv->wep_key[i].key_length) {
 			continue;
 		} else {
@@ -527,13 +527,13 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 	if (enc_key->is_wapi_key) {
 		dev_dbg(priv->adapter->dev, "info: Set WAPI Key\n");
 		key_material->key_param_set.key_type_id =
-			cpu_to_le16(KEY_TYPE_ID_WAPI);
+						cpu_to_le16(KEY_TYPE_ID_WAPI);
 		if (cmd_oid == KEY_INFO_ENABLED)
 			key_material->key_param_set.key_info =
-				cpu_to_le16(KEY_ENABLED);
+						cpu_to_le16(KEY_ENABLED);
 		else
 			key_material->key_param_set.key_info =
-				cpu_to_le16(!KEY_ENABLED);
+						cpu_to_le16(!KEY_ENABLED);
 
 		key_material->key_param_set.key[0] = enc_key->key_index;
 		if (!priv->sec_info.wapi_key_on)
@@ -553,9 +553,9 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		}
 
 		key_material->key_param_set.type =
-			cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+					cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
 		key_material->key_param_set.key_len =
-			cpu_to_le16(WAPI_KEY_LEN);
+						cpu_to_le16(WAPI_KEY_LEN);
 		memcpy(&key_material->key_param_set.key[2],
 		       enc_key->key_material, enc_key->key_len);
 		memcpy(&key_material->key_param_set.key[2 + enc_key->key_len],
@@ -565,49 +565,49 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 
 		key_param_len = (WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN) +
 				 sizeof(struct mwifiex_ie_types_header);
-		cmd->size = cpu_to_le16(key_param_len +
-				sizeof(key_material->action) + S_DS_GEN);
+		cmd->size = cpu_to_le16(sizeof(key_material->action)
+					+ S_DS_GEN +  key_param_len);
 		return ret;
 	}
 	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
 		dev_dbg(priv->adapter->dev, "cmd: WPA_AES\n");
 		key_material->key_param_set.key_type_id =
-			cpu_to_le16(KEY_TYPE_ID_AES);
+						cpu_to_le16(KEY_TYPE_ID_AES);
 		if (cmd_oid == KEY_INFO_ENABLED)
 			key_material->key_param_set.key_info =
-				cpu_to_le16(KEY_ENABLED);
+						cpu_to_le16(KEY_ENABLED);
 		else
 			key_material->key_param_set.key_info =
-				cpu_to_le16(!KEY_ENABLED);
+						cpu_to_le16(!KEY_ENABLED);
 
 		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
 				/* AES pairwise key: unicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_UNICAST);
+						cpu_to_le16(KEY_UNICAST);
 		else		/* AES group key: multicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_MCAST);
+							cpu_to_le16(KEY_MCAST);
 	} else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
 		dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
 		key_material->key_param_set.key_type_id =
-			cpu_to_le16(KEY_TYPE_ID_TKIP);
+						cpu_to_le16(KEY_TYPE_ID_TKIP);
 		key_material->key_param_set.key_info =
-			cpu_to_le16(KEY_ENABLED);
+						cpu_to_le16(KEY_ENABLED);
 
 		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
 				/* TKIP pairwise key: unicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_UNICAST);
+						cpu_to_le16(KEY_UNICAST);
 		else		/* TKIP group key: multicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_MCAST);
+							cpu_to_le16(KEY_MCAST);
 	}
 
 	if (key_material->key_param_set.key_type_id) {
 		key_material->key_param_set.type =
-			cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+					cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
 		key_material->key_param_set.key_len =
-			cpu_to_le16((u16) enc_key->key_len);
+					cpu_to_le16((u16) enc_key->key_len);
 		memcpy(key_material->key_param_set.key, enc_key->key_material,
 		       enc_key->key_len);
 		key_material->key_param_set.length =
@@ -615,10 +615,10 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 				    KEYPARAMSET_FIXED_LEN);
 
 		key_param_len = (u16) (enc_key->key_len + KEYPARAMSET_FIXED_LEN)
-				      + sizeof(struct mwifiex_ie_types_header);
+				+ sizeof(struct mwifiex_ie_types_header);
 
-		cmd->size = cpu_to_le16(key_param_len +
-				    sizeof(key_material->action) + S_DS_GEN);
+		cmd->size = cpu_to_le16(sizeof(key_material->action) + S_DS_GEN
+					+ key_param_len);
 	}
 
 	return ret;
@@ -655,21 +655,22 @@ static int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 	/* Set domain info fields */
 	domain->header.type = cpu_to_le16(WLAN_EID_COUNTRY);
 	memcpy(domain->country_code, adapter->domain_reg.country_code,
-			sizeof(domain->country_code));
+	       sizeof(domain->country_code));
 
-	domain->header.len = cpu_to_le16((no_of_triplet *
-				sizeof(struct ieee80211_country_ie_triplet)) +
-				sizeof(domain->country_code));
+	domain->header.len =
+		cpu_to_le16((no_of_triplet *
+			     sizeof(struct ieee80211_country_ie_triplet))
+			    + sizeof(domain->country_code));
 
 	if (no_of_triplet) {
 		memcpy(domain->triplet, adapter->domain_reg.triplet,
-				no_of_triplet *
-				sizeof(struct ieee80211_country_ie_triplet));
+		       no_of_triplet * sizeof(struct
+					      ieee80211_country_ie_triplet));
 
 		cmd->size = cpu_to_le16(sizeof(domain_info->action) +
-				le16_to_cpu(domain->header.len) +
-				sizeof(struct mwifiex_ie_types_header)
-				+ S_DS_GEN);
+					le16_to_cpu(domain->header.len) +
+					sizeof(struct mwifiex_ie_types_header)
+					+ S_DS_GEN);
 	} else {
 		cmd->size = cpu_to_le16(sizeof(domain_info->action) + S_DS_GEN);
 	}
@@ -698,8 +699,8 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 				+ S_DS_GEN);
 
 	if (cmd_action == HostCmd_ACT_GEN_SET) {
-		if ((priv->adapter->adhoc_start_band & BAND_A)
-		    || (priv->adapter->adhoc_start_band & BAND_AN))
+		if ((priv->adapter->adhoc_start_band & BAND_A) ||
+		    (priv->adapter->adhoc_start_band & BAND_AN))
 			rf_chan->rf_type =
 				cpu_to_le16(HostCmd_SCAN_RADIO_TYPE_A);
 
@@ -777,7 +778,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 
 		cmd->size = cpu_to_le16(sizeof(*mac_reg) + S_DS_GEN);
 		mac_reg = (struct host_cmd_ds_mac_reg_access *) &cmd->
-			params.mac_reg;
+								params.mac_reg;
 		mac_reg->action = cpu_to_le16(cmd_action);
 		mac_reg->offset =
 			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
@@ -789,8 +790,8 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 		struct host_cmd_ds_bbp_reg_access *bbp_reg;
 
 		cmd->size = cpu_to_le16(sizeof(*bbp_reg) + S_DS_GEN);
-		bbp_reg = (struct host_cmd_ds_bbp_reg_access *) &cmd->
-			params.bbp_reg;
+		bbp_reg = (struct host_cmd_ds_bbp_reg_access *)
+							&cmd->params.bbp_reg;
 		bbp_reg->action = cpu_to_le16(cmd_action);
 		bbp_reg->offset =
 			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
@@ -802,11 +803,10 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 		struct host_cmd_ds_rf_reg_access *rf_reg;
 
 		cmd->size = cpu_to_le16(sizeof(*rf_reg) + S_DS_GEN);
-		rf_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
-			params.rf_reg;
+		rf_reg = (struct host_cmd_ds_rf_reg_access *)
+							&cmd->params.rf_reg;
 		rf_reg->action = cpu_to_le16(cmd_action);
-		rf_reg->offset =
-			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		rf_reg->offset = cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
 		rf_reg->value = (u8) le32_to_cpu(reg_rw->value);
 		break;
 	}
@@ -819,7 +819,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 				params.pmic_reg;
 		pmic_reg->action = cpu_to_le16(cmd_action);
 		pmic_reg->offset =
-			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
 		pmic_reg->value = (u8) le32_to_cpu(reg_rw->value);
 		break;
 	}
@@ -828,11 +828,11 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 		struct host_cmd_ds_rf_reg_access *cau_reg;
 
 		cmd->size = cpu_to_le16(sizeof(*cau_reg) + S_DS_GEN);
-		cau_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
-				params.rf_reg;
+		cau_reg = (struct host_cmd_ds_rf_reg_access *)
+							&cmd->params.rf_reg;
 		cau_reg->action = cpu_to_le16(cmd_action);
 		cau_reg->offset =
-			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
 		cau_reg->value = (u8) le32_to_cpu(reg_rw->value);
 		break;
 	}
@@ -868,7 +868,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
  */
 static int
 mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
-				   struct host_cmd_ds_command *cmd, u16 action)
+			   struct host_cmd_ds_command *cmd, u16 action)
 {
 	struct host_cmd_ds_pcie_details *host_spec =
 					&cmd->params.pcie_host_spec;
@@ -882,29 +882,25 @@ mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
 
 	memset(host_spec, 0, sizeof(struct host_cmd_ds_pcie_details));
 
-	if (action == HostCmd_ACT_GEN_SET) {
-		/* Send the ring base addresses and count to firmware */
-		host_spec->txbd_addr_lo = (u32)(card->txbd_ring_pbase);
-		host_spec->txbd_addr_hi =
-				(u32)(((u64)card->txbd_ring_pbase)>>32);
-		host_spec->txbd_count = MWIFIEX_MAX_TXRX_BD;
-		host_spec->rxbd_addr_lo = (u32)(card->rxbd_ring_pbase);
-		host_spec->rxbd_addr_hi =
-				(u32)(((u64)card->rxbd_ring_pbase)>>32);
-		host_spec->rxbd_count = MWIFIEX_MAX_TXRX_BD;
-		host_spec->evtbd_addr_lo =
-				(u32)(card->evtbd_ring_pbase);
-		host_spec->evtbd_addr_hi =
-				(u32)(((u64)card->evtbd_ring_pbase)>>32);
-		host_spec->evtbd_count = MWIFIEX_MAX_EVT_BD;
-		if (card->sleep_cookie) {
-			buf_pa = MWIFIEX_SKB_PACB(card->sleep_cookie);
-			host_spec->sleep_cookie_addr_lo = (u32) *buf_pa;
-			host_spec->sleep_cookie_addr_hi =
-						(u32) (((u64)*buf_pa) >> 32);
-			dev_dbg(priv->adapter->dev, "sleep_cook_lo phy addr: "
-				 "0x%x\n", host_spec->sleep_cookie_addr_lo);
-		}
+	if (action != HostCmd_ACT_GEN_SET)
+		return 0;
+
+	/* Send the ring base addresses and count to firmware */
+	host_spec->txbd_addr_lo = (u32)(card->txbd_ring_pbase);
+	host_spec->txbd_addr_hi = (u32)(((u64)card->txbd_ring_pbase)>>32);
+	host_spec->txbd_count = MWIFIEX_MAX_TXRX_BD;
+	host_spec->rxbd_addr_lo = (u32)(card->rxbd_ring_pbase);
+	host_spec->rxbd_addr_hi = (u32)(((u64)card->rxbd_ring_pbase)>>32);
+	host_spec->rxbd_count = MWIFIEX_MAX_TXRX_BD;
+	host_spec->evtbd_addr_lo = (u32)(card->evtbd_ring_pbase);
+	host_spec->evtbd_addr_hi = (u32)(((u64)card->evtbd_ring_pbase)>>32);
+	host_spec->evtbd_count = MWIFIEX_MAX_EVT_BD;
+	if (card->sleep_cookie) {
+		buf_pa = MWIFIEX_SKB_PACB(card->sleep_cookie);
+		host_spec->sleep_cookie_addr_lo = (u32) *buf_pa;
+		host_spec->sleep_cookie_addr_hi = (u32) (((u64)*buf_pa) >> 32);
+		dev_dbg(priv->adapter->dev, "sleep_cook_lo phy addr: 0x%x\n",
+			host_spec->sleep_cookie_addr_lo);
 	}
 
 	return 0;
@@ -1036,12 +1032,12 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		break;
 	case HostCmd_CMD_802_11_KEY_MATERIAL:
 		ret = mwifiex_cmd_802_11_key_material(priv, cmd_ptr,
-						cmd_action, cmd_oid,
-						data_buf);
+						      cmd_action, cmd_oid,
+						      data_buf);
 		break;
 	case HostCmd_CMD_802_11D_DOMAIN_INFO:
 		ret = mwifiex_cmd_802_11d_domain_info(priv, cmd_ptr,
-						cmd_action);
+						      cmd_action);
 		break;
 	case HostCmd_CMD_RECONFIGURE_TX_BUFF:
 		ret = mwifiex_cmd_recfg_tx_buf(priv, cmd_ptr, cmd_action,
@@ -1052,8 +1048,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 						  data_buf);
 		break;
 	case HostCmd_CMD_11N_CFG:
-		ret = mwifiex_cmd_11n_cfg(cmd_ptr, cmd_action,
-					  data_buf);
+		ret = mwifiex_cmd_11n_cfg(cmd_ptr, cmd_action, data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
 		dev_dbg(priv->adapter->dev,
@@ -1131,8 +1126,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (first_sta) {
 		if (priv->adapter->iface_type == MWIFIEX_PCIE) {
 			ret = mwifiex_send_cmd_async(priv,
-					HostCmd_CMD_PCIE_DESC_DETAILS,
-					HostCmd_ACT_GEN_SET, 0, NULL);
+						HostCmd_CMD_PCIE_DESC_DETAILS,
+						HostCmd_ACT_GEN_SET, 0, NULL);
 			if (ret)
 				return -1;
 		}
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index a2a9c51..4da19ed 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -49,7 +49,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	unsigned long flags;
 
 	dev_err(adapter->dev, "CMD_RESP: cmd %#x error, result=%#x\n",
-			resp->command, resp->result);
+		resp->command, resp->result);
 
 	if (adapter->curr_cmd->wait_q_enabled)
 		adapter->cmd_wait_q.status = -1;
@@ -57,13 +57,13 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	switch (le16_to_cpu(resp->command)) {
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		pm = &resp->params.psmode_enh;
-		dev_err(adapter->dev, "PS_MODE_ENH cmd failed: "
-					"result=0x%x action=0x%X\n",
-				resp->result, le16_to_cpu(pm->action));
+		dev_err(adapter->dev,
+			"PS_MODE_ENH cmd failed: result=0x%x action=0x%X\n",
+			resp->result, le16_to_cpu(pm->action));
 		/* We do not re-try enter-ps command in ad-hoc mode. */
 		if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
-			(le16_to_cpu(pm->params.ps_bitmap) & BITMAP_STA_PS) &&
-				priv->bss_mode == NL80211_IFTYPE_ADHOC)
+		    (le16_to_cpu(pm->params.ps_bitmap) & BITMAP_STA_PS) &&
+		    priv->bss_mode == NL80211_IFTYPE_ADHOC)
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
 
 		break;
@@ -123,7 +123,7 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 					struct mwifiex_ds_get_signal *signal)
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
-		&resp->params.rssi_info_rsp;
+						&resp->params.rssi_info_rsp;
 
 	priv->data_rssi_last = le16_to_cpu(rssi_info_rsp->data_rssi_last);
 	priv->data_nf_last = le16_to_cpu(rssi_info_rsp->data_nf_last);
@@ -191,8 +191,8 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 	u32 ul_temp;
 
 	dev_dbg(priv->adapter->dev, "info: SNMP_RESP: oid value = %#x,"
-			" query_type = %#x, buf size = %#x\n",
-			oid, query_type, le16_to_cpu(smib->buf_size));
+		" query_type = %#x, buf size = %#x\n",
+		oid, query_type, le16_to_cpu(smib->buf_size));
 	if (query_type == HostCmd_ACT_GEN_GET) {
 		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
 		if (data_buf)
@@ -444,7 +444,7 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd action %d\n",
-				action);
+			action);
 		return 0;
 	}
 	dev_dbg(adapter->dev,
@@ -464,7 +464,7 @@ static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_mac_address *cmd_mac_addr =
-		&resp->params.mac_addr;
+							&resp->params.mac_addr;
 
 	memcpy(priv->curr_addr, cmd_mac_addr->mac_addr, ETH_ALEN);
 
@@ -549,7 +549,7 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 					   struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_key_material *key =
-		&resp->params.key_material;
+						&resp->params.key_material;
 
 	if (le16_to_cpu(key->action) == HostCmd_ACT_GEN_SET) {
 		if ((le16_to_cpu(key->key_param_set.key_info) & KEY_MCAST)) {
@@ -580,17 +580,18 @@ static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	u16 action = le16_to_cpu(domain_info->action);
 	u8 no_of_triplet;
 
-	no_of_triplet = (u8) ((le16_to_cpu(domain->header.len) -
-					IEEE80211_COUNTRY_STRING_LEN) /
-				sizeof(struct ieee80211_country_ie_triplet));
+	no_of_triplet = (u8) ((le16_to_cpu(domain->header.len)
+				- IEEE80211_COUNTRY_STRING_LEN)
+			      / sizeof(struct ieee80211_country_ie_triplet));
 
-	dev_dbg(priv->adapter->dev, "info: 11D Domain Info Resp:"
-			" no_of_triplet=%d\n", no_of_triplet);
+	dev_dbg(priv->adapter->dev,
+		"info: 11D Domain Info Resp: no_of_triplet=%d\n",
+		no_of_triplet);
 
 	if (no_of_triplet > MWIFIEX_MAX_TRIPLET_802_11D) {
 		dev_warn(priv->adapter->dev,
-			"11D: invalid number of triplets %d "
-			"returned!!\n", no_of_triplet);
+			 "11D: invalid number of triplets %d returned\n",
+			 no_of_triplet);
 		return -1;
 	}
 
@@ -624,8 +625,8 @@ static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 
 	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
 		dev_dbg(priv->adapter->dev, "cmd: Channel Switch: %d to %d\n",
-		       priv->curr_bss_params.bss_descriptor.channel,
-		       new_channel);
+			priv->curr_bss_params.bss_descriptor.channel,
+			new_channel);
 		/* Update the channel again */
 		priv->curr_bss_params.bss_descriptor.channel = new_channel;
 	}
@@ -747,7 +748,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 					      struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_ibss_status *ibss_coal_resp =
-		&(resp->params.ibss_coalescing);
+					&(resp->params.ibss_coalescing);
 	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 
 	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
@@ -887,20 +888,17 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_RECONFIGURE_TX_BUFF:
 		adapter->tx_buf_size = (u16) le16_to_cpu(resp->params.
 							     tx_buf.buff_size);
-		adapter->tx_buf_size = (adapter->tx_buf_size /
-						MWIFIEX_SDIO_BLOCK_SIZE) *
-						MWIFIEX_SDIO_BLOCK_SIZE;
+		adapter->tx_buf_size = (adapter->tx_buf_size
+					/ MWIFIEX_SDIO_BLOCK_SIZE)
+				       * MWIFIEX_SDIO_BLOCK_SIZE;
 		adapter->curr_tx_buf_size = adapter->tx_buf_size;
 		dev_dbg(adapter->dev,
 			"cmd: max_tx_buf_size=%d, tx_buf_size=%d\n",
-		       adapter->max_tx_buf_size, adapter->tx_buf_size);
+			adapter->max_tx_buf_size, adapter->tx_buf_size);
 
 		if (adapter->if_ops.update_mp_end_port)
 			adapter->if_ops.update_mp_end_port(adapter,
-					le16_to_cpu(resp->
-						params.
-						tx_buf.
-						mp_end_port));
+				le16_to_cpu(resp->params.tx_buf.mp_end_port));
 		break;
 	case HostCmd_CMD_AMSDU_AGGR_CTRL:
 		ret = mwifiex_ret_amsdu_aggr_ctrl(resp, data_buf);
@@ -928,7 +926,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
-		       resp->command);
+			resp->command);
 		break;
 	}
 
-- 
1.7.0.2

