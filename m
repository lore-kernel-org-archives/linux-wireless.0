Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54DFC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCBC20863
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BCBC20863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbeK2Vfz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 16:35:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39259 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbeK2Vfy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 16:35:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id t27so1326748wra.6
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 02:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Vu1YceFceYMkkL720pgddkej3sdwlyIucghxyyNT79w=;
        b=RGvYfmZGnVPFXaWm/8LwjT07cAtslt1wCIpCYx4R4zqlFrvMxRzKMjnrSmYK8doKZg
         VyD06PRhF62nxBVXdGUyHrRZIdUnnXqp3cBoF0eiPp4jaTOw44+UsFwOEpUyC438PXCn
         8d6YA6GTdUvXha2pcBpo+3TeaLfVPRxffxOp4HS+ql8hXMZcSfM2Z8bihrdipmXcvXip
         LMD3KBh8joGt80Og/6MZ63L1jsWDxMbiJk1w4QV5w3e5g5V9gZsIo8yDLQdxMtc3AVhF
         dTTY3HJe9YPhsaGkb5RbMfOZC4LsPnzedPQbAFthzLNtyHRRr5XY7ZG97fYP13KRTcNq
         30og==
X-Gm-Message-State: AA+aEWbmAImcsuI16APoh4U1dxMVw6ZvXXg8GI17yE5Htmso5Jhj9C7w
        cSx1RVp4i5VCH8W4zDZv5ibKpA==
X-Google-Smtp-Source: AFSGD/XDzGg+7DhrO9kU1IOTZPwtD2+jLW2x5k67baPR3cq0UAYeX3f8rciqYAGEKOEScgoRYmCpTw==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr858812wrs.268.1543487459217;
        Thu, 29 Nov 2018 02:30:59 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id n5sm838269wrr.94.2018.11.29.02.30.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Nov 2018 02:30:58 -0800 (PST)
Date:   Thu, 29 Nov 2018 11:30:56 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, nbd@nbd.name,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Message-ID: <20181129103054.GA6365@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net>
 <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk>
 <20181128164306.0135ca83@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181128164306.0135ca83@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Wed, 28 Nov 2018 13:36:26 +0100
> Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> 
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> > 
> > >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> > >>   
> > >> > This series is intended as a playground to start experimenting/developing
> > >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
> > >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
> > >> > actions are:
> > >> > - XDP_PASS
> > >> > - XDP_ABORTED
> > >> > - XDP_DROP
> > >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
> > >> > program into low level driver XDP rx hook.
> > >> > This series has been tested through a simple bpf program (available here:
> > >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
> > >> > used to count frame types received by the device.
> > >> > Possible eBPF use cases could be:
> > >> > - implement new statistics through bpf maps
> > >> > - implement fast packet filtering (e.g in monitor mode)
> > >> > - ...  
> > >
> > > Hi Kalle,
> > >  
> > >> 
> > >> This is most likely a stupid question, but why do this in the driver and
> > >> not in mac80211 so that all drivers could benefit from it? I guess there
> > >> are reasons for that, I just can't figure that out.  
> > 
> > XDP achieves its speedup by running the eBPF program inside the driver
> > NAPI loop, before the kernel even touches the data in any other capacity
> > (and in particular, before it allocates an SKB). Which kinda means the
> > hook needs to be in the driver... Could be a fallback in mac80211,
> > though; although we'd have to figure out how that interacts with Generic
> > XDP.
> > 
> > > This is an early stage implementation, at this point I would collect
> > > other people opinions/concerns about using bpf/xdp directly on 802.11
> > > frames.  
> > 
> > Thanks for looking into this!
> > 
> > I have two concerns with running XDP on 802.11 frames:
> > 
> > 1. It makes it more difficult to add other XDP actions (such as
> >    REDIRECT), as the XDP program would then have to make sure that the
> >    outer packet headers are removed before, say, redirecting the packet
> >    out of an ethernet interface. Also, if we do add redirect, we would
> >    be bypassing mac80211 entirely; to what extent would that mess up
> >    internal state?
> > 
> > 2. UI consistency; suddenly, the user needs to know which kind of
> >    frames to expect, and XDP program reuse becomes more difficult. This
> >    may be unavoidable given the nature of XDP, but some thought needs to
> >    go into this. Especially since we wouldn't necessarily be consistent
> >    between WiFi drivers (there are fullmac devices that remove 802.11
> >    headers before sending up the frame, right?).
> > 
> > 
> > Adding in Jesper; maybe he has some thoughts on this?

Hi Jesper,

> 
> Today XDP assumes the frame is an Ethernet frame.  With WiFi I guess
> this assumption change, right?

yes correct, SoftMAC devices report 802.11 frames to the stack

>   I worry a bit about this, as XDP is all about performance, and I don't
> want to add performance regressions, by requiring all XDP programs or
> core-code to having to check-frame-type before proceeding. That said, I
> do think it is doable, without adding performance regressions.
> 
> Option #1 is to move the check-frame-type to setup time.  By either
> having frame-type be part of eBPF prog, or supply frame-type as option
> XDP attach call.  And then reject attaching XDP prog to a device, where
> the expected frame-type does not match.
> 

I guess it will be enough to avoid loading a 'non-WiFi' bpf program on a 802.11
netdevice (and vice versa). We could add a flag (or something similar) in
XDP_SETUP_PROG section of netdev_bpf data structure and use ieee80211_ptr
netdevice pointer in order to guarantee that the bpf program will work on the
expected 'frame-type'

> Option#2, leave it up to eBPF-programmer if they want to add runtime
> checks.  By extending xdp_rxq_info with frame-type (default to
> Ethernet), which allow the eBPF-programmer choose to write a generic
> XDP program that both work on Ethernet and WiFi, or skip-check as they
> know this will e.g. only run on Wifi.  (Note xdp_rxq_info is static
> read-only info per RX-queue, will all Wifi frames have same frame-type?.
> 

802.11 standards define three frame subtype (data, management and control).
Subtypes could be detected parsing 802.11 header

> 
> Also consider what happens in case of XDP_REDIRECT, from a Wifi NIC to
> an Ethernet NIC.  It would of-cause be cool to get this working cross,
> Wifi-Ethernet.
> 

Very cool :) On tx side the driver will accept standard ethernet frames in
ndo_xdp_xmit pointer

> Option#3 is to say, Wifi XDP is so different that we should create a
> new (enum) bpf_prog_type.  And then still see if we can leverage some
> of the same core-code (as long as it doesn't slowdown performance).
> 

Do you think that Option#3 will be more 'future-proof' respect to Option#1?

Regards,
Lorenzo

> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
