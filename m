Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8723 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaFMKGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 06:06:31 -0400
Message-ID: <539ACD24.9070407@broadcom.com> (sfid-20140613_120638_938691_6C26DE25)
Date: Fri, 13 Jun 2014 12:06:28 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211: expose cfg80211_disable_40mhz_24ghz module parameter
References: <1402064613-19795-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1402064613-19795-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06-06-14 16:23, Arend van Spriel wrote:
> Drivers may need to know this variable value for configuring the
> device they are controlling. It can be determined indirectly by
> setting IEEE80211_HT_CAP_SUP_WIDTH_20_40 flag in the field
> ieee80211_sta_htcap::cap of 2G band. During the wiphy_register()
> call cfg80211 will clear that bit if the module parameter is true.
> However, brcmfmac for one needs to know the value to determine
> its custom regulatory domain which must be applied before doing
> the wiphy_register().
>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Johannes,
>
> In brcmfmac I need to know the value of cfg80211 module parameter
> as stated in the commit message. Just taking a shot at how to get
> this exposed. I was reluctant exporting the module parameter itself.

Hi Johannes,

Could you give me your feedback on this. Would be appreciated.

Regards,
Arend

> Regards,
> Arend
> ---
>   include/net/cfg80211.h |    9 +++++++++
>   net/wireless/core.c    |    6 ++++++
>   2 files changed, 15 insertions(+)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f3539a1..9279197 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3107,6 +3107,15 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
>   struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv);
>
>   /**
> + * wiphy_is_40mhz_24ghz_disabled - check whether 40MHz bandwidth in 2.4G
> + *
> + * @wiphy: The wiphy to check.
> + *
> + * Return: true is 40MHz is disabled in 2.4G band.
> + */
> +bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy);
> +
> +/**
>    * wiphy_register - register a wiphy with cfg80211
>    *
>    * @wiphy: The wiphy to register.
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 086cddd..52750ef 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -355,6 +355,12 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
>   }
>   EXPORT_SYMBOL(wiphy_new);
>
> +bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy)
> +{
> +	return cfg80211_disable_40mhz_24ghz;
> +}
> +EXPORT_SYMBOL(wiphy_is_40mhz_24ghz_disabled);
> +
>   static int wiphy_verify_combinations(struct wiphy *wiphy)
>   {
>   	const struct ieee80211_iface_combination *c;
>

