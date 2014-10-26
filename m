Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:52851 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751504AbaJZTEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2014 15:04:15 -0400
Message-ID: <1414350250.15751.22.camel@perches.com> (sfid-20141026_201345_239027_C2375C2C)
Subject: Re: [PATCH 2/2] staging: rtl8723au:core
From: Joe Perches <joe@perches.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Date: Sun, 26 Oct 2014 12:04:10 -0700
In-Reply-To: <1414340332-4556-1-git-send-email-paulmcquad@gmail.com>
References: <1414340332-4556-1-git-send-email-paulmcquad@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-10-26 at 16:18 +0000, Paul McQuade wrote:
> ERROR: spaces required around that ':' (ctx:VxE)
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> index 6274cb3..41006cf 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> @@ -794,28 +794,28 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
>  
>  	if (rf_type == RF_1T1R) {
>  		if (mcs->rx_mask[0] & BIT(7))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350) :
>  				((short_GI_20)?722:650);
>  		else if (mcs->rx_mask[0] & BIT(6))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215) :
>  				((short_GI_20)?650:585);
>  		else if (mcs->rx_mask[0] & BIT(5))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080) :
>  				((short_GI_20)?578:520);
>  		else if (mcs->rx_mask[0] & BIT(4))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810) :
>  				((short_GI_20)?433:390);
>  		else if (mcs->rx_mask[0] & BIT(3))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540) :
>  				((short_GI_20)?289:260);
>  		else if (mcs->rx_mask[0] & BIT(2))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405) :
>  				((short_GI_20)?217:195);
>  		else if (mcs->rx_mask[0] & BIT(1))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270) :
>  				((short_GI_20)?144:130);
>  		else if (mcs->rx_mask[0] & BIT(0))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135):
> +			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135) :
>  				((short_GI_20)?72:65);

A macro could help intelligibility here - maybe something like:

#define get_max_rate(r1, r2, r3, r4)					\
	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))
and:
 		if (mcs->rx_mask[0] & BIT(7))
			max_rate = get_max_rate(1500, 1350, 722, 650);
		else if (mcs->rx_mask[0] & BIT(6))
			max_rate = get_max_rate(1350, 1215, 650, 585);
		else if (mcs->rx_mask[0] & BIT(5))
			max_rate = get_max_rate(1200, 1080, 578, 520);
		else if (mcs->rx_mask[0] & BIT(4))
			max_rate = get_max_rate(900, 810, 433, 390);
		else if (mcs->rx_mask[0] & BIT(3))
			max_rate = get_max_rate(600, 540, 289, 260);
		else if (mcs->rx_mask[0] & BIT(2))
			max_rate = get_max_rate(450, 405, 217, 195);
		else if (mcs->rx_mask[0] & BIT(1))
			max_rate = get_max_rate(300, 270, 144, 130);
		else if (mcs->rx_mask[0] & BIT(0))
			max_rate = get_max_rate(150, 135, 72, 65);



