Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB78C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 12:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43E5520660
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 12:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NpcTlK8T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43E5520660
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbeK1Xyz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 18:54:55 -0500
Received: from mail-qk1-f179.google.com ([209.85.222.179]:40711 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbeK1Xyy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 18:54:54 -0500
Received: by mail-qk1-f179.google.com with SMTP id y16so16663573qki.7
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 04:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MGdA9mkmob3pD8iIiA7QGpIvR1hFzL3xLBrxuGzccp0=;
        b=NpcTlK8TWgsLDvO/IGOu6ImoeLJ4hhhJoRE+DNouLqczFxygmkkEyMWCb+t45HVDEP
         ZwP0euApwvgusLRaIVpFhCS8Lcoovt9H3/ZVb6vD7hgryNtyE+mpSmt30wQdnUcImv8e
         l3d0lNQFcccAD4Bqs8VHI6LOTErXIGbjbdBt22tSqfxvzcUvBf9KV1fCSjfOcpCXcTeD
         1fR7WXU9K0huXsud0amq+cTibtXf+qHQWQXVgYpA3dvgVSBvtYwYfhz59aumr8KPE3L+
         8CN9LAPI2go4KGYsIjh0JX9I83PGw5TFoUefLv8+jD7mH6+DHGl5zoFxHp+z9cPZqU5J
         f6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MGdA9mkmob3pD8iIiA7QGpIvR1hFzL3xLBrxuGzccp0=;
        b=Gp02ea8cfAoeKI7LRdk6VggTn5r8QiUx5S68lud6FifnzdFDJ5CBYa92h4XOiRFzNw
         RG7luYfwf5eisBkeJU49FclkeT5ITipjQowp4H2iXnH7VoFOJkSFjZQH2CCqtVLuOcKS
         0qxddXIYXZoVaHXzCil5tHIcDCyo0SSPVxuqkiubYESIrOzCemLxjSoOazzZwNXHNTGL
         n2Ez7n+A7vvpFzFeyJNpZF3NhDGjbv7aLtxGc7u5hlLO1k7tZKo/bpJ+Nus+9JDZSuRJ
         3utDdlXiqdgct6xKd5vf5N1dmEgp/ixLs512zt1aZfAaCo5O1sIJ3b5+fD9yogRHh51s
         aJkQ==
X-Gm-Message-State: AA+aEWYfkcrAbwPqiY4MmaQstt6V5PRkulsPAQaak0NYL4unDPJuTDKq
        IGR6Isy6efHmC03rQxZ83xCV4jtHriAf38o+2r4=
X-Google-Smtp-Source: AFSGD/XFW5YAAQVLoobbwAO/v1A8Le+zDmsmOVWV8wLzc4zWYuG6/ZbSqhg4VUHc3v74sKQh0B16QEwG8ruxVAq9Dws=
X-Received: by 2002:a37:1745:: with SMTP id i66mr33403450qkh.125.1543409599968;
 Wed, 28 Nov 2018 04:53:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk>
In-Reply-To: <87bm69v0ol.fsf@toke.dk>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Wed, 28 Nov 2018 13:53:08 +0100
Message-ID: <CABvG-CWkb80iVR=Q-q9a-n0x8Yy9NJAYjnTsOhfErpiOz2SDCw@mail.gmail.com>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     lorenzo.bianconi@redhat.com, kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>, nbd@nbd.name,
        brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 28 Nov 2018 at 13:39, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.d=
k> wrote:[...]
> > This is an early stage implementation, at this point I would collect
> > other people opinions/concerns about using bpf/xdp directly on 802.11
> > frames.
>
> Thanks for looking into this!

I'm really hyped up with this especially when I think this could be
maybe offloaded to wlan cpu's for e.g. deep powersaving (allow host
system to suspend) without relying on blackbox logic you get today, or
802.11 -> 802.3 conversion (to offload host cpu).


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

Yep - you can expect 802.3 frames or amsdu subframes (DA+SA+length)
too. In some cases you could also expect internal events (broadcom if
I understand their fullmac arch).


Micha=C5=82
