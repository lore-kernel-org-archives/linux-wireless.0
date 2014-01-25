Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36189 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaAYAe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:34:26 -0500
Received: by mail-pd0-f179.google.com with SMTP id q10so3705030pdj.38
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 16:34:26 -0800 (PST)
Date: Fri, 24 Jan 2014 16:34:20 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzi@tieto.com>
Subject: Re: [PATCH v2 1/3] cfg80211: add helper reg_get_regdomain() function
Message-ID: <20140125003418.GF28512@garbanzo.do-not-panic.com> (sfid-20140125_013429_487846_C9504B2C)
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 01:43:42PM +0100, Janusz Dziedzic wrote:
> Add helper function that will return regdomain.
> Follow the driver's regulatory domain, if present,
> unless a country IE has been processed or a user
> wants to help complaince further.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzi@tieto.com>
> ---
>  net/wireless/reg.c |   31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 9b897fc..d58a09c 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -522,6 +522,25 @@ bool reg_is_valid_request(const char *alpha2)
>  	return alpha2_equal(lr->alpha2, alpha2);
>  }
>  
> +static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
> +{
> +	const struct ieee80211_regdomain *regd;
> +	struct regulatory_request *lr = get_last_request();
> +
> +	/*
> +	 * Follow the driver's regulatory domain, if present, unless a country
> +	 * IE has been processed or a user wants to help complaince further
> +	 */
> +	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
> +	    lr->initiator != NL80211_REGDOM_SET_BY_USER &&
> +	    wiphy->regd)
> +		regd = get_wiphy_regdom(wiphy);
> +	else
> +		regd = get_cfg80211_regdom();
> +
> +	return regd;
> +}
> +
>  /* Sanity check on a regulatory rule */
>  static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
>  {
> @@ -821,18 +840,8 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
>  					       u32 center_freq)
>  {
>  	const struct ieee80211_regdomain *regd;
> -	struct regulatory_request *lr = get_last_request();
>  
> -	/*
> -	 * Follow the driver's regulatory domain, if present, unless a country
> -	 * IE has been processed or a user wants to help complaince further
> -	 */
> -	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
> -	    lr->initiator != NL80211_REGDOM_SET_BY_USER &&
> -	    wiphy->regd)
> -		regd = get_wiphy_regdom(wiphy);
> -	else
> -		regd = get_cfg80211_regdom();
> +	regd = reg_get_regdomain(wiphy);

Nice! I welcome this -- can you also add nl80211 API to expose when
a wiphy has its own wiphy->regd and send that to userspace too?

  Luis
