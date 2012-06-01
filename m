Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:44308 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965935Ab2FAW41 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 18:56:27 -0400
Message-ID: <1338591384.19112.12.camel@joe2Laptop> (sfid-20120602_005630_464249_08C7B645)
Subject: Re: [PATCH] bcma: fix null pointer in bcma_core_pci_irq_ctl
From: Joe Perches <joe@perches.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>, linville@tuxdriver.com,
	zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Date: Fri, 01 Jun 2012 15:56:24 -0700
In-Reply-To: <4FC9271C.5030608@hauke-m.de>
References: <1338496770-16381-1-git-send-email-hauke@hauke-m.de>
	 <4FC8796E.4060800@broadcom.com> <4FC9271C.5030608@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-01 at 22:33 +0200, Hauke Mehrtens wrote:
> On 06/01/2012 10:12 AM, Arend van Spriel wrote:
> > On 05/31/2012 10:39 PM, Hauke Mehrtens wrote:
> >> pc could be null if hosttype != BCMA_HOSTTYPE_PCI.
> >> If we are on a device without a pci core this function is called with
> >> pc = null by b43 and brcmsmac. If the host type is PCI we have a pci
> >> core as well and pc can not be null.
> >>
> >> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> >> ---
> >>  drivers/bcma/driver_pci.c |    4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
> >> index 9a96f14..884b7af 100644
> >> --- a/drivers/bcma/driver_pci.c
> >> +++ b/drivers/bcma/driver_pci.c
> >> @@ -232,7 +232,7 @@ void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc)
> >>  int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
> >>  			  bool enable)
> >>  {
> >> -	struct pci_dev *pdev = pc->core->bus->host_pci;
> >> +	struct pci_dev *pdev;
> >>  	u32 coremask, tmp;
> >>  	int err = 0;
> >>  
> >> @@ -243,6 +243,8 @@ int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
> > Could you change the if statement as well:
> >   - if (core->bus->hosttype != BCMA_HOSTTYPE_PCI) {
> >   + if (!pc || core->bus->hosttype != BCMA_HOSTTYPE_PCI)
> 
> Yes that's good I will change that, just to be save.
> 
> >>		/* This bcma device is not on a PCI host-bus. So the IRQs are
> >>		 * not routed through the PCI core.
> >>		 * So we must not enable routing through the PCI core. */
> >>		goto out;
> >   -  	}
> 
> Is removing the braces correct here? There is just one line of code so
> it will compile and the braces are not necessary, but I think it would
> looks somehow strange because there is a 3 line comment in addition to
> the one line of code in that if block.
> 
> @Joe Perches what do you think about this?

I try not to tell others what they must do, I just
try to suggest more standard ways to do things.

I think it's better to use braces when there's a
multiline comment after a test with a single statement.

	if (some_test()) {
		/* a multiline
		 * comment
		 */
		single_statement(action);
	}

But I would tend to move that sort of comment above the fold
and use something like:

	/* If the bcma device is not on a PCI host-bus,
	 * IRQs are not routed through the PCI core.
	 */
	if (!pc || core->bus->hosttype != BCMA_HOSTTYPE_PCI)
		goto out;

Feel free to do what you you think best.

cheers, Joe

