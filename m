Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33470 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAYAUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:20:10 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so3697181pde.35
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 16:20:09 -0800 (PST)
Date: Fri, 24 Jan 2014 16:20:05 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v2 4/6] cfg80211: Add an option to hint indoor operation
Message-ID: <20140125002002.GB28512@garbanzo.do-not-panic.com> (sfid-20140125_012014_979566_63DA6349)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <1389801162-14488-5-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389801162-14488-5-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 15, 2014 at 05:52:40PM +0200, Ilan Peer wrote:
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 212b5c2..0361035 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -110,6 +110,14 @@ const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
>   */
>  static int reg_num_devs_support_basehint;
>  
> +/*
> + * State variable indicating if the platform on which the devices
> + * are attached is operating in an indoor environment. The state variable
> + * is relevant for all registered devices.
> + * Note: currently not protected by any synchronization primitive.
> + */
> +static bool reg_is_indoor;
> +

See if it makes sense to instead start building up a single reg
data structure that has a slew of members. That's welcomed as a
separate patch later...

> @@ -1475,6 +1493,11 @@ reg_process_hint_user(struct regulatory_request *user_request)
>  		return treatment;
>  	}
>  
> +	if (reg_request_indoor(user_request) && treatment == REG_REQ_OK) {
> +		reg_is_indoor = true;
> +		return REG_REQ_OK;
> +	}
> +

Are you setting this to false when we disconnect (reset regulatory)?
You should.

> @@ -1658,9 +1681,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>  	struct wiphy *wiphy = NULL;
>  	enum reg_request_treatment treatment;
>  
> -	if (WARN_ON(!reg_request->alpha2))
> -		return;
> -

last_request checks for the alpha2 are abundent... you'd
have to go review such use cases... One strategy might be
to not treat this as a pure regulatory request but rather
a hint of information, ie, not override last_request for
this type of request.

> @@ -2482,6 +2518,19 @@ int cfg80211_get_unii(int freq)
>  	return -EINVAL;
>  }
>  
> +bool regulatory_ir_allowed(struct ieee80211_channel *chan)
> +{
> +#ifdef CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS
> +	if (reg_is_indoor && (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
> +		return true;
> +#endif /* CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS */

config_enabled() would make this look sexier.

> @@ -2502,6 +2551,8 @@ int __init regulatory_init(void)
>  	user_alpha2[0] = '9';
>  	user_alpha2[1] = '7';
>  
> +	reg_is_indoor = false;

Yeah this is not needed as during init this will be false, but you
do want to ensure you set this to flase during reset of regulatory.

  Luis
