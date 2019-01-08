Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A69C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 10:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 746F62087E
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 10:09:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airfi-aero.20150623.gappssmtp.com header.i=@airfi-aero.20150623.gappssmtp.com header.b="scWjcIU2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfAHKJW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 05:09:22 -0500
Received: from mail-it1-f172.google.com ([209.85.166.172]:33656 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfAHKJW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 05:09:22 -0500
Received: by mail-it1-f172.google.com with SMTP id m8so9611522itk.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 02:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airfi-aero.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aEZD6odh1geSv84IuYYxbbWVm05CJ0v01s1F7bRMOBo=;
        b=scWjcIU22syzqr8DENlQVTbuYAdcew6fIikEx8xfn8NNqYA2a6tYHONkotuUGeMCW9
         fc53ZnCks18jhNnyyr3JX7lSm7lQ/mZTs+6FIIwAUv3pF5j7mpJviK62OFSBOokGyz7q
         oXESNArgBT+CkliiI89pNuZn4t0Wvm5vSMQtH46eFyJH/VsvrcAm7f+sFnJmJGRhuL0u
         t9NywMzua3BSVlk4BDK0Q/MzTfKLKNZGxPPRBKgPAH1MaiehwEF85lWYxKW3YI1WDU1V
         igFsz9dWrjNKFIk9ScmfFLU5ylW7d9RGGio8NMUiMYPApiC47OiQ4uVJcMwZ/vdnExKy
         liMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aEZD6odh1geSv84IuYYxbbWVm05CJ0v01s1F7bRMOBo=;
        b=fgOGTEn0yJQIp/oVz1suZEvGD2XgxvbktObL8h8X7Qa4wrkkApmgOxLLToeX9x0wsO
         MeHVDkHQSpBOzAKkDi2FUqzdg+LgEafBbtyZg5L4B5CyVZNLNgrOnS+QD+vthqYQtxKl
         akkbu904C0JhdwqFFYgpoa5QkFtYXqAWhWq+VgIOxUbwLolq/wD7iTvIqfFGqgZ5AF6t
         mcJABgyu86XO+BvH8Cox+COv20WvCP74qdmw6BnC+spcUaqSDA19QW4YdjH4659rzZt8
         NG/qZYatQBYUnU3fgu9Iqm95RDyP7Z2qD041ZOMX9rhPtMDWWAZ+v8OBkOBC95FM/aB4
         dVnQ==
X-Gm-Message-State: AJcUukfTv0h50sAbPsvqWCmZn4LkmbBZpjSRfTU2pwrBt43zGWNFwT/s
        Gh1SJ3kmaCW8Vdd6Q6QTfG8IvK79zPui8cQPYPVYCA==
X-Google-Smtp-Source: ALg8bN5vvH8aJdRfbJI2+lVTkx1Gkz4bcJHKQdh2YhRGUvaxqdWRPEr2mBH9xTF+xE/VoHdQj1FXNDJxEV6hpKX9lYM=
X-Received: by 2002:a02:a906:: with SMTP id n6mr598237jam.123.1546942161574;
 Tue, 08 Jan 2019 02:09:21 -0800 (PST)
MIME-Version: 1.0
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com> <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com> <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
In-Reply-To: <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
From:   Jeroen Roovers <jer@airfi.aero>
Date:   Tue, 8 Jan 2019 11:09:10 +0100
Message-ID: <CANCHnQr=gkP9XMUmUFeNcHE8KPZuHyJpPrueRV3ExwAPDK1uXQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        =?UTF-8?Q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 8 Jan 2019 at 10:30, Jeroen Roovers <jer@airfi.aero> wrote:
> I tend to see
>
> usb: kworker.* timed out on ep.*
>
> followed by rt2x00 specific warnings about the queues filling up:

Sorry that should read "preceded by".

> rt2800usb_txdone: Warning - Data pending for entry N in queue N
> [may repeat a few times]


Kind regards,
     jer
