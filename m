Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1ITMN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 08:13:56 -0400
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Kalle Valo <kvalo@adurom.com>, Luciano Coelho <coelho@ti.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEeMZvv374SBTPDg1W8-E24=K5yVRhDQ0ktpUgxAEJgdzw@mail.gmail.com> (sfid-20110920_140619_504198_304C20F0)
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	 <1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
	 <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	 <1316450319.5995.33.camel@jlt3.sipsolutions.net>
	 <CAB3XZEeMZvv374SBTPDg1W8-E24=K5yVRhDQ0ktpUgxAEJgdzw@mail.gmail.com>
	 (sfid-20110920_140619_504198_304C20F0)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 14:13:50 +0200
Message-ID: <1316520830.3953.19.camel@jlt3.sipsolutions.net> (sfid-20110920_141409_879891_71834699)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-20 at 15:05 +0300, Eliad Peller wrote:

> > It'd be interesting to see if we can just treat this as a "minimum awake
> > time", kinda like going back to the range I thought about earlier.
> >
> do you mean something like:
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 4274e94..57695e3 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -702,11 +702,12 @@ void ieee80211_recalc_ps(struct ieee80211_local
> *local, s32 latency)
>                         if (latency > (1900 * USEC_PER_MSEC) &&
>                             latency != (2000 * USEC_PER_SEC))
>                                 timeout = 0;
> -                       else if (local->dynamic_ps_driver_timeout >= 0)
> -                               timeout = local->dynamic_ps_driver_timeout;
>                         else
>                                 timeout = 100;
>                 }
> +               if (timeout && local->dynamic_ps_driver_timeout > timeout)
> +                       timeout = local->dynamic_ps_driver_timeout;
> +
>                 local->dynamic_ps_user_timeout = timeout;
>                 if (!local->disable_dynamic_ps)
>                         conf->dynamic_ps_timeout =
> 
> ?
> 
> i don't find it much different.

I did mean something like that, yes, but I was thinking we actually
calculate the timeout based on latency requirements :)

johannes

