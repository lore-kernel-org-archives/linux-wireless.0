Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65018 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1FVI7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 04:59:14 -0400
Received: by iyb12 with SMTP id 12so500814iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 01:59:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimmn3o-+rexOYy2CjrOX_Xo06R+uw@mail.gmail.com>
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
 <BANLkTikB3egX4YikC1JdgEr-E-7Dm13_CA@mail.gmail.com> <BANLkTikba=gw=1itPywfUaK28pVL2Z6=2g@mail.gmail.com>
 <BANLkTimmn3o-+rexOYy2CjrOX_Xo06R+uw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 22 Jun 2011 11:58:58 +0300
Message-ID: <BANLkTik4udr8ciy9WZxwuwTQivRSpaePxA@mail.gmail.com> (sfid-20110622_105917_547486_3711115A)
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are pending
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Sam Leffler <sleffler@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 09:33, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
>
> Well, I can't find any way to stop this race. :)
> Atleast the other race could be fixed with stop_queues.

Sure I'll add a stop_queues for for the IEEE80211_HW_PS_NULLFUNC_STACK
case. If you can't hit the other race I guess it doesn't matter. It's
a corner case anyway.

> How about the below patch? I am not sure about the disable_dynamic_ps
> and its BT/WLAN antenna sharing. Please add that if you see it as
> appropriate.

I think the disable_dynamic_ps and peers are needed. Otherwise we risk
getting inconsistent PS notifications from mac80211 when dyn_ps is
disabled.

>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index faca503..67ecad1 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -778,15 +778,14 @@ void ieee80211_dynamic_ps_enable_work(struct
> work_struct *work)
>        }
>        spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
>
> -       if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
> -           (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
> +       if (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
>                netif_tx_stop_all_queues(sdata->dev);
>
>                if (drv_tx_frames_pending(local))
>                        mod_timer(&local->dynamic_ps_timer, jiffies +
>                                  msecs_to_jiffies(
>                                  local->hw.conf.dynamic_ps_timeout));
> -               else {
> +               else if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
>                        ieee80211_send_nullfunc(local, sdata, 1);
>                        /* Flush to get the tx status of nullfunc frame */
>                        drv_flush(local, false);
>

Well drivers without IEEE80211_HW_PS_NULLFUNC_STACK need to leave the
function after mod_timer(). Otherwise we end up changing the PS state
anyway.
But yea, basically its very similar to my patch.

I'll submit a v2 with the stop_queues pending Sam's review.

Arik
