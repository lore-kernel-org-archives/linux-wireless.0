Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8A73B3894;
	Wed, 15 Jul 2026 16:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784133347; cv=none; b=T5gbvzaqHoBQFfqreVogtIWHihmL136pnZqKjhuO+9kladtez60gGEaX9jUNGDnjtb9v75FSiZyH73pemV9wWcm0sEleQke0oSow01JAfVmcadEXWVUYZckwzhBnbbzgOZLxXOeN4oJEcAJW76Nrju7BkMF23/vABURKeVOn/Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784133347; c=relaxed/simple;
	bh=RGAT27eQhFKhaoYKm+6RKUow0WqgRxbXRMsqqEn+iok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7TsapL2T6xEGG3akIHbYRCdfzPbza4brnM5wSjD7VJoEd9EKiY28QmsALGLDjf+/B99FRdF0tMJmK5ebMHDGsUhUDes/0E2Mc4XBVRfG6OqGr1eSLP1I67n0pLwRpcC7YnwrptLmxJgXJAcvx9RUKfS6ieiPoUrsdx0NHoJ4TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCY0d7Lk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCY0d7Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABB01F000E9;
	Wed, 15 Jul 2026 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784133343;
	bh=4nO3zAolY5TrJ/y7ChBWlq8RF/4GmBQfZSn+B2+iIf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kCY0d7LkDrpiYMTY3tMHXNpLmoJQErWXd+ZXXGKwIuLm6jz3HMXfshXF9U9xBs1zS
	 ShP6bly3VbqsRJ3yC0yiyH9hhBr3ecv13rJNMLjVl6zb69V310/hdyLUShh5AnvnoQ
	 kmKi0JQuNEE/CYzcAX9+SAGZkP2BDNur+PwEh8eZOMytZKTUlXX0P2t8zwEbKf1FEv
	 9Lt9dk19a1M7YmwKnIfGqjBeKtXCBFg5NyWNyFGH/6BnGWU2+FP3p27fKedy7n50+r
	 rPt/wZYT4C8kndYFSNMVVQYWfj/nNTFH88ORJyv1/jF8iDeJ5MZf9Uw4k2uZG/Wmg/
	 aRmpmrTf4F9fQ==
Date: Wed, 15 Jul 2026 09:35:42 -0700
From: Kees Cook <kees@kernel.org>
To: Georgi Valkov <gvalkov@gmail.com>
Cc: briannorris@chromium.org, francesco@dolcini.it, johannes.berg@intel.com,
	bhelgaas@google.com, error27@gmail.com, s.kerkmann@pengutronix.de,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: replace one-element arrays with flexible
 array members
Message-ID: <202607150932.F2A0836@keescook>
References: <20260712222334.7134-1-gvalkov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712222334.7134-1-gvalkov@gmail.com>

On Mon, Jul 13, 2026 at 01:23:34AM +0300, Georgi Valkov wrote:
> Replace deprecated one-element arrays with flexible array members.
> CONFIG_FORTIFY_SOURCE reports the following warning when
> one-element arrays are used as variable-length buffers:
> 
> sta_cmd.c:1033 mwifiex_sta_prepare_cmd
> memcpy: detected field-spanning write (size 84) of single field
> "domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)
> 
> Convert affected structs to use flexible array members.
> - Preserve existing wire layouts.
> - Replace affected uses of sizeof(member) with sizeof(type).
> - Replace unions containing one-element arrays with
>   u8 flexible arrays, and document the stored parameter-set type.
> 
> Tested-on: WRT3200ACM, OpenWrt
> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/fw.h     | 20 +++++++------------
>  drivers/net/wireless/marvell/mwifiex/join.c   |  8 ++++----
>  .../net/wireless/marvell/mwifiex/sta_cmd.c    |  2 +-
>  3 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
> index e9e896606912..ec3e3f806134 100644
> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
> @@ -823,7 +823,7 @@ struct chan_band_param_set {
>  
>  struct mwifiex_ie_types_chan_band_list_param_set {
>  	struct mwifiex_ie_types_header header;
> -	struct chan_band_param_set chan_band_param[1];
> +	struct chan_band_param_set chan_band_param[];
>  } __packed;
>  
>  struct mwifiex_ie_types_rates_param_set {
> @@ -886,7 +886,7 @@ struct mwifiex_ie_types_wildcard_ssid_params {
>  #define TSF_DATA_SIZE            8
>  struct mwifiex_ie_types_tsf_timestamp {
>  	struct mwifiex_ie_types_header header;
> -	u8 tsf_data[1];
> +	u8 tsf_data[];
>  } __packed;
>  
>  struct mwifiex_cf_param_set {
> @@ -902,10 +902,7 @@ struct mwifiex_ibss_param_set {
>  
>  struct mwifiex_ie_types_ss_param_set {
>  	struct mwifiex_ie_types_header header;
> -	union {
> -		struct mwifiex_cf_param_set cf_param_set[1];
> -		struct mwifiex_ibss_param_set ibss_param_set[1];
> -	} cf_ibss;
> +	u8 cf_ibss[];	/* CF and IBSS param sets are stored here */
>  } __packed;
>  
>  struct mwifiex_fh_param_set {
> @@ -921,10 +918,7 @@ struct mwifiex_ds_param_set {
>  
>  struct mwifiex_ie_types_phy_param_set {
>  	struct mwifiex_ie_types_header header;
> -	union {
> -		struct mwifiex_fh_param_set fh_param_set[1];
> -		struct mwifiex_ds_param_set ds_param_set[1];
> -	} fh_ds;
> +	u8 fh_ds[];	/* FH and DS param sets are stored here */
>  } __packed;

This (and below) can still be a union so you don't lose the type
information:

	union {
		DECLARE_FLEX_ARRAY(struct mwifiex_fh_param_set, fh_param_set);
		DECLARE_FLEX_ARRAY(struct mwifiex_ds_param_set, ds_param_set);
	} fh_ds;

>  
>  struct mwifiex_ie_types_auth_type {
> @@ -1383,7 +1377,7 @@ struct host_cmd_ds_802_11_snmp_mib {
>  	__le16 query_type;
>  	__le16 oid;
>  	__le16 buf_size;
> -	u8 value[1];
> +	u8 value[];
>  } __packed;
>  
>  struct mwifiex_rate_scope {
> @@ -1551,7 +1545,7 @@ struct mwifiex_scan_cmd_config {
>  	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
>  	 *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
>  	 */
> -	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
> +	u8 tlv_buf[];	/* SSID TLV(s) and ChanList TLVs are stored
>  				   here */
>  } __packed;
>  
> @@ -1683,7 +1677,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
>  struct mwifiex_ietypes_domain_param_set {
>  	struct mwifiex_ie_types_header header;
>  	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
> -	struct ieee80211_country_ie_triplet triplet[1];
> +	struct ieee80211_country_ie_triplet triplet[];
>  } __packed;
>  
>  struct host_cmd_ds_802_11d_domain_info {
> diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
> index 5a1a0287c1d5..a2c427e6af3f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/join.c
> +++ b/drivers/net/wireless/marvell/mwifiex/join.c
> @@ -421,15 +421,15 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
>  
>  	phy_tlv = (struct mwifiex_ie_types_phy_param_set *) pos;
>  	phy_tlv->header.type = cpu_to_le16(WLAN_EID_DS_PARAMS);
> -	phy_tlv->header.len = cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
> -	memcpy(&phy_tlv->fh_ds.ds_param_set,
> +	phy_tlv->header.len = cpu_to_le16(sizeof(struct mwifiex_ds_param_set));

And this would become (the "*" added to get the member size):

	phy_tlv->header.len = cpu_to_le16(sizeof(*phy_tlv->fh_ds.ds_param_set));

etc.

> +	memcpy(phy_tlv->fh_ds,
>  	       &bss_desc->phy_param_set.ds_param_set.current_chan,
> -	       sizeof(phy_tlv->fh_ds.ds_param_set));
> +	       sizeof(struct mwifiex_ds_param_set));
>  	pos += sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
>  
>  	ss_tlv = (struct mwifiex_ie_types_ss_param_set *) pos;
>  	ss_tlv->header.type = cpu_to_le16(WLAN_EID_CF_PARAMS);
> -	ss_tlv->header.len = cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
> +	ss_tlv->header.len = cpu_to_le16(sizeof(struct mwifiex_cf_param_set));
>  	pos += sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
>  
>  	/* Get the common rates supported between the driver and the BSS Desc */
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> index 623ddde8c8e5..071f7cb305e1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> @@ -108,7 +108,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
>  		    "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
>  	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
>  	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
> -				- 1 + S_DS_GEN);
> +				+ S_DS_GEN);
>  
>  	snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
>  	if (cmd_action == HostCmd_ACT_GEN_GET) {
> -- 
> 2.55.0
> 

-- 
Kees Cook
