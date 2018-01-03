Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:46143 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbeACUNx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 15:13:53 -0500
Received: by mail-qt0-f175.google.com with SMTP id r39so3547480qtr.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jan 2018 12:13:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <00fc2806-3e2c-811e-0f00-6774dc37d843@gmail.com>
References: <20171228175832.3253-1-denkenz@gmail.com> <20171228175832.3253-5-denkenz@gmail.com>
 <1514899804.2024.5.camel@sipsolutions.net> <c73dcadb-bd96-fa82-b857-b5e2432fbadb@gmail.com>
 <1514924529.10342.4.camel@sipsolutions.net> <00fc2806-3e2c-811e-0f00-6774dc37d843@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Date: Wed, 3 Jan 2018 21:13:51 +0100
Message-ID: <CAF7Mx6oKi3gAiyjTOCcZX3Y--=xFV9NuiCdSbVTL7R0A=NYKcQ@mail.gmail.com> (sfid-20180103_212350_946783_F2641AC3)
Subject: Re: [RFC 4/4] nl80211: Implement TX of control port frames
To: Denis Kenzior <denkenz@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 3, 2018 at 6:17 PM, Denis Kenzior <denkenz@gmail.com> wrote:
> Hi Johannes,
>
> <snip>
>
>>> If so, can we do something like what ieee80211_process_sa_query_req in
>>> net/mac80211/rx.c or ieee80211_tdls_prep_mgmt_packet in
>>> net/mac80211/tdls.c do?  E.g. use ieee80211_tx_skb or
>>> __ieee80211_subif_start_xmit or similar to inject the skb with the
>>> DONT_ENCRYPT flag?
>>
>>
>> Yes, this will work - but like I said, it requires more control over
>> the SKB than cfg80211 has today, and than you can get through the
>> regular netdev xmit.
>
>
> So, I'm a bit lost here.  You're saying this will work but then it won't.
> Are you saying this would only work for mac80211 based devices (e.g. ones
> that implement ieee80211_ops) but not ones that implement cfg80211_ops?  I
> presume because those provide their own net_device_ops?

That is my assumption as well.

>>
>>>> Perhaps a new operation, where we pass a pre-built SKB and control
>>>> flags?
>>
>>
>>>
>>> This would likely mean that legacy behavior would still have to be
>>> supported for quite some time (forever?) for drivers that don't get
>>> around to implementing this, which would be unfortunate.
>>
>>
>> What do you mean by "legacy behaviour"? *Drivers* don't really need to
>> do anything one way or the other, and mac80211 is the only thing
>> implementing control port encrypt/ethertype right now, I suspect.
>>
>
> When I say legacy I mean 'over netdev', e.g. not over nl80211.
>
> Okay, so what you're saying is that the current CONTROL_PORT_* stuff doesn't
> work on anything besides mac80211 since drivers can completely ignore stuff
> inside cfg80211_connect_params.  And there's no way for userspace to know
> this ahead of time?
>
> So essentially we'd need a new operation in cfg80211_ops that would accept
> the control port frame data and some control flags.  Do we want to pass in
> an skb with all the 802.11 headers set or a 802.3 formatted skb (since that
> is what other data frames look like initially on the netdev).

Our firmware expects EAPOL stuff to come in as 802.3 packet, which
probably applies to the other full-mac devices as well. Is there any
reason for passing 802.11 packets.

Regards,
Arend
