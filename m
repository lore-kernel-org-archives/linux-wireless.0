Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36305 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1C3HXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 03:23:46 -0400
Received: by eyx24 with SMTP id 24so299763eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 00:23:45 -0700 (PDT)
Date: Wed, 30 Mar 2011 10:24:30 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] wl1251: Add support for idle mode
Message-Id: <20110330102430.8bef80f6.jhnikula@gmail.com>
In-Reply-To: <87r59prtx6.fsf@purkki.adurom.net>
References: <1301408114-2325-1-git-send-email-jhnikula@gmail.com>
	<87r59prtx6.fsf@purkki.adurom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, 30 Mar 2011 09:42:13 +0300
Kalle Valo <kvalo@adurom.com> wrote:

> > It seems it is just enough the authorize ELP mode followed by
> > CMD_DISCONNECT (thanks to Kalle Valo about the idea to use it).
> 
> Actually I was expecting that you would first issue the disconnect
> command and only then enable elp. The thing is that for sending
> commands we need to wakeup firmware from elp, so enabling elp last
> makes more sense. Was there a reason why you did it in this order?
> 
Actually order is this. Both PSM and idle are activated via
wl1251_op_config so those precommands etc are executed first and the ELP
activation after that. See

wl1251_op_config
-> wl1251_ps_elp_wakeup
...
-> wl1251_ps_set_mode (those precommands for PSM and idle)
-> wl1251_ps_elp_sleep (+ called from other functions as well)
  -> ieee80211_queue_delayed_work(wl->hw, &wl->elp_work, delay);
    -> wl1251_elp_work (ELP activated here)

> > --- a/drivers/net/wireless/wl1251/cmd.h
> > +++ b/drivers/net/wireless/wl1251/cmd.h
> > @@ -314,7 +314,8 @@ struct wl1251_cmd_vbm_update {
> >  
> >  enum wl1251_cmd_ps_mode {
> >  	STATION_ACTIVE_MODE,
> > -	STATION_POWER_SAVE_MODE
> > +	STATION_POWER_SAVE_MODE,
> > +	STATION_IDLE,
> >  };
> 
> My idea was that cmd and acx files contain only the firmware
> interface, nothing more. I assume that firmware knows nothing this new
> value, right?
> 
Ok, this is good to know.

> Another way to do this would be that you create a new state enum to
> wl1251.h with the three states above and then change
> wl1251_ps_set_mode(), and it's callers, to use the new enum. That way
> you can keep cmd.h intact.
> 
> Also I'm guessing that in the future we need to store the new state
> enum to struct wl1251.
> 
This sounds much better idea. E.g. now the code is a bit unclear as the
flag psm is used also when in idle. I think the flag psm is better to
replace by some ps_mode state variable since then it can be used to
distinguish the PSM and idle if there's ever need to do so and no risk
that psm and new variable goes out of sync.

-- 
Jarkko
