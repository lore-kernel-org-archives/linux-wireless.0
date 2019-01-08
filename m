Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570D5C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 11:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23A81206B7
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 11:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ci9ftEKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfAHLEl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:04:41 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46697 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfAHLEl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 06:04:41 -0500
Received: by mail-ot1-f68.google.com with SMTP id w25so3085180otm.13
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 03:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=W50w5Z7nid7KjRgkVsziv2sLyZZHIQxcvomWN14ltlI=;
        b=Ci9ftEKdADd51G1HyPfLfb4g+Mjo9JeGgmE05JCMd46TrJ/Umc8F/PIrVYtEQhAn9M
         ba8ajj/BgQZnhJo90ZfVkwcnEzeAfea66cCnaz8YufS4NRLKJfkiuWve6FeKqLu9pKyP
         v8rgQD+IttZ1pzXGmLoKSbvCuUMtMirpCqnJOsUJIuUhGpjuQCksuFWnLwj/zsblirpK
         70DflXOYzOOLFgExh2LEpjUyEY1YpeEtyusfffwkEcfmgjXcpShq4cFI6JNST1QnOBt0
         RKsVy+JBPt6udb3HeRPRDgwMdPQvwwxaeV8dbMCTG70HoZ2mubg25GK/XHeNEqE7+Hcr
         Q2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=W50w5Z7nid7KjRgkVsziv2sLyZZHIQxcvomWN14ltlI=;
        b=ML5TvIWUIlJkTfw0/Br4cAEYiE4m8WLQ3PkjAgtIHdHAGKe0n6Mn/rbSJTMK9CSSOQ
         DfQnv9wX6wJ9t0edsrxVXoExTs8d91jrePHvWndfRYNM8aabzwjpXIH60/9obj0AEtrZ
         QodRoU32SvbEf+CfKCfMXZ8PsO3qpT7o8rH2nl5daPgcXAl6MNUAoMWEANkF7BvhrdNe
         yej5dVvRi5f22sIenCbmS8TSPfX79G6ZQf4XvaBpdFubheadr79K4dJaDvsGtW3pyr/5
         i+ku2fUcIcG/flq0EnIqo0Jk7IkjNSr7WPjZx/ABRG/GgIMtMP9dUHZfFtnsy1rp0kmY
         3JXg==
X-Gm-Message-State: AJcUuke5eYHHJEpU9CmQ31RxsGCTOiogA+7LaQt/4ucbjMUG2kyD5qzu
        Qp1M23uDOxSO0tUgmtvRQjEmPXxpjbgqR6XHm21le8ss
X-Google-Smtp-Source: ALg8bN6I5SYQ0wt1LgJ72sbmQ7axvVw62oD51ysTok1HPSn/PGbysvqEm6oBDP5OtI418jRr2HxFzkfDLNOR0RqScyo=
X-Received: by 2002:a9d:620f:: with SMTP id g15mr842233otj.296.1546945480178;
 Tue, 08 Jan 2019 03:04:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Tue, 8 Jan 2019 03:04:39 -0800 (PST)
In-Reply-To: <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com> <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com> <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 8 Jan 2019 12:04:39 +0100
Message-ID: <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
To:     Jeroen Roovers <jer@airfi.aero>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 08/01/2019, Jeroen Roovers <jer@airfi.aero> wrote:
>      Hi Stanislaw,
>
>
> On Mon, 7 Jan 2019 at 16:09, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Mon, Jan 07, 2019 at 01:47:19PM +0100, Jeroen Roovers wrote:
>> > Maybe I am wrong about this, but then again I have neither ever seen
>> > the driver respond to an ENOENT like this when an RT5592
>> > "disappeared".
>
> By "neither ever seen" I mean I have never seen rt2x00usb respond
> properly like that because no -ENOENT was ever seen. I have many
> system logs collected over the years showing the exact error that the
> code was trying to catch and still does try to catch: with USB debug
> messages enabled, I tend to see
>
> usb: kworker.* timed out on ep.*
>
> followed by rt2x00 specific warnings about the queues filling up:
> rt2800usb_txdone: Warning - Data pending for entry N in queue N
> [may repeat a few times]
>
> followed by the fatal:
>
> rt2x00usb_vendor_request: Error - Vendor Request X failed for offset X
> with error -110
> [many of these, system is slowly locking up]
>
> So the only clue that I had was that perhaps rt2x00usb_vendor_request
> wasn't catching the correct return value.

Hi

error message vendor request failed - do you get it on a real hardware
or in virtualized environment?

noticed it only happens when running attached USB device in
virtualbox, even in such case I was able once to hit the right
combination of ubuntu, vbox and vbox extensions and could run the USB
wifi without lockups. so you might consider fixing this bug at
different level. oh, and I'd also pay attention to hardware connection
at the USB port, at least one of the devices I tested seems flaky when
plugged in (edup mini adapter/RT53xx)

regards, Tom
