Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A9AC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE3B20659
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DE3B20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbeLCTl7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 14:41:59 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41318 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbeLCTl7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 14:41:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gTu6K-00085P-Qd; Mon, 03 Dec 2018 20:41:52 +0100
Message-ID: <4e2d8543c6e4e48d6b6a9f4fde5c811dd4d71243.camel@sipsolutions.net>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        =?UTF-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        lorenzo.bianconi@redhat.com
Cc:     kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, brouer@redhat.com
Date:   Mon, 03 Dec 2018 20:41:50 +0100
In-Reply-To: <87bm62jtbu.fsf@toke.dk>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
         <8736rla4ow.fsf@purkki.adurom.net>
         <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk>
         <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk>
         <20181128143533.GE2298@localhost.localdomain> <87zhtttg8p.fsf@toke.dk>
         <20181128153508.GG2298@localhost.localdomain> <87in0gu78s.fsf@toke.dk>
         <20181129125929.GB6365@localhost.localdomain>
         <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com>
         <87k1kwq9bo.fsf@toke.dk>
         <bb855ffd6043743ef10058c9395d0c6b42a7832a.camel@sipsolutions.net>
         <87bm62jtbu.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-12-03 at 21:36 +0200, Toke Høiland-Jørgensen wrote:
> Hi Johannes
> 
> I think your email can be basically summed up to:
> 
> > [ ... ] but really I think it's a can of worms.
> 
> ...right? :)

Heh, yeah :)

> I sort of had a feeling it would be, but thank you for spelling out in
> excruciating detail why that is so.

:-)

> Given this, I think I agree that it's not worth it for now, and we
> should hold off on adding XDP support until we have 802.3/.11 conversion
> offload working... Which I think is also where you ended up? :)

That case is at least easy, yeah. And it seems kinda likely that we'll
end up with that in all well-maintained drivers in the relatively near
future anyway?

BTW, in a sense I still kind of want to add eBPF to the mac80211 ingress
path, just not in the XDP sense. For example, I had a proposal a while
ago to add a filter to the monitor mode RX path(s) in eBPF; I still
think that's useful.

I also think it may be useful to put eBPF programs into per-netdev
ingress path, in order to e.g. collect statistics, rather than hard-
coding all kinds of statistics into mac80211.

All of these things I consider absolutely useful and helpful. I like
eBPF and the flexibility it affords. I just really don't think we should
call it XDP or let it do similar things to XDP like dropping or
redirecting frames.

johannes

