Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44261 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1C3Hj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 03:39:57 -0400
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] wl1251: Add support for idle mode
References: <1301408114-2325-1-git-send-email-jhnikula@gmail.com>
	<87r59prtx6.fsf@purkki.adurom.net>
	<20110330102430.8bef80f6.jhnikula@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 30 Mar 2011 10:39:56 +0300
In-Reply-To: <20110330102430.8bef80f6.jhnikula@gmail.com> (Jarkko Nikula's message of "Wed\, 30 Mar 2011 10\:24\:30 +0300")
Message-ID: <87ipv1rr8z.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jarkko Nikula <jhnikula@gmail.com> writes:

> On Wed, 30 Mar 2011 09:42:13 +0300
> Kalle Valo <kvalo@adurom.com> wrote:
>
>> Actually I was expecting that you would first issue the disconnect
>> command and only then enable elp. The thing is that for sending
>> commands we need to wakeup firmware from elp, so enabling elp last
>> makes more sense. Was there a reason why you did it in this order?
>> 
> Actually order is this. Both PSM and idle are activated via
> wl1251_op_config so those precommands etc are executed first and the ELP
> activation after that. See
>
> wl1251_op_config
> -> wl1251_ps_elp_wakeup
> ...
> -> wl1251_ps_set_mode (those precommands for PSM and idle)
> -> wl1251_ps_elp_sleep (+ called from other functions as well)
>   -> ieee80211_queue_delayed_work(wl->hw, &wl->elp_work, delay);
>     -> wl1251_elp_work (ELP activated here)

Ah, of course. Forgot that we delay elp.

>> My idea was that cmd and acx files contain only the firmware
>> interface, nothing more. I assume that firmware knows nothing this new
>> value, right?
>> 
> Ok, this is good to know.

My bad, I should document this properly in the headers.

>> Another way to do this would be that you create a new state enum to
>> wl1251.h with the three states above and then change
>> wl1251_ps_set_mode(), and it's callers, to use the new enum. That way
>> you can keep cmd.h intact.
>> 
>> Also I'm guessing that in the future we need to store the new state
>> enum to struct wl1251.
>> 
> This sounds much better idea. E.g. now the code is a bit unclear as the
> flag psm is used also when in idle. I think the flag psm is better to
> replace by some ps_mode state variable since then it can be used to
> distinguish the PSM and idle if there's ever need to do so and no risk
> that psm and new variable goes out of sync.

Good idea, this way it is more robust.

-- 
Kalle Valo
