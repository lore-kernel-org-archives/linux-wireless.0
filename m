Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:51053 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388083AbeGWKQv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 06:16:51 -0400
Received: by mail-it0-f66.google.com with SMTP id w16-v6so456095ita.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2018 02:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
 <1531205430.26214.8.camel@mtkswgap22> <20180710095222.GA18926@redhat.com>
 <1531230864.26214.20.camel@mtkswgap22> <20180711080721.GA3871@localhost.localdomain>
 <1532100994.8953.305.camel@mtkswgap22>
In-Reply-To: <1532100994.8953.305.camel@mtkswgap22>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 23 Jul 2018 11:16:25 +0200
Message-ID: <CAJ0CqmXmQMBfz7GUe31LYrqD=ZF1bWGSdvD0DMgA7cTC=eyQpQ@mail.gmail.com> (sfid-20180723_111640_184789_A9F591F0)
Subject: Re: [PATCH v2 00/12] Add mt76x0 driver
To: Sean Wang <sean.wang@mediatek.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> On Wed, 2018-07-11 at 10:07 +0200, Lorenzo Bianconi wrote:
> > > On Tue, 2018-07-10 at 11:52 +0200, Stanislaw Gruszka wrote:
> > > > On Tue, Jul 10, 2018 at 02:50:30PM +0800, Sean Wang wrote:
> > > > > > For full support mt7610.bin firmware blob is need, hopefully with
> > > > > > the permission of Mediatek, the blob will be pushed into linux-firmware
> > > > > > git tree.
> > > > > >
> > > > >
> > > > > Hi, Stanislaw
> > > > >
> > > > > You can feel free to add mt7610.bin firmware blob to linux-firmware with
> > > > > the license LICENCE.mediatek I added in [1].
> > > > >
> > > > >
> > > > > [1]
> > > > > http://lists.infradead.org/pipermail/linux-mediatek/2018-June/013759.html
> > > >
> > > > Thank you Sean!
> > > >
> > > > I guess there is no problem with similar submission for
> > > > mt7662u.bin and mt7662u_rom_patch.bin needed for mt76x2u:
> > > > https://marc.info/?l=linux-wireless&m=153045438821562&w=2
> > > >
> > >
> >
> > Thanks Sean,
> >
> > I will submit mt7662u.bin and mt7662u_rom_patch.bin with LICENCE.mediatek
> > soon
> >
> > > Sure, there is no any problem for submitting mt7662u.bin and
> > > mt7662u_rom_patch.bin if they are added with LICENCE.mediatek.
> > >
> > > Do you or Lorenzo have a plan to add MT7668u support to mt76?
> > > MT7668 is a newer wifi device than MT7610u or MT7662u.
> > >
> >
> > Cool, I am interested in adding MT7668u support to mt76 driver.
> > Is the adapter available on the market?
>
> I'm not sure if it can be got from the market easily.
>
> I would like to say, mt7668 is based on new MTK wifi architecture. as
> for mt7662/mt7612/mt7610, they all belong to legacy Ralink based design.
> of course, we will never see any new chip based on Ralink based design
> wifi in the future.
>
> There must be really lots of differences exist between two types of
> devices, such as MCU firmware download, MCU control interface, tx/rx
> path, even hardware register layout all changed and so on.
>
> I guess the hardware abstraction layer needs to be largely adjusted to
> add the new device mt7668u into mt76 driver. And even I think it would
> be easier for development and maintenance if we make a separate driver
> and then pick up some pure software components from mt76 to reuse.
>

the mt76 driver has a hw independent layer (mt76/mt76-usb modules) that
implements data path (tx/rx side), mac80211 integration and calls hw dependent
code for hw initialization (that approach allows to support mt76x2 and mt7603
chipsets in the same driver).
I guess it will be feasible (at least in theory) to integrate mt7668
support in the
mt76 driver (but I can't be more precise since I have no any reference code or
hw to test)

> Maybe it's the time I want to test your tree first with 7612u (?) or
> mt7610u (?) , what is suggested? and see how big the gap between this
> two type of devices and last write some code based on your tree to test
> mt7668u

mt76x2u and mt76x0 are not merged yet, but I would suggest to start looking
at mt76x2u since it is already integrated in the mt76 driver while
mt76x0 is a standalone
driver for the moment.

@Stanislaw what do you think?

Regards,
Lorenzo

>
>         Sean
>
> > Regards,
> > Lorenzo
> >
> > > > Regards
> > > > Stanislaw
> > > >
> > > > _______________________________________________
> > > > Linux-mediatek mailing list
> > > > Linux-mediatek@lists.infradead.org
> > > > http://lists.infradead.org/mailman/listinfo/linux-mediatek
> > >
> > >
>
>
