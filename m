Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34251 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2GIJPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:15:47 -0400
Received: by gglu4 with SMTP id u4so9842519ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 02:15:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341825002.4455.10.camel@jlt3.sipsolutions.net>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
 <1341608733-7503-2-git-send-email-johannes@sipsolutions.net>
 <CA+XVXfdo7agXE9Osxzmda2ZWi-xQ6pvP66zktdiDJq3P6PULgg@mail.gmail.com>
 <1341820743.4455.1.camel@jlt3.sipsolutions.net> <CA+XVXfeAhP9EjKJr6Ch1GAuT8u4CV_WsDQiCCt6b4YGjHzZwrQ@mail.gmail.com>
 <1341825002.4455.10.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 9 Jul 2012 12:15:31 +0300
Message-ID: <CA+XVXfcqEgXW8yr5F3Rbvyf6g=Y+cZ+3kS0wooRX+pt3dQxC_A@mail.gmail.com> (sfid-20120709_111551_246776_B678C35D)
Subject: Re: [RFC 1/3] mac80211: make scan_sdata pointer usable with RCU
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 12:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-07-09 at 11:48 +0300, Arik Nemtsov wrote:
>> On Mon, Jul 9, 2012 at 10:59 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sun, 2012-07-08 at 19:27 +0300, Arik Nemtsov wrote:
>> >> On Sat, Jul 7, 2012 at 12:05 AM, Johannes Berg
>> >> <johannes@sipsolutions.net> wrote:
>> >> > From: Johannes Berg <johannes.berg@intel.com>
>> >> >
>> >> > Making the scan_sdata pointer usable with RCU makes
>> >> > it possible to dereference it in the RX path to see
>> >> > if a received frame actually matches the interface
>> >> > that is scanning. This is just preparations, making
>> >> > the pointer __rcu.
>> >>
>> >> I noticed no synchronize_rcu() in the start/stop scan calls. Good/bad idea?
>> >
>> > Well, start() certainly wouldn't need it since you'd only get NULL :-)
>> >
>> > stop() in theory could use it, but it doesn't actually matter because as
>> > long as the interface still exists the pointer is valid. We don't free
>> > the interface in scan stop, so we don't need to make sure that the
>> > pointer is cleared before we continue. And in the case that we *do* in
>> > fact clear the interface (when it's going down) we have synchronize_rcu
>> > already in those code paths due to say the interface list with RCU
>> > protection.
>>
>> I meant protecting these (in patch 2/3):
>>
>> -            local->sched_scanning,
>> +            rcu_dereference_protected(local->sched_scan_sdata,
>> +                                      lockdep_is_held(&local->mtx)),
>>
>> The check is obviously racy here, but it was racy before as well I guess.
>> I'm not sure why something line test_bit(SCHED_SCANNING) wasn't used
>> in these places.
>
> I don't think I understand what you're trying to say ... why is this
> racy? We hold the mutex that we always hold when we assign the pointer.

I mean this check in ieee80211_rx_h_passive_scan():

	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
	    test_bit(SCAN_SW_SCANNING, &local->scanning) ||
	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
	    local->sched_scanning)
		return ieee80211_scan_rx(rx->sdata, skb);

since this is RCU, the pointer might be there a while longer after the
scan finished..
