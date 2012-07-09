Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41294 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2GIJxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:53:34 -0400
Received: by yhmm54 with SMTP id m54so10666522yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 02:53:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341827029.4455.27.camel@jlt3.sipsolutions.net>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
 <1341608733-7503-2-git-send-email-johannes@sipsolutions.net>
 <CA+XVXfdo7agXE9Osxzmda2ZWi-xQ6pvP66zktdiDJq3P6PULgg@mail.gmail.com>
 <1341820743.4455.1.camel@jlt3.sipsolutions.net> <CA+XVXfeAhP9EjKJr6Ch1GAuT8u4CV_WsDQiCCt6b4YGjHzZwrQ@mail.gmail.com>
 <1341825002.4455.10.camel@jlt3.sipsolutions.net> <CA+XVXfcqEgXW8yr5F3Rbvyf6g=Y+cZ+3kS0wooRX+pt3dQxC_A@mail.gmail.com>
 <1341825800.4455.17.camel@jlt3.sipsolutions.net> <CA+XVXfeKw_C1i=xukZVgRV6woLnNdpDw=m3B_iXES28TrCJimg@mail.gmail.com>
 <1341827029.4455.27.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 9 Jul 2012 12:53:18 +0300
Message-ID: <CA+XVXfdF5=ivUWXQqXMepyV7Hy_JUHp-9qfqSAaZ4N8VQ8dc0g@mail.gmail.com> (sfid-20120709_115338_372098_0EB3600F)
Subject: Re: [RFC 1/3] mac80211: make scan_sdata pointer usable with RCU
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 12:43 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-07-09 at 12:39 +0300, Arik Nemtsov wrote:
>
>> >> >> >> I noticed no synchronize_rcu() in the start/stop scan calls. Good/bad idea?
>> >> >> >
>> >> >> > Well, start() certainly wouldn't need it since you'd only get NULL :-)
>> >> >> >
>> >> >> > stop() in theory could use it, but it doesn't actually matter because as
>> >> >> > long as the interface still exists the pointer is valid. We don't free
>> >> >> > the interface in scan stop, so we don't need to make sure that the
>> >> >> > pointer is cleared before we continue. And in the case that we *do* in
>> >> >> > fact clear the interface (when it's going down) we have synchronize_rcu
>> >> >> > already in those code paths due to say the interface list with RCU
>> >> >> > protection.
>> >> >>
>> >> >> I meant protecting these (in patch 2/3):
>> >> >>
>> >> >> -            local->sched_scanning,
>> >> >> +            rcu_dereference_protected(local->sched_scan_sdata,
>> >> >> +                                      lockdep_is_held(&local->mtx)),
>> >> >>
>> >> >> The check is obviously racy here, but it was racy before as well I guess.
>> >> >> I'm not sure why something line test_bit(SCHED_SCANNING) wasn't used
>> >> >> in these places.
>> >> >
>> >> > I don't think I understand what you're trying to say ... why is this
>> >> > racy? We hold the mutex that we always hold when we assign the pointer.
>> >>
>> >> I mean this check in ieee80211_rx_h_passive_scan():
>> >>
>> >>       if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
>> >>           test_bit(SCAN_SW_SCANNING, &local->scanning) ||
>> >>           test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
>> >>           local->sched_scanning)
>> >>               return ieee80211_scan_rx(rx->sdata, skb);
>> >>
>> >> since this is RCU, the pointer might be there a while longer after the
>> >> scan finished..
>> >
>> > Oh. I was looking at the code after patch 3 and this no longer
>> > exists ;-)
>> >
>> > But then my first argument applies -- as long as the interface is there,
>> > the pointer is OK, and when the interface is removed we need to remove
>> > it from the RCU-managed interface list so need to synchronize_rcu()
>> > already. No?
>>
>> The add/remove interface part is covered, yes.
>>
>> What happens when starting/stopping sched scan? The rcu pointer is
>> removed in ieee80211_request_sched_scan_stop(), but we may still think
>> we are sched scanning for a while inside
>> ieee80211_rx_h_passive_scan().
>>
>> Probably nothing too bad will happen though..
>
> Yes, well... Say we stick synchronize_rcu() into sched_scan_stop(). What
> would actually change?
> We'd still think we're sched scanning (in the RX handler) for exactly
> the same amount of time, except the sched scan stop code would now wait
> for it, while doing nothing. It has nothing to do after the wait (since
> it doesn't free the RCU data or anything).

I was referring to using test_bit(SCHED_SCANNING). You're right
syncronize_rcu() doesn't do anything here (I even realized my mistake
somewhere along the email chain I think).

Arik
