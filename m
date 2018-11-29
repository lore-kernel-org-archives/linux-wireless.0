Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63636C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2548520868
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:45:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U9bYrle3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2548520868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbeK3AvG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:51:06 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40479 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbeK3AvG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:51:06 -0500
Received: by mail-qk1-f194.google.com with SMTP id y16so1049700qki.7
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 05:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aJx1hECWRCKg5FmEY9NJ85dpOveH2C6n5uS7BUhclzk=;
        b=U9bYrle3WCO3ZKYMKZcyhBFXhzDNfat8plAofB4upWyvrR21GIKSWeIl1u/TeuP191
         whth5CLoSu3C1lBlLTJ9ktddu2e98K9/fs2TazCTmQIfp3f8xCMyFwWOQ5LOmGoDvK4U
         iFScU48+/BFpdI1fdcHOhsLYlkqOKFxsAmM4KlbtKbpBWM6R0iYJYCsQ63yKPm5UFYXl
         5eQVBwOxQYx8hHeCeSX1A9QUTAqPrPuCz9rGJDApVohG6ag935niONFNBAOPcCDndteZ
         o5j/mVra7nle6GHRkgYq3yO7OSt51oMyQIdZAs0Eg6l3sx7nXZ574hy2udV3TD2jTCKp
         z91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aJx1hECWRCKg5FmEY9NJ85dpOveH2C6n5uS7BUhclzk=;
        b=N3QiEvzU6VUCxGLguY5APA2r/nDMl2R6TrR16dwHK1qLYeBgsMFrOWUmRtvuP7RvOz
         u9gMo45iGU86Bo8Ae3vZgT675/S/KrV8yORFwOHC8VpWjystORaZ5m1peffRGGoS+riX
         Vt4YS5Hcykhu/4QQ4zYa/o91QiEkO6krekhBequqFTbBug7PwL7dYV1qDih7HIUA31hr
         ysdFJZ6T/0MH6YJccDoBpw4hWwTfhViQI9tDP8jRFNKfm+XBqVib1Cu0nk6ROK4mqXOg
         0Zojv5wD6jjR2//ZuZVr7gDcWMSxLQ6iJjSykXEDMsLr6YzFhLpvYK7z4O5HbEDKHoTQ
         Idmw==
X-Gm-Message-State: AA+aEWbRDRCvr4dZHJR8OJzQPGpHvZ5JIDtN/tFIgREIbuEzpcUfKpM7
        YEx/36Au0rZIFix3muqvL+1VIREDzC8HhTrhzloGtrjU
X-Google-Smtp-Source: AFSGD/UM3O1UlahJJxDX2RDldRqvWFJFm6JAH5wX0IntLjxkINeGRRVavPJc1unY4ec6ALzj81KLSvDGpdq5SQU7CEY=
X-Received: by 2002:a37:c653:: with SMTP id b80mr1380362qkj.245.1543499140741;
 Thu, 29 Nov 2018 05:45:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain>
 <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain>
 <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain>
 <87zhtttg8p.fsf@toke.dk> <20181128153508.GG2298@localhost.localdomain>
 <87in0gu78s.fsf@toke.dk> <20181129125929.GB6365@localhost.localdomain>
In-Reply-To: <20181129125929.GB6365@localhost.localdomain>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Thu, 29 Nov 2018 14:45:28 +0100
Message-ID: <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
To:     lorenzo.bianconi@redhat.com
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 29 Nov 2018 at 14:00, Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
[...]
> > The other direction will probably be more difficult, at least if 802.11
> > frames need to be built in software. It *might* be possible with the XD=
P
> > egress hook we are planning (with a suitable set of helpers, the eBPF
> > program could build the 802.11 frames), but I'm not really sure if that
> > is worth doing as I'm quite sure there are some hairy edge cases
> > there...
>
> The possible issue with XDP_DROP action you are referring to here is A-MP=
DU
> reordering on rx side, right? If so I guess the issue will be fixed by
> tid_agg_rx->reorder_timer. Are you referring to other possible edge cases=
?

What I'm thinking is reordering could be one of possible things to
offload to an XDP program. It would require per-station data structure
to keep track of the frame sequence numbers (among other things). Same
could be said for crypto offloads (would require XDP programs to be
able to use crypto apis I guess?).


Micha=C5=82
