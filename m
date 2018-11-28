Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4945C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 13:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738CE20989
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 13:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 738CE20989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbeK2ANY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 19:13:24 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37233 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbeK2ANY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 19:13:24 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so2523826wmd.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 05:11:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/9ASl2zNcq6oT/tfZTlwxRxc3pUK2BJTsRltUZXsqcE=;
        b=pD/dh6jgOc5tJwnS1Ph5iLIC0UKkUisVSlxA+QIlKXsATJzKsgxISIcUWu4oBTJaax
         CHpdtDqje33mg77fMgDJprehjY91f102hR+QNYnn3aucc4yhRCiY+759D1GJpE3h+F9K
         9yenR+xPxdL9ZxB7CbyYXvKG+QC8MZirRvLqsiETrOHMRs3bnBYKEoUyt8EA/Tu3znpB
         0N/PPg5/qOeHVWg6No7avxt+l+Pll2Ro7b/qNXO/e5QChKv34Z8gHlhM+87lWV8k1w0B
         1I5N6iGjGdVZWbdORzg8Gos4PWW6qJQOiw+bBQY9prBi+kX6qjt5l63dYZPheb2iSQ1g
         2plg==
X-Gm-Message-State: AA+aEWZof0PREyNuQZiYE97IhCdsGGhjNkR8cfpdbFcKnqHtyVPjEhAm
        JwayfxJYjXu8XQsBtA6a1ji+Gg==
X-Google-Smtp-Source: AFSGD/WlOz1nfTNaxJD2Wc41AH157kTK/GnQ7RhN6edf28WxTIWdymXyLFC3SKFlJGrBWRxJW6hLew==
X-Received: by 2002:a1c:ddc3:: with SMTP id u186mr2640180wmg.110.1543410705368;
        Wed, 28 Nov 2018 05:11:45 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e9sm7214647wro.16.2018.11.28.05.11.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Nov 2018 05:11:44 -0800 (PST)
Date:   Wed, 28 Nov 2018 14:11:42 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        nbd@nbd.name, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Message-ID: <20181128131141.GD2298@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net>
 <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bm69v0ol.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

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

Hi Toke,

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

You are right, my assumption here is the logic/complexity is moved to the bpf
program that needs to take care of all possible issues that can be introduced.
More or less it is the same if a bpf program mess up with TCP segments on a
wired connection, isn't it?

> 2. UI consistency; suddenly, the user needs to know which kind of
>    frames to expect, and XDP program reuse becomes more difficult. This
>    may be unavoidable given the nature of XDP, but some thought needs to
>    go into this. Especially since we wouldn't necessarily be consistent
>    between WiFi drivers (there are fullmac devices that remove 802.11
>    headers before sending up the frame, right?).
> 

Right, maybe can we have some kind of 'wifi' bpf helpers?

Regards,
Lorenzo

> 
> Adding in Jesper; maybe he has some thoughts on this?
> 
> -Toke
