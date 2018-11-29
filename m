Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CA7C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 14:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8617B21019
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 14:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="X+zkv85S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8617B21019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbeK3BLt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 20:11:49 -0500
Received: from mail.toke.dk ([52.28.52.200]:40685 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbeK3BLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 20:11:48 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543500378; bh=NnEjvQp+VmjTaZxrFJPVbT6bfQZu918bCLabooWCcXg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=X+zkv85SemUOxVdh0rjQBkce+V1Pz7G9m+Ni/y12zIAZbeVT4od1vniYz2hT5gxZw
         mVD9lkUVUY3S6gmqewzxJtWlnKmFs2rtKDnsbnejpJChpXpQMRIjHv6XRU0EJJ3nYu
         5zucNFueTNpCgMXN0h4hmwCXtVFWVXnKWS8zar7onn8pLVBEA5aMwZ8DFytj/1sQgi
         s5c1l+bDiRM2nVNkL85bRT8r4dqVsFaI60MkDEVqE5SJpQ0GqIza/81YhySHVtWOAu
         d2KB8HPMAtFf9TuKNXqVSFZQV3wa1HkkIphkLoC8eXUqw/kF4e/ia98bVUNQ9sXy7j
         UpSsDDEL4NioQ==
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, nbd@nbd.name,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <20181129135825.GD6365@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128164306.0135ca83@redhat.com> <20181129103054.GA6365@localhost.localdomain> <87sgzkqaip.fsf@toke.dk> <20181129135825.GD6365@localhost.localdomain>
Date:   Thu, 29 Nov 2018 15:06:17 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h8g0q8py.fsf@toke.dk>
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
>> >> On Wed, 28 Nov 2018 13:36:26 +0100
>> >> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> wrote:
>> >>=20
>> >> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >> >=20
>> >> > >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >> > >>=20=20=20
>> >> > >> > This series is intended as a playground to start experimenting=
/developing
>> >> > >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
>> >> > >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently su=
pported
>> >> > >> > actions are:
>> >> > >> > - XDP_PASS
>> >> > >> > - XDP_ABORTED
>> >> > >> > - XDP_DROP
>> >> > >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
>> >> > >> > program into low level driver XDP rx hook.
>> >> > >> > This series has been tested through a simple bpf program (avai=
lable here:
>> >> > >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/m=
t76_xdp_stats)
>> >> > >> > used to count frame types received by the device.
>> >> > >> > Possible eBPF use cases could be:
>> >> > >> > - implement new statistics through bpf maps
>> >> > >> > - implement fast packet filtering (e.g in monitor mode)
>> >> > >> > - ...=20=20
>> >> > >
>> >> > > Hi Kalle,
>> >> > >=20=20
>> >> > >>=20
>> >> > >> This is most likely a stupid question, but why do this in the dr=
iver and
>> >> > >> not in mac80211 so that all drivers could benefit from it? I gue=
ss there
>> >> > >> are reasons for that, I just can't figure that out.=20=20
>> >> >=20
>> >> > XDP achieves its speedup by running the eBPF program inside the dri=
ver
>> >> > NAPI loop, before the kernel even touches the data in any other cap=
acity
>> >> > (and in particular, before it allocates an SKB). Which kinda means =
the
>> >> > hook needs to be in the driver... Could be a fallback in mac80211,
>> >> > though; although we'd have to figure out how that interacts with Ge=
neric
>> >> > XDP.
>> >> >=20
>> >> > > This is an early stage implementation, at this point I would coll=
ect
>> >> > > other people opinions/concerns about using bpf/xdp directly on 80=
2.11
>> >> > > frames.=20=20
>> >> >=20
>> >> > Thanks for looking into this!
>> >> >=20
>> >> > I have two concerns with running XDP on 802.11 frames:
>> >> >=20
>> >> > 1. It makes it more difficult to add other XDP actions (such as
>> >> >    REDIRECT), as the XDP program would then have to make sure that =
the
>> >> >    outer packet headers are removed before, say, redirecting the pa=
cket
>> >> >    out of an ethernet interface. Also, if we do add redirect, we wo=
uld
>> >> >    be bypassing mac80211 entirely; to what extent would that mess up
>> >> >    internal state?
>> >> >=20
>> >> > 2. UI consistency; suddenly, the user needs to know which kind of
>> >> >    frames to expect, and XDP program reuse becomes more difficult. =
This
>> >> >    may be unavoidable given the nature of XDP, but some thought nee=
ds to
>> >> >    go into this. Especially since we wouldn't necessarily be consis=
tent
>> >> >    between WiFi drivers (there are fullmac devices that remove 802.=
11
>> >> >    headers before sending up the frame, right?).
>> >> >=20
>> >> >=20
>> >> > Adding in Jesper; maybe he has some thoughts on this?
>> >
>> > Hi Jesper,
>> >
>> >>=20
>> >> Today XDP assumes the frame is an Ethernet frame.  With WiFi I guess
>> >> this assumption change, right?
>> >
>> > yes correct, SoftMAC devices report 802.11 frames to the stack
>> >
>> >>   I worry a bit about this, as XDP is all about performance, and I do=
n't
>> >> want to add performance regressions, by requiring all XDP programs or
>> >> core-code to having to check-frame-type before proceeding. That said,=
 I
>> >> do think it is doable, without adding performance regressions.
>> >>=20
>> >> Option #1 is to move the check-frame-type to setup time.  By either
>> >> having frame-type be part of eBPF prog, or supply frame-type as option
>> >> XDP attach call.  And then reject attaching XDP prog to a device, whe=
re
>> >> the expected frame-type does not match.
>> >>=20
>> >
>> > I guess it will be enough to avoid loading a 'non-WiFi' bpf program on
>> > a 802.11 netdevice (and vice versa). We could add a flag (or something
>> > similar) in XDP_SETUP_PROG section of netdev_bpf data structure and
>> > use ieee80211_ptr netdevice pointer in order to guarantee that the bpf
>> > program will work on the expected 'frame-type'
>>=20
>> Yeah, a flag would be good; we've been discussing that for other XDP use
>> cases; it's not a done deal yet, but I think it would be useful.
>
> Do you think something wifi specific is ok (e.g bool wifi) or do you pref=
er
> something more general (e.g u32 frame_type)?

My thought was a feature flag where the program can set a flag which
means "I expect 802.11 frames", and the driver can set a flag saying "I
emit 802.11 frames", and if those two flags don't match, the verifier
can refuse to load the program. This would not be fool-proof (an XDP
program can still corrupt things if written incorrectly), but it would
at least protect against the most obvious mistakes.

>> >> Option#2, leave it up to eBPF-programmer if they want to add runtime
>> >> checks.  By extending xdp_rxq_info with frame-type (default to
>> >> Ethernet), which allow the eBPF-programmer choose to write a generic
>> >> XDP program that both work on Ethernet and WiFi, or skip-check as they
>> >> know this will e.g. only run on Wifi.  (Note xdp_rxq_info is static
>> >> read-only info per RX-queue, will all Wifi frames have same frame-typ=
e?.
>> >>=20
>> >
>> > 802.11 standards define three frame subtype (data, management and cont=
rol).
>> > Subtypes could be detected parsing 802.11 header
>> >
>> >>=20
>> >> Also consider what happens in case of XDP_REDIRECT, from a Wifi NIC to
>> >> an Ethernet NIC.  It would of-cause be cool to get this working cross,
>> >> Wifi-Ethernet.
>> >>=20
>> >
>> > Very cool :) On tx side the driver will accept standard ethernet frame=
s in
>> > ndo_xdp_xmit pointer
>>=20
>> How do you envision that will work with drivers that build software
>> 802.11 frames? The TX hook would have to be in mac80211 somewhere,
>> wouldn't it?
>
> In order to perform 802.3 --> 802.11 xdp forwarding my current idea is
> is to have ndo_xdp_xmit pointer in mac80211 that will forward the
> frame to the low-level driver (more or less what I did in the RFC
> series to upload the bpf program to mt76). We will probably need to
> pass some info to the driver from mac80211 (e.g sequence number or hw
> key idx to use)

So this means that the driver will need to do the 802.11 encapsulation?
I guess we could have a fallback implementation in mac80211; but there
is possibly quite a bit of refactoring needed to make the existing code
work without an skb. Also, we need to think about queueing; I'm not sure
it's a good idea to have redirected frames bypass the TXQs...

-Toke
