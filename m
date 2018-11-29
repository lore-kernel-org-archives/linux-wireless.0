Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A22C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB57220863
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="lyKT7wAU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB57220863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbeK3A6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:58:44 -0500
Received: from mail.toke.dk ([52.28.52.200]:60295 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbeK3A6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:58:44 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543499596; bh=2GMwa70bjkVmfgsLJvB/gjbAvyIPTrx1uTQbJ/OOsuk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lyKT7wAUEqFFmQuh4FBX87S+xGHoocCAq2AhZovZ/elFxGc/U0uGbyGXx2M95cS/M
         vjMHtgKj/nRr969vVqIlXjBxODUKT+Pcgf30T2T6sGqjrI9/rKi6Rt6xBVV+XYidqU
         CKXxSH07XRcqopE6j8FHQ8hfZcZ4dee/tEUV7mEGW0snPMotHp9zUbKmme1AgyL7E6
         yf/owikX0LebsMNRuOh+bJ8Ha+n2pBrdh+Ce1k5E8i9lKRztsO1bMZ/biYBnHjhfUe
         yRMkzvuce2zdyIP7QIxcFZCgofHwqTMXl1TT0xMItHrRk7vBZ2+FIq/4iTB02j7GFN
         U1m89YV6wXQQQ==
To:     =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        lorenzo.bianconi@redhat.com
Cc:     kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain> <87zhtttg8p.fsf@toke.dk> <20181128153508.GG2298@localhost.localdomain> <87in0gu78s.fsf@toke.dk> <20181129125929.GB6365@localhost.localdomain> <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com>
Date:   Thu, 29 Nov 2018 14:53:15 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k1kwq9bo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Micha=C5=82 Kazior <kazikcz@gmail.com> writes:

> On Thu, 29 Nov 2018 at 14:00, Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> [...]
>> > The other direction will probably be more difficult, at least if 802.11
>> > frames need to be built in software. It *might* be possible with the X=
DP
>> > egress hook we are planning (with a suitable set of helpers, the eBPF
>> > program could build the 802.11 frames), but I'm not really sure if that
>> > is worth doing as I'm quite sure there are some hairy edge cases
>> > there...
>>
>> The possible issue with XDP_DROP action you are referring to here is A-M=
PDU
>> reordering on rx side, right? If so I guess the issue will be fixed by
>> tid_agg_rx->reorder_timer. Are you referring to other possible edge case=
s?
>
> What I'm thinking is reordering could be one of possible things to
> offload to an XDP program. It would require per-station data structure
> to keep track of the frame sequence numbers (among other things). Same
> could be said for crypto offloads (would require XDP programs to be
> able to use crypto apis I guess?).

In principle, all of this could be done. But we need to think carefully
about what things it really makes sense to offload to XDP. In the
general case, we will end up re-implementing all of mac80211 in eBPF,
which is obviously not ideal. However, fast-path handling in XDP, which
will punt to the full stack on edge cases, is probably doable (and is
the general model we envision for XDP programs).

For crypto in particular, I wonder if there is much of a speedup to be
had if the crypto is in software anyway. Wouldn't that dominate the
processing time? Whereas, if the crypto is offloaded to hardware,
fast-path packet processing in XDP might make sense. This would
translate to the fallback mode I mention above: If hardware crypto is
enabled, handle in XDP fast-path, otherwise punt to mac80211 for full
(crypto) processing.

-Toke
