Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41400 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KXS6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:58:00 -0500
Received: by wwo28 with SMTP id 28so1108382wwo.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 10:57:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322160343.5366.47.camel@jlt3.sipsolutions.net>
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
	<1322158678.5366.27.camel@jlt3.sipsolutions.net>
	<CALGY4fv6NTRDPUEa-7h+DqaHZwdKnNG4fEmzyHrYZukz3B1gqA@mail.gmail.com>
	<1322159944.5366.42.camel@jlt3.sipsolutions.net>
	<1322160343.5366.47.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Nov 2011 13:57:59 -0500
Message-ID: <CALGY4fsfmKhns0+AB69ZmKE33-k95V0su3wex-kJ888cUB4Gcg@mail.gmail.com> (sfid-20111124_195805_356357_5E52F8CD)
Subject: Re: [PATCH v2 0/3] mac80211: timeout tx agg sessions in way similar
 to rx agg sessions
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2011/11/24 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2011-11-24 at 19:39 +0100, Johannes Berg wrote:
>
>> >   And one more thing, if you do not mind.
>> > 'ieee80211_stop_tx_ba_session' tests tx_tid->state for
>> > HT_AGG_STATE_STOPPING holding only spinlock on sta->lock.
>> > '___ieee80211_stop_tx_ba_session' sets this bit when spin lock on
>> > sta->lock is not being held. It seems to be that this could lead to
>> > problems if these two functions get called at about same time (which
>> > could easily happen when this patch is applied). Although actual
>> > window when lock is not help is really small. But I think the way it
>> > is currently done could still lead to problems. I think
>> > 'set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);' should be moved up
>> > to be covered by spin lock. I can include this as a part of next
>> > version of my patch. I'd really appreciate your thoughts about this.
>>
>> Yeah that does indeed seem like an issue
>
> Actually I think the right way to fix it would be the change below, do
> you agree? I think just moving the set_bit doesn't help because other
> code might call right into ___ieee80211_stop_tx_ba_session (or with just
> two underscores on front)
>
> johannes
>
> --- wireless-testing.orig/net/mac80211/agg-tx.c 2011-11-09 10:07:34.000000000 +0100
> +++ wireless-testing/net/mac80211/agg-tx.c      2011-11-24 19:44:51.000000000 +0100
> @@ -162,6 +162,12 @@ int ___ieee80211_stop_tx_ba_session(stru
>                return -ENOENT;
>        }
>
> +       /* if we're already stopping ignore any new requests to stop */
> +       if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
> +               spin_unlock_bh(&sta->lock);
> +               return -EALREADY;
> +       }
> +
>        if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
>                /* not even started yet! */
>                ieee80211_assign_tid_tx(sta, tid, NULL);
> @@ -170,6 +176,8 @@ int ___ieee80211_stop_tx_ba_session(stru
>                return 0;
>        }
>
> +       set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
> +
>        spin_unlock_bh(&sta->lock);
>
>  #ifdef CONFIG_MAC80211_HT_DEBUG
> @@ -177,8 +185,6 @@ int ___ieee80211_stop_tx_ba_session(stru
>               sta->sta.addr, tid);
>  #endif /* CONFIG_MAC80211_HT_DEBUG */
>
> -       set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
> -
>        del_timer_sync(&tid_tx->addba_resp_timer);
>
>        /*
>
>
>

Yes, this patch does make sense to me.

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
