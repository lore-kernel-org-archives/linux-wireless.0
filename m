Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34095 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbeGGInE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jul 2018 04:43:04 -0400
Received: by mail-wm0-f66.google.com with SMTP id s13-v6so6064643wmc.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2018 01:43:04 -0700 (PDT)
Date: Sat, 7 Jul 2018 10:38:27 +0200 (CEST)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 00/11] Add mt76x0 driver
In-Reply-To: <20180705153216.GE17524@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1807071027140.11361@T420s> (sfid-20180707_104311_535366_08DA898B)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com> <20180705153216.GE17524@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi 

On Thu, 5 Jul 2018, Lorenzo Bianconi wrote:

> On Jul 05, Stanislaw Gruszka wrote:
> > Add mt76x0 driver for MT7610U based USB dongles. Currently driver
> > support only STA mode.
> 
> Hi Stanislaw,
> 
> > 
> > mt76x0 is based on Jakub's mt7601u driver already included
> > in the kernel. I would like the driver be integrated as part
> > of mt76 (instead of separate driver in mediatek dir like mt7601u)
> > to utilize mt76 code for adding support for MT76x0 PCIe devices
> > in further development.
> > 
> > To do not collide with current mt76x2u work from Lorenzo, I did not
> > remove some code duplication. This will be done in the future, when
> > Lorenzo patches will be merged. I plan to do more close integration
> > with mt76x2u into common mt76 layer and add support for MT76x0 PCIe
> > devices (i.e. MT7630E). Any help with this work is obviously welcome.
> > My integration efforts can be traced here:
> > https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft
> > 
> 
> I just had a brief review of the code and I compiled the driver since at
> the moment I had no adapter for that chipset.
> As a remainder for future improvements/integration most of the code in 
> dma.c, usb.c (except probe/disconnect functions) and tx.c can use the related
> routines in the mt76-usb layer (we need to fill function pointer for chipset
> related stuff if there are differences with mt76x2u, not looked yet).
> Moreover mcu code can use utility routines in usb-mcu.c
> I have not looked at mt76x2 common code yet.
> 
> Regards,
> Lorenzo
> 

It is also possible to reuse 
struct mt76x2_txwi
struct mt76x2_rxwi

They have the same memory layout for both mt76x0u and mt76x2u chipsets.

Lorenzo can you move them up to
mt76.h
and rename them to
struct mt76_txwi
struct mt76_rxwi

And we can also do this for
struct mt76x2_vif

Greetings
Hans Ulli
