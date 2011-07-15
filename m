Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33184 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1GORrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 13:47:05 -0400
Date: Fri, 15 Jul 2011 13:32:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: libertas-dev@lists.infradead.org, daniel@zonque.org,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: [PATCH] cfg80211: hold reg_mutex when updating regulatory
Message-ID: <20110715173240.GD2566@tuxdriver.com> (sfid-20110715_194713_276766_494DA021)
References: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
 <1310457159-16698-2-git-send-email-s.neumann@raumfeld.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310457159-16698-2-git-send-email-s.neumann@raumfeld.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis, any comment on this?

On Tue, Jul 12, 2011 at 09:52:39AM +0200, Sven Neumann wrote:
> The function wiphy_update_regulatory() uses the static variable
> last_request and thus needs to be called with reg_mutex held.
> This is the case for all users in reg.c, but the function was
> exported for use by wiphy_register(), from where it is called
> without the lock being held.
> 
> Fix this by making wiphy_update_regulatory() private and introducing
> regulatory_update() as a wrapper that acquires and holds the lock.
> 
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
> ---
>  net/wireless/core.c |    2 +-
>  net/wireless/core.h |    2 -
>  net/wireless/reg.c  |   62 +++++++++++++++++++++++++++++---------------------
>  net/wireless/reg.h  |    2 +
>  4 files changed, 39 insertions(+), 29 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index c22ef34..179921e 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -577,7 +577,7 @@ int wiphy_register(struct wiphy *wiphy)
>  	}
>  
>  	/* set up regulatory info */
> -	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
> +	regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
>  
>  	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
>  	cfg80211_rdev_list_generation++;
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 3dce1f1..0517d03 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -277,8 +277,6 @@ extern int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
>  			       char *newname);
>  
>  void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
> -void wiphy_update_regulatory(struct wiphy *wiphy,
> -			     enum nl80211_reg_initiator setby);
>  
>  void cfg80211_bss_expire(struct cfg80211_registered_device *dev);
>  void cfg80211_bss_age(struct cfg80211_registered_device *dev,
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 1ad0f39..a10dc34 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -912,14 +912,6 @@ static bool ignore_reg_update(struct wiphy *wiphy,
>  	return false;
>  }
>  
> -static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
> -{
> -	struct cfg80211_registered_device *rdev;
> -
> -	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
> -		wiphy_update_regulatory(&rdev->wiphy, initiator);
> -}
> -
>  static void handle_reg_beacon(struct wiphy *wiphy,
>  			      unsigned int chan_idx,
>  			      struct reg_beacon *reg_beacon)
> @@ -1119,24 +1111,6 @@ static void reg_process_ht_flags(struct wiphy *wiphy)
>  
>  }
>  
> -void wiphy_update_regulatory(struct wiphy *wiphy,
> -			     enum nl80211_reg_initiator initiator)
> -{
> -	enum ieee80211_band band;
> -
> -	if (ignore_reg_update(wiphy, initiator))
> -		goto out;
> -	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> -		if (wiphy->bands[band])
> -			handle_band(wiphy, band, initiator);
> -	}
> -out:
> -	reg_process_beacons(wiphy);
> -	reg_process_ht_flags(wiphy);
> -	if (wiphy->reg_notifier)
> -		wiphy->reg_notifier(wiphy, last_request);
> -}
> -
>  static void handle_channel_custom(struct wiphy *wiphy,
>  				  enum ieee80211_band band,
>  				  unsigned int chan_idx,
> @@ -1423,6 +1397,42 @@ new_request:
>  	return call_crda(last_request->alpha2);
>  }
>  
> +static void wiphy_update_regulatory(struct wiphy *wiphy,
> +				    enum nl80211_reg_initiator initiator)
> +{
> +	enum ieee80211_band band;
> +
> +	assert_reg_lock();
> +
> +	if (ignore_reg_update(wiphy, initiator))
> +		goto out;
> +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +		if (wiphy->bands[band])
> +			handle_band(wiphy, band, initiator);
> +	}
> +out:
> +	reg_process_beacons(wiphy);
> +	reg_process_ht_flags(wiphy);
> +	if (wiphy->reg_notifier)
> +		wiphy->reg_notifier(wiphy, last_request);
> +}
> +
> +static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
> +		wiphy_update_regulatory(&rdev->wiphy, initiator);
> +}
> +
> +void regulatory_update(struct wiphy *wiphy,
> +		       enum nl80211_reg_initiator setby)
> +{
> +	mutex_lock(&reg_mutex);
> +	wiphy_update_regulatory(wiphy, setby);
> +	mutex_unlock(&reg_mutex);
> +}
> +
>  /* This processes *all* regulatory hints */
>  static void reg_process_hint(struct regulatory_request *reg_request)
>  {
> diff --git a/net/wireless/reg.h b/net/wireless/reg.h
> index b67d1c3..4a56799 100644
> --- a/net/wireless/reg.h
> +++ b/net/wireless/reg.h
> @@ -16,6 +16,8 @@ void regulatory_exit(void);
>  
>  int set_regdom(const struct ieee80211_regdomain *rd);
>  
> +void regulatory_update(struct wiphy *wiphy, enum nl80211_reg_initiator setby);
> +
>  /**
>   * regulatory_hint_found_beacon - hints a beacon was found on a channel
>   * @wiphy: the wireless device where the beacon was found on
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
