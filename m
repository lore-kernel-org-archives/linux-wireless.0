Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DB0C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBBDF2082F
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:45:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBBDF2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbeK3Cuz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:50:55 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:41756 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbeK3Cuz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:50:55 -0500
Received: by mail-wr1-f44.google.com with SMTP id x10so2369081wrs.8
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 07:45:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=PPRrNes7TjAPTjS+UPYqYtK6Zuz2ToclcHLsgc4sDLk=;
        b=fuGuzEZdhNFhIZ/aoeu80DxhCsbHFo12KBr1qOISYeHqSh7cHwH6eNo+Opiau9cen1
         GUR/9xe+2ABCt3U9AST+NpSzwByzl2JqAxpUn2TMkcIz6mFnmMMEW5yiWMT1wkJ0N1vw
         g6k9XmDZDzU+Y8qreOSZveY5xFwiFEaydKqA4UtCTerJh1es35ftRqtf35yRtghOmrDB
         tpxNq4nWwZ8Y3befcwTchonprSWfA0uWUFW3w6EHwnFR8wf6dnP1y9hpv/30nHEXG+6z
         gdzxUTTOAtZrUT25C4Iga769gS8MlU7pZmBgGInGjNdeLdWZNdCQiC65c6Y5vBq98UZ8
         yFKg==
X-Gm-Message-State: AA+aEWatdFJ16mtddFTtByuVgz2yTG93FSDobjpF+Tkionc9egxqVbXa
        bCg5y4BeAP10HoUi+4wDpU9Ieg==
X-Google-Smtp-Source: AFSGD/UFASAiNLV5U3qW7lniGknM/kHz7gQjoBIkM0UoxRUzhCDjMxaYBabXqrbaI39RZID6e+Hs7g==
X-Received: by 2002:a5d:4b42:: with SMTP id w2mr1913600wrs.156.1543506306936;
        Thu, 29 Nov 2018 07:45:06 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y9sm3105847wrq.55.2018.11.29.07.45.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Nov 2018 07:45:06 -0800 (PST)
Date:   Thu, 29 Nov 2018 16:45:03 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, nbd@nbd.name,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Message-ID: <20181129154502.GA29066@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net>
 <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk>
 <20181128164306.0135ca83@redhat.com>
 <20181129103054.GA6365@localhost.localdomain>
 <87sgzkqaip.fsf@toke.dk>
 <20181129135825.GD6365@localhost.localdomain>
 <87h8g0q8py.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h8g0q8py.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >> 
> >> >> On Wed, 28 Nov 2018 13:36:26 +0100
> >> >> Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> >> >> 

[...]

> >> >
> >> > I guess it will be enough to avoid loading a 'non-WiFi' bpf program on
> >> > a 802.11 netdevice (and vice versa). We could add a flag (or something
> >> > similar) in XDP_SETUP_PROG section of netdev_bpf data structure and
> >> > use ieee80211_ptr netdevice pointer in order to guarantee that the bpf
> >> > program will work on the expected 'frame-type'
> >> 
> >> Yeah, a flag would be good; we've been discussing that for other XDP use
> >> cases; it's not a done deal yet, but I think it would be useful.
> >
> > Do you think something wifi specific is ok (e.g bool wifi) or do you prefer
> > something more general (e.g u32 frame_type)?
> 
> My thought was a feature flag where the program can set a flag which
> means "I expect 802.11 frames", and the driver can set a flag saying "I
> emit 802.11 frames", and if those two flags don't match, the verifier
> can refuse to load the program. This would not be fool-proof (an XDP
> program can still corrupt things if written incorrectly), but it would
> at least protect against the most obvious mistakes.

I guess we can use iee80211_ptr in dev_xdp_install to double check if it is
allowed to upload a 802.11 (or 802.3) bpf program

> 
> >> >> Option#2, leave it up to eBPF-programmer if they want to add runtime
> >> >> checks.  By extending xdp_rxq_info with frame-type (default to
> >> >> Ethernet), which allow the eBPF-programmer choose to write a generic
> >> >> XDP program that both work on Ethernet and WiFi, or skip-check as they
> >> >> know this will e.g. only run on Wifi.  (Note xdp_rxq_info is static
> >> >> read-only info per RX-queue, will all Wifi frames have same frame-type?.
> >> >> 
> >> >
> >> > 802.11 standards define three frame subtype (data, management and control).
> >> > Subtypes could be detected parsing 802.11 header
> >> >
> >> >> 
> >> >> Also consider what happens in case of XDP_REDIRECT, from a Wifi NIC to
> >> >> an Ethernet NIC.  It would of-cause be cool to get this working cross,
> >> >> Wifi-Ethernet.
> >> >> 
> >> >
> >> > Very cool :) On tx side the driver will accept standard ethernet frames in
> >> > ndo_xdp_xmit pointer
> >> 
> >> How do you envision that will work with drivers that build software
> >> 802.11 frames? The TX hook would have to be in mac80211 somewhere,
> >> wouldn't it?
> >
> > In order to perform 802.3 --> 802.11 xdp forwarding my current idea is
> > is to have ndo_xdp_xmit pointer in mac80211 that will forward the
> > frame to the low-level driver (more or less what I did in the RFC
> > series to upload the bpf program to mt76). We will probably need to
> > pass some info to the driver from mac80211 (e.g sequence number or hw
> > key idx to use)
> 
> So this means that the driver will need to do the 802.11 encapsulation?
> I guess we could have a fallback implementation in mac80211; but there
> is possibly quite a bit of refactoring needed to make the existing code
> work without an skb. Also, we need to think about queueing; I'm not sure
> it's a good idea to have redirected frames bypass the TXQs...
> 

good point :)

Regards,
Lorenzo

> -Toke
