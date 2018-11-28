Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE42FC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 14:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5B22206B6
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 14:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="JkjHWjQf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5B22206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbeK2BpQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 20:45:16 -0500
Received: from mail.toke.dk ([52.28.52.200]:52623 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbeK2BpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 20:45:15 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543416199; bh=PADHl65bHefIoTQiULt/+FpTJpwsCkkIiG26dSwVSn8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JkjHWjQfprhKfA1y/u8el8WS4a5r+lOFLL8GgpiwjlOpI58XgzJhO+fgOQo9ra6Ym
         krXbQYqZHFwW8rh6T0fWNajTsZT+rLgFNCmCIfAlzWvTzoa9dDmKkAx/RsVK6PzdaI
         HpFxoVRC0sZw38IPEFdFzus5WudehnTNvOsXDT/iYdYJaytEI2buP9MNkoaHBiypeR
         frWer4GIhgh+w+VGl4B5Cf0X8Rz3hvgJWbdUW7BzP/unIHfELyOhDEboQXBhfsmNxK
         1e6Nu0jeQ7p0HCmY5dwD1nTOKcaRsNPZI3rguxbvQOx2+kbFk7IvPihC9bKkRjPnDG
         5UnV8E2KYIdBA==
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        nbd@nbd.name, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <20181128143533.GE2298@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain>
Date:   Wed, 28 Nov 2018 15:43:18 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87zhtttg8p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> 
>> >> >> > This series is intended as a playground to start experimenting/developing
>> >> >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
>> >> >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
>> >> >> > actions are:
>> >> >> > - XDP_PASS
>> >> >> > - XDP_ABORTED
>> >> >> > - XDP_DROP
>> >> >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
>> >> >> > program into low level driver XDP rx hook.
>> >> >> > This series has been tested through a simple bpf program (available here:
>> >> >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
>> >> >> > used to count frame types received by the device.
>> >> >> > Possible eBPF use cases could be:
>> >> >> > - implement new statistics through bpf maps
>> >> >> > - implement fast packet filtering (e.g in monitor mode)
>> >> >> > - ...
>> >> >
>> >> > Hi Kalle,
>> >> >
>> >> >> 
>> >> >> This is most likely a stupid question, but why do this in the driver and
>> >> >> not in mac80211 so that all drivers could benefit from it? I guess there
>> >> >> are reasons for that, I just can't figure that out.
>> >> 
>> >> XDP achieves its speedup by running the eBPF program inside the driver
>> >> NAPI loop, before the kernel even touches the data in any other capacity
>> >> (and in particular, before it allocates an SKB). Which kinda means the
>> >> hook needs to be in the driver... Could be a fallback in mac80211,
>> >> though; although we'd have to figure out how that interacts with Generic
>> >> XDP.
>> >> 
>> >> > This is an early stage implementation, at this point I would collect
>> >> > other people opinions/concerns about using bpf/xdp directly on 802.11
>> >> > frames.
>> >> 
>> >> Thanks for looking into this!
>> >
>> > Hi Toke,
>> >
>> >> 
>> >> I have two concerns with running XDP on 802.11 frames:
>> >> 
>> >> 1. It makes it more difficult to add other XDP actions (such as
>> >>    REDIRECT), as the XDP program would then have to make sure that the
>> >>    outer packet headers are removed before, say, redirecting the packet
>> >>    out of an ethernet interface. Also, if we do add redirect, we would
>> >>    be bypassing mac80211 entirely; to what extent would that mess up
>> >>    internal state?
>> >> 
>> >
>> > You are right, my assumption here is the logic/complexity is moved to
>> > the bpf program that needs to take care of all possible issues that
>> > can be introduced. More or less it is the same if a bpf program mess
>> > up with TCP segments on a wired connection, isn't it?
>> 
>> No, I guess not; except here it potentially applies to all packets
>> (things like BAW tracking), and it is *in addition* to TCP.
>
> Yes, here it is a little bit harder, but I was meaning that the bpf program
> has to be very careful when dropping a packet :)

Yeah. What kind of filtering were you thinking you would use this for in
the short term?

-Toke
