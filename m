Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47670C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 20:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 187DC206B7
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 20:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fs+pfVHL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfANUGZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 15:06:25 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:36228 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfANUGZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 15:06:25 -0500
Received: by mail-oi1-f180.google.com with SMTP id x23so275362oix.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 12:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hlbIZMfo5DeaZXSLUOwywE2pmYYF/mV5cWFuUA8bfIg=;
        b=Fs+pfVHLkDhcw2eaiC73xDLclV4jl5Eb5nNldxpZ0qxLHISZLdZE6/8iPf7YJqA2+6
         6+UJHtVbFpSRgu2qEkKc7BmuQW7iokP2IBUqKmhyjd98/X4UeG1mnoqKz0+mUuB/VlAh
         ul8qysFwQ388CMkPm6qq5+kXGT+zQ0NrRNj+PC6Ki61sLl92c34BELU36euQcbWIlEfU
         OKXRLbtgtyDNqAEoFZSav9thg8Bm6fjN5WbU69Xc9zYFAmfJG1sR1r+JsmOp3L5+3XvU
         T3C4u5icuSwfdVSjl1It16TPBXK2q8zJxAQ5fEIYMJi5uawiVQwUYWXvYUhTr8coKmdY
         C5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hlbIZMfo5DeaZXSLUOwywE2pmYYF/mV5cWFuUA8bfIg=;
        b=Qn7RIgEE3iQxlO9kZIWo2PuVxT5zb7U8gv9NnnzBolnmrajFUzc1UzQ64FiUBKvXkr
         POmQk5as0AIXXJBn87OdWCDVnsZQ3xVg51QL+XHZ/CxJ/fo8qnJLPUwOI8o14PobgoRl
         T0Hi+tGljcOVLlC/UgsUdGXx07uWpEsIoRYRfFPfvVLpom3mt2oT0RVmtr/PCOy7dC2a
         YSV4wUdL7zerxs+7dFBZPhcavW8RsNF/bdYmOjDk1311eInwDmW9RFc/on4GLxA2gHxr
         6othUaBY8u4ooQmc7qSToFMW1MYjbXf3rLbFPgL7s9jBj4lz4bg7lztuMo4ulWV+hx08
         Nriw==
X-Gm-Message-State: AJcUukczzEC6fQABzW6asYNMOP4zPhIjJsmwJA8C96dN2some9Z9ByXi
        Q/LJf8KY3LdJ7NhdYx7xIoBfMQO7kPqYh1wAU6arsQeO
X-Google-Smtp-Source: ALg8bN5sIABzrIut2hngIgdeHcrZmC26BLfb3ATl+C2mhf6mCU2VccPlWbpzOSxAiioPoqF0HP3Wl1Qco634laX5o7Y=
X-Received: by 2002:aca:c4d8:: with SMTP id u207mr99691oif.30.1547496383721;
 Mon, 14 Jan 2019 12:06:23 -0800 (PST)
MIME-Version: 1.0
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com> <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com> <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com> <20190114091841.GA23045@localhost.localdomain>
In-Reply-To: <20190114091841.GA23045@localhost.localdomain>
From:   Rosen Penev <rosenp@gmail.com>
Date:   Mon, 14 Jan 2019 12:06:12 -0800
Message-ID: <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 14, 2019 at 1:18 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
> > <lorenzo.bianconi@redhat.com> wrote:
> > >
> > > >
> > > >
> > > > On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > > >
> > > > Direct. No VM used. This is the only peripheral causing this issue.
> > > >
> > > > Is the device connected to a usb3.0 port? If so, could you please try to connect the dongle to a 2.0 one?
> > > >
> > > > I tried through a USB 2.0 port. Shouldn't make a difference as they both use the xhci driver.
> > > >
> > >
> > > mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)
> > Tried a USB 3 port. Same result.
> > >
> > > > Could you please double check if IOMMU is enabled?
> > > >
> > >
> > > Have you tried to disable it? Does it make any difference?
> > No idea how. UEFI doesn't seem to show anything similar.
> >
> > Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241
>
> You should be able to disable iommu using GRUB_CMDLINE_LINUX in
> /etc/default/grub (I guess setting iommu=off and reinstalling grub)
> https://wiki.gentoo.org/wiki/IOMMU_SWIOTLB
Yep. Working great now. I wonder what mt76 is doing to cause the crash though...
>
> Regards,
> Lorenzo
