Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:53854 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZEPWIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 18:08:04 -0400
Received: by pxi29 with SMTP id 29so1495009pxi.33
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 15:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242397016.5799.102.camel@johannes.local>
References: <1242397016.5799.102.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 16 May 2009 15:07:43 -0700
Message-ID: <43e72e890905161507r664cafd2i8815f400a5158b04@mail.gmail.com>
Subject: Re: some wireless suspend thoughts
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2009 at 7:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>  * kick pci driver suspend/resume out of ath9k and keep the device in
>   low power while unused

This is nice.

>  * make mac80211 send nullfunc for suspend/resume
>  * make cfg80211 always call suspend/resume
>
> This is quite hackish. It works for me, but my AP disassocs me anyway
> because it probes every 5 seconds and if you don't respond ... however,
> due to the nullfunc at resume time we notice very very quickly since it
> sends a deauth as a response to that.
>
> The ->shutdown hook in cfg80211 is a little odd.
>
> To implement WoW on top of this, we need to refactor the cfg80211 hooks
> and probably actually pass the information to ->stop after all, I think?
> I can't think of a good way to do this.

Well that's for sure with this patch. Let me take a crack at it.

> --- wireless-testing.orig/net/mac80211/pm.c     2009-05-15 15:17:08.851827827 +0200
> +++ wireless-testing/net/mac80211/pm.c  2009-05-15 15:17:09.891708511 +0200
> @@ -16,6 +16,17 @@ int __ieee80211_suspend(struct ieee80211
>
>        ieee80211_scan_cancel(local);
>
> +       local->ps_before_suspend = !!(local->hw.conf.flags & IEEE80211_CONF_PS);
> +       local->hw.conf.flags &= ~IEEE80211_CONF_PS;

Why clear it? Wasn't the goal to go to PS mode during suspend? Also if
we're already in PS mode no point in calling hw_config.

I take it we don't want to go to PS mode when we don't have WoW
enabled then, because as you noted you're going to disassoc pretty
quickly otherwise, unless your AP has long idle detection times. PS
mode requires you to be able to be up at least every DTIM it would
seem better to just disassoc unless wow is enabled.


> --- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c 2009-05-15 15:44:19.261837573 +0200
> +++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c      2009-05-15 15:47:15.051830998 +0200
> @@ -1901,6 +1901,10 @@ static int ath9k_start(struct ieee80211_
>        DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
>                "initial channel: %d MHz\n", curchan->center_freq);
>
> +       r = sc->bus_ops->start(sc);
> +       if (r)
> +               return r;
> +
>        mutex_lock(&sc->mutex);
>
>        if (ath9k_wiphy_started(sc)) {
> @@ -2105,6 +2109,8 @@ static void ath9k_stop(struct ieee80211_
>
>        mutex_unlock(&sc->mutex);
>
> +       sc->bus_ops->stop(sc);
> +
>        DPRINTF(sc, ATH_DBG_CONFIG, "Driver halt\n");
>  }

We need to consider ahb as well but that's a quick fix.

  Luis
