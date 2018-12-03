Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7163CC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F37A20848
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="LFJzmfid"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F37A20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbeLCTv2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 14:51:28 -0500
Received: from mail.toke.dk ([52.28.52.200]:43281 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbeLCTv2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 14:51:28 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543866683; bh=0O8wRJzvss4OnIvgfa68VllZDX6m3zAP44ZFIkaLBlQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=LFJzmfidP24crdn3E4HZ7G3MMMf8Z0W52C15emlSAsD1T546onhtPGoH5arT4/gmv
         OZhMlPM6wzaOgGjc0nyY3KuQmwYkwWBSRwG5Pj3oXwdXkOs2bes7LA6mVZQqi7BkBb
         JMOQ52N7jV6ZnZp5YkbfS7y3/Fw/khrMi6xxzq0WWn85BAFPYuT8xLR7v9QV5XODeY
         rQ6O4NmlyTZSu2zig2h4ePdX6f2ODGidTMyEqSFUEWbunCFKX2k0AF2f0CblFEl9a2
         sz32z1pj1GKcAMurbxl6UnxTqPrwakQq0Ko8zQzn2wSWuIGmXEjv0YmAE9ujEDRDlE
         2bPoZ+AxtSCjw==
To:     Johannes Berg <johannes@sipsolutions.net>,
        =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        lorenzo.bianconi@redhat.com
Cc:     kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <4e2d8543c6e4e48d6b6a9f4fde5c811dd4d71243.camel@sipsolutions.net>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain> <87zhtttg8p.fsf@toke.dk> <20181128153508.GG2298@localhost.localdomain> <87in0gu78s.fsf@toke.dk> <20181129125929.GB6365@localhost.localdomain> <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com> <87k1kwq9bo.fsf@toke.dk> <bb855ffd6043743ef10058c9395d0c6b42a7832a.camel@sipsolutions.net> <87bm62jtbu.fsf@toke.dk> <4e2d8543c6e4e48d6b6a9f4fde5c811dd4d71243.camel@sipsolutions.net>
Date:   Mon, 03 Dec 2018 21:51:20 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875zwajsnb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2018-12-03 at 21:36 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Hi Johannes
>>=20
>> I think your email can be basically summed up to:
>>=20
>> > [ ... ] but really I think it's a can of worms.
>>=20
>> ...right? :)
>
> Heh, yeah :)
>
>> I sort of had a feeling it would be, but thank you for spelling out in
>> excruciating detail why that is so.
>
> :-)
>
>> Given this, I think I agree that it's not worth it for now, and we
>> should hold off on adding XDP support until we have 802.3/.11
>> conversion offload working... Which I think is also where you ended
>> up? :)
>
> That case is at least easy, yeah. And it seems kinda likely that we'll
> end up with that in all well-maintained drivers in the relatively near
> future anyway?

Right; you probably know that better than me :)

> BTW, in a sense I still kind of want to add eBPF to the mac80211 ingress
> path, just not in the XDP sense. For example, I had a proposal a while
> ago to add a filter to the monitor mode RX path(s) in eBPF; I still
> think that's useful.
>
> I also think it may be useful to put eBPF programs into per-netdev
> ingress path, in order to e.g. collect statistics, rather than hard-
> coding all kinds of statistics into mac80211.
>
> All of these things I consider absolutely useful and helpful. I like
> eBPF and the flexibility it affords. I just really don't think we should
> call it XDP or let it do similar things to XDP like dropping or
> redirecting frames.

Absolutely; totally on board with that!

-Toke
