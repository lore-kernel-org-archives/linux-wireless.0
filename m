Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59953 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaJUM1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 08:27:03 -0400
Received: by mail-ie0-f171.google.com with SMTP id x19so463096ier.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 05:27:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413873729.1998.2.camel@jlt4.sipsolutions.net>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	<21568.29077.518022.812356@gargle.gargle.HOWL>
	<1413797588.10246.3.camel@jlt4.sipsolutions.net>
	<21572.55536.308167.684155@gargle.gargle.HOWL>
	<1413798712.10246.14.camel@jlt4.sipsolutions.net>
	<21572.58249.490532.207564@gargle.gargle.HOWL>
	<1413801423.10246.16.camel@jlt4.sipsolutions.net>
	<21572.60015.349942.74265@gargle.gargle.HOWL>
	<1413806542.10246.21.camel@jlt4.sipsolutions.net>
	<1413809136.24269.0.camel@jlt4.sipsolutions.net>
	<21573.55666.43231.68176@gargle.gargle.HOWL>
	<1413873729.1998.2.camel@jlt4.sipsolutions.net>
Date: Tue, 21 Oct 2014 15:27:02 +0300
Message-ID: <CAB3XZEd8xCieC8xhOw=V0rHtJadYBKwe9NjwkNsmAmXqiL4ZRQ@mail.gmail.com> (sfid-20141021_142708_343622_3927AF07)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2014 at 9:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-10-21 at 09:26 +0530, Sujith Manoharan wrote:
>> Johannes Berg wrote:
>> > Maybe we need something like this:
>> >
>> > diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
>> > index af0d094b2f2f..45b74ab1c59d 100644
>> > --- a/net/mac80211/scan.c
>> > +++ b/net/mac80211/scan.c
>> > @@ -985,7 +985,6 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
>> >                     drv_cancel_hw_scan(local,
>> >                             rcu_dereference_protected(local->scan_sdata,
>> >                                             lockdep_is_held(&local->mtx)));
>> > -           goto out;
>> >     }
>>
>> Is the big comment at the beginning of ieee80211_scan_cancel()
>> outdated ? It does seem valid to me, at least the point about
>> not cancelling scan_work for HW scan.
>
> Yeah you're right.
>
> However, when the interface is deleted, the driver must still also
> remove the scan and definitely schedule the work, so most drivers will
> really always do so in cancel_hw_scan()? We could change the API and
> require that to be synchronous, like in the interface removal case, but
> maybe we don't want to.
>
> How about this then?
>
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index e469b3390f2a..6f1b90eb568c 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -766,10 +766,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>         int i, flushed;
>         struct ps_data *ps;
>         struct cfg80211_chan_def chandef;
> +       bool cancel_scan;
>
>         clear_bit(SDATA_STATE_RUNNING, &sdata->state);
>
> -       if (rcu_access_pointer(local->scan_sdata) == sdata)
> +       cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
> +       if (cancel_scan)
>                 ieee80211_scan_cancel(local);
>
>         /*
> @@ -993,6 +995,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>
>         ieee80211_recalc_ps(local, -1);
>
> +       if (cancel_scan)
> +               flush_delayed_work(&local->scan_work);
> +
>         if (local->open_count == 0) {
>                 ieee80211_stop_device(local);
>
This patch actually solves a kernel panic that can be reproduced
easily by increasing the delay in ieee80211_scan_completed() and
removing the driver right after initiating a scan - the delayed
scan_work never gets flushed, resulting in invalid memory access, etc.

Eliad.
