Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3082 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759299Ab1FQPmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 11:42:11 -0400
Subject: Re: [PATCH 4/4] rtlwifi: rtl8192{c,ce,cu,se}: Remove comparisons
 of booleans with true
From: Joe Perches <joe@perches.com>
To: Mike McCormack <mikem@ring3k.org>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4DF93EE1.1090102@ring3k.org>
References: <4DF93EE1.1090102@ring3k.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 08:42:09 -0700
Message-ID: <1308325329.16582.37.camel@Joe-Laptop> (sfid-20110617_174225_132957_BE66F44D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-16 at 08:23 +0900, Mike McCormack wrote:
> These are a potential source of confusion, as most C code treats all
> non-zero values as true.

Thanks Mike.

Larry has applied this.
Could you please submit a follow up patch that
removes the extra parentheses that surround
the individual boolean variable tests?

> diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
> @@ -523,7 +523,7 @@ static void _rtl_query_shortgi(struct ieee80211_hw *hw,
[]
> -	if ((bw_40 == true) && sgi_40)
> +	if (bw_40 && sgi_40)

Done here.

> diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
[]
> @@ -90,7 +90,7 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
>  		ppsc->rfoff_reason &= (~changesource);
>  
>  		if ((changesource == RF_CHANGE_BY_HW) &&
> -		    (ppsc->hwradiooff == true)) {
> +		    (ppsc->hwradiooff)) {

Not done here.

		      ppsc->hwradiooff))
or
		if (ppsc->hwradiooff && changesource == RF_CHANGE_BY_HW)

> diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
[]
> @@ -200,7 +200,7 @@ static void rtl_tx_status(void *ppriv,
>  	if (sta) {
>  		/* Check if aggregation has to be enabled for this tid */
>  		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
> -		if ((sta->ht_cap.ht_supported == true) &&
> +		if ((sta->ht_cap.ht_supported) &&

		if (sta->ht_cap.ht_supported &&

etc...

cheers, Joe

