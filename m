Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47383 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755977AbcHVPhY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 11:37:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: Fix missing country code for Great Britain
References: <1471619674-29439-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 22 Aug 2016 18:36:59 +0300
In-Reply-To: <1471619674-29439-1-git-send-email-Larry.Finger@lwfinger.net>
        (Larry Finger's message of "Fri, 19 Aug 2016 10:14:34 -0500")
Message-ID: <87wpj8vmqs.fsf@kamboji.qca.qualcomm.com> (sfid-20160822_173803_789239_2CE7F2B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Some RTL8821AE devices sold in Great Britain have the country code of
> 0x25 encoded in their EEPROM. This value is not tested in the routine
> that establishes the regulatory info for the chip. The fix is to set
> this code to have the same capabilities as the EU countries.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/regd.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
> @@ -345,9 +345,9 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
>  		return &rtl_regdom_no_midband;
>  	case COUNTRY_CODE_IC:
>  		return &rtl_regdom_11;
> -	case COUNTRY_CODE_ETSI:
>  	case COUNTRY_CODE_TELEC_NETGEAR:
>  		return &rtl_regdom_60_64;
> +	case COUNTRY_CODE_ETSI:
>  	case COUNTRY_CODE_SPAIN:
>  	case COUNTRY_CODE_FRANCE:
>  	case COUNTRY_CODE_ISRAEL:

I didn't check the full source, but here you seem to be changing also
the content of ETSI regdomain. The commit log doesn't mention anything
about that so I want to double check that this is really intentionally.

-- 
Kalle Valo
