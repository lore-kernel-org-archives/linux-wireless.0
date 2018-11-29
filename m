Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FE1C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 12:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ABF42081C
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 12:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ABF42081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbeK3AEy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:04:54 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51575 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbeK3AEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:04:53 -0500
Received: by mail-wm1-f65.google.com with SMTP id s14so2176654wmh.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 04:59:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Gc+Xw7+61sNPcDSekEdA0FGBSyNf5w0sAygVNInyEn8=;
        b=YUOHyVBMicRkYZs5QUpdZ9LO7nyc6NBlHMIpX8JWFOx+kGgt6SyagjVR/1Mfk7WWZH
         rHwhRZRb4OFo19Ys4MHlMdleWB0oAytmZrUHg2AZUosjYNEkzvecZFjf5P1tXt7pE6YY
         eMAL3d1pLV0EFqKqegjRHZ4gPWLMZ83xnTppTAG9YQ5FiOFZ0MdIujQTX92GC77Gh+YF
         dLzMr0SONSux1vQLaGzQP3HBUrC3TDlQrlBNV5tNYmBt4l/xgTPWQFP/+VYCXiW2oTQH
         SeWd7772oNuBX40HOXaN5fWF8cnUXyXP1jKUURVSBel3Xk/4+/HS9E+vgBRUVwKpg1Cz
         ulxw==
X-Gm-Message-State: AA+aEWaR1LldIRj8NEYLDPWGyddVHbRN3koWUBs1NgDa10jaVJfACTZ5
        wW1pv+v+BqshMNzTIOcS56fPKA==
X-Google-Smtp-Source: AFSGD/XpUGvyz/IE2A29afhfl663BBWYluMGVn/SNLPpDUIoxcK4Xa7dn8DNpYDd9wQtD9VGxfIA7Q==
X-Received: by 2002:a1c:8cd0:: with SMTP id o199mr1575224wmd.56.1543496374026;
        Thu, 29 Nov 2018 04:59:34 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x79sm5345640wmd.42.2018.11.29.04.59.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Nov 2018 04:59:33 -0800 (PST)
Date:   Thu, 29 Nov 2018 13:59:30 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        nbd@nbd.name, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Message-ID: <20181129125929.GB6365@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net>
 <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk>
 <20181128131141.GD2298@localhost.localdomain>
 <875zwhuvta.fsf@toke.dk>
 <20181128143533.GE2298@localhost.localdomain>
 <87zhtttg8p.fsf@toke.dk>
 <20181128153508.GG2298@localhost.localdomain>
 <87in0gu78s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87in0gu78s.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> > On Nov 28, Toke Høiland-Jørgensen wrote:
> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >> 
> >> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >> >> 
> >> >> >> >> > This series is intended as a playground to start experimenting/developing
> >> >> >> >> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
> >> >> >> >> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
> >> >> >> >> > actions are:
> >> >> >> >> > - XDP_PASS
> >> >> >> >> > - XDP_ABORTED
> >> >> >> >> > - XDP_DROP
> >> >> >> >> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
> >> >> >> >> > program into low level driver XDP rx hook.
> >> >> >> >> > This series has been tested through a simple bpf program (available here:
> >> >> >> >> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
> >> >> >> >> > used to count frame types received by the device.
> >> >> >> >> > Possible eBPF use cases could be:
> >> >> >> >> > - implement new statistics through bpf maps
> >> >> >> >> > - implement fast packet filtering (e.g in monitor mode)
> >> >> >> >> > - ...
> >> >> >> >
> >> >> >> > Hi Kalle,
> >> >> >> >
> >> >> >> >> 
> >> >> >> >> This is most likely a stupid question, but why do this in the driver and
> >> >> >> >> not in mac80211 so that all drivers could benefit from it? I guess there
> >> >> >> >> are reasons for that, I just can't figure that out.
> >> >> >> 
> >> >> >> XDP achieves its speedup by running the eBPF program inside the driver
> >> >> >> NAPI loop, before the kernel even touches the data in any other capacity
> >> >> >> (and in particular, before it allocates an SKB). Which kinda means the
> >> >> >> hook needs to be in the driver... Could be a fallback in mac80211,
> >> >> >> though; although we'd have to figure out how that interacts with Generic
> >> >> >> XDP.
> >> >> >> 
> >> >> >> > This is an early stage implementation, at this point I would collect
> >> >> >> > other people opinions/concerns about using bpf/xdp directly on 802.11
> >> >> >> > frames.
> >> >> >> 
> >> >> >> Thanks for looking into this!
> >> >> >
> >> >> > Hi Toke,
> >> >> >
> >> >> >> 
> >> >> >> I have two concerns with running XDP on 802.11 frames:
> >> >> >> 
> >> >> >> 1. It makes it more difficult to add other XDP actions (such as
> >> >> >>    REDIRECT), as the XDP program would then have to make sure that the
> >> >> >>    outer packet headers are removed before, say, redirecting the packet
> >> >> >>    out of an ethernet interface. Also, if we do add redirect, we would
> >> >> >>    be bypassing mac80211 entirely; to what extent would that mess up
> >> >> >>    internal state?
> >> >> >> 
> >> >> >
> >> >> > You are right, my assumption here is the logic/complexity is moved to
> >> >> > the bpf program that needs to take care of all possible issues that
> >> >> > can be introduced. More or less it is the same if a bpf program mess
> >> >> > up with TCP segments on a wired connection, isn't it?
> >> >> 
> >> >> No, I guess not; except here it potentially applies to all packets
> >> >> (things like BAW tracking), and it is *in addition* to TCP.
> >> >
> >> > Yes, here it is a little bit harder, but I was meaning that the bpf program
> >> > has to be very careful when dropping a packet :)
> >> 
> >> Yeah. What kind of filtering were you thinking you would use this for in
> >> the short term?
> >> 
> >
> > When I started working on XDP for mt76 I was thinking about BSSID
> > filtering but I was looking for a more general solution respect to add
> > that feature in the driver. Moreover we could use bpf for fast packet
> > filtering when you add an interface in monitor mode.
> 
> Yup, both of these make sense.
> 
> > Nevertheless I guess there could be other use cases not limited to
> > frame filtering. My primary goal with this series is to collect
> > ideas/concerns on WiFi XDP/eBPF possible uses cases.
> 
> Well, Michał's idea about offloading is cool if it is possible to get
> vendors to implement it.
> 

Yep, would be very cool :)

> Other than that, if we can solve the issues with differences between
> 802.11 and plain Ethernet frames, I see no reason why it wouldn't be
> possible to implement an XDP fast-path for WiFi-to-Ethernet forwarding,
> which might be useful in an access point, especially as WiFi speeds
> increase.
> 

Agree

> The other direction will probably be more difficult, at least if 802.11
> frames need to be built in software. It *might* be possible with the XDP
> egress hook we are planning (with a suitable set of helpers, the eBPF
> program could build the 802.11 frames), but I'm not really sure if that
> is worth doing as I'm quite sure there are some hairy edge cases
> there...

The possible issue with XDP_DROP action you are referring to here is A-MPDU
reordering on rx side, right? If so I guess the issue will be fixed by
tid_agg_rx->reorder_timer. Are you referring to other possible edge cases?

Regards,
Lorenzo

> 
> -Toke
