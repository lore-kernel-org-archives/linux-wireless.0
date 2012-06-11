Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39235 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2FKRjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 13:39:05 -0400
Date: Mon, 11 Jun 2012 23:10:20 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k: defer btcoex scheme update
Message-ID: <20120611174018.GA2655@vmraj-lnx.users.atheros.com> (sfid-20120611_193910_375656_5DFD946E)
References: <1339418354-1843-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20437.61328.931380.948942@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20437.61328.931380.948942@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2012 at 06:46:00PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > As btcoex scheme updation might sleep, remove the function call
> > from tasklet context and queue it up as a separate work.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -188,6 +188,9 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
> >  
> >  	ath9k_debug_samp_bb_mac(sc);
> >  	ath9k_hw_disable_interrupts(ah);
> > +#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
> > +	cancel_work_sync(&sc->mci_work);
> > +#endif
> 
> I think this should go inside __ath_cancel_work(), otherwise there is a
> chance that this would not be cleaned up properly when stopping the
> interface or unloading the driver.
>
mci_work is queued up by the ath9k_tasklet that is triggered by interrupt
routine. So it is safer to cancel the mci_work after disabling interrupt.
Does it make sense?

--
Rajkumar
