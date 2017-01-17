Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:60229 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdAQC3h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 21:29:37 -0500
Date: Tue, 17 Jan 2017 02:56:53 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 09/14] rt2x00: rt2x00pci: set PCI MWI only if supported
Message-ID: <20170117015653.GF1912@makrotopia.org> (sfid-20170117_032941_260780_3E0B2927)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116030613.GA32249@makrotopia.org>
 <20170116100856.GB6968@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116100856.GB6968@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 11:08:57AM +0100, Stanislaw Gruszka wrote:
> On Mon, Jan 16, 2017 at 04:06:25AM +0100, Daniel Golle wrote:
> > From: Claudio Mignanti <c.mignanti@gmail.com>
> > 
> > This is needed for devices without support for PCI MWI. See also
> > https://dev.openwrt.org/changeset/21850
> > 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2x00pci.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
> > index eb6dbcd4fddf..4becfeb75ba8 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
> > @@ -94,8 +94,10 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
> >  
> >  	pci_set_master(pci_dev);
> >  
> > +#ifdef CONFIG_PCI_SET_MWI
> >  	if (pci_set_mwi(pci_dev))
> >  		rt2x00_probe_err("MWI not available\n");
> > +#endif
> 
> There is no CONFIG_PCI_SET_MWI in the kernel. This patch is either not
> needed (pci subsystem has own PCI_DISABLE_MWI define) or wrong (we
> should not call this function for some devices).

Apparently we thus never enabled MWI on PCI devices. John Crispin has
started to investigate why this patch was needed in first place, see
http://lists.infradead.org/pipermail/lede-dev/2017-January/005400.html

I suggest to drop it entirely until we figure out why it wasn't safe to
use MWI at least on some platforms. Once we know more there might be
a follow-up to selectively have the precompiler skip pci_set_mwi in
case we really still need to do this.
Aparently this was originally related to a compiler error on Kernel
2.6.30 when trying to build for Rt305x WiSoC platforms (which simply
do not have any PCI bus and probably explicite support for SoC devices
wasn't implemented in rt2x00 at the time).


Cheers


Daniel

> 
> Stanislaw
