Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51259 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZK0LUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 06:20:49 -0500
Received: by bwz27 with SMTP id 27so1094074bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 03:20:54 -0800 (PST)
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix dynamic power save for scanning.
References: <1259063627-20033-1-git-send-email-vnatarajan@atheros.com>
	<1259063627-20033-2-git-send-email-vnatarajan@atheros.com>
	<87einlaeut.fsf@purkki.valot.fi>
	<8e92b4100911260309o6120ef22j1f22d4dd6e8e964c@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Nov 2009 13:20:52 +0200
In-Reply-To: <8e92b4100911260309o6120ef22j1f22d4dd6e8e964c@mail.gmail.com> (Vivek Natarajan's message of "Thu\, 26 Nov 2009 16\:39\:28 +0530")
Message-ID: <87y6ls8b8r.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> On Thu, Nov 26, 2009 at 1:37 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Vivek Natarajan <vnatarajan@atheros.com> writes:
>>
>> I don't like the idea of adding more state variables to
>> ieee80211_local. We should be removing them instead because the code
>> is getting quite complex. Is there any way to fix this but not add a
>> new variable?
>
> In this case, I need a variable to store the PS state before scan so
> that I can restore the same state when we come back to home channel.
>
> There are only two variables relating to this context:
> the flag IEEE80211_CONF_PS and ps_sdata
> CONF_PS flag is getting changed in scan_ps_enable.
> After association, ps_sdata is always set since power save is enabled
> by default.
> This will be changed if the power save is disabled through iwconfig
> which may happen during scan too. Hence I cannot use this too.
> So, I had to introduce a new variable.

Ok, we have to live with this then.

>> You need to take into account that dynamic_ps_timeout can be zero.
>
> When dynamic_ps_timeout is zero, as soon as the station is associated,
> CONF_PS will be set and communicated to the driver.
> If a scan request comes in this period, there will be a issue with my
> fix. I think this is the case you are pointing at. If so, I think the
> following chunk will work:
>
> @@ -277,6 +279,10 @@ static void ieee80211_scan_ps_disable(struct
> ieee80211_sub_if_data *sdata)
>                 */
>                local->hw.conf.flags |= IEEE80211_CONF_PS;
>                ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +       } else if (local->hw.conf.dynamic_ps_timeout > 0){
> +               ieee80211_send_nullfunc(local, sdata, 0);
> +               mod_timer(&local->dynamic_ps_timer, jiffies +
> +                         msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));

Yes, this should be enough. Please also add a comment why we send a
nullfunc frame.

-- 
Kalle Valo
