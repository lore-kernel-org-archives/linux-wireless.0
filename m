Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64814 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2B0SMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 13:12:22 -0500
Message-ID: <4F4BC77F.2010400@qca.qualcomm.com> (sfid-20120227_191225_900006_66276375)
Date: Mon, 27 Feb 2012 20:12:15 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add provision to define suspend policy in disconnected
 state.
References: <1329308528-2925-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1329308528-2925-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2012 02:22 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> It gives flexibility to the user to define suspend policy
> when the suspend mode is set to WOW and the device is in 
> disconnected state at the time of suspend.
> 
> Some bits (bit 4 to 7) of existing mod parameter suspend_mode
> is used for that purpose. There is no change in the existing
> way of defining suspend mode.
> 
> To force cut power:
>   suspend_mode=0x1
> 
> To force deep sleep:
>   suspend_mode=0x2
> 
> To force wow (deep sleep is the default mode
> in disconnected state):
>   suspend_mode=0x3
> 
> To force wow in connected state and cut power
> in disconnected state:
>   suspend_mode=0x13

What's the difference between values 0x3 and 0x13? It wasn't clear for
me from the description and neither from the code.

> To force wow in connected state and deep sleep
> in disconnected state:
>   suspend_mode=0x23

I'm not sure if adding bits to suspend_mode is the best way. To me
adding a separate parameter wow_mode looks easier from user's point of
view. What do you think?

And if you add a new module paratemer please use charp type so that can
use strings like 'deepsleep' and 'cutpower'. I wish that we had used
that already with suspend_mode but it's too late now :(

> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -2063,7 +2063,6 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
>  
>  		ret = ath6kl_wow_suspend(ar, wow);
>  		if (ret) {
> -			ath6kl_err("wow suspend failed: %d\n", ret);
>  			ar->state = prev_state;
>  			return ret;
>  		}

Please convert this to a debug message, maybe using the suspend level.
It might be useful when debugging something.

> diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
> index c4926cf..37c92a1 100644
> --- a/drivers/net/wireless/ath/ath6kl/core.c
> +++ b/drivers/net/wireless/ath/ath6kl/core.c
> @@ -41,6 +41,7 @@ int ath6kl_core_init(struct ath6kl *ar)
>  {
>  	struct ath6kl_bmi_target_info targ_info;
>  	struct net_device *ndev;
> +	u16 pri_suspend_mode, wow2_suspend_mode;

Why the number two? Why not just wow_suspend_mode?

Kalle
