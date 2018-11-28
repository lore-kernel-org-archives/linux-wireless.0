Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B91C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 23:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99BF7208E7
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 23:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="TyqqMfd9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99BF7208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbeK2KPh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 05:15:37 -0500
Received: from mail.toke.dk ([52.28.52.200]:55695 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbeK2KPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 05:15:37 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543446740; bh=aLvZ5aGZABV+CSB8HhF6rNBwgJ9gzaU9L4R5UOx0M9w=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=TyqqMfd9Gr3ul6sTIjXzJFS/oVi0we5IYi4/dWDjktJnLMp520DJZ+ASf1WqXqzpR
         HcPs84jAaoheTqPUEoiiLD8evbo5nOmXSAA1TPApjc1rQD868yBVODwHIUsBcjvDUr
         pLbRd2YXghkwKv+AzSCubyqN3G/v6lY3B/umUnMfJDVCOTATGTA64jHEFuAoXqf3DD
         wWQ8bThKhQweoUXCl7gAg3T5TP2sqTpN3PFuFud0y/pn541DV9JEG14C9vIIX1pESD
         /XWkcnzX7JfhOktOHbdvt5d7ZF+0CkCkDdajdxIWrrRpWhH3RlMueLMw4AgQflei+N
         ydZC1ij1bN6kQ==
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        nbd@nbd.name, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <20181128153508.GG2298@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain> <87zhtttg8p.fsf@toke.dk> <20181128153508.GG2298@localhost.localdomain>
Date:   Thu, 29 Nov 2018 00:12:19 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87in0gu78s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> On Nov 28, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>>=20
>> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >>=20
>> >> >> >> > This series is intended as a playground to start experimentin=
g/developing
>> >> >> >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
>> >> >> >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently s=
upported
>> >> >> >> > actions are:
>> >> >> >> > - XDP_PASS
>> >> >> >> > - XDP_ABORTED
>> >> >> >> > - XDP_DROP
>> >> >> >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
>> >> >> >> > program into low level driver XDP rx hook.
>> >> >> >> > This series has been tested through a simple bpf program (ava=
ilable here:
>> >> >> >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/=
mt76_xdp_stats)
>> >> >> >> > used to count frame types received by the device.
>> >> >> >> > Possible eBPF use cases could be:
>> >> >> >> > - implement new statistics through bpf maps
>> >> >> >> > - implement fast packet filtering (e.g in monitor mode)
>> >> >> >> > - ...
>> >> >> >
>> >> >> > Hi Kalle,
>> >> >> >
>> >> >> >>=20
>> >> >> >> This is most likely a stupid question, but why do this in the d=
river and
>> >> >> >> not in mac80211 so that all drivers could benefit from it? I gu=
ess there
>> >> >> >> are reasons for that, I just can't figure that out.
>> >> >>=20
>> >> >> XDP achieves its speedup by running the eBPF program inside the dr=
iver
>> >> >> NAPI loop, before the kernel even touches the data in any other ca=
pacity
>> >> >> (and in particular, before it allocates an SKB). Which kinda means=
 the
>> >> >> hook needs to be in the driver... Could be a fallback in mac80211,
>> >> >> though; although we'd have to figure out how that interacts with G=
eneric
>> >> >> XDP.
>> >> >>=20
>> >> >> > This is an early stage implementation, at this point I would col=
lect
>> >> >> > other people opinions/concerns about using bpf/xdp directly on 8=
02.11
>> >> >> > frames.
>> >> >>=20
>> >> >> Thanks for looking into this!
>> >> >
>> >> > Hi Toke,
>> >> >
>> >> >>=20
>> >> >> I have two concerns with running XDP on 802.11 frames:
>> >> >>=20
>> >> >> 1. It makes it more difficult to add other XDP actions (such as
>> >> >>    REDIRECT), as the XDP program would then have to make sure that=
 the
>> >> >>    outer packet headers are removed before, say, redirecting the p=
acket
>> >> >>    out of an ethernet interface. Also, if we do add redirect, we w=
ould
>> >> >>    be bypassing mac80211 entirely; to what extent would that mess =
up
>> >> >>    internal state?
>> >> >>=20
>> >> >
>> >> > You are right, my assumption here is the logic/complexity is moved =
to
>> >> > the bpf program that needs to take care of all possible issues that
>> >> > can be introduced. More or less it is the same if a bpf program mess
>> >> > up with TCP segments on a wired connection, isn't it?
>> >>=20
>> >> No, I guess not; except here it potentially applies to all packets
>> >> (things like BAW tracking), and it is *in addition* to TCP.
>> >
>> > Yes, here it is a little bit harder, but I was meaning that the bpf pr=
ogram
>> > has to be very careful when dropping a packet :)
>>=20
>> Yeah. What kind of filtering were you thinking you would use this for in
>> the short term?
>>=20
>
> When I started working on XDP for mt76 I was thinking about BSSID
> filtering but I was looking for a more general solution respect to add
> that feature in the driver. Moreover we could use bpf for fast packet
> filtering when you add an interface in monitor mode.

Yup, both of these make sense.

> Nevertheless I guess there could be other use cases not limited to
> frame filtering. My primary goal with this series is to collect
> ideas/concerns on WiFi XDP/eBPF possible uses cases.

Well, Micha=C5=82's idea about offloading is cool if it is possible to get
vendors to implement it.

Other than that, if we can solve the issues with differences between
802.11 and plain Ethernet frames, I see no reason why it wouldn't be
possible to implement an XDP fast-path for WiFi-to-Ethernet forwarding,
which might be useful in an access point, especially as WiFi speeds
increase.

The other direction will probably be more difficult, at least if 802.11
frames need to be built in software. It *might* be possible with the XDP
egress hook we are planning (with a suitable set of helpers, the eBPF
program could build the 802.11 frames), but I'm not really sure if that
is worth doing as I'm quite sure there are some hairy edge cases
there...

-Toke
