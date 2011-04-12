Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40618 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab1DLOd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 10:33:27 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 07:33:02 -0700
Date: Tue, 12 Apr 2011 20:03:06 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ralf@linux-mips.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 03/22] ath9k_hw: Introduce a bool for 25mhz clock and
	populate it
Message-ID: <20110412143305.GB15609@vasanth-laptop>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com> <4DA458A8.5030205@openwrt.org> <20110412140035.GA15609@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110412140035.GA15609@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 07:30:36PM +0530, Vasanth Thiagarajan wrote:
> > >   {
> > > +#define AR9340_SOC_SEL_25M_40M 0xB80600B0
> > > +#define AR9340_REF_CLK_40 (1<<  4) /* 0 - 25MHz   1 - 40 MHz */
> > > +
> > >   	struct ath_common *common = ath9k_hw_common(ah);
> > >   	int r = 0;
> > >
> > > @@ -508,6 +511,14 @@ static int __ath9k_hw_init(struct ath_hw *ah)
> > >
> > >   	ath9k_hw_attach_ops(ah);
> > >
> > > +	if (AR_SREV_9340(ah)) {
> > > +		if (*((volatile u32 *) AR9340_SOC_SEL_25M_40M)&
> > > +		    AR9340_REF_CLK_40)
> > > +			ah->is_clk_25mhz = false;
> > > +		else
> > > +			ah->is_clk_25mhz = true;
> > > +	}
> > > +
> > >   	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
> > >   		ath_err(common, "Couldn't wakeup chip\n");
> > >   		return -EIO;
> > I think this flag should be passed down from the arch code through 
> > platform data instead. Also, dereferencing volatile u32 pointers for 
> > reading registers is somewhat hackish, readl or ioread32 would be better.
> 
> Yeah, I was also not comfortable with this part of code. I'll fix
> that. thanks for the comments.

Linville, ralf,

The code change needs to be done in arch code also to fix this
cleanly. I'm not quite sure about the right way of submitting changes
in BSP and ath9k driver without possibly breaking the driver due to
the fact that the change in BSP may not be available along with
driver change soon in wireless-testing.

Vasanth
