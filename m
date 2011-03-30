Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39622 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab1C3GmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 02:42:15 -0400
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] wl1251: Add support for idle mode
References: <1301408114-2325-1-git-send-email-jhnikula@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 30 Mar 2011 09:42:13 +0300
In-Reply-To: <1301408114-2325-1-git-send-email-jhnikula@gmail.com> (Jarkko Nikula's message of "Tue\, 29 Mar 2011 17\:15\:14 +0300")
Message-ID: <87r59prtx6.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moro Jarkko,

Jarkko Nikula <jhnikula@gmail.com> writes:

> This patch adds support for the mac80211 idle notifications. Chip is put into
> idle very much the same way when entering into PSM by utilizing the Extreme
> Low Power (ELP) mode. I.e. idle is entered by first setting necessary
> conditions with psm flag set and then via calling the wl1251_ps_elp_sleep.

Good stuff! Thank you very much for working on this.

> It seems it is just enough the authorize ELP mode followed by
> CMD_DISCONNECT (thanks to Kalle Valo about the idea to use it).

Actually I was expecting that you would first issue the disconnect
command and only then enable elp. The thing is that for sending
commands we need to wakeup firmware from elp, so enabling elp last
makes more sense. Was there a reason why you did it in this order?

> - There is still problem that the consumtion jumps again ~+180 mA after
>   disconnection happens. Reason is the BSS_LOSE_EVENT which puts the chip
>   again into active mode and driver doesn't receive an idle mode request
>   after that. For me it looks the driver doesn't notify the mac80211
>   properly and thus no idle mode request is coming.

Yes, that's an existing bug in wl1251. It should call either
mac80211_beacon_loss() or mac80211_connection_loss() after the event.

> As this patch doesn't affect that I see that is better to handle
> separately.

Agreed.

> --- a/drivers/net/wireless/wl1251/cmd.h
> +++ b/drivers/net/wireless/wl1251/cmd.h
> @@ -314,7 +314,8 @@ struct wl1251_cmd_vbm_update {
>  
>  enum wl1251_cmd_ps_mode {
>  	STATION_ACTIVE_MODE,
> -	STATION_POWER_SAVE_MODE
> +	STATION_POWER_SAVE_MODE,
> +	STATION_IDLE,
>  };

My idea was that cmd and acx files contain only the firmware
interface, nothing more. I assume that firmware knows nothing this new
value, right?

Another way to do this would be that you create a new state enum to
wl1251.h with the three states above and then change
wl1251_ps_set_mode(), and it's callers, to use the new enum. That way
you can keep cmd.h intact.

Also I'm guessing that in the future we need to store the new state
enum to struct wl1251.

-- 
Kalle Valo
