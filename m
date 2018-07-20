Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727167AbeGTLSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 07:18:11 -0400
Date: Fri, 20 Jul 2018 12:30:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 00/11] Add mt76x0 driver
Message-ID: <20180720103032.GA1791@redhat.com> (sfid-20180720_123038_570050_9BFCA6F7)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
 <20180705153216.GE17524@localhost.localdomain>
 <alpine.LNX.2.00.1807071027140.11361@T420s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.00.1807071027140.11361@T420s>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 07, 2018 at 10:38:27AM +0200, Hans Ulli Kroll wrote:
> > > My integration efforts can be traced here:
> > > https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft
> > > 
> > 
> > I just had a brief review of the code and I compiled the driver since at
> > the moment I had no adapter for that chipset.
> > As a remainder for future improvements/integration most of the code in 
> > dma.c, usb.c (except probe/disconnect functions) and tx.c can use the related
> > routines in the mt76-usb layer (we need to fill function pointer for chipset
> > related stuff if there are differences with mt76x2u, not looked yet).
> > Moreover mcu code can use utility routines in usb-mcu.c
> > I have not looked at mt76x2 common code yet.
> > 
> > Regards,
> > Lorenzo
> > 
> 
> It is also possible to reuse 
> struct mt76x2_txwi
> struct mt76x2_rxwi
> 
> They have the same memory layout for both mt76x0u and mt76x2u chipsets.
> 
> Lorenzo can you move them up to
> mt76.h
> and rename them to
> struct mt76_txwi
> struct mt76_rxwi
> 
> And we can also do this for
> struct mt76x2_vif

For the record. I unified bunch of mac80211 callbacks and mac/wcid functions
and structures (including structures pointed above) into new mt76xx_lib
module. I also rebased the changes on top of latest wireless-drivers-next
master and mt76x2u patches in new branch mt76x0-draft-v2:
https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v2

Regards
Stanislaw
