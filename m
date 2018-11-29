Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF690C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4461208E7
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="vSxMCLLc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4461208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbeK3Aez (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:34:55 -0500
Received: from mail.toke.dk ([52.28.52.200]:43569 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbeK3Aez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:34:55 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543498170; bh=IzBi4U0WWTQ+LwZ4CmrQNsZGDwJL3mfTH9Cd/OoXo9o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=vSxMCLLcL70CjAPyFdGPaW5fzwvpJZnczGR5V9MZRcv6e60pmTQ6sWSL5aKl69Tfa
         s1Xqi8IhLNeIXGsB34QHrQ79w7MAIZ9aPEG797UORQEV+AyDgytkYBTUxhZSArWBp9
         u45nwTKr6qgVLXyNItKwW73oGO8V8wIpQX8UF6vjyGwr2cOaR1aqIDTgU0IhoNGW3p
         CsHSA1U5fEZPwrjJLrwj9QyfHZyj8OgfYnPaRDYWjgtLSJU4RPE1RHxl8YQoNTStc0
         8Ax+c2dFjnp6k17ej/FXAopq2FOLgu5xk21pv06dFgEs3V76QVN0cNrJ8Lx9l+qlZI
         5z51bt2b2P8XQ==
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        nbd@nbd.name, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <20181129125929.GB6365@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain> <87zhtttg8p.fsf@toke.dk> <20181128153508.GG2298@localhost.localdomain> <87in0gu78s.fsf@toke.dk> <20181129125929.GB6365@localhost.localdomain>
Date:   Thu, 29 Nov 2018 14:29:29 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pnuoqafa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>>=20
>> > On Nov 28, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >>=20
>> >> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >> >>=20
>> >> >> >> >> > This series is intended as a playground to start experimen=
ting/developing
>> >> >> >> >> > with XDP/eBPF over WiFi and collect ideas/concerns about i=
t.
>> >> >> >> >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currentl=
y supported
>> >> >> >> >> > actions are:
>> >> >> >> >> > - XDP_PASS
>> >> >> >> >> > - XDP_ABORTED
>> >> >> >> >> > - XDP_DROP
>> >> >> >> >> > Introduce ndo_bpf mac80211 callback in order to to load a =
bpf
>> >> >> >> >> > program into low level driver XDP rx hook.
>> >> >> >> >> > This series has been tested through a simple bpf program (=
available here:
>> >> >> >> >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/mast=
er/mt76_xdp_stats)
>> >> >> >> >> > used to count frame types received by the device.
>> >> >> >> >> > Possible eBPF use cases could be:
>> >> >> >> >> > - implement new statistics through bpf maps
>> >> >> >> >> > - implement fast packet filtering (e.g in monitor mode)
>> >> >> >> >> > - ...
>> >> >> >> >
>> >> >> >> > Hi Kalle,
>> >> >> >> >
>> >> >> >> >>=20
>> >> >> >> >> This is most likely a stupid question, but why do this in th=
e driver and
>> >> >> >> >> not in mac80211 so that all drivers could benefit from it? I=
 guess there
>> >> >> >> >> are reasons for that, I just can't figure that out.
>> >> >> >>=20
>> >> >> >> XDP achieves its speedup by running the eBPF program inside the=
 driver
>> >> >> >> NAPI loop, before the kernel even touches the data in any other=
 capacity
>> >> >> >> (and in particular, before it allocates an SKB). Which kinda me=
ans the
>> >> >> >> hook needs to be in the driver... Could be a fallback in mac802=
11,
>> >> >> >> though; although we'd have to figure out how that interacts wit=
h Generic
>> >> >> >> XDP.
>> >> >> >>=20
>> >> >> >> > This is an early stage implementation, at this point I would =
collect
>> >> >> >> > other people opinions/concerns about using bpf/xdp directly o=
n 802.11
>> >> >> >> > frames.
>> >> >> >>=20
>> >> >> >> Thanks for looking into this!
>> >> >> >
>> >> >> > Hi Toke,
>> >> >> >
>> >> >> >>=20
>> >> >> >> I have two concerns with running XDP on 802.11 frames:
>> >> >> >>=20
>> >> >> >> 1. It makes it more difficult to add other XDP actions (such as
>> >> >> >>    REDIRECT), as the XDP program would then have to make sure t=
hat the
>> >> >> >>    outer packet headers are removed before, say, redirecting th=
e packet
>> >> >> >>    out of an ethernet interface. Also, if we do add redirect, w=
e would
>> >> >> >>    be bypassing mac80211 entirely; to what extent would that me=
ss up
>> >> >> >>    internal state?
>> >> >> >>=20
>> >> >> >
>> >> >> > You are right, my assumption here is the logic/complexity is mov=
ed to
>> >> >> > the bpf program that needs to take care of all possible issues t=
hat
>> >> >> > can be introduced. More or less it is the same if a bpf program =
mess
>> >> >> > up with TCP segments on a wired connection, isn't it?
>> >> >>=20
>> >> >> No, I guess not; except here it potentially applies to all packets
>> >> >> (things like BAW tracking), and it is *in addition* to TCP.
>> >> >
>> >> > Yes, here it is a little bit harder, but I was meaning that the bpf=
 program
>> >> > has to be very careful when dropping a packet :)
>> >>=20
>> >> Yeah. What kind of filtering were you thinking you would use this for=
 in
>> >> the short term?
>> >>=20
>> >
>> > When I started working on XDP for mt76 I was thinking about BSSID
>> > filtering but I was looking for a more general solution respect to add
>> > that feature in the driver. Moreover we could use bpf for fast packet
>> > filtering when you add an interface in monitor mode.
>>=20
>> Yup, both of these make sense.
>>=20
>> > Nevertheless I guess there could be other use cases not limited to
>> > frame filtering. My primary goal with this series is to collect
>> > ideas/concerns on WiFi XDP/eBPF possible uses cases.
>>=20
>> Well, Micha=C5=82's idea about offloading is cool if it is possible to g=
et
>> vendors to implement it.
>>=20
>
> Yep, would be very cool :)
>
>> Other than that, if we can solve the issues with differences between
>> 802.11 and plain Ethernet frames, I see no reason why it wouldn't be
>> possible to implement an XDP fast-path for WiFi-to-Ethernet forwarding,
>> which might be useful in an access point, especially as WiFi speeds
>> increase.
>>=20
>
> Agree
>
>> The other direction will probably be more difficult, at least if 802.11
>> frames need to be built in software. It *might* be possible with the XDP
>> egress hook we are planning (with a suitable set of helpers, the eBPF
>> program could build the 802.11 frames), but I'm not really sure if that
>> is worth doing as I'm quite sure there are some hairy edge cases
>> there...
>
> The possible issue with XDP_DROP action you are referring to here is
> A-MPDU reordering on rx side, right? If so I guess the issue will be
> fixed by tid_agg_rx->reorder_timer. Are you referring to other
> possible edge cases?

I'm not sure, which is why I was being deliberately vague... ;)

Just something to be aware of when going beyond proof of concept, I
guess: here be dragons.

-Toke
