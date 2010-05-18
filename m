Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab0ERE0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 00:26:53 -0400
Subject: Re: [RFC] Libertas: Added 11d support using cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Kiran Divekar <dkiran@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04D61E8DA4@SC-VEXCH1.marvell.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C04D61E8DA4@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 21:26:46 -0700
Message-ID: <1274156806.14012.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-13 at 04:00 -0700, Kiran Divekar wrote:
> Added 11d support for libertas driver using cfg80211. This is based on Holger Shurig's initial work to add cfg80211 support libertas.
> (https://patchwork.kernel.org/patch/64286/)
> 
> Please let us know, if there are any improvements comments.
> 
> Code is added to send 11d enable command to firmware while
> initialisation and pass 11d specific information to firmware
> when notifier handler is called by cfg80211.

Looks OK, though I'd prefer making 11D_DOMAIN_INFO a direct command
instead.  But if you don't want to do that right now, that's fine, just
send the final patch and I'll ack it.

Acked-by: Dan Williams <dcbw@redhat.com>

> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> ---
>  drivers/net/wireless/libertas/cfg.c     |  110 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/libertas/cfg.h     |    5 ++
>  drivers/net/wireless/libertas/cmd.c     |   65 ++++++++++++++++++
>  drivers/net/wireless/libertas/cmdresp.c |   50 ++++++++++++++
>  drivers/net/wireless/libertas/decl.h    |    5 ++
>  drivers/net/wireless/libertas/dev.h     |    3 +
>  drivers/net/wireless/libertas/host.h    |   28 ++++++++-
>  drivers/net/wireless/libertas/main.c    |    3 +
>  8 files changed, 268 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 9b23728..7a44384 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -8,6 +8,7 @@
>  
>  #include <linux/slab.h>
>  #include <linux/if_arp.h>
> +#include <linux/ieee80211.h>
>  #include <net/cfg80211.h>
>  #include <asm/unaligned.h>
>  
> @@ -2044,6 +2045,7 @@ int lbs_cfg_register(struct lbs_private *priv)
>  	 */
>  	wdev->wiphy->cipher_suites = cipher_suites;
>  	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
> +	wdev->wiphy->reg_notifier = lbs_reg_notifier;
>  
>  	ret = wiphy_register(wdev->wiphy);
>  	if (ret < 0)
> @@ -2063,6 +2065,114 @@ int lbs_cfg_register(struct lbs_private *priv)
>  	return ret;
>  }
>  
> +/**
> + *  @brief This function sets DOMAIN INFO to FW
> + *  @param priv       pointer to struct lbs_private
> + *  @return          0; -1
> +*/
> +static int lbs_11d_set_domain_info(struct lbs_private *priv)
> +{
> +	int ret;
> +
> +	ret = lbs_prepare_and_send_command(priv, CMD_802_11D_DOMAIN_INFO,
> +			CMD_ACT_SET,
> +			CMD_OPTION_WAITFORRSP, 0, NULL);
> +	if (ret)
> +		lbs_deb_11d("fail to dnld domain info\n");
> +
> +	return ret;
> +}
> +
> +static void lbs_send_domain_info_cmd_fw(struct wiphy *wiphy,
> +					struct regulatory_request *request)
> +{
> +	u8   no_of_triplet = 0;
> +	u8   no_of_parsed_chan = 0;
> +	u8   first_channel = 0, next_chan = 0, max_pwr = 0;
> +	u8   i, flag = 0;
> +	enum ieee80211_band band;
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *ch;
> +	struct lbs_private *priv = wiphy_priv(wiphy);
> +	struct lbs_802_11d_domain_reg *domain_info = &priv->domain_reg;
> +	int ret = 0;
> +
> +	lbs_deb_enter(LBS_DEB_CFG80211);
> +
> +	/* Set country code */
> +	domain_info->country_code[0] = request->alpha2[0];
> +	domain_info->country_code[1] = request->alpha2[1];
> +	domain_info->country_code[2] = ' ';
> +
> +	for (band = 0; band < IEEE80211_NUM_BANDS ; band++) {
> +
> +		if (!wiphy->bands[band])
> +			continue;
> +
> +		sband = wiphy->bands[band];
> +
> +		for (i = 0; i < sband->n_channels ; i++) {
> +			ch = &sband->channels[i];
> +			if (ch->flags & IEEE80211_CHAN_DISABLED)
> +				continue;
> +
> +			if (!flag) {
> +				flag = 1;
> +				next_chan = first_channel = (u32) ch->hw_value;
> +				max_pwr = ch->max_power;
> +				no_of_parsed_chan = 1;
> +				continue;
> +			}
> +
> +			if (ch->hw_value == next_chan + 1 &&
> +					ch->max_power == max_pwr) {
> +				next_chan++;
> +				no_of_parsed_chan++;
> +			} else {
> +				domain_info->triplet[no_of_triplet]
> +					.chans.first_channel = first_channel;
> +				domain_info->triplet[no_of_triplet]
> +					.chans.num_channels = no_of_parsed_chan;
> +				domain_info->triplet[no_of_triplet]
> +					.chans.max_power = max_pwr;
> +				no_of_triplet++;
> +				flag = 0;
> +			}
> +		}
> +		if (flag) {
> +			domain_info->triplet[no_of_triplet]
> +				.chans.first_channel = first_channel;
> +			domain_info->triplet[no_of_triplet]
> +				.chans.num_channels = no_of_parsed_chan;
> +			domain_info->triplet[no_of_triplet]
> +				.chans.max_power = max_pwr;
> +			no_of_triplet++;
> +		}
> +	}
> +
> +	domain_info->no_triplet = no_of_triplet;
> +
> +	/* Set domain info */
> +	ret = lbs_11d_set_domain_info(priv);
> +	if (ret)
> +		lbs_pr_err("11D: error setting domain info in FW\n");
> +
> +	lbs_deb_leave(LBS_DEB_CFG80211);
> +}
> +
> +int lbs_reg_notifier(struct wiphy *wiphy,
> +		struct regulatory_request *request)
> +{
> +	lbs_deb_enter_args(LBS_DEB_CFG80211, "cfg80211 regulatory domain "
> +			"callback for domain %c%c\n", request->alpha2[0],
> +			request->alpha2[1]);
> +
> +	lbs_send_domain_info_cmd_fw(wiphy, request);
> +
> +	lbs_deb_leave(LBS_DEB_CFG80211);
> +
> +	return 0;
> +}
>  
>  void lbs_scan_deinit(struct lbs_private *priv)
>  {
> diff --git a/drivers/net/wireless/libertas/cfg.h b/drivers/net/wireless/libertas/cfg.h
> index eae3fd9..756fb98 100644
> --- a/drivers/net/wireless/libertas/cfg.h
> +++ b/drivers/net/wireless/libertas/cfg.h
> @@ -3,11 +3,16 @@
>  
>  struct device;
>  struct lbs_private;
> +struct regulatory_request;
> +struct wiphy;
>  
>  struct wireless_dev *lbs_cfg_alloc(struct device *dev);
>  int lbs_cfg_register(struct lbs_private *priv);
>  void lbs_cfg_free(struct lbs_private *priv);
>  
> +int lbs_reg_notifier(struct wiphy *wiphy,
> +		struct regulatory_request *request);
> +
>  /* All of those are TODOs: */
>  #define lbs_cmd_802_11_rssi(priv, cmdptr) (0)
>  #define lbs_ret_802_11_rssi(priv, resp) (0)
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 10067ca..cb93de9 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -877,6 +877,66 @@ void lbs_set_mac_control(struct lbs_private *priv)
>  }
>  
>  /**
> + *  @brief This function implements command CMD_802_11D_DOMAIN_INFO
> + *  @param priv       pointer to struct lbs_private
> + *  @param cmd        pointer to cmd buffer
> + *  @param cmdno      cmd ID
> + *  @param cmdOption  cmd action
> + *  @return           0
> +*/
> +int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
> +				 struct cmd_ds_command *cmd,
> +				 u16 cmdoption)
> +{
> +	struct cmd_ds_802_11d_domain_info *pdomaininfo =
> +	    &cmd->params.domaininfo;
> +	struct mrvl_ie_domain_param_set *domain = &pdomaininfo->domain;
> +	u8 nr_triplet = priv->domain_reg.no_triplet;
> +
> +	lbs_deb_enter(LBS_DEB_11D);
> +
> +	lbs_deb_11d("nr_triplet=%x\n", nr_triplet);
> +
> +	pdomaininfo->action = cpu_to_le16(cmdoption);
> +	if (cmdoption == CMD_ACT_GET) {
> +		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
> +					sizeof(struct cmd_header));
> +		lbs_deb_hex(LBS_DEB_11D, "802_11D_DOMAIN_INFO", (u8 *) cmd,
> +			le16_to_cpu(cmd->size));
> +		goto done;
> +	}
> +
> +	domain->header.type = cpu_to_le16(TLV_TYPE_DOMAIN);
> +	memcpy(domain->countrycode, priv->domain_reg.country_code,
> +	       sizeof(domain->countrycode));
> +
> +	domain->header.len = cpu_to_le16(nr_triplet
> +				* sizeof(struct ieee80211_country_ie_triplet)
> +				+ sizeof(domain->countrycode));
> +
> +	if (nr_triplet) {
> +		memcpy(domain->triplet, priv->domain_reg.triplet,
> +				nr_triplet *
> +				sizeof(struct ieee80211_country_ie_triplet));
> +
> +		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
> +					     le16_to_cpu(domain->header.len) +
> +					     sizeof(struct mrvl_ie_header) +
> +					     sizeof(struct cmd_header));
> +	} else {
> +		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
> +					sizeof(struct cmd_header));
> +	}
> +
> +	lbs_deb_hex(LBS_DEB_11D, "802_11D_DOMAIN_INFO", (u8 *) cmd,
> +			le16_to_cpu(cmd->size));
> +
> +done:
> +	lbs_deb_enter(LBS_DEB_11D);
> +	return 0;
> +}
> +
> +/**
>   *  @brief This function prepare the command before send to firmware.
>   *
>   *  @param priv		A pointer to struct lbs_private structure
> @@ -974,6 +1034,11 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
>  		ret = 0;
>  		goto done;
>  
> +	case CMD_802_11D_DOMAIN_INFO:
> +		cmdptr->command = cpu_to_le16(cmd_no);
> +		ret = lbs_cmd_802_11d_domain_info(priv, cmdptr, cmd_action);
> +		break;
> +
>  	case CMD_802_11_TPC_CFG:
>  		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
>  		cmdptr->size =
> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index d6c61bd..c31b32d 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -97,6 +97,52 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
>  	return ret;
>  }
>  
> +/**
> + *  @brief This function parses countryinfo from AP and download country info to FW
> + *  @param priv    pointer to struct lbs_private
> + *  @param resp    pointer to command response buffer
> + *  @return        0; -1
> + */
> +int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
> +{
> +	struct cmd_ds_802_11d_domain_info *domaininfo =
> +			&resp->params.domaininforesp;
> +	struct mrvl_ie_domain_param_set *domain = &domaininfo->domain;
> +	u16 action = le16_to_cpu(domaininfo->action);
> +	s16 ret = 0;
> +	u8 nr_triplet = 0;
> +
> +	lbs_deb_enter(LBS_DEB_11D);
> +
> +	lbs_deb_hex(LBS_DEB_11D, "domain info resp", (u8 *) resp,
> +			(int)le16_to_cpu(resp->size));
> +
> +	nr_triplet = (le16_to_cpu(domain->header.len) - COUNTRY_CODE_LEN) /
> +		sizeof(struct ieee80211_country_ie_triplet);
> +
> +	lbs_deb_11d("domain info resp: nr_triplet %d\n", nr_triplet);
> +
> +	if (nr_triplet > MRVDRV_MAX_TRIPLET_802_11D) {
> +		lbs_deb_11d("invalid number of triplets returned!!\n");
> +		return -1;
> +	}
> +
> +	switch (action) {
> +	case CMD_ACT_SET:	/*Proc set action */
> +		break;
> +
> +	case CMD_ACT_GET:
> +		break;
> +	default:
> +		lbs_deb_11d("invalid action:%d\n", domaininfo->action);
> +		ret = -1;
> +		break;
> +	}
> +
> +	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
> +	return ret;
> +}
> +
>  static inline int handle_cmd_response(struct lbs_private *priv,
>  				      struct cmd_header *cmd_response)
>  {
> @@ -130,6 +176,10 @@ static inline int handle_cmd_response(struct lbs_private *priv,
>  		ret = lbs_ret_802_11_rssi(priv, resp);
>  		break;
>  
> +	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
> +		ret = lbs_ret_802_11d_domain_info(resp);
> +		break;
> +
>  	case CMD_RET(CMD_802_11_TPC_CFG):
>  		spin_lock_irqsave(&priv->driver_lock, flags);
>  		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
> diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
> index 2bccad3..9d2566e 100644
> --- a/drivers/net/wireless/libertas/decl.h
> +++ b/drivers/net/wireless/libertas/decl.h
> @@ -13,6 +13,7 @@
>  struct lbs_private;
>  struct sk_buff;
>  struct net_device;
> +struct cmd_ds_command;
>  
> 
>  /* ethtool.c */
> @@ -52,5 +53,9 @@ int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
>  u32 lbs_fw_index_to_data_rate(u8 index);
>  u8 lbs_data_rate_to_fw_index(u32 rate);
>  
> +int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
> +		struct cmd_ds_command *cmd, u16 cmdoption);
> +
> +int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp);
>  
>  #endif
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index afbd891..d9dad5d 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -60,6 +60,9 @@ struct lbs_private {
>  	struct dentry *regs_dir;
>  	struct dentry *debugfs_regs_files[6];
>  
> +	/** 11D and domain regulatory data */
> +	struct lbs_802_11d_domain_reg domain_reg;
> +
>  	/* Hardware debugging */
>  	u32 mac_offset;
>  	u32 bbp_offset;
> diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> index 3809c0b..112fbf1 100644
> --- a/drivers/net/wireless/libertas/host.h
> +++ b/drivers/net/wireless/libertas/host.h
> @@ -389,6 +389,30 @@ struct lbs_offset_value {
>  	u32 value;
>  } __attribute__ ((packed));
>  
> +#define MRVDRV_MAX_TRIPLET_802_11D              83
> +
> +#define COUNTRY_CODE_LEN                        3
> +
> +struct mrvl_ie_domain_param_set {
> +	struct mrvl_ie_header header;
> +
> +	u8 countrycode[COUNTRY_CODE_LEN];
> +	struct ieee80211_country_ie_triplet triplet[1];
> +} __attribute__ ((packed));
> +
> +struct cmd_ds_802_11d_domain_info {
> +	__le16 action;
> +	struct mrvl_ie_domain_param_set domain;
> +} __attribute__ ((packed));
> +
> +struct lbs_802_11d_domain_reg {
> +	/** Country code*/
> +	u8 country_code[COUNTRY_CODE_LEN];
> +	/** No. of triplet*/
> +	u8 no_triplet;
> +	struct ieee80211_country_ie_triplet triplet[MRVDRV_MAX_TRIPLET_802_11D];
> +} __attribute__ ((packed));
> +
>  /*
>   * Define data structure for CMD_GET_HW_SPEC
>   * This structure defines the response for the GET_HW_SPEC command
> @@ -949,6 +973,9 @@ struct cmd_ds_command {
>  		struct cmd_ds_bbp_reg_access bbpreg;
>  		struct cmd_ds_rf_reg_access rfreg;
>  
> +		struct cmd_ds_802_11d_domain_info domaininfo;
> +		struct cmd_ds_802_11d_domain_info domaininforesp;
> +
>  		struct cmd_ds_802_11_tpc_cfg tpccfg;
>  		struct cmd_ds_802_11_afc afc;
>  		struct cmd_ds_802_11_led_ctrl ledgpio;
> @@ -958,5 +985,4 @@ struct cmd_ds_command {
>  		struct cmd_ds_802_11_beacon_control bcn_ctrl;
>  	} params;
>  } __attribute__ ((packed));
> -
>  #endif
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 2fd5042..ff4380e 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -629,6 +629,9 @@ static int lbs_setup_firmware(struct lbs_private *priv)
>  		priv->txpower_max = maxlevel;
>  	}
>  
> +	/* Send cmd to FW to enable 11D function */
> +	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
> +
>  	lbs_set_mac_control(priv);
>  done:
>  	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);


