Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1BOTuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 14:50:18 -0500
Received: by bwz15 with SMTP id 15so4267bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 11:50:16 -0800 (PST)
Message-ID: <4D5AD73A.70909@gmail.com>
Date: Tue, 15 Feb 2011 20:42:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, mickflemm@gmail.com, me@bobcopeland.com
Subject: Re: [PATCH] ath5k: Right channel setting for ar2317 chip
References: <20110215221313.498d21ed.nledovskikh@gmail.com>
In-Reply-To: <20110215221313.498d21ed.nledovskikh@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 08:13 PM, Nikolay Ledovskikh wrote:
> Patch that fixes right channel setting when running ar2317 based boards.

I see what it does. However I want to know why. That's what the
changelog should enlighten. I suppose we didn't handled ar2317 and we
want to. And since it is the same as 2425 we may reuse the current code?

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
> 


-- 
js
