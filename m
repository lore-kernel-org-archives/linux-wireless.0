Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:37882 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751722AbaJ0Ak7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2014 20:40:59 -0400
Message-ID: <1414370455.15751.24.camel@perches.com> (sfid-20141027_014136_918004_C7A9CD06)
Subject: Re: [PATCH] staging: rtl8723au: create macro get_max_rate
From: Joe Perches <joe@perches.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Date: Sun, 26 Oct 2014 17:40:55 -0700
In-Reply-To: <1414368300-9596-1-git-send-email-paulmcquad@gmail.com>
References: <1414368300-9596-1-git-send-email-paulmcquad@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 00:05 +0000, Paul McQuade wrote:
> create marco for max_rate values

macro

> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
[]
> @@ -13,6 +13,8 @@
>   *
>   ******************************************************************************/
>  #define _IEEE80211_C
> +#define get_max_rate(r1, r2, r3, r4)					\
> +	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))

This macro should really be defined next to the uses as
it's dependent on naming within the rtw_mcs_rate23a function.

> @@ -794,64 +796,56 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
>  
>  	if (rf_type == RF_1T1R) {
>  		if (mcs->rx_mask[0] & BIT(7))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
> -				((short_GI_20)?722:650);
> +			max_rate = get_max_rate(1500, 1350, 722, 650);
[...]
>  	} else {
>  		if (mcs->rx_mask[1]) {
>  			if (mcs->rx_mask[1] & BIT(7))
> -				max_rate = (bw_40MHz) ? ((short_GI_40)?3000:2700):((short_GI_20)?1444:1300);
> +				max_rate = get_max_rate(3000, 2700, 1444, 1300);
[...]
>  		} else {
>  			if (mcs->rx_mask[0] & BIT(7))
> -				max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):((short_GI_20)?722:650);
> +				max_rate = get_max_rate(1500, 1350, 722, 650);
[...]
>  		}
>  	}
>  	return max_rate;

This can be written with fewer indents as

	if (rf_type == RF_1T1R( {
		[...]
	else if (mcs->rx_mask[1]) {
		[...]
	} else {
		[...]
	}

	return max_rate;
}


