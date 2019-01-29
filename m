Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46032C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 15:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10794214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 15:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d1+4KLSu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfA2P4D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 10:56:03 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38421 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfA2P4C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 10:56:02 -0500
Received: by mail-io1-f67.google.com with SMTP id l14so16680173ioj.5;
        Tue, 29 Jan 2019 07:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9eurXkD5s+OkcyanSX7bHj5PaKC8jsiubC3aA8IyLGc=;
        b=d1+4KLSue5PX75mclr3nf2vOng+Qt1w964NQaIte3maR3ADUjzRDMzbt5m3rOGu66B
         HRrNZP4uXBzFpDD+tBqmTJZZfJe1QjYQCvjVcOEHMxM0lvt9pQB/klhW8JGmSj+1P5oU
         gzJ/5biheUNtjYFRC/acOqLQzYiNo7wma5hbCROBslPA8BOAyrmNNaC60nmYaleMrBvx
         lIL5+eH3LWP563AKNIED8IYPuC8e7XxJF39VDPzaejRNDcHnxPUU+wiXpvjouQKeNrib
         equmcckph3d7/N98ZGy8lrIC6m4D8irGVm1KHdhk0bbM+1bsy90TCeo+GMF/WYU6KqAw
         cpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9eurXkD5s+OkcyanSX7bHj5PaKC8jsiubC3aA8IyLGc=;
        b=iHUfVe6TBLRNHGEso8k566KKCpcdM3vYhErbmH9TQeom9CI/H+Z8vcreeyxqddsVA0
         SL6RXeLs4u7NoaW3ABwElnlAVsR/u5boqxuVEMdGoXvY8Gjsk5DwPqqvkwc6S1fUssG9
         jId+NA1kmeDdGL4ywfrr+4+7sYo4ppVx7f4zHqH4WfECp/fR2I4ZqxEDyta2r/bNvaKW
         hkeFnfcalEK9ufY6iv3W7Qn2FcQeT8YITjRJoXWtPcJmyuIacC+5cJ0T2RoSOj2bMaXJ
         lohLILg0GUykjXEgFCYw/4pZNIYgW1ujDOmXi8e/D01HiZdkoVzYlDRqrOent9mtGYJE
         Oj4w==
X-Gm-Message-State: AHQUAubCuMmPY09CIyEJ4964sB51rNwEctXbf3u8GTYNqQGfvQxbpIP8
        I5vZekvFSqZigZSVBFnljMItfFVeOoaGYwxZfds=
X-Google-Smtp-Source: AHgI3IbM3hgoMe/vZFa6mvF8Wd/hix5WottMDMSiQViLtuL0A77Fx8Xcy7oX8z+4wX/5X/5wOwMI+EPiUK7S7tpNs4k=
X-Received: by 2002:a6b:b6c6:: with SMTP id g189mr687701iof.54.1548777361488;
 Tue, 29 Jan 2019 07:56:01 -0800 (PST)
MIME-Version: 1.0
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbBz4hLWuN5oAGJV9rXEGuHP1UDPsL2fYaKJA6pRJG1MDA@mail.gmail.com> <20190129094334.GC20645@kroah.com>
In-Reply-To: <20190129094334.GC20645@kroah.com>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Tue, 29 Jan 2019 10:55:55 -0500
Message-ID: <CAM0KTbBhQ+NMS814A3dWC2P6ttn78pwTCMeQ2LOhhPdbMAcecA@mail.gmail.com>
Subject: Re: [PATCH 4.20.x 0/7] mt76x0 fixes for 4.20 stable
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thanks for the responses, I know how hard you all work.  From my
perspective I cannot tell the difference between missed and just in
queue.

Is there a patchwork page for patches targeting stable, or is the
process there too complex for patchwork?  Right now I only see the
mailing list and the stable queue git tree and no other idea on how to
see status.

Thanks again for your hard work, truly didn't mean to suggest otherwise.

-Zero


On Tue, Jan 29, 2019 at 4:43 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jan 28, 2019 at 11:06:41AM -0500, Sid Hayn wrote:
> > On Tue, Jan 22, 2019 at 7:41 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > >
> > > There ware several bugs introduced in 4.20 development cycle
> > > for mt76x0 driver, that were fixed later but missed 4.20
> > > release. This patche set fixes issues for MT7610U and
> > > MT7630E.
> > >
> > > Bug reference:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=202243
> > >
> > > Lorenzo Bianconi (1):
> > >   mt76x0: phy: unify calibration between mt76x0u and mt76x0e
> > >
> > > Stanislaw Gruszka (6):
> > >   mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
> > >   mt76x0: use band parameter for LC calibration
> > >   mt76x02: run calibration after scanning
> > >   mt76x02: assure we update gain after scan
> > >   mt76x0: do not perform MCU calibration for MT7630
> > >   mt76x0: antenna select corrections
> > >
> > >  drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
> > >  drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   9 +-
> > >  drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   5 +
> > >  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 170 +++++++--------------
> > >  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   1 +
> > >  drivers/net/wireless/mediatek/mt76/mt76x02.h       |   1 +
> > >  .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |  10 +-
> > >  drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |   1 +
> > >  .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   3 +
> > >  9 files changed, 76 insertions(+), 125 deletions(-)
> > >
> > > --
> > > 1.9.3
> > >
> >
> > Please forgive if I'm mistaken, but I haven't seen this hit the stable
> > queue or see any response at all.  Did this get missed or just hasn't
> > been reached yet?
>
> Not reached yet, please give us a chance :)
>
> Backports that have to be "applied by hand" like this are at the bottom
> of the pile...
>
> greg k-h
