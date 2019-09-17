Return-Path: <SRS0=ULv+=XM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDBFC4CEC9
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Sep 2019 19:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F3920640
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Sep 2019 19:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcAVhxGo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfIQTHp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Sep 2019 15:07:45 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:36155 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfIQTHp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Sep 2019 15:07:45 -0400
Received: by mail-qk1-f175.google.com with SMTP id y189so97589qkc.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2019 12:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1WdQr9GiiKoEfe6jyqA7QBt16q0K995/4QsraxdgYg=;
        b=mcAVhxGoNS4UU8LukWb010nRxnyydeKw+x8hD4+BK1HCsPOT/+/HWq6bPD2LNcJ30m
         6JAmb1IoL7mBUdfdLuKQq8O9Yi1z4MLW46U4aebK13Puijdm/nB8cNsXw5ZFh8QxtQP0
         wDqwSitvh7vWfQvjBqjPhtDN5f1nROwHRP2vASyt4reEs1/SJJYWnTXeW3TX6puZi4cz
         DFC8Q3PgGRuSDSGYMu6SHdUhwbOi4ZNr9/oBNGY0wOJ90OYxguOzqYcBzvl+sVmBXobY
         WiV3MFJxFT3SZIwC8yPNy9VEsGIoBS7aib91fThfGqcoI8fU05Vik0E50xBMkSXNXvT3
         xBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1WdQr9GiiKoEfe6jyqA7QBt16q0K995/4QsraxdgYg=;
        b=kCSCVT8zof3FhreQXMyIsjI0MboWkf3sSeUIXRL/G3+a6w78bOuLYQA7RvUOuJ5Deb
         Tv1sik5P3Bbm4XGP2RaHSmiCFKmiAMON/g4WYXCkNKOBE1HR6ScKWWsNWDoTurufsVMb
         N8x+9da84pVNazVSjIriLmizBE87x1polSu/VIoBhnpILaqIkCgoLt0rmM1t2ctkcV0W
         TuRpGdrtfsdLdC/kDVOvmbkvWknLDjCz9VoqB2QzfcXrH18DLQ2GeSAyokve1cH0FxFI
         ROemxJJncVQ+SqfS0AKGPmZChXnWRClJ87/pl/c6AfOiCV1PAUyhqbfBBkmfo66RSLas
         8/Ug==
X-Gm-Message-State: APjAAAVE2W4Nu+LebomjTjM9D5QlVD/qs36RG3mHytM4mux/5CbmNjyk
        /2OOLyqIfBuNT6k9o36OieUuhRETQ1dBYQhGTts=
X-Google-Smtp-Source: APXvYqy4/dwYfwXsxcUreqsRxb8j3WS72Kg2s0PHRQ/4edOpm78GWBMyP8qNOCgeXG1dTFYnCuN04rh/r0zKozjBNmY=
X-Received: by 2002:a37:a9d1:: with SMTP id s200mr5554800qke.251.1568747264582;
 Tue, 17 Sep 2019 12:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAKKzd-8jgQWTO2w589gMVJm3CaU-15wUER+fsqpYJJSeZL4RPg@mail.gmail.com>
In-Reply-To: <CAKKzd-8jgQWTO2w589gMVJm3CaU-15wUER+fsqpYJJSeZL4RPg@mail.gmail.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Tue, 17 Sep 2019 12:07:08 -0700
Message-ID: <CALLGbRKUZmZzBh9=YpJ+r_ts8aY+HXy159oviihSgqMEofOCRQ@mail.gmail.com>
Subject: Re: Linux wireless times out at Google Starbucks location
To:     David Ho <davidkwho@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Sep 17, 2019 at 11:53 AM David Ho <davidkwho@gmail.com> wrote:
>
> Hi there,
>
> I found this issue with my Ubuntu 18.04.3 LTS setup at a Starbucks
> location I regularly visit.  I have tracked down the problem and at
> this point, I think I will need the wireless subsystem folks' input
> before I can proceed.  Can you folks help me with this?  See my Reddit
> post below for details.
>
> https://www.reddit.com/r/Ubuntu/comments/d5l79f/linux_wireless_times_out_at_google_starbucks/
>

Hi David,

If you have an issue to report and want help with, please put the
details in your email instead of pointing to external posts. This way
it can be discussed here and you enable maintainers to help you. If
I'm not mistaken, there's a very clear process and location to get
help as mentioned on the wiki:
https://wireless.wiki.kernel.org/en/users/support

I will tell you I did go look and you don't have sufficient and useful
information for us to help you. We need to know the wifi chipset
you're using, the drivers involved, what network subsystems you're
using, the methodology of your connection, and the kernel logs
themselves would all be helpful.

Thanks for your cooperation.

- Steve
