Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC9DC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D5B2081C
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79D5B2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbeK3BEA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 20:04:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35858 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbeK3BD7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 20:03:59 -0500
Received: by mail-wm1-f68.google.com with SMTP id a18so2354484wmj.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 05:58:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1AoML8tMR4Jk3fawFB/zO5S239Z42Vc5vI4Sk0fc1L8=;
        b=ZXqeBfYfcdT3cqVHuxCyaIpHshjrcl74/OBKv29wHyAeW/Z9//LSgkHexxGoX+4NBI
         SjSuFe0xGEQ7FYFw/H94oaFbxNh7uZqnsvYeKSYt4Su+4X2v+B05QARtWivVziq5FN5f
         IQsT/AMZiWCEmg3rxkzfOo1ZD065aLdhfggqDrz4yibQO0VuPPiW5ZkprX+Kg8ytI5JM
         VwRHWhWa6/nyXJUnkNgTO571MKhweJIEJo2eDcUWc5RUAHgKREHF3fgyQDg25p8My/xM
         Nfrk1AyN5OGcPPymiqIY2BiKVAm+QvTiCO9QsbCWBQvrWL4lZbI7Gy0Xq0WxbY2KaoW0
         lR0g==
X-Gm-Message-State: AA+aEWa7kUMewCa9HCnJ7CZDlVvJ4Hymxu6TfVQW70ji9C6lwz4hVB4p
        xttWKPV0XxM4RhlUB94wykwUkw==
X-Google-Smtp-Source: AFSGD/XVh7A91CozDzso/pwZOS0O+AfxmuCUBj+FUeDcPEPn8tZ9CVvTjHBKDBdXnkUs7UGH1i+TLw==
X-Received: by 2002:a1c:8548:: with SMTP id h69mr1742030wmd.11.1543499909319;
        Thu, 29 Nov 2018 05:58:29 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v1sm2720680wrw.90.2018.11.29.05.58.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Nov 2018 05:58:28 -0800 (PST)
Date:   Thu, 29 Nov 2018 14:58:26 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, nbd@nbd.name,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Message-ID: <20181129135825.GD6365@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net>
 <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk>
 <20181128164306.0135ca83@redhat.com>
 <20181129103054.GA6365@localhost.localdomain>
 <87sgzkqaip.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sgzkqaip.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> >> On Wed, 28 Nov 2018 13:36:26 +0100
> >> Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> >> 
> >> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >> > 
> >> > >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >> > >>   
> >> > >> > This series is intended as a playground to start experimenting/developing
> >> > >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
> >> > >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
> >> > >> > actions are:
> >> > >> > - XDP_PASS
> >> > >> > - XDP_ABORTED
> >> > >> > - XDP_DROP
> >> > >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
> >> > >> > program into low level driver XDP rx hook.
> >> > >> > This series has been tested through a simple bpf program (available here:
> >> > >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
> >> > >> > used to count frame types received by the device.
> >> > >> > Possible eBPF use cases could be:
> >> > >> > - implement new statistics through bpf maps
> >> > >> > - implement fast packet filtering (e.g in monitor mode)
> >> > >> > - ...  
> >> > >
> >> > > Hi Kalle,
> >> > >  
> >> > >> 
> >> > >> This is most likely a stupid question, but why do this in the driver and
> >> > >> not in mac80211 so that all drivers could benefit from it? I guess there
> >> > >> are reasons for that, I just can't figure that out.  
> >> > 
> >> > XDP achieves its speedup by running the eBPF program inside the driver
> >> > NAPI loop, before the kernel even touches the data in any other capacity
> >> > (and in particular, before it allocates an SKB). Which kinda means the
> >> > hook needs to be in the driver... Could be a fallback in mac80211,
> >> > though; although we'd have to figure out how that interacts with Generic
> >> > XDP.
> >> > 
> >> > > This is an early stage implementation, at this point I would collect
> >> > > other people opinions/concerns about using bpf/xdp directly on 802.11
> >> > > frames.  
> >> > 
> >> > Thanks for looking into this!
> >> > 
> >> > I have two concerns with running XDP on 802.11 frames:
> >> > 
> >> > 1. It makes it more difficult to add other XDP actions (such as
> >> >    REDIRECT), as the XDP program would then have to make sure that the
> >> >    outer packet headers are removed before, say, redirecting the packet
> >> >    out of an ethernet interface. Also, if we do add redirect, we would
> >> >    be bypassing mac80211 entirely; to what extent would that mess up
> >> >    internal state?
> >> > 
> >> > 2. UI consistency; suddenly, the user needs to know which kind of
> >> >    frames to expect, and XDP program reuse becomes more difficult. This
> >> >    may be unavoidable given the nature of XDP, but some thought needs to
> >> >    go into this. Especially since we wouldn't necessarily be consistent
> >> >    between WiFi drivers (there are fullmac devices that remove 802.11
> >> >    headers before sending up the frame, right?).
> >> > 
> >> > 
> >> > Adding in Jesper; maybe he has some thoughts on this?
> >
> > Hi Jesper,
> >
> >> 
> >> Today XDP assumes the frame is an Ethernet frame.  With WiFi I guess
> >> this assumption change, right?
> >
> > yes correct, SoftMAC devices report 802.11 frames to the stack
> >
> >>   I worry a bit about this, as XDP is all about performance, and I don't
> >> want to add performance regressions, by requiring all XDP programs or
> >> core-code to having to check-frame-type before proceeding. That said, I
> >> do think it is doable, without adding performance regressions.
> >> 
> >> Option #1 is to move the check-frame-type to setup time.  By either
> >> having frame-type be part of eBPF prog, or supply frame-type as option
> >> XDP attach call.  And then reject attaching XDP prog to a device, where
> >> the expected frame-type does not match.
> >> 
> >
> > I guess it will be enough to avoid loading a 'non-WiFi' bpf program on
> > a 802.11 netdevice (and vice versa). We could add a flag (or something
> > similar) in XDP_SETUP_PROG section of netdev_bpf data structure and
> > use ieee80211_ptr netdevice pointer in order to guarantee that the bpf
> > program will work on the expected 'frame-type'
> 
> Yeah, a flag would be good; we've been discussing that for other XDP use
> cases; it's not a done deal yet, but I think it would be useful.

Do you think something wifi specific is ok (e.g bool wifi) or do you prefer
something more general (e.g u32 frame_type)?

> >
> >> Option#2, leave it up to eBPF-programmer if they want to add runtime
> >> checks.  By extending xdp_rxq_info with frame-type (default to
> >> Ethernet), which allow the eBPF-programmer choose to write a generic
> >> XDP program that both work on Ethernet and WiFi, or skip-check as they
> >> know this will e.g. only run on Wifi.  (Note xdp_rxq_info is static
> >> read-only info per RX-queue, will all Wifi frames have same frame-type?.
> >> 
> >
> > 802.11 standards define three frame subtype (data, management and control).
> > Subtypes could be detected parsing 802.11 header
> >
> >> 
> >> Also consider what happens in case of XDP_REDIRECT, from a Wifi NIC to
> >> an Ethernet NIC.  It would of-cause be cool to get this working cross,
> >> Wifi-Ethernet.
> >> 
> >
> > Very cool :) On tx side the driver will accept standard ethernet frames in
> > ndo_xdp_xmit pointer
> 
> How do you envision that will work with drivers that build software
> 802.11 frames? The TX hook would have to be in mac80211 somewhere,
> wouldn't it?

In order to perform 802.3 --> 802.11 xdp forwarding my current idea is is to have
ndo_xdp_xmit pointer in mac80211 that will forward the frame to the low-level driver
(more or less what I did in the RFC series to upload the bpf program to mt76).
We will probably need to pass some info to the driver from mac80211 (e.g sequence
number or hw key idx to use)

> 
> >> Option#3 is to say, Wifi XDP is so different that we should create a
> >> new (enum) bpf_prog_type.  And then still see if we can leverage some
> >> of the same core-code (as long as it doesn't slowdown performance).
> >> 
> >
> > Do you think that Option#3 will be more 'future-proof' respect to
> > Option#1?
> 
> My feeling is that WiFi devices are not sufficiently different to
> warrant a whole new program type. We risk combinatorial explosion for
> all the stuff that is the same, but now need to be tested for two (or N)
> types...

Agree

Regards,
Lorenzo

> 
> -Toke
