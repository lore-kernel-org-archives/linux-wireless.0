Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF0DC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD24208E7
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="YP5A9sUR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFD24208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbeK3Acw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:32:52 -0500
Received: from mail.toke.dk ([52.28.52.200]:35127 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbeK3Acv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:32:51 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543498047; bh=snD9oRng9leIXeMreDGX5ZCWuDf44iGGjdkeU6CDab8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=YP5A9sURTmpSeQDK+dWWOJ6ucxG/gM6kt8frS22VL3IGp2E7iRaaNhswJmk5BXN6/
         lG6SVBH/uS53nnCIgDtWY9iGwsq51npKkpD8qU7trbIfePFCeHhjQRHHy+ztXuQnXi
         LvflN8MyYhSebN6+M9hCRmlVHGjPOwWiYWwegCveAz7e4BHYmdP/APLU2wxKC44fC/
         tW3u8QC24MA9afr2WTf3na16YRQSheiFeiimD8AFaqyAV0Ksis4DRcr5aJ9uXMWRSZ
         QBUaUxdpq+GJHohrUAvLfrYqLcytOJuoKoPOfvCwpRfHbQk9B0UatBZKcjtywTL4QB
         uIcCq+4EYpqTg==
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        nbd@nbd.name, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <20181129103054.GA6365@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128164306.0135ca83@redhat.com> <20181129103054.GA6365@localhost.localdomain>
Date:   Thu, 29 Nov 2018 14:27:26 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87sgzkqaip.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> On Wed, 28 Nov 2018 13:36:26 +0100
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> wrote:
>>=20
>> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >=20
>> > >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> > >>=20=20=20
>> > >> > This series is intended as a playground to start experimenting/de=
veloping
>> > >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
>> > >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently suppo=
rted
>> > >> > actions are:
>> > >> > - XDP_PASS
>> > >> > - XDP_ABORTED
>> > >> > - XDP_DROP
>> > >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
>> > >> > program into low level driver XDP rx hook.
>> > >> > This series has been tested through a simple bpf program (availab=
le here:
>> > >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76=
_xdp_stats)
>> > >> > used to count frame types received by the device.
>> > >> > Possible eBPF use cases could be:
>> > >> > - implement new statistics through bpf maps
>> > >> > - implement fast packet filtering (e.g in monitor mode)
>> > >> > - ...=20=20
>> > >
>> > > Hi Kalle,
>> > >=20=20
>> > >>=20
>> > >> This is most likely a stupid question, but why do this in the drive=
r and
>> > >> not in mac80211 so that all drivers could benefit from it? I guess =
there
>> > >> are reasons for that, I just can't figure that out.=20=20
>> >=20
>> > XDP achieves its speedup by running the eBPF program inside the driver
>> > NAPI loop, before the kernel even touches the data in any other capaci=
ty
>> > (and in particular, before it allocates an SKB). Which kinda means the
>> > hook needs to be in the driver... Could be a fallback in mac80211,
>> > though; although we'd have to figure out how that interacts with Gener=
ic
>> > XDP.
>> >=20
>> > > This is an early stage implementation, at this point I would collect
>> > > other people opinions/concerns about using bpf/xdp directly on 802.11
>> > > frames.=20=20
>> >=20
>> > Thanks for looking into this!
>> >=20
>> > I have two concerns with running XDP on 802.11 frames:
>> >=20
>> > 1. It makes it more difficult to add other XDP actions (such as
>> >    REDIRECT), as the XDP program would then have to make sure that the
>> >    outer packet headers are removed before, say, redirecting the packet
>> >    out of an ethernet interface. Also, if we do add redirect, we would
>> >    be bypassing mac80211 entirely; to what extent would that mess up
>> >    internal state?
>> >=20
>> > 2. UI consistency; suddenly, the user needs to know which kind of
>> >    frames to expect, and XDP program reuse becomes more difficult. This
>> >    may be unavoidable given the nature of XDP, but some thought needs =
to
>> >    go into this. Especially since we wouldn't necessarily be consistent
>> >    between WiFi drivers (there are fullmac devices that remove 802.11
>> >    headers before sending up the frame, right?).
>> >=20
>> >=20
>> > Adding in Jesper; maybe he has some thoughts on this?
>
> Hi Jesper,
>
>>=20
>> Today XDP assumes the frame is an Ethernet frame.  With WiFi I guess
>> this assumption change, right?
>
> yes correct, SoftMAC devices report 802.11 frames to the stack
>
>>   I worry a bit about this, as XDP is all about performance, and I don't
>> want to add performance regressions, by requiring all XDP programs or
>> core-code to having to check-frame-type before proceeding. That said, I
>> do think it is doable, without adding performance regressions.
>>=20
>> Option #1 is to move the check-frame-type to setup time.  By either
>> having frame-type be part of eBPF prog, or supply frame-type as option
>> XDP attach call.  And then reject attaching XDP prog to a device, where
>> the expected frame-type does not match.
>>=20
>
> I guess it will be enough to avoid loading a 'non-WiFi' bpf program on
> a 802.11 netdevice (and vice versa). We could add a flag (or something
> similar) in XDP_SETUP_PROG section of netdev_bpf data structure and
> use ieee80211_ptr netdevice pointer in order to guarantee that the bpf
> program will work on the expected 'frame-type'

Yeah, a flag would be good; we've been discussing that for other XDP use
cases; it's not a done deal yet, but I think it would be useful.
>
>> Option#2, leave it up to eBPF-programmer if they want to add runtime
>> checks.  By extending xdp_rxq_info with frame-type (default to
>> Ethernet), which allow the eBPF-programmer choose to write a generic
>> XDP program that both work on Ethernet and WiFi, or skip-check as they
>> know this will e.g. only run on Wifi.  (Note xdp_rxq_info is static
>> read-only info per RX-queue, will all Wifi frames have same frame-type?.
>>=20
>
> 802.11 standards define three frame subtype (data, management and control=
).
> Subtypes could be detected parsing 802.11 header
>
>>=20
>> Also consider what happens in case of XDP_REDIRECT, from a Wifi NIC to
>> an Ethernet NIC.  It would of-cause be cool to get this working cross,
>> Wifi-Ethernet.
>>=20
>
> Very cool :) On tx side the driver will accept standard ethernet frames in
> ndo_xdp_xmit pointer

How do you envision that will work with drivers that build software
802.11 frames? The TX hook would have to be in mac80211 somewhere,
wouldn't it?

>> Option#3 is to say, Wifi XDP is so different that we should create a
>> new (enum) bpf_prog_type.  And then still see if we can leverage some
>> of the same core-code (as long as it doesn't slowdown performance).
>>=20
>
> Do you think that Option#3 will be more 'future-proof' respect to
> Option#1?

My feeling is that WiFi devices are not sufficiently different to
warrant a whole new program type. We risk combinatorial explosion for
all the stuff that is the same, but now need to be tested for two (or N)
types...

-Toke
