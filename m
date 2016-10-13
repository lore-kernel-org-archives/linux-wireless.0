Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36300 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754728AbcJMS6Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 14:58:25 -0400
Received: by mail-lf0-f44.google.com with SMTP id b75so149688630lfg.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 11:58:24 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Add support to update connection parameters
To: Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1476373178-31105-1-git-send-email-jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <61aa0cc9-6485-b206-56ce-cd682d91dd96@broadcom.com> (sfid-20161013_205850_107597_ECD7C7A1)
Date: Thu, 13 Oct 2016 20:58:22 +0200
MIME-Version: 1.0
In-Reply-To: <1476373178-31105-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-10-16 17:39, Jouni Malinen wrote:
> From: vamsi krishna <vamsin@qti.qualcomm.com>
> 
> Add functionality to update the connection parameters when in connected
> state, so that driver/firmware uses the updated parameters for
> subsequent roaming. This is for drivers that support internal BSS
> selection and roaming. The new command does not change the current
> association state, i.e., it can be used to update IE contents for future
> (re)associations without causing an immediate disassociation or
> reassociation with the current BSS.
> 
> This commit implements the required functionality for updating IEs for
> (Re)Association Request frame only. Other parameters can be added in
> future when required.
> 
> Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  include/net/cfg80211.h       | 22 ++++++++++++++++++++++
>  include/uapi/linux/nl80211.h |  7 +++++++
>  net/wireless/core.h          |  4 ++++
>  net/wireless/nl80211.c       | 33 +++++++++++++++++++++++++++++++++
>  net/wireless/rdev-ops.h      | 13 +++++++++++++
>  net/wireless/sme.c           | 10 ++++++++++
>  net/wireless/trace.h         | 19 +++++++++++++++++++
>  7 files changed, 108 insertions(+)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 5000ec7..a4fc28a 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2044,6 +2044,18 @@ struct cfg80211_connect_params {
>  };
>  
>  /**
> + * struct cfg80211_connect_params_valid - Connection parame ters to be updated

What's in a name? Could we just use '_updated' instead of '_valid' here
and below.

> + *
> + * This structure provides information of all connect parameters that
> + * have to be updated as part of update_connect_params() call.
> + *
> + * @assoc_ies_valid: Indicates whether association request IEs are updated
> + */
> +struct cfg80211_connect_params_valid {
> +	bool assoc_ies_valid;
> +};
> +
> +/**
>   * enum wiphy_params_flags - set_wiphy_params bitfield values
>   * @WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
>   * @WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
> @@ -2564,6 +2576,12 @@ struct cfg80211_nan_func {
>   *	cases, the result of roaming is indicated with a call to
>   *	cfg80211_roamed() or cfg80211_roamed_bss().
>   *	(invoked with the wireless_dev mutex held)
> + * @update_connect_params: Update the connect parameters while connected to a
> + *	BSS. The updated parameters can be used by driver/firmware for
> + *	subsequent BSS selection (roaming) decisions and to form the
> + *	Authentication/(Re)Association Request frames. This call does not
> + *	request an immediate disassociation or reassociation with the current
> + *	BSS, i.e., this impacts only subsequence (re)associations.

typo: should be 'subsequent' (I think ;-) ).

>   * @disconnect: Disconnect from the BSS/ESS. Once done, call
>   *	cfg80211_disconnected().
>   *	(invoked with the wireless_dev mutex held)
> @@ -2848,6 +2866,10 @@ struct cfg80211_ops {
>  
>  	int	(*connect)(struct wiphy *wiphy, struct net_device *dev,
>  			   struct cfg80211_connect_params *sme);
> +	int	(*update_connect_params)(struct wiphy *wiphy,
> +					 struct net_device *dev,
> +					 struct cfg80211_connect_params *sme,
> +					 struct cfg80211_connect_params_valid *cpv);

If the struct is renamed as proposed earlier the parameter might be
called 'cpu' although that might confuse code readers :-p

>  	int	(*disconnect)(struct wiphy *wiphy, struct net_device *dev,
>  			      u16 reason_code);
>  

[...]

> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index a77db33..93106da 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -1073,6 +1073,16 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
>  	return 0;
>  }
>  
> +int cfg80211_update_connect_params(struct cfg80211_registered_device *rdev,
> +				   struct net_device *dev,
> +				   struct cfg80211_connect_params *connect,
> +				   struct cfg80211_connect_params_valid *cpv)
> +{
> +	if (rdev->ops->update_connect_params)
> +		return rdev_update_connect_params(rdev, dev, connect, cpv);
> +	return 0;
> +}

So why is this function added in sme.c. It does not do an awful lot so
is there still something up your sleeve by which this makes more sense?

Regards,
Arend
