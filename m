Return-Path: <SRS0=uvJa=WJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B1DC32750
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Aug 2019 13:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F1CC20844
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Aug 2019 13:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QrxepzLm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfHMNgp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Aug 2019 09:36:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35158 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbfHMNgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Aug 2019 09:36:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id d85so1135953pfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2019 06:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+IvNSSv0dZm7axcgPut/ZuBnpzRxpjWFBA2DB52xh9c=;
        b=QrxepzLmOBoZK0Vp3cJ2nU93pw3j3fVwLPP8sYLTjyx0IrRfZhfNrpYzbxSV6rTCll
         EmiUYGYTX/d16aMLmSc8zxA6nrlusrfk7a54k3X3x+0w5bKqsCAvGcutC+y5oY1vxqrC
         HB3wcWK9ul5YcGkECANGcKImB6LFLDHw+ivDJsmvT2lE/K6e4KJPGs+wEHMOnl/ab009
         3PmktF3ayV9N06px7vQqpGNxi6fgpDwjJ5x37k7Nn3ZP67mX2GuBdkk4QB7b37w4vSUL
         44PAQ/6IXK21Y77LShwQS5tFQQoUs9mVJXc1EFAJPROnHsBtgVSix1r9eu9T2+wwIVHY
         OeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+IvNSSv0dZm7axcgPut/ZuBnpzRxpjWFBA2DB52xh9c=;
        b=iUIj5h52YcDA8cRZZ8KLl11T3gCknY4yTxYcly45rQKr3360c9B9MA5mrWRHzOUUB7
         J5Cc3c4pM4eniZw/Lv5Vujyo8Cqpp52AQDxKlurmvCfmzGQzpCfKIj6020ioDe47QjHS
         6JfFICeUP1UuhWvCQMQvjVbBbnPJE0v/W+uqxUdqx8YXDUOWSq39r59tgwhs53p85IYw
         zONJfqT2y4OA12dCE4XtwjjxDpNGdG3jgJ9X+hNz6amoy6mpXNVFx57MvkvQ4vSyLR/5
         1Zq4zXZkzXP49Gtedg/QVJygVzu+5lC5+y6RjO4tNS1oSXngdifC/sNJYIGb5lf2Q1hE
         i61Q==
X-Gm-Message-State: APjAAAX5Cuz4u+BGWu4ET3h+9/4vqvRsofpMs7lBHmZeMQU0AgDexSZR
        p70FpmCPYpsEJfunHgGQNlbrTSoZ7lZ6fRXH7glWJg==
X-Google-Smtp-Source: APXvYqwzus8Mtw0RHdzJEsBAud/s5NcacwuOmBPpD3609fcLHhegjTsTUDGvYfNxqz6BY5e0KvIMty/JsLsr6xzPyEE=
X-Received: by 2002:a17:90a:c20f:: with SMTP id e15mr2243028pjt.123.1565703404043;
 Tue, 13 Aug 2019 06:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000927a7b0586561537@google.com> <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
 <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
 <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 13 Aug 2019 15:36:33 +0200
Message-ID: <CAAeHK+z8MBNikw_x50Crf8ZhOhcF=uvPHakvBx44K77xHRUNfg@mail.gmail.com>
Subject: Re: [EXT] INFO: trying to register non-static key in del_timer_sync (2)
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jun 12, 2019 at 6:03 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> Hi Dmitry,
>
> We have a patch to fix this: https://patchwork.kernel.org/patch/10990275/

Hi Ganapathi,

Has this patch been accepted anywhere? This bug is still open on syzbot.

Thanks!
