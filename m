Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:11268 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYFSVJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 17:09:54 -0400
Received: by py-out-1112.google.com with SMTP id p76so430050pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 14:09:53 -0700 (PDT)
Message-ID: <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com> (sfid-20080619_231003_765559_E06B0E08)
Date: Fri, 20 Jun 2008 00:09:52 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Broken fragmentation
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1213899419.8967.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com>
	 <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
	 <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com>
	 <1213881855.8967.19.camel@johannes.berg>
	 <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 <1213899419.8967.59.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 9:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-19 at 21:13 +0300, Tomas Winkler wrote:
>> On Thu, Jun 19, 2008 at 6:26 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2008-06-19 at 17:45 +0300, Tomas Winkler wrote:
>> >> On Thu, Jun 19, 2008 at 4:24 PM, Johannes Berg
>> >> <johannes@sipsolutions.net> wrote:
>> >> > On Thu, 2008-06-19 at 16:08 +0300, Tomas Winkler wrote:
>> >> >> On Thu, Jun 19, 2008 at 3:23 PM, Johannes Berg
>> >> >> <johannes@sipsolutions.net> wrote:
>> >> >> >
>> >> >> >> > Now it crashes in the driver...maybe the txinfo to cb changes. Looking into it.
>> >> >> >> > Tomas
>> >> >> >> Looks like this is the second part keyconf is null
>> >> >> >
>> >> >> > Part? You mean fragment? What encryption algorithm? I've quickly looked
>> >> >> > and all of them seem to do the control.hw_key assignment in their
>> >> >> > respective _skb handler so it should be done for all fragments.
>> >> >>
>> >> >> The problem is w/o crypto
>> >> >> I think this is not set on each fragment
>> >> >> info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
>> >> >
>> >> > Ouch, you're right, the whole tx info isn't properly initialised for
>> >> > fragments.
>> >> >
>> >> > Can you try putting
>> >> >
>> >> > memcpy(frag->cb, first->cb, sizeof(first->cb));
>> >> >
>> >> > at around line 690 of tx.c where this code is?
>> >> >
>> >> >                frag->priority = first->priority;
>> >> >                skb_reserve(frag, tx->local->tx_headroom +
>> >> >                                  IEEE80211_ENCRYPT_HEADROOM);
>> >> >
>> >> >
>> >> > [now I know what the cause is. I had another patch that used skb_segment
>> >> > to do the fragmentation, but that was dropped and skb_segment does copy
>> >> > skb->cb while our code doesn't]
>> >>
>> >> No crash but still not at home. No fragmented traffic on the air...grrr.
>> >
>> > Hmm, ok. I'll give it a try later.
>>
>> Fragments are in the air but the peer is not able to reassemble them.
>> Something is wrong with the first fragment but I'm not sure yet.
>
> Hm, ok. got a packet capture? Maybe that was broken before, I remember
> having problems with fragmentation but putting it down to the
> known-to-be-completely-broken AP I was using.

It is working the latest problem was caused by the driver, Yet i still
don't understand the regression
in the driver.  Would be nice if you can confirm it works also with another HW.
Sending your patch out.
Thanks
Tomas
