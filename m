Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50737 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759492AbcJYQa0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 12:30:26 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 5/5] mwifiex: wait for firmware dump completion in
 remove_card
Date: Tue, 25 Oct 2016 16:30:20 +0000
Message-ID: <254e0132255b4f7d94c04261afd1f510@SC-EXCH04.marvell.com> (sfid-20161025_183038_094293_F8F88912)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-5-git-send-email-akarwar@marvell.com>
 <20161024202332.GD968@localhost>
In-Reply-To: <20161024202332.GD968@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Tuesday, October 25, 2016 1:54 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> dmitry.torokhov@gmail.com; Xinming Hu
> Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in
> remove_card
> 
> On Mon, Oct 24, 2016 at 07:51:32PM +0530, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > This patch ensures to wait for firmware dump completion in
> > mwifiex_remove_card().
> >
> > For sdio interface, reset_trigger variable is used to identify if
> > mwifiex_sdio_remove() is called by sdio_work during reset or the call
> > is from sdio subsystem.
> >
> > This patch fixes a kernel crash observed during reboot when firmware
> > dump operation is in process.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c |  2 ++
> > drivers/net/wireless/marvell/mwifiex/sdio.c | 15 ++++++++++++++-
> >  2 files changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index 986bf07..4512e86 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -528,6 +528,8 @@ static void mwifiex_pcie_remove(struct pci_dev
> *pdev)
> >  	if (!adapter || !adapter->priv_num)
> >  		return;
> >
> > +	cancel_work_sync(&pcie_work);
> 
> Is there a good reason you have to cancel the work? What if you were
> just to finish it (i.e., flush_work())?

I assume if work is running, cancel_work_sync() will wait until completion. Otherwise it will cancel queued work. Firmware dump takes 20-30 seconds to complete. I think, it's ok to cancel it if work is just queued and not running yet. Reboot taking significant time due to our wait in remove handler may not be a good experience from end user point of view.

If you prefer flush_work(), I can use the same.

> 
> In any case, I think this is fine, so for the PCIe bits:
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> 
> > +
> >  	if (user_rmmod && !adapter->mfg_mode) {  #ifdef CONFIG_PM_SLEEP
> >  		if (adapter->is_suspended)
> > diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > index 4cad1c2..f974260 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > @@ -46,6 +46,15 @@
> >   */
> >  static u8 user_rmmod;
> >
> > +/* reset_trigger variable is used to identify if
> > +mwifiex_sdio_remove()
> > + * is called by sdio_work during reset or the call is from sdio
> subsystem.
> > + * We will cancel sdio_work only if the call is from sdio subsystem.
> > + */
> > +static u8 reset_triggered;
> > +
> > +static void mwifiex_sdio_work(struct work_struct *work); static
> > +DECLARE_WORK(sdio_work, mwifiex_sdio_work);
> > +
> >  static struct mwifiex_if_ops sdio_ops;  static unsigned long
> > iface_work_flags;
> >
> > @@ -289,6 +298,9 @@ mwifiex_sdio_remove(struct sdio_func *func)
> >  	if (!adapter || !adapter->priv_num)
> >  		return;
> >
> > +	if (!reset_triggered)
> > +		cancel_work_sync(&sdio_work);
> > +
> >  	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
> >
> >  	if (user_rmmod && !adapter->mfg_mode) { @@ -2290,7 +2302,9 @@
> static
> > void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
> >  	 * discovered and initializes them from scratch.
> >  	 */
> >
> > +	reset_triggered = 1;
> >  	mwifiex_sdio_remove(func);
> > +	reset_triggered = 0;
> 
> Boy that's ugly! Couldn't you just create something like
> __mwifiex_sdio_remove(), which does everything except the
> cancel_work_sync()? Then you'd do this for the .remove() callback:
> 
> 	cancel_work_sync(&sdio_work);
> 	__mwifiex_sdio_remove(func);
> 
> and for mwifiex_recreate_adapter() you'd just call
> __mwifiex_sdio_remove()? The static variable that simply serves as a
> (non-reentrant) function call parameter seems like a really poor
> alternative to this simple refactoring.

Thanks a lot for the suggestion.
I will use this approach in updated version.

Regards,
Amitkumar
