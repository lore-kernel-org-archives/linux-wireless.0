Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78665C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 20:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C89F20848
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 20:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C89F20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbeLCUBI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 15:01:08 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:40511 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbeLCUBI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 15:01:08 -0500
Received: by mail-it1-f195.google.com with SMTP id h193so10571458ita.5
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2018 12:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6+K7PiOiOlB2I1kNVKTBJu37TBdtqVGpkOy9TVfFmSU=;
        b=ESiXPLiOEiXp1fxuasGv0XvQXDvyFas+YuOdUi9YiHWuBVwa6Qe74jJ6/yo06M/fU0
         hT3oO9SifMOXZD3N89JGoTM+Xb708fv4N2hb80VF7IuxVAxqzTpbvLtOEvw54rkLdh4R
         auoZrKIr6D397HkirUjWw8SiV/dNRahz4kM2/mwJsNMQ2UOhSTf48irDyxAwuYYoWT1l
         FhuK1Gs4+p+uIDMrGLSgRvcEHymqsZuFGKHnR7aE1EY/UtADQzagrCPf78RQ8vZS3az3
         sDX9kcifMwDW5738CKkNdXWQ5nE+B18n6kC/dbxyTEZ+VduzTAB+I/2leZ5OOCsAsuPT
         LiRA==
X-Gm-Message-State: AA+aEWbJCV9yMyF8/2raPIvTZi2oVXwMe2CeU+5n0ZfwdsORPrrH1DNU
        G7N3mmSefZUrfXLNG3ye4YXIfhG38Sq/45SitnQolCnO
X-Google-Smtp-Source: AFSGD/UpkG057wKjwp4R3QN7iVE4qC05ijogex9K70c1jL2BIW2aSP1sx01joQ1f1floS5ABFlOofyIWApaf728rJIg=
X-Received: by 2002:a24:c187:: with SMTP id e129mr10235277itg.68.1543867265667;
 Mon, 03 Dec 2018 12:01:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain>
 <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain>
 <87zhtttg8p.fsf@toke.dk> <20181128153508.GG2298@localhost.localdomain>
 <87in0gu78s.fsf@toke.dk> <20181129125929.GB6365@localhost.localdomain>
 <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com>
 <87k1kwq9bo.fsf@toke.dk> <bb855ffd6043743ef10058c9395d0c6b42a7832a.camel@sipsolutions.net>
 <87bm62jtbu.fsf@toke.dk> <4e2d8543c6e4e48d6b6a9f4fde5c811dd4d71243.camel@sipsolutions.net>
In-Reply-To: <4e2d8543c6e4e48d6b6a9f4fde5c811dd4d71243.camel@sipsolutions.net>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Mon, 3 Dec 2018 21:00:54 +0100
Message-ID: <CAJ0CqmXnNNZUX1C0Zu0unof_5MxEVVtyO=k3vXGAVB04nMdm9A@mail.gmail.com>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        kazikcz@gmail.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Mon, 2018-12-03 at 21:36 +0200, Toke Høiland-Jørgensen wrote:
> > Hi Johannes
> >
> > I think your email can be basically summed up to:
> >
> > > [ ... ] but really I think it's a can of worms.
> >
> > ...right? :)
>
> Heh, yeah :)
>
> > I sort of had a feeling it would be, but thank you for spelling out in
> > excruciating detail why that is so.
>
> :-)
>
> > Given this, I think I agree that it's not worth it for now, and we
> > should hold off on adding XDP support until we have 802.3/.11 conversion
> > offload working... Which I think is also where you ended up? :)
>
> That case is at least easy, yeah. And it seems kinda likely that we'll
> end up with that in all well-maintained drivers in the relatively near
> future anyway?

Hi all,

thanks for sharing your thoughts and concerns, as already stated the
main goal of this series
is get feedbacks and/or blocking points to start experimenting with
eBPF over 802.11 devices.
Reviewing the points indicated by Johannes, 802.11 protocol is too
complicated to be managed without skb
allocation. I agree that for the moment XDP/eBPF can be useful for
devices that supports hw offloading
(or FullMac devices?) since all the tricky aspects are already managed
in the firmware and we can take care of XDP stuff.
Probably in the near future we will respin this argument :)

>
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
>

+1 :)

Regards,
Lorenzo

> johannes
>
