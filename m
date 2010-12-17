Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16410 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0LQGkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 01:40:04 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 22:39:48 -0800
Date: Fri, 17 Dec 2010 12:09:57 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC 3/8] cfg80211: pass DFS region to drivers through
 reg_notifier()
Message-ID: <20101217063957.GB1381@senthil-lnx.users.atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
 <1292556197-4820-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1292556197-4820-4-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 08:53:12AM +0530, Luis R. Rodriguez wrote:
> This grants drivers access to the DFS region that a
> regulatory domain belongs to.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ar9170/main.c        |    6 ++++--
>  drivers/net/wireless/ath/ath5k/base.c         |    6 ++++--
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |    6 ++++--
>  drivers/net/wireless/ath/ath9k/init.c         |    5 +++--
>  drivers/net/wireless/ath/carl9170/main.c      |    6 ++++--
>  drivers/net/wireless/ath/regd.c               |    9 ++++++---
>  drivers/net/wireless/ath/regd.h               |    5 +++--
>  include/net/cfg80211.h                        |    3 ++-
>  net/wireless/reg.c                            |    4 +++-
>  9 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index 32bf79e..7f65d3d 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -2122,12 +2122,14 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
>  }
>  
>  static int ar9170_reg_notifier(struct wiphy *wiphy,
> -			struct regulatory_request *request)
> +			       struct regulatory_request *request,
> +			       u8 dfs_region)
>  {
>  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
>  	struct ar9170 *ar = hw->priv;
>  
> -	return ath_reg_notifier_apply(wiphy, request, &ar->common.regulatory);
> +	return ath_reg_notifier_apply(wiphy, request,
> +				      &ar->common.regulatory, dfs_region);
>  }
>  
>  int ar9170_register(struct ar9170 *ar, struct device *pdev)
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 4e3b97c..5a8d9a9 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -261,13 +261,15 @@ static const struct ath_ops ath5k_common_ops = {
>  * Driver Initialization *
>  \***********************/
>  
> -static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
> +static int ath5k_reg_notifier(struct wiphy *wiphy,
> +			      struct regulatory_request *request,
> +			      u8 dfs_region)
>  {
>  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
>  	struct ath5k_softc *sc = hw->priv;
>  	struct ath_regulatory *regulatory = ath5k_hw_regulatory(sc->ah);
>  
> -	return ath_reg_notifier_apply(wiphy, request, regulatory);
> +	return ath_reg_notifier_apply(wiphy, request, regulatory, dfs_region);
>  }
>  
>  /********************\
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index 0f6be35..2970026 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -266,13 +266,15 @@ err:
>  }
>  
>  static int ath9k_reg_notifier(struct wiphy *wiphy,
> -			      struct regulatory_request *request)
> +			      struct regulatory_request *request,
> +			      u8 dfs_region)
>  {
>  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
>  	struct ath9k_htc_priv *priv = hw->priv;
>  
>  	return ath_reg_notifier_apply(wiphy, request,
> -				      ath9k_hw_regulatory(priv->ah));
> +				      ath9k_hw_regulatory(priv->ah),
> +				      dfs_region);
>  }
>  
>  static unsigned int ath9k_regread(void *hw_priv, u32 reg_offset)
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 1238795..930ccec 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -249,14 +249,15 @@ static void setup_ht_cap(struct ath_softc *sc,
>  }
>  
>  static int ath9k_reg_notifier(struct wiphy *wiphy,
> -			      struct regulatory_request *request)
> +			      struct regulatory_request *request,
> +			      u8 dfs_region)
>  {
>  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
>  	struct ath_wiphy *aphy = hw->priv;
>  	struct ath_softc *sc = aphy->sc;
>  	struct ath_regulatory *reg = ath9k_hw_regulatory(sc->sc_ah);
>  
> -	return ath_reg_notifier_apply(wiphy, request, reg);
> +	return ath_reg_notifier_apply(wiphy, request, reg, dfs_region);
>  }
>  
>  /*
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index 870df8c..474a04a 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -1774,12 +1774,14 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
>  }
>  
>  static int carl9170_reg_notifier(struct wiphy *wiphy,
> -				 struct regulatory_request *request)
> +				 struct regulatory_request *request,
> +				 u8 dfs_region)
>  {
>  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
>  	struct ar9170 *ar = hw->priv;
>  
> -	return ath_reg_notifier_apply(wiphy, request, &ar->common.regulatory);
> +	return ath_reg_notifier_apply(wiphy, request,
> +				      &ar->common.regulatory, dfs_region);
>  }
>  
>  int carl9170_register(struct ar9170 *ar)
> diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
> index 2b14775..426b514 100644
> --- a/drivers/net/wireless/ath/regd.c
> +++ b/drivers/net/wireless/ath/regd.c
> @@ -337,7 +337,8 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
>  
>  int ath_reg_notifier_apply(struct wiphy *wiphy,
>  			   struct regulatory_request *request,
> -			   struct ath_regulatory *reg)
> +			   struct ath_regulatory *reg,
> +			   u16 dfs_region)
may be we can maintain consistency of dfs_regsion type. It's u8 everywhere
except here..???

>  {
>  	/* We always apply this */
>  	ath_reg_apply_radar_flags(wiphy);
> @@ -453,7 +454,8 @@ static int
>  ath_regd_init_wiphy(struct ath_regulatory *reg,
>  		    struct wiphy *wiphy,
>  		    int (*reg_notifier)(struct wiphy *wiphy,
> -					struct regulatory_request *request))
> +					struct regulatory_request *request,
> +					u8 dfs_region))
>  {
>  	const struct ieee80211_regdomain *regd;
>  
> @@ -500,7 +502,8 @@ int
>  ath_regd_init(struct ath_regulatory *reg,
>  	      struct wiphy *wiphy,
>  	      int (*reg_notifier)(struct wiphy *wiphy,
> -				  struct regulatory_request *request))
> +				  struct regulatory_request *request,
> +				  u8 dfs_region))
>  {
>  	struct country_code_to_enum_rd *country = NULL;
>  	u16 regdmn;
> diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
> index 345dd97..e06c784 100644
> --- a/drivers/net/wireless/ath/regd.h
> +++ b/drivers/net/wireless/ath/regd.h
> @@ -252,11 +252,12 @@ enum CountryCode {
>  bool ath_is_world_regd(struct ath_regulatory *reg);
>  int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
>  		  int (*reg_notifier)(struct wiphy *wiphy,
> -		  struct regulatory_request *request));
> +		  struct regulatory_request *request, u8 dfs_region));
>  u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
>  			  enum ieee80211_band band);
>  int ath_reg_notifier_apply(struct wiphy *wiphy,
>  			   struct regulatory_request *request,
> -			   struct ath_regulatory *reg);
> +			   struct ath_regulatory *reg,
> +			   u16 dfs_region);
>  
>  #endif
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 1db4d8d..ae5d590 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1533,7 +1533,8 @@ struct wiphy {
>  
>  	/* Lets us get back the wiphy on the callback */
>  	int (*reg_notifier)(struct wiphy *wiphy,
> -			    struct regulatory_request *request);
> +			    struct regulatory_request *request,
> +			    u8 dfs_region);
>  
>  	/* fields below are read-only, assigned by cfg80211 */
>  
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index a3731d2..b6780f6 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1126,6 +1126,8 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
>  			     enum nl80211_reg_initiator initiator)
>  {
>  	enum ieee80211_band band;
> +	u8 dfs_region = (cfg80211_regdomain->flags &
> +			 NL80211_CFLAG_ALL_DFS_FLAGS);
>  
>  	if (ignore_reg_update(wiphy, initiator))
>  		goto out;
> @@ -1137,7 +1139,7 @@ out:
>  	reg_process_beacons(wiphy);
>  	reg_process_ht_flags(wiphy);
>  	if (wiphy->reg_notifier)
> -		wiphy->reg_notifier(wiphy, last_request);
> +		wiphy->reg_notifier(wiphy, last_request, dfs_region);
>  }
>  
>  static void handle_channel_custom(struct wiphy *wiphy,
> -- 
> 1.7.3.2.90.gd4c43
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
