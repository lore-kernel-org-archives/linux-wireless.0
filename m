Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1BQIYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 03:24:04 -0500
Subject: Re: [PATCH v2] mac80211: add missing locking in ieee80211_reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTincDtRH=uq9H16W4Lyx-Z4WK9+YOZBYf6GEXjJ-@mail.gmail.com>
References: <1297183399-2296-1-git-send-email-eliad@wizery.com>
	 <1297678190.3785.13.camel@jlt3.sipsolutions.net>
	 <AANLkTincDtRH=uq9H16W4Lyx-Z4WK9+YOZBYf6GEXjJ-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 09:24:00 +0100
Message-ID: <1297931040.3750.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-17 at 02:51 +0200, Eliad Peller wrote:

> >>                       changed |= BSS_CHANGED_ASSOC;
> >> +                     mutex_lock(&sdata->u.mgd.mtx);
> >>                       ieee80211_bss_info_change_notify(sdata, changed);
> >> +                     mutex_unlock(&sdata->u.mgd.mtx);
> >>                       break;
> >>               case NL80211_IFTYPE_ADHOC:
> >>                       changed |= BSS_CHANGED_IBSS;
> >
> > Oi, this is a complicated locking rule.
> >
> > Can you please stick a
> >
> > lockdep_assert_held(...)
> >
> > in the right place to make sure we catch it even on drivers that don't
> > use the probe_req function?
> >
> well, i'm not sure what is the right place / when this mutex should be taken.
> when doing something like:
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 1c507c6..ab1843d 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -191,6 +191,7 @@ void ieee80211_bss_info_change_notify(struct
> ieee80211_sub_if_data *sdata,
>                 return;
> 
>         if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> +               lockdep_assert_held(&sdata->u.mgd.mtx);
>                 /*
>                  * While not associated, claim a BSSID of all-zeroes
>                  * so that drivers don't do any weird things with the
> 
> i got several warnings from ieee80211_open, ieee80211_recalc_idle, etc.
> should this mutex be taken if the psm has been changed (for example)?
> or should we check the mutex only if certain flags has been changed?

Yikes!! So you're saying that the locking is conditional on a certain
flag? That makes the driver API a lot more complex, and the locking
rules get really icky. I really don't like that.

I think the answer to that is that we must rewrite the entire API. My
suggestion would be:
 * remove ieee80211_ap_probereq_get
 * add a new driver op "void set_ap_probe_req(..., skb)"
 * call this in the few appropriate places, but not from
   ieee80211_bss_info_change_notify
 * make sure the locking for it is correct

johannes

