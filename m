Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40135 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab1DLOAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 10:00:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 07:00:27 -0700
Date: Tue, 12 Apr 2011 19:30:36 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/22] ath9k_hw: Introduce a bool for 25mhz clock and
	populate it
Message-ID: <20110412140035.GA15609@vasanth-laptop>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com> <4DA458A8.5030205@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4DA458A8.5030205@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 07:20:32PM +0530, Felix Fietkau wrote:
> On 2011-04-12 3:17 PM, Vasanthakumar Thiagarajan wrote:
> > pll configuration will differ for 25mhz clock.
> >
> > Signed-off-by: Vasanthakumar Thiagarajan<vasanth@atheros.com>
> > ---
> >   drivers/net/wireless/ath/ath9k/hw.c |   11 +++++++++++
> >   drivers/net/wireless/ath/ath9k/hw.h |    2 ++
> >   2 files changed, 13 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> > index d98b4c6..8b90b9c 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
> > @@ -481,6 +481,9 @@ static void ath9k_hw_attach_ops(struct ath_hw *ah)
> >   /* Called for all hardware families */
> >   static int __ath9k_hw_init(struct ath_hw *ah)
> >   {
> > +#define AR9340_SOC_SEL_25M_40M 0xB80600B0
> > +#define AR9340_REF_CLK_40 (1<<  4) /* 0 - 25MHz   1 - 40 MHz */
> > +
> >   	struct ath_common *common = ath9k_hw_common(ah);
> >   	int r = 0;
> >
> > @@ -508,6 +511,14 @@ static int __ath9k_hw_init(struct ath_hw *ah)
> >
> >   	ath9k_hw_attach_ops(ah);
> >
> > +	if (AR_SREV_9340(ah)) {
> > +		if (*((volatile u32 *) AR9340_SOC_SEL_25M_40M)&
> > +		    AR9340_REF_CLK_40)
> > +			ah->is_clk_25mhz = false;
> > +		else
> > +			ah->is_clk_25mhz = true;
> > +	}
> > +
> >   	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
> >   		ath_err(common, "Couldn't wakeup chip\n");
> >   		return -EIO;
> I think this flag should be passed down from the arch code through 
> platform data instead. Also, dereferencing volatile u32 pointers for 
> reading registers is somewhat hackish, readl or ioread32 would be better.

Yeah, I was also not comfortable with this part of code. I'll fix
that. thanks for the comments.

Vasanth
