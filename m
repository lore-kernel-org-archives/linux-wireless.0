Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:45984 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbeICHDb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 03:03:31 -0400
Received: by mail-io0-f196.google.com with SMTP id e12-v6so14751268iok.12
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2018 19:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com> <20180901074757.GB3719@redhat.com>
In-Reply-To: <20180901074757.GB3719@redhat.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Mon, 3 Sep 2018 02:45:16 +0000
Message-ID: <CAM0KTbD9E1jq23d17DiPxzRD21tPVCs96BOBr=UUyZ64r+ddfQ@mail.gmail.com> (sfid-20180903_044536_945252_FF2B7FCC)
Subject: Re: [PATCH v2 00/17] mt76 patches 2018-08-24 v2
To: sgruszka@redhat.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YES.  That fixed the issue for me.  Confirmed across 4 affected
devices and 1 unaffected device (mt76x2u driver).  After this patch
the issue is resolved.  Thanks for working with me.

I haven't completed all my testing, but the only other thing I've
noticed so far is that firmware version isn't available in ethtool,
while the majority of devices it is.  If you can please squeeze that
in before 4.19 drops it would be great to help with tracking and
debugging when needed.

Thanks,
Zero
On Sat, Sep 1, 2018 at 7:48 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Wed, Aug 29, 2018 at 02:26:44AM +0000, Sid Hayn wrote:
> > dhcpcd_prestartinterface: t2uh: No space left on device
> > t2uh: waiting for carrier
> >
> > the same happens with just ifconfig up:
> >
> > SIOCSIFFLAGS: No space left on device
>
> I think I found bug that could result in this. Please test
> below patch:
>
> https://github.com/sgruszka/wireless-drivers-next/commit/be446879afd6b0e315691e379a2aa4412f05884e.patch
>
> Thanks
> Stanislaw
