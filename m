Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25368 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0LUNgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 08:36:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 05:36:05 -0800
Date: Tue, 21 Dec 2010 19:06:13 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k_hw: Fix incorrect macversion and macrev checks
Message-ID: <20101221133613.GA2192@senthil-lnx.users.atheros.com>
References: <1292866656-2253-1-git-send-email-senthilkumar@atheros.com>
 <4D0F9E4C.7090208@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D0F9E4C.7090208@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 11:49:56PM +0530, Felix Fietkau wrote:
> On 2010-12-20 6:37 PM, Senthil Balasubramanian wrote:
> > There are few places where we are checking for macversion and revsions
> > before RTC is powered ON. However we are reading the macversion and
> > revisions only after RTC is powered ON and so both macversion and
> > revisions are actully zero and this leads to incorrect srev checks.
> > 
> > fix this by reading the macversion and revisisons even before we start
> > using them. There is no reason why should we delay reading this info
> > until RTC is powered on as this is just a register information.
> > 
> > Cc: Stable Kernel <stable@kernel.org>
> > Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> > index ddda76f..c9b7f1e 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
> > @@ -1078,13 +1078,13 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
> >  		return false;
> >  	}
> >  
> > -	ath9k_hw_read_revisions(ah);
> > -
> >  	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
> >  }
> >  
> >  static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
> >  {
> > +	ath9k_hw_read_revisions(ah);
> > +
> >  	if (AR_SREV_9300_20_OR_LATER(ah)) {
> >  		REG_WRITE(ah, AR_WA, ah->WARegVal);
> >  		udelay(10);
> Why re-read the revision on every reset?
yes.. not required on every reset and we can read it in __ath9k_hw_init itself
right before ath9k_hw_set_reset_reg().

I just overlooked the reset part for WARM/COLD which is mostly the case except
for ar9280 with olc and just wanted to retain how it was before for POWER_ON.

will send v2 thanks.

> 
> - Felix
