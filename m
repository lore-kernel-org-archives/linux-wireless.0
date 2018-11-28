Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD73EC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 15:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D5BB206B6
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 15:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D5BB206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbeK2CpU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 21:45:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbeK2CpU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 21:45:20 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D6DBC05000B;
        Wed, 28 Nov 2018 15:43:15 +0000 (UTC)
Received: from localhost (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3653F100191D;
        Wed, 28 Nov 2018 15:43:07 +0000 (UTC)
Date:   Wed, 28 Nov 2018 16:43:06 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, nbd@nbd.name, brouer@redhat.com,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Message-ID: <20181128164306.0135ca83@redhat.com>
In-Reply-To: <87bm69v0ol.fsf@toke.dk>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
        <8736rla4ow.fsf@purkki.adurom.net>
        <20181128104436.GA2298@localhost.localdomain>
        <87bm69v0ol.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 28 Nov 2018 15:43:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 28 Nov 2018 13:36:26 +0100
Toke Høiland-Jørgensen <toke@toke.dk> wrote:

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >>   
> >> > This series is intended as a playground to start experimenting/developing
> >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
> >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
> >> > actions are:
> >> > - XDP_PASS
> >> > - XDP_ABORTED
> >> > - XDP_DROP
> >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
> >> > program into low level driver XDP rx hook.
> >> > This series has been tested through a simple bpf program (available here:
> >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
> >> > used to count frame types received by the device.
> >> > Possible eBPF use cases could be:
> >> > - implement new statistics through bpf maps
> >> > - implement fast packet filtering (e.g in monitor mode)
> >> > - ...  
> >
> > Hi Kalle,
> >  
> >> 
> >> This is most likely a stupid question, but why do this in the driver and
> >> not in mac80211 so that all drivers could benefit from it? I guess there
> >> are reasons for that, I just can't figure that out.  
> 
> XDP achieves its speedup by running the eBPF program inside the driver
> NAPI loop, before the kernel even touches the data in any other capacity
> (and in particular, before it allocates an SKB). Which kinda means the
> hook needs to be in the driver... Could be a fallback in mac80211,
> though; although we'd have to figure out how that interacts with Generic
> XDP.
> 
> > This is an early stage implementation, at this point I would collect
> > other people opinions/concerns about using bpf/xdp directly on 802.11
> > frames.  
> 
> Thanks for looking into this!
> 
> I have two concerns with running XDP on 802.11 frames:
> 
> 1. It makes it more difficult to add other XDP actions (such as
>    REDIRECT), as the XDP program would then have to make sure that the
>    outer packet headers are removed before, say, redirecting the packet
>    out of an ethernet interface. Also, if we do add redirect, we would
>    be bypassing mac80211 entirely; to what extent would that mess up
>    internal state?
> 
> 2. UI consistency; suddenly, the user needs to know which kind of
>    frames to expect, and XDP program reuse becomes more difficult. This
>    may be unavoidable given the nature of XDP, but some thought needs to
>    go into this. Especially since we wouldn't necessarily be consistent
>    between WiFi drivers (there are fullmac devices that remove 802.11
>    headers before sending up the frame, right?).
> 
> 
> Adding in Jesper; maybe he has some thoughts on this?

Today XDP assumes the frame is an Ethernet frame.  With WiFi I guess
this assumption change, right?
  I worry a bit about this, as XDP is all about performance, and I don't
want to add performance regressions, by requiring all XDP programs or
core-code to having to check-frame-type before proceeding. That said, I
do think it is doable, without adding performance regressions.

Option #1 is to move the check-frame-type to setup time.  By either
having frame-type be part of eBPF prog, or supply frame-type as option
XDP attach call.  And then reject attaching XDP prog to a device, where
the expected frame-type does not match.

Option#2, leave it up to eBPF-programmer if they want to add runtime
checks.  By extending xdp_rxq_info with frame-type (default to
Ethernet), which allow the eBPF-programmer choose to write a generic
XDP program that both work on Ethernet and WiFi, or skip-check as they
know this will e.g. only run on Wifi.  (Note xdp_rxq_info is static
read-only info per RX-queue, will all Wifi frames have same frame-type?.


Also consider what happens in case of XDP_REDIRECT, from a Wifi NIC to
an Ethernet NIC.  It would of-cause be cool to get this working cross,
Wifi-Ethernet.

Option#3 is to say, Wifi XDP is so different that we should create a
new (enum) bpf_prog_type.  And then still see if we can leverage some
of the same core-code (as long as it doesn't slowdown performance).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
