Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:45569 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728362AbeGTQZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 12:25:31 -0400
Message-ID: <1532100994.8953.305.camel@mtkswgap22> (sfid-20180720_173648_747953_72734D46)
Subject: Re: [PATCH v2 00/12] Add mt76x0 driver
From: Sean Wang <sean.wang@mediatek.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "Michal Schmidt" <mschmidt@redhat.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>
Date: Fri, 20 Jul 2018 23:36:34 +0800
In-Reply-To: <20180711080721.GA3871@localhost.localdomain>
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
         <1531205430.26214.8.camel@mtkswgap22> <20180710095222.GA18926@redhat.com>
         <1531230864.26214.20.camel@mtkswgap22>
         <20180711080721.GA3871@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-11 at 10:07 +0200, Lorenzo Bianconi wrote:
> > On Tue, 2018-07-10 at 11:52 +0200, Stanislaw Gruszka wrote:
> > > On Tue, Jul 10, 2018 at 02:50:30PM +0800, Sean Wang wrote:
> > > > > For full support mt7610.bin firmware blob is need, hopefully with 
> > > > > the permission of Mediatek, the blob will be pushed into linux-firmware
> > > > > git tree.
> > > > > 
> > > > 
> > > > Hi, Stanislaw
> > > > 
> > > > You can feel free to add mt7610.bin firmware blob to linux-firmware with
> > > > the license LICENCE.mediatek I added in [1].
> > > > 
> > > > 
> > > > [1]
> > > > http://lists.infradead.org/pipermail/linux-mediatek/2018-June/013759.html
> > > 
> > > Thank you Sean!
> > > 
> > > I guess there is no problem with similar submission for
> > > mt7662u.bin and mt7662u_rom_patch.bin needed for mt76x2u:
> > > https://marc.info/?l=linux-wireless&m=153045438821562&w=2
> > > 
> > 
> 
> Thanks Sean,
> 
> I will submit mt7662u.bin and mt7662u_rom_patch.bin with LICENCE.mediatek
> soon
> 
> > Sure, there is no any problem for submitting mt7662u.bin and
> > mt7662u_rom_patch.bin if they are added with LICENCE.mediatek.
> > 
> > Do you or Lorenzo have a plan to add MT7668u support to mt76?
> > MT7668 is a newer wifi device than MT7610u or MT7662u.
> > 
> 
> Cool, I am interested in adding MT7668u support to mt76 driver.
> Is the adapter available on the market?

I'm not sure if it can be got from the market easily.

I would like to say, mt7668 is based on new MTK wifi architecture. as
for mt7662/mt7612/mt7610, they all belong to legacy Ralink based design.
of course, we will never see any new chip based on Ralink based design
wifi in the future.

There must be really lots of differences exist between two types of
devices, such as MCU firmware download, MCU control interface, tx/rx
path, even hardware register layout all changed and so on.

I guess the hardware abstraction layer needs to be largely adjusted to
add the new device mt7668u into mt76 driver. And even I think it would
be easier for development and maintenance if we make a separate driver
and then pick up some pure software components from mt76 to reuse.

Maybe it's the time I want to test your tree first with 7612u (?) or
mt7610u (?) , what is suggested? and see how big the gap between this
two type of devices and last write some code based on your tree to test
mt7668u

	Sean

> Regards,
> Lorenzo
> 
> > > Regards
> > > Stanislaw
> > > 
> > > _______________________________________________
> > > Linux-mediatek mailing list
> > > Linux-mediatek@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/linux-mediatek
> > 
> > 
