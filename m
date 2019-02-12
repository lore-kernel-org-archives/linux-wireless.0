Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AAC3C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 14:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A72214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 14:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfBLOKG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:10:06 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:33375 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbfBLOKG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 09:10:06 -0500
Received: by mail-it1-f194.google.com with SMTP id q78so1897141itc.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 06:10:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oarYMZ07c7306qykYtDZA3RQkSWcTNfQx3uzFwbgkMg=;
        b=dwgMpVc7FC9GytlZAEI7Mr303w+GCTzeWcj4uoigYNCGSni7aNXNMrfOlCmhYAXKVw
         fV/F7aLbqT1T8DIo6pCr4PTVzLy3YU+YqVKrfM1XD+0ily2wWgZrXNaAlAjmiuR2HfhG
         1I4mR5c8updYVgiFiqCpp57sRH8LxNxNFDN7OdwSkklpTY5J0+drTwFM1j5ddJRIakA6
         rzJTmsgz1XBtoxB+EtkM98q8WdAdVDiIk9OQrqFYtNIQsY4msQMeGz9ssScf+84d+inC
         qfwdguM0fOojNVnc8PN9L+m1jIUgFEwODOoR7LQaB7WUV1iW9Bml09USPsAOXcgR30/N
         JTrQ==
X-Gm-Message-State: AHQUAuZGC8zf3/WZwXIT52Di9f/Cm6r6lXL6UD3BhLoavEwl4KYoJt6j
        Cb+z6foP6NZYN7ga9rqJokEmnUW/X9HlSuRRA4TBcA==
X-Google-Smtp-Source: AHgI3IYQE43TDR4nt7zOn5tJKOl9wyvMBlM17Bxp66pr676AI/OuIdLponI6x3iE9T9qHNwreuA/cytgbbNHYBAG/rM=
X-Received: by 2002:a24:7b48:: with SMTP id q69mr2065964itc.31.1549980604926;
 Tue, 12 Feb 2019 06:10:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1549977282.git.lorenzo@kernel.org> <20190212134550.GA12256@redhat.com>
 <20190212135100.GA15292@redhat.com>
In-Reply-To: <20190212135100.GA15292@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Tue, 12 Feb 2019 15:09:53 +0100
Message-ID: <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb controller
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> (repost with corrected Lorenzo email)
>
> On Tue, Feb 12, 2019 at 02:45:50PM +0100, Stanislaw Gruszka wrote:
> > On Tue, Feb 12, 2019 at 02:24:47PM +0100, LorenzoBianconilorenzo@kernel.org wrote:
> > > From: Lorenzo Bianconi <lorenzo@kernel.org>
> > >
> > > Use linear fragment and not a single usb scatter-gather buffer in mt76u
> > > {tx,rx} datapath if the usb controller has sg data length constraints.
> > > Moreover add disable_usb_sg module parameter in order to explicitly
> > > disable scatter-gather. SG I/O is not supported by all host drivers and
> > > some users have reported sg issues on AMD IOMMU.
> >
> > Again. This is not right approach. SG issues should be fixed
> > not workarounded.

Hi Stanislaw,

here we do not use SG, so num_sg is 0 and we use transfer_buffer. I do
not see how I am working around the issue.
Moreover with this approach we avoid some unnecessary operation in the hotpath

Regards,
Lorenzo

> >
> > > This series has been tested on AMD IOMMU cpus/motherboards and on rpi3+
> >
> > > - rebased on top of 'fix multiple issues in mt76u error path'
> > >   https://patchwork.kernel.org/cover/10804919/
> > >
> > > Lorenzo Bianconi (4):
> > >   mt76: usb: move mt76u_check_sg in usb.c
> > >   mt76: usb: do not use sg buffers for mcu messages
> > >   mt76: usb: use a linear buffer for tx/rx datapath if sg is not
> > >     supported
> > >   mt76: usb: introduce disable_usb_sg parameter
> > >
> > >  drivers/net/wireless/mediatek/mt76/mt76.h     |  14 +-
> > >  .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +-
> > >  .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |   3 +-
> > >  .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   2 +-
> > >  drivers/net/wireless/mediatek/mt76/usb.c      | 133 +++++++++++++-----
> > >  drivers/net/wireless/mediatek/mt76/usb_mcu.c  |   5 +-
> > >  6 files changed, 105 insertions(+), 54 deletions(-)
> >
> > I really think my approach is simpler. Diffstat from my proposed patch is:
> >
> >   drivers/net/wireless/mediatek/mt76/mt76.h |  1 +
> >   drivers/net/wireless/mediatek/mt76/usb.c  | 55 ++++++++++++++---------
> >   2 files changed, 36 insertions(+), 20 deletions(-)
> >
> > Also this fix bug(s), presumably regression for mt76x0, should be
> > backported.
> >
> > Stanislaw
> >
