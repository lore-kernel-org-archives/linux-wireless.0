Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:44315 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932715AbcBAOvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 09:51:13 -0500
Message-ID: <1454338265.7329.67.camel@perches.com> (sfid-20160201_155116_962170_D51D5007)
Subject: Re: [PATCH 4/4] Staging: rtl8723au: core: rtw_ieee80211: Fixed a
 coding style Warning.
From: Joe Perches <joe@perches.com>
To: Rakhi Sharma <rakhish1994@gmail.com>, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 01 Feb 2016 06:51:05 -0800
In-Reply-To: <1454331104-16835-1-git-send-email-rakhish1994@gmail.com>
References: <1454331104-16835-1-git-send-email-rakhish1994@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-01 at 18:21 +0530, Rakhi Sharma wrote:
> Fixed a braces style warning.
> Warning: braces {} are not necessary for single statement blocks.
[]
> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
[]
> @@ -176,11 +176,9 @@ u8 *rtw_get_ie23a(u8 *pbuf, int index, int *len, int limit)
>  	int tmp, i;
>  	u8 *p;
>  
> -	if (limit < 1) {
> +	if (limit < 1)
>  
>  		return NULL;
> -	}
> -
>  	p = pbuf;
>  	i = 0;
>  	*len = 0;

This ends up as:

	if (limit < 1)

		return NULL;
	p = pbuf;

And isn't particularly more readable.
It would be better as:

	if (limit < 1)
		return NULL;

	p = pbuf;
etc...
