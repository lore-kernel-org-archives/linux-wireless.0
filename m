Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:33907 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932884AbeFYM4D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 08:56:03 -0400
Received: by mail-pl0-f66.google.com with SMTP id g20-v6so6786408plq.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 05:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20180409141032.GA9247@redhat.com> <20180409142640.GA5680@localhost.localdomain>
 <20180409144819.GA9253@redhat.com> <20180625120816.GA2072@redhat.com>
In-Reply-To: <20180625120816.GA2072@redhat.com>
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Mon, 25 Jun 2018 14:55:51 +0200
Message-ID: <CAA2SeNJjHCrO5NyznK+EJt5K6SRVRr_FPZA2i53Z-FnqzkKz_g@mail.gmail.com> (sfid-20180625_145642_093320_AAD264BC)
Subject: Re: [ANN] mt76x0 usb driver
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, moorray3@wp.pl,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        mschmidt@redhat.com, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Hi all,

Hi Stanislaw,

>
> On Mon, Apr 09, 2018 at 04:48:19PM +0200, Stanislaw Gruszka wrote:
> > On Mon, Apr 09, 2018 at 04:26:42PM +0200, Lorenzo Bianconi wrote:
> > > > I would like to integrate the driver to kernel via mt76 driver, i.e.
> > > > add USB hooks and mt76x0 mac/phy code to mt76. This will open
> > > > possibility to develop support for mt76x2 USB devices as well as mt76x0
> > > > PCIe devices in mt76.
> > > >
> > >
> > > I have already started supporting mt76x2 USB devices in mt76 since register map
> > > is pretty similar to PCIe devices:
> > > https://github.com/LorenzoBianconi/wireless-drivers-next/tree/mt76x2u
> > > I added some usb utility routines so I think we can integrate mt76x0 in mt76 as
> > > well
> >
> > Great, I'll start to integrate mt76x0 on top of your tree.
>
> So I started to do integration here:
> https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft
>
> However since driver is self containging, I think better would be just
> submit the driver into mt76/mt76x0/ dir upstream and do code merging work as
> follow-up patches posted on the mailing list. Patches then could be reviewed
> on regular basic. This will provide support for new mt76x0 devices in kernel
> quicker. Conflicts with mt76x2u and not yet upstreamed mt7603 could be resolved
> on the fly.

I did a quick review of the code and it seems (please correct me if I
am wrong) there is
a lot of duplicated code with mt76/mt76x2u and mt7601u drivers (i.e:
mcu/eeprom/mac code
is quite the same of the ones used in mt76x2u). Moreover mt76/mt76x2u has been
refactored in order to expose usb and mt76x2_common modules where you
can use better
802.11 aggregation (using mac80211 per-sta queuing) and A-MSDU support (using
tx/rx usb scatter-gather). Moreover mt76x2u has been tested/used by
various users till now.
So since mt76x0 will be deeply modified I guess it would be better to
start integrating the driver with
mt76/mt76x2u before been merged upstream otherwise will end-up with a
lot of integration commits.
What do you think?

>
> Another issue is firmware submission, how it was done for mt7601u and mt76x2 ?
>

I guess the fw submission has to be approved by mtk before been pushed
to linux-firmware

> Thanks
> Stanislaw

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
