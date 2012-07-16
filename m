Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2GPOJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 10:09:16 -0400
Message-ID: <1342447770.11265.8.camel@dcbw.foobar.com> (sfid-20120716_160920_540464_4616EC9F)
Subject: Re: [PATCH 1/3] libertas: Update 11d info only when interface is
 active
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Mon, 16 Jul 2012 09:09:30 -0500
In-Reply-To: <20120715224458.6677C9D401E@zog.reactivated.net>
References: <20120715224458.6677C9D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-15 at 23:44 +0100, Daniel Drake wrote:
> reg_notifier can be called before the interface is up.
> Handle this correctly by storing the requested country code, then
> apply the relevant configuration when the interface is brought up.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cfg.c  |    6 ++++--
>  drivers/net/wireless/libertas/cmd.c  |   19 ++++++++++---------
>  drivers/net/wireless/libertas/cmd.h  |    4 +---
>  drivers/net/wireless/libertas/dev.h  |    1 +
>  drivers/net/wireless/libertas/main.c |    6 ++++++
>  5 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 2fa879b..c338f0b 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -2164,13 +2164,15 @@ int lbs_reg_notifier(struct wiphy *wiphy,
>  		struct regulatory_request *request)
>  {
>  	struct lbs_private *priv = wiphy_priv(wiphy);
> -	int ret;
> +	int ret = 0;
>  
>  	lbs_deb_enter_args(LBS_DEB_CFG80211, "cfg80211 regulatory domain "
>  			"callback for domain %c%c\n", request->alpha2[0],
>  			request->alpha2[1]);
>  
> -	ret = lbs_set_11d_domain_info(priv, request, wiphy->bands);
> +	memcpy(priv->country_code, request->alpha2, sizeof(request->alpha2));
> +	if (lbs_iface_active(priv))
> +		ret = lbs_set_11d_domain_info(priv);
>  
>  	lbs_deb_leave(LBS_DEB_CFG80211);
>  	return ret;
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index d798bcc..dd0743c 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -733,15 +733,13 @@ int lbs_get_rssi(struct lbs_private *priv, s8 *rssi, s8 *nf)
>   *  to the firmware
>   *
>   *  @priv:	pointer to &struct lbs_private
> - *  @request:	cfg80211 regulatory request structure
> - *  @bands:	the device's supported bands and channels
>   *
>   *  returns:	0 on success, error code on failure
>  */
> -int lbs_set_11d_domain_info(struct lbs_private *priv,
> -			    struct regulatory_request *request,
> -			    struct ieee80211_supported_band **bands)
> +int lbs_set_11d_domain_info(struct lbs_private *priv)
>  {
> +	struct wiphy *wiphy = priv->wdev->wiphy;
> +	struct ieee80211_supported_band **bands = wiphy->bands;
>  	struct cmd_ds_802_11d_domain_info cmd;
>  	struct mrvl_ie_domain_param_set *domain = &cmd.domain;
>  	struct ieee80211_country_ie_triplet *t;
> @@ -752,21 +750,23 @@ int lbs_set_11d_domain_info(struct lbs_private *priv,
>  	u8 first_channel = 0, next_chan = 0, max_pwr = 0;
>  	u8 i, flag = 0;
>  	size_t triplet_size;
> -	int ret;
> +	int ret = 0;
>  
>  	lbs_deb_enter(LBS_DEB_11D);
> +	if (!priv->country_code[0])
> +		goto out;
>  
>  	memset(&cmd, 0, sizeof(cmd));
>  	cmd.action = cpu_to_le16(CMD_ACT_SET);
>  
>  	lbs_deb_11d("Setting country code '%c%c'\n",
> -		    request->alpha2[0], request->alpha2[1]);
> +		    priv->country_code[0], priv->country_code[1]);
>  
>  	domain->header.type = cpu_to_le16(TLV_TYPE_DOMAIN);
>  
>  	/* Set country code */
> -	domain->country_code[0] = request->alpha2[0];
> -	domain->country_code[1] = request->alpha2[1];
> +	domain->country_code[0] = priv->country_code[0];
> +	domain->country_code[1] = priv->country_code[1];
>  	domain->country_code[2] = ' ';
>  
>  	/* Now set up the channel triplets; firmware is somewhat picky here
> @@ -848,6 +848,7 @@ int lbs_set_11d_domain_info(struct lbs_private *priv,
>  
>  	ret = lbs_cmd_with_response(priv, CMD_802_11D_DOMAIN_INFO, &cmd);
>  
> +out:
>  	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
>  	return ret;
>  }
> diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
> index b280ef7..ab07608 100644
> --- a/drivers/net/wireless/libertas/cmd.h
> +++ b/drivers/net/wireless/libertas/cmd.h
> @@ -128,9 +128,7 @@ int lbs_set_monitor_mode(struct lbs_private *priv, int enable);
>  
>  int lbs_get_rssi(struct lbs_private *priv, s8 *snr, s8 *nf);
>  
> -int lbs_set_11d_domain_info(struct lbs_private *priv,
> -			    struct regulatory_request *request,
> -			    struct ieee80211_supported_band **bands);
> +int lbs_set_11d_domain_info(struct lbs_private *priv);
>  
>  int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value);
>  
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index 6720054..ba955cb 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -49,6 +49,7 @@ struct lbs_private {
>  	bool wiphy_registered;
>  	struct cfg80211_scan_request *scan_req;
>  	u8 assoc_bss[ETH_ALEN];
> +	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
>  	u8 disassoc_reason;
>  
>  	/* Mesh */
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index e96ee0a..5804818 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -152,6 +152,12 @@ int lbs_start_iface(struct lbs_private *priv)
>  		goto err;
>  	}
>  
> +	ret = lbs_set_11d_domain_info(priv);
> +	if (ret) {
> +		lbs_deb_net("set 11d domain info failed\n");
> +		goto err;
> +	}
> +
>  	lbs_update_channel(priv);
>  
>  	priv->iface_running = true;


