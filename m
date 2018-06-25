Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933639AbeFYMIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 08:08:21 -0400
Date: Mon, 25 Jun 2018 14:08:17 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
Cc: linux-wireless@vger.kernel.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
Message-ID: <20180625120816.GA2072@redhat.com> (sfid-20180625_140851_254117_CCB28D0A)
References: <20180409141032.GA9247@redhat.com>
 <20180409142640.GA5680@localhost.localdomain>
 <20180409144819.GA9253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180409144819.GA9253@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Mon, Apr 09, 2018 at 04:48:19PM +0200, Stanislaw Gruszka wrote:
> On Mon, Apr 09, 2018 at 04:26:42PM +0200, Lorenzo Bianconi wrote:
> > > I would like to integrate the driver to kernel via mt76 driver, i.e.
> > > add USB hooks and mt76x0 mac/phy code to mt76. This will open
> > > possibility to develop support for mt76x2 USB devices as well as mt76x0
> > > PCIe devices in mt76.
> > > 
> > 
> > I have already started supporting mt76x2 USB devices in mt76 since register map
> > is pretty similar to PCIe devices:
> > https://github.com/LorenzoBianconi/wireless-drivers-next/tree/mt76x2u
> > I added some usb utility routines so I think we can integrate mt76x0 in mt76 as
> > well
> 
> Great, I'll start to integrate mt76x0 on top of your tree.

So I started to do integration here:
https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft

However since driver is self containging, I think better would be just
submit the driver into mt76/mt76x0/ dir upstream and do code merging work as
follow-up patches posted on the mailing list. Patches then could be reviewed
on regular basic. This will provide support for new mt76x0 devices in kernel
quicker. Conflicts with mt76x2u and not yet upstreamed mt7603 could be resolved
on the fly.

Another issue is firmware submission, how it was done for mt7601u and mt76x2 ?

Thanks
Stanislaw
