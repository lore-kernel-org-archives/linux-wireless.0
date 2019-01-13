Return-Path: <SRS0=htfS=PV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8FEC43387
	for <linux-wireless@archiver.kernel.org>; Sun, 13 Jan 2019 20:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1535120675
	for <linux-wireless@archiver.kernel.org>; Sun, 13 Jan 2019 20:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfAMULP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 13 Jan 2019 15:11:15 -0500
Received: from mail-it1-f172.google.com ([209.85.166.172]:50769 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfAMULP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Jan 2019 15:11:15 -0500
Received: by mail-it1-f172.google.com with SMTP id z7so10267751iti.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2019 12:11:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4LLw0cMPFkTRcHjhYg3y5FqrvR4Yaqb6wxLYmC6X9+M=;
        b=rK4Dd0ziYckW2qofUuBrfpafCtVWpQhKR5RoEMe5FzrqTnl2Q8Y8y13T6UldrKNik1
         DZO/hgEaEOo+RXGyo32QPHDC6q5EHoq5NC21ZuQdszVFdfNrQMKFtn9oUrHgxZ1Vxzjy
         WpYAoehfe8RPBtYEUpHNIq8XREnvI9n4IUo93WQl5MDHi5wKvakKzYoUTEFxBt9WGgT9
         gkMtoSf9Dic5wzSx/Rm9VgOsVoCnkjpyctc8SnzoYlrZjUROd9vfJqWq/eMDAuVK4xyo
         WGsqlabk9HCFJgox+RVmggqaUoxHboPvCnXbmntLvayHq1j/ip779qKWbXxDG/SimZTw
         ha/w==
X-Gm-Message-State: AJcUukfOyTo8vdnHy5fWOcnvQBTti3BWIEgKZiCLBhyU5bSIv5qIJIp5
        c2PCc1cUpuDQuAwyuJsHJr5Qr/txtDd3L7hCc2E2dB6ZZpo=
X-Google-Smtp-Source: ALg8bN5Wrm/WXofv9jXWl7ZmHBWAKSayHRpM1ApP6v2KawEF/ls1YFnTCluee+AwCl/fy5KLFRgRIA+XosBBudYyM2k=
X-Received: by 2002:a24:c187:: with SMTP id e129mr7244168itg.68.1547406050009;
 Sun, 13 Jan 2019 11:00:50 -0800 (PST)
MIME-Version: 1.0
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com> <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
In-Reply-To: <1547404075.1582.0@smtp.gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 13 Jan 2019 20:00:38 +0100
Message-ID: <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
>
> On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>
> Direct. No VM used. This is the only peripheral causing this issue.
>
> Is the device connected to a usb3.0 port? If so, could you please try to connect the dongle to a 2.0 one?
>
> I tried through a USB 2.0 port. Shouldn't make a difference as they both use the xhci driver.
>

mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)

> Could you please double check if IOMMU is enabled?
>

Have you tried to disable it? Does it make any difference?

Regards,
Lorenzo

> It is.
>
> Note that this does not happen on kernel 4.15 (Ubuntu's kernel) as mt76 lacks support.
>
> Regards, Lorenzo
>
>
>
