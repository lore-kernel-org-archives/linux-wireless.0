Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:40191 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757391Ab2JLQkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 12:40:45 -0400
Message-ID: <1350060043.2243.28.camel@joe-AO722> (sfid-20121012_184049_418362_084E9137)
Subject: Re: [PATCH NEXT 2/2] rtlwifi: rtl8192c: rtl8192ce: rtl8192cu:
 rtl8192se: rtl8192de: Shorten some variable names
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 12 Oct 2012 09:40:43 -0700
In-Reply-To: <1350057128-16969-3-git-send-email-Larry.Finger@lwfinger.net>
References: <1350057128-16969-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1350057128-16969-3-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-12 at 10:52 -0500, Larry Finger wrote:
> The private data areas for these drivers contain some very long variable
> names that cause difficulty in fitting source lines to an 80-character
> limit.

[]

> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
[]
> @@ -177,8 +177,8 @@ static void rtl92c_dm_diginit(struct ieee80211_hw *hw)
>  	dm_digtable->rx_gain_range_max = DM_DIG_MAX;
>  	dm_digtable->rx_gain_range_min = DM_DIG_MIN;
>  	dm_digtable->backoff_val = DM_DIG_BACKOFF_DEFAULT;
> -	dm_digtable->backoff_val_range_max = DM_DIG_BACKOFF_MAX;
> -	dm_digtable->backoff_val_range_min = DM_DIG_BACKOFF_MIN;
> +	dm_digtable->back_range_max = DM_DIG_BACKOFF_MAX;
> +	dm_digtable->back_range_min = DM_DIG_BACKOFF_MIN;

Hi Larry, good idea but it looks like maybe you grepped
for long variable names with something like "\w{20,}".

Please try to convert all the similarly grouped names at
the same time.

iow: backoff_val should probably be changed too.

I didn't read any further.  cheers, Joe

