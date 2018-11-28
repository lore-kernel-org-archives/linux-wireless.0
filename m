Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FA8C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 14:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221CF20832
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 14:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="PH7VFqMk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 221CF20832
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbeK2BVN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 20:21:13 -0500
Received: from mail.toke.dk ([52.28.52.200]:60457 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbeK2BVN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 20:21:13 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543414762; bh=TLs8qIphhtmsSyX5+FmEBE5VmhgHnBNLRY3prgsC7Qs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PH7VFqMkL7wP63dNeLomzG/1J1JNsJp7TgPj/qy9NmGXxg2IwgmlXjGSrDGOpnx2D
         kWYVoYbaF6q1p7iA+OmRGVwLJuAyTTENkUdhs9/YeJ2lZNJwuxx11iCJuhDA9t+2Vi
         5o73OviEgggxkkkBc1olYxciWQjR2DN5vRFLVq+Lvw/QMPBxzHsNI9T9WP/U6wS+dr
         GVuZSSh0TCnbW0HJIyoBTyXSvnMoTIVN8JnB1CJhxt116+hZpqnPG3MMTLX76uPDyc
         iuJIKFU88Fmhcc5ztDxRBc6aAbXag64Csa6gIzweHH06Gi3R4aEI+mdwSjOMsoLIZo
         n1uReZIzGUHwg==
To:     =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>
Cc:     lorenzo.bianconi@redhat.com, kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>, nbd@nbd.name,
        brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <CABvG-CWkb80iVR=Q-q9a-n0x8Yy9NJAYjnTsOhfErpiOz2SDCw@mail.gmail.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <CABvG-CWkb80iVR=Q-q9a-n0x8Yy9NJAYjnTsOhfErpiOz2SDCw@mail.gmail.com>
Date:   Wed, 28 Nov 2018 15:19:21 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878t1duvx2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Micha=C5=82 Kazior <kazikcz@gmail.com> writes:

> On Wed, 28 Nov 2018 at 13:39, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:[...]
>> > This is an early stage implementation, at this point I would collect
>> > other people opinions/concerns about using bpf/xdp directly on 802.11
>> > frames.
>>
>> Thanks for looking into this!
>
> I'm really hyped up with this especially when I think this could be
> maybe offloaded to wlan cpu's for e.g. deep powersaving (allow host
> system to suspend) without relying on blackbox logic you get today, or
> 802.11 -> 802.3 conversion (to offload host cpu).

Yeah, good point!

>> I have two concerns with running XDP on 802.11 frames:
>>
>> 1. It makes it more difficult to add other XDP actions (such as
>>    REDIRECT), as the XDP program would then have to make sure that the
>>    outer packet headers are removed before, say, redirecting the packet
>>    out of an ethernet interface. Also, if we do add redirect, we would
>>    be bypassing mac80211 entirely; to what extent would that mess up
>>    internal state?
>>
>> 2. UI consistency; suddenly, the user needs to know which kind of
>>    frames to expect, and XDP program reuse becomes more difficult. This
>>    may be unavoidable given the nature of XDP, but some thought needs to
>>    go into this. Especially since we wouldn't necessarily be consistent
>>    between WiFi drivers (there are fullmac devices that remove 802.11
>>    headers before sending up the frame, right?).
>
> Yep - you can expect 802.3 frames or amsdu subframes (DA+SA+length)
> too. In some cases you could also expect internal events (broadcom if
> I understand their fullmac arch).

Oh boy. I figured it was going to be a can of worms; didn't realise it
was quite that big :/

-Toke
