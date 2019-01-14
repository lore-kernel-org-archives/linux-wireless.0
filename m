Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC19CC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDBC120660
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:22:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+qQ5yJY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfANJWL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:22:11 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:34701 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfANJWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:22:11 -0500
Received: by mail-ot1-f48.google.com with SMTP id t5so18727273otk.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 01:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=nBR8Fu8ep9QCMxiyh2N90JK6Cp/W6U1+a3Z0c+WE1IM=;
        b=V+qQ5yJYv6AV/xY7hw0PskvDh+aPf4VucG59lV2s8LegIBJZtemyNaRCIDqRqlPk5A
         cKFN3CWnd31jfs0H1Puj78B7nOXN6NHcuPiHMGHFcWsR7WnoHekm+uIlN/XPjdtoEOZG
         oWS/NT+9j4V/r6hzW5qMkLcuCvgQFamfs3+8B3peeBWy/vTQ7wydPbrZzjdD9Rme4PjA
         5Q9eUUVgwH17Zmbo2RpaMtReBiPXo8PiLqf3oJO37G4ifgMYF10yfTm8jUKpGoGzSc+e
         GvKU/8SO8vngHLS4mDlaqyIkr/rAt+AVqhn5Otahkifd5oCnU2epXViPkYDSzGxhvgsS
         wvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=nBR8Fu8ep9QCMxiyh2N90JK6Cp/W6U1+a3Z0c+WE1IM=;
        b=kCmfdMjrxzTQb7O9ZJHun/erEgHB9kpE9u+GDN5Jxlp/k9QAxWxEy8+V6T4T4N8FNK
         sxUzMAAc8unFL0aAJjfN4n+XZfk7oqy6A2KnXJpPGmLn8EHmplWOPBX6xNqMW4X8skNY
         HLUj6FnqpDpcJ0/QjiN3zfIYvHM7S0wZe4a9tJHRtLBxU2M5z7HiLcPyMCcwsHZVaRog
         FdqpFyvuWBgWvsL7wpTsdrXc9QzvX1mzHnDTBxw4DvKOTgFSnIRNyChxL0aPGXm46H4P
         QeDZpShNcfAm55xg/j+RejyImqwIAL+nRA1kvHQ46S8QZ/IQ1monFnjHQ8AjWIj8gW+6
         XasA==
X-Gm-Message-State: AJcUukfFlVTioQtLDxaqg61Xo01cK1WDF0nZ99AOZwT0xvkxmjAkjt3U
        IQ2yqAxwTv3Qdd3J8NJD1ZKUs1k4DH2tNGNugXY=
X-Google-Smtp-Source: ALg8bN5Lm3KRroyuShQQ3QyQwJNmCLcW/oWQjZ58TqNGHJrRkSp04k1kHrLxIkOyzNiF+RQHjCG/QHTPNNn9oxIIqGI=
X-Received: by 2002:a9d:172e:: with SMTP id i46mr15631048ota.322.1547457730208;
 Mon, 14 Jan 2019 01:22:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Mon, 14 Jan 2019 01:22:09
 -0800 (PST)
In-Reply-To: <20190114091841.GA23045@localhost.localdomain>
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com> <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com> <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com> <20190114091841.GA23045@localhost.localdomain>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Mon, 14 Jan 2019 10:22:09 +0100
Message-ID: <CAKR_QV+L083Lsjh4M_9+KuPBVgPKaivpmb7P5uFcGAV3fMrwvQ@mail.gmail.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 14/01/2019, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>> On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
>> <lorenzo.bianconi@redhat.com> wrote:
>> >
>> > >
>> > >
>> > > On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi
>> > > <lorenzo.bianconi@redhat.com> wrote:
>> > >
>> > > Direct. No VM used. This is the only peripheral causing this issue.
>> > >
>> > > Is the device connected to a usb3.0 port? If so, could you please try
>> > > to connect the dongle to a 2.0 one?
>> > >
>> > > I tried through a USB 2.0 port. Shouldn't make a difference as they
>> > > both use the xhci driver.
>> > >
>> >
>> > mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)
>> Tried a USB 3 port. Same result.
>> >
>> > > Could you please double check if IOMMU is enabled?
>> > >
>> >
>> > Have you tried to disable it? Does it make any difference?
>> No idea how. UEFI doesn't seem to show anything similar.
>>
>> Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241
>
> You should be able to disable iommu using GRUB_CMDLINE_LINUX in
> /etc/default/grub (I guess setting iommu=off and reinstalling grub)
> https://wiki.gentoo.org/wiki/IOMMU_SWIOTLB
>
> Regards,
> Lorenzo
>

updating grub, not reinstalling
