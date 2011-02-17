Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1BQKZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 05:25:43 -0500
Received: by bwz15 with SMTP id 15so1515875bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 02:25:42 -0800 (PST)
Message-ID: <4D5CF7A3.9040809@gmail.com>
Date: Thu, 17 Feb 2011 11:25:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, mickflemm@gmail.com, me@bobcopeland.com
Subject: Re: [PATCH] ath5k: Correct channel setting for ar2317 chip
References: <20110217074454.7233f22f.nledovskikh@gmail.com>
In-Reply-To: <20110217074454.7233f22f.nledovskikh@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2011 05:44 AM, Nikolay Ledovskikh wrote:
> Use correct channel setting function for AR2317

This is as useless as the one before. Why you didn't add there what you
already wrote:
rf2317 handled but not fully, when I tested ahb patch on bullet2 all
seemed to work fine, but it couldn't connect another host (ibss for
example). During an analysis I observed that it's transmitting on
another channel and then I looked into madwifi code and understood that
the problem is in channel setting function.

This is almost perfect and what people want to know. Especially those
who deal with distro bug reports and backport patches to distro kernels...

> Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 78c26fd..c44111f 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1253,6 +1253,7 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
>  	case AR5K_RF5111:
>  		ret = ath5k_hw_rf5111_channel(ah, channel);
>  		break;
> +	case AR5K_RF2317:
>  	case AR5K_RF2425:
>  		ret = ath5k_hw_rf2425_channel(ah, channel);
>  		break;

thanks,
-- 
js
