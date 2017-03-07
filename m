Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36549 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdCGKf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:35:29 -0500
Received: by mail-qk0-f175.google.com with SMTP id 1so199844406qkl.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 02:34:34 -0800 (PST)
Subject: Re: [PATCH] mac80211: ignore VHT membership selector when parsing
 rates
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170306220113.4666-1-johannes@sipsolutions.net>
Cc: Johannes Berg <johannes.berg@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <220e1799-9fba-c113-805d-3589421cdecd@broadcom.com> (sfid-20170307_113533_147202_FEA15973)
Date: Tue, 7 Mar 2017 09:39:28 +0100
MIME-Version: 1.0
In-Reply-To: <20170306220113.4666-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6-3-2017 23:01, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There isn't really much harm in not ignoring, since it doesn't
> represent a valid rate, but since we already ignore the HT one
> also ignore VHT. Also simplify the code a bit.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/mlme.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 1568a74757bc..6340127a71c6 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2823,15 +2823,15 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
>  			*have_higher_than_11mbit = true;
>  
>  		/*
> -		 * BSS_MEMBERSHIP_SELECTOR_HT_PHY is defined in 802.11n-2009
> -		 * 7.3.2.2 as a magic value instead of a rate. Hence, skip it.
> +		 * Skip HT and VHT BSS membership selectors since they're not
> +		 * rates.
>  		 *
>  		 * Note: Even through the membership selector and the basic

typo: through -> though.

Regards,
Arend

>  		 *	 rate flag share the same bit, they are not exactly
>  		 *	 the same.
>  		 */
> -		if (!!(supp_rates[i] & 0x80) &&
> -		    (supp_rates[i] & 0x7f) == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
> +		if (supp_rates[i] == (0x80 | BSS_MEMBERSHIP_SELECTOR_HT_PHY) ||
> +		    supp_rates[i] == (0x80 | BSS_MEMBERSHIP_SELECTOR_VHT_PHY))
>  			continue;
>  
>  		for (j = 0; j < sband->n_bitrates; j++) {
> 
