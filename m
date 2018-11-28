Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FC3C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 12:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F3282081B
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 12:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="Uo0cz7aK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F3282081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbeK1XiA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 18:38:00 -0500
Received: from mail.toke.dk ([52.28.52.200]:57429 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727676AbeK1XiA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 18:38:00 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543408587; bh=Xy01UM958O79MBlljDaWo9T+z5IBsxjBR9gjnQQ3uPQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Uo0cz7aKXULAQLm5DAHp0B7RiRjOLoaC//eF7s5iHp/GUEAhqithEh47x63K2rE1w
         xQ1fPy1kH9d8AxFOSeTQW1vVi/4hVNARKnY3q9h0QTlF/44NJd0wA1i+Q7BNwhkoOE
         CemV0GBhaFG3T+nM0EBgro25nk3k2M+7o/9S0ol+qLA++2ShuyjxKfmP671I6+Xlwe
         0UGS9+zKS3jJijYFhQnIVuKGow0foQ9lJ0f2FO5z2hOI49Da0KZOGv5oQmJqDNt7jJ
         0gywVQGgv0W5QT+s1s+GKR9ygvsxUBBEjrEb//tgfV1dpSioJSU7eNgnpQEqtKxge4
         YN0+LIAituj2Q==
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <20181128104436.GA2298@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain>
Date:   Wed, 28 Nov 2018 13:36:26 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bm69v0ol.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> 
>> > This series is intended as a playground to start experimenting/developing
>> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
>> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
>> > actions are:
>> > - XDP_PASS
>> > - XDP_ABORTED
>> > - XDP_DROP
>> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
>> > program into low level driver XDP rx hook.
>> > This series has been tested through a simple bpf program (available here:
>> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
>> > used to count frame types received by the device.
>> > Possible eBPF use cases could be:
>> > - implement new statistics through bpf maps
>> > - implement fast packet filtering (e.g in monitor mode)
>> > - ...
>
> Hi Kalle,
>
>> 
>> This is most likely a stupid question, but why do this in the driver and
>> not in mac80211 so that all drivers could benefit from it? I guess there
>> are reasons for that, I just can't figure that out.

XDP achieves its speedup by running the eBPF program inside the driver
NAPI loop, before the kernel even touches the data in any other capacity
(and in particular, before it allocates an SKB). Which kinda means the
hook needs to be in the driver... Could be a fallback in mac80211,
though; although we'd have to figure out how that interacts with Generic
XDP.

> This is an early stage implementation, at this point I would collect
> other people opinions/concerns about using bpf/xdp directly on 802.11
> frames.

Thanks for looking into this!

I have two concerns with running XDP on 802.11 frames:

1. It makes it more difficult to add other XDP actions (such as
   REDIRECT), as the XDP program would then have to make sure that the
   outer packet headers are removed before, say, redirecting the packet
   out of an ethernet interface. Also, if we do add redirect, we would
   be bypassing mac80211 entirely; to what extent would that mess up
   internal state?

2. UI consistency; suddenly, the user needs to know which kind of
   frames to expect, and XDP program reuse becomes more difficult. This
   may be unavoidable given the nature of XDP, but some thought needs to
   go into this. Especially since we wouldn't necessarily be consistent
   between WiFi drivers (there are fullmac devices that remove 802.11
   headers before sending up the frame, right?).


Adding in Jesper; maybe he has some thoughts on this?

-Toke
