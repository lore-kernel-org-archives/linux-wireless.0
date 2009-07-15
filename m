Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63314 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZGOFlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 01:41:49 -0400
Message-ID: <4A5D6BF9.8030701@nokia.com>
Date: Wed, 15 Jul 2009 08:41:13 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Jiri Slaby <jirislaby@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: wl12xx, fix lock imbalance
References: <1247603833-10862-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1247603833-10862-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Jiri Slaby wrote:
> Add omitted mutex_unlock to one of wl12xx_op_start fail paths (when
> wl12xx_chip_wakeup fails).
>
> [v2]
> Power off the device, because:
> \= cite from http://marc.info/?l=linux-kernel&m=124755028209880&w=2
> If the chip cannot be booted, why should it remain powered on?
> In some rare cases, the chip might fail to initialize, but can
> recover if powered off and on again, so turning it off at this
> point is the right thing to do. =/
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>   

Looks good now.  Thanks!

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

>  drivers/net/wireless/wl12xx/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 603d611..d30683c 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -336,7 +336,7 @@ static int wl12xx_op_start(struct ieee80211_hw *hw)
>  
>  	ret = wl12xx_chip_wakeup(wl);
>  	if (ret < 0)
> -		return ret;
> +		goto out;
>  
>  	ret = wl->chip.op_boot(wl);
>  	if (ret < 0)
>   


-- 
Cheers,
Luca.

