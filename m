Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbYCDRPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:15:45 -0500
Subject: Re: [PATCH] libertas: convert KEY_MATERIAL to a direct command
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803031215.39947.hs4233@mail.mn-solutions.de>
References: <200803031215.39947.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:11:45 -0500
Message-Id: <1204650705.30024.0.camel@localhost.localdomain> (sfid-20080304_171550_140270_8C0715AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-03 at 12:15 +0100, Holger Schurig wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> The struct enc_key probably wants to die too, but that can come later.
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> 
> Hi John !
> 
> David said on IRC:
> 
> [11:18] <dwmw2> if you want to rebase the tree, or send the patches upstream, be my guest :)
> 
> So here are some patches from libertas-2.6 that I want to have
> upstream so that they don't bit-rot.
> 
> diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> index c622e9b..495c2bd 100644
> --- a/drivers/net/wireless/libertas/assoc.c
> +++ b/drivers/net/wireless/libertas/assoc.c
> @@ -358,11 +358,7 @@ static int assoc_helper_wpa_keys(struct lbs_private *priv,
>  
>  	if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
>  		clear_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags);
> -		ret = lbs_prepare_and_send_command(priv,
> -					CMD_802_11_KEY_MATERIAL,
> -					CMD_ACT_SET,
> -					CMD_OPTION_WAITFORRSP,
> -					0, assoc_req);
> +		ret = lbs_cmd_802_11_key_material(priv, CMD_ACT_SET, assoc_req);
>  		assoc_req->flags = flags;
>  	}
>  
> @@ -372,11 +368,7 @@ static int assoc_helper_wpa_keys(struct lbs_private *priv,
>  	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
>  		clear_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
>  
> -		ret = lbs_prepare_and_send_command(priv,
> -					CMD_802_11_KEY_MATERIAL,
> -					CMD_ACT_SET,
> -					CMD_OPTION_WAITFORRSP,
> -					0, assoc_req);
> +		ret = lbs_cmd_802_11_key_material(priv, CMD_ACT_SET, assoc_req);
>  		assoc_req->flags = flags;
>  	}
>  
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 4d06dec..9158328 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -327,75 +327,103 @@ int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
>  	return ret;
>  }
>  
> -static void set_one_wpa_key(struct MrvlIEtype_keyParamSet * pkeyparamset,
> -                            struct enc_key * pkey)
> +static void set_one_wpa_key(struct MrvlIEtype_keyParamSet *keyparam,
> +                            struct enc_key *key)
>  {
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> -	if (pkey->flags & KEY_INFO_WPA_ENABLED) {
> -		pkeyparamset->keyinfo |= cpu_to_le16(KEY_INFO_WPA_ENABLED);
> -	}
> -	if (pkey->flags & KEY_INFO_WPA_UNICAST) {
> -		pkeyparamset->keyinfo |= cpu_to_le16(KEY_INFO_WPA_UNICAST);
> -	}
> -	if (pkey->flags & KEY_INFO_WPA_MCAST) {
> -		pkeyparamset->keyinfo |= cpu_to_le16(KEY_INFO_WPA_MCAST);
> -	}
> +	if (key->flags & KEY_INFO_WPA_ENABLED)
> +		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_ENABLED);
> +	if (key->flags & KEY_INFO_WPA_UNICAST)
> +		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_UNICAST);
> +	if (key->flags & KEY_INFO_WPA_MCAST)
> +		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_MCAST);
>  
> -	pkeyparamset->type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
> -	pkeyparamset->keytypeid = cpu_to_le16(pkey->type);
> -	pkeyparamset->keylen = cpu_to_le16(pkey->len);
> -	memcpy(pkeyparamset->key, pkey->key, pkey->len);
> -	pkeyparamset->length = cpu_to_le16(  sizeof(pkeyparamset->keytypeid)
> -	                                        + sizeof(pkeyparamset->keyinfo)
> -	                                        + sizeof(pkeyparamset->keylen)
> -	                                        + sizeof(pkeyparamset->key));
> +	keyparam->type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
> +	keyparam->keytypeid = cpu_to_le16(key->type);
> +	keyparam->keylen = cpu_to_le16(key->len);
> +	memcpy(keyparam->key, key->key, key->len);
> +
> +	/* Length field doesn't include the {type,length} header */
> +	keyparam->length = cpu_to_le16(sizeof(*keyparam) - 4);
>  	lbs_deb_leave(LBS_DEB_CMD);
>  }
>  
> -static int lbs_cmd_802_11_key_material(struct lbs_private *priv,
> -					struct cmd_ds_command *cmd,
> -					u16 cmd_action,
> -					u32 cmd_oid, void *pdata_buf)
> +int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
> +				struct assoc_request *assoc)
>  {
> -	struct cmd_ds_802_11_key_material *pkeymaterial =
> -	    &cmd->params.keymaterial;
> -	struct assoc_request * assoc_req = pdata_buf;
> +	struct cmd_ds_802_11_key_material cmd;
>  	int ret = 0;
>  	int index = 0;
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> -	cmd->command = cpu_to_le16(CMD_802_11_KEY_MATERIAL);
> -	pkeymaterial->action = cpu_to_le16(cmd_action);
> +	cmd.action = cpu_to_le16(cmd_action);
> +	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  
>  	if (cmd_action == CMD_ACT_GET) {
> -		cmd->size = cpu_to_le16(S_DS_GEN + sizeof (pkeymaterial->action));
> -		ret = 0;
> -		goto done;
> -	}
> +		cmd.hdr.size = cpu_to_le16(S_DS_GEN + 2);
> +	} else {
> +		memset(cmd.keyParamSet, 0, sizeof(cmd.keyParamSet));
>  
> -	memset(&pkeymaterial->keyParamSet, 0, sizeof(pkeymaterial->keyParamSet));
> +		if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc->flags)) {
> +			set_one_wpa_key(&cmd.keyParamSet[index],
> +					&assoc->wpa_unicast_key);
> +			index++;
> +		}
>  
> -	if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
> -		set_one_wpa_key(&pkeymaterial->keyParamSet[index],
> -		                &assoc_req->wpa_unicast_key);
> -		index++;
> -	}
> +		if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc->flags)) {
> +			set_one_wpa_key(&cmd.keyParamSet[index],
> +					&assoc->wpa_mcast_key);
> +			index++;
> +		}
>  
> -	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
> -		set_one_wpa_key(&pkeymaterial->keyParamSet[index],
> -		                &assoc_req->wpa_mcast_key);
> -		index++;
> +		/* The common header and as many keys as we included */
> +		cmd.hdr.size = cpu_to_le16(offsetof(typeof(cmd),
> +						    keyParamSet[index]));
>  	}
> +	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
> +	/* Copy the returned key to driver private data */
> +	if (!ret && cmd_action == CMD_ACT_GET) {
> +		void *buf_ptr = cmd.keyParamSet;
> +		void *resp_end = &(&cmd)[1];
> +
> +		while (buf_ptr < resp_end) {
> +			struct MrvlIEtype_keyParamSet *keyparam = buf_ptr;
> +			struct enc_key *key;
> +			uint16_t param_set_len = le16_to_cpu(keyparam->length);
> +			uint16_t key_len = le16_to_cpu(keyparam->keylen);
> +			uint16_t key_flags = le16_to_cpu(keyparam->keyinfo);
> +			uint16_t key_type = le16_to_cpu(keyparam->keytypeid);
> +			void *end;
> +
> +			end = (void *)keyparam + sizeof(keyparam->type)
> +				+ sizeof(keyparam->length) + param_set_len;
> +
> +			/* Make sure we don't access past the end of the IEs */
> +			if (end > resp_end)
> +				break;
>  
> -	cmd->size = cpu_to_le16(  S_DS_GEN
> -	                        + sizeof (pkeymaterial->action)
> -	                        + (index * sizeof(struct MrvlIEtype_keyParamSet)));
> +			if (key_flags & KEY_INFO_WPA_UNICAST)
> +				key = &priv->wpa_unicast_key;
> +			else if (key_flags & KEY_INFO_WPA_MCAST)
> +				key = &priv->wpa_mcast_key;
> +			else
> +				break;
>  
> -	ret = 0;
> +			/* Copy returned key into driver */
> +			memset(key, 0, sizeof(struct enc_key));
> +			if (key_len > sizeof(key->key))
> +				break;
> +			key->type = key_type;
> +			key->flags = key_flags;
> +			key->len = key_len;
> +			memcpy(key->key, keyparam->key, key->len);
> +
> +			buf_ptr = end + 1;
> +		}
> +	}
>  
> -done:
>  	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
>  	return ret;
>  }
> @@ -1427,11 +1455,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
>  		ret = lbs_cmd_80211_ad_hoc_stop(priv, cmdptr);
>  		break;
>  
> -	case CMD_802_11_KEY_MATERIAL:
> -		ret = lbs_cmd_802_11_key_material(priv, cmdptr, cmd_action,
> -				cmd_oid, pdata_buf);
> -		break;
> -
>  	case CMD_802_11_PAIRWISE_TSC:
>  		break;
>  	case CMD_802_11_GROUP_TSC:
> diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
> index b9ab85c..d250e6b 100644
> --- a/drivers/net/wireless/libertas/cmd.h
> +++ b/drivers/net/wireless/libertas/cmd.h
> @@ -57,5 +57,7 @@ int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
>  			   struct assoc_request *assoc);
>  int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
>  			      uint16_t *enable);
> +int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
> +				struct assoc_request *assoc);
>  
>  #endif /* _LBS_CMD_H */
> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index 159216a..595fbff 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -204,61 +204,6 @@ static int lbs_ret_802_11_snmp_mib(struct lbs_private *priv,
>  	return 0;
>  }
>  
> -static int lbs_ret_802_11_key_material(struct lbs_private *priv,
> -					struct cmd_ds_command *resp)
> -{
> -	struct cmd_ds_802_11_key_material *pkeymaterial =
> -	    &resp->params.keymaterial;
> -	u16 action = le16_to_cpu(pkeymaterial->action);
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
> -	/* Copy the returned key to driver private data */
> -	if (action == CMD_ACT_GET) {
> -		u8 * buf_ptr = (u8 *) &pkeymaterial->keyParamSet;
> -		u8 * resp_end = (u8 *) (resp + le16_to_cpu(resp->size));
> -
> -		while (buf_ptr < resp_end) {
> -			struct MrvlIEtype_keyParamSet * pkeyparamset =
> -			    (struct MrvlIEtype_keyParamSet *) buf_ptr;
> -			struct enc_key * pkey;
> -			u16 param_set_len = le16_to_cpu(pkeyparamset->length);
> -			u16 key_len = le16_to_cpu(pkeyparamset->keylen);
> -			u16 key_flags = le16_to_cpu(pkeyparamset->keyinfo);
> -			u16 key_type = le16_to_cpu(pkeyparamset->keytypeid);
> -			u8 * end;
> -
> -			end = (u8 *) pkeyparamset + sizeof (pkeyparamset->type)
> -			                          + sizeof (pkeyparamset->length)
> -			                          + param_set_len;
> -			/* Make sure we don't access past the end of the IEs */
> -			if (end > resp_end)
> -				break;
> -
> -			if (key_flags & KEY_INFO_WPA_UNICAST)
> -				pkey = &priv->wpa_unicast_key;
> -			else if (key_flags & KEY_INFO_WPA_MCAST)
> -				pkey = &priv->wpa_mcast_key;
> -			else
> -				break;
> -
> -			/* Copy returned key into driver */
> -			memset(pkey, 0, sizeof(struct enc_key));
> -			if (key_len > sizeof(pkey->key))
> -				break;
> -			pkey->type = key_type;
> -			pkey->flags = key_flags;
> -			pkey->len = key_len;
> -			memcpy(pkey->key, pkeyparamset->key, pkey->len);
> -
> -			buf_ptr = end + 1;
> -		}
> -	}
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -	return 0;
> -}
> -
>  static int lbs_ret_802_11_mac_address(struct lbs_private *priv,
>  				       struct cmd_ds_command *resp)
>  {
> @@ -475,10 +420,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
>  		ret = lbs_ret_80211_ad_hoc_stop(priv, resp);
>  		break;
>  
> -	case CMD_RET(CMD_802_11_KEY_MATERIAL):
> -		ret = lbs_ret_802_11_key_material(priv, resp);
> -		break;
> -
>  	case CMD_RET(CMD_802_11_EEPROM_ACCESS):
>  		ret = lbs_ret_802_11_eeprom_access(priv, resp);
>  		break;
> diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
> index be325ed..b183fc1 100644
> --- a/drivers/net/wireless/libertas/hostcmd.h
> +++ b/drivers/net/wireless/libertas/hostcmd.h
> @@ -572,6 +572,8 @@ struct cmd_ds_host_sleep {
>  } __attribute__ ((packed));
>  
>  struct cmd_ds_802_11_key_material {
> +	struct cmd_header hdr;
> +
>  	__le16 action;
>  	struct MrvlIEtype_keyParamSet keyParamSet[2];
>  } __attribute__ ((packed));
> @@ -712,7 +714,6 @@ struct cmd_ds_command {
>  		struct cmd_ds_802_11_rssi_rsp rssirsp;
>  		struct cmd_ds_802_11_disassociate dassociate;
>  		struct cmd_ds_802_11_mac_address macadd;
> -		struct cmd_ds_802_11_key_material keymaterial;
>  		struct cmd_ds_mac_reg_access macreg;
>  		struct cmd_ds_bbp_reg_access bbpreg;
>  		struct cmd_ds_rf_reg_access rfreg;

