Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53403 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab0LBFGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 00:06:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 21:06:02 -0800
Date: Thu, 2 Dec 2010 10:35:49 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 10/26] ath9k: Configure pll control for AR9485
Message-ID: <20101202050549.GI12908@vasanth-laptop>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com> <1291188775-13707-11-git-send-email-vasanth@atheros.com> <4CF67A3C.4060105@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CF67A3C.4060105@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 01, 2010 at 10:09:24PM +0530, Felix Fietkau wrote:
> On 2010-12-01 8:32 AM, Vasanthakumar Thiagarajan wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   16 ++++++++++------
> >  drivers/net/wireless/ath/ath9k/hw.c         |    7 ++++++-
> >  drivers/net/wireless/ath/ath9k/reg.h        |    2 ++
> >  3 files changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > index b34a9e9..4e35bda 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > @@ -390,14 +390,18 @@ static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
> >  {
> >  	u32 pll;
> >  
> > -	pll = SM(0x5, AR_RTC_9300_PLL_REFDIV);
> > +	if (AR_SREV_9485(ah))
> > +		pll = 0x142c;
> > +	else {
> > +		pll = SM(0x5, AR_RTC_9300_PLL_REFDIV);
> >  
> > -	if (chan && IS_CHAN_HALF_RATE(chan))
> > -		pll |= SM(0x1, AR_RTC_9300_PLL_CLKSEL);
> > -	else if (chan && IS_CHAN_QUARTER_RATE(chan))
> > -		pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
> > +		if (chan && IS_CHAN_HALF_RATE(chan))
> > +			pll |= SM(0x1, AR_RTC_9300_PLL_CLKSEL);
> > +		else if (chan && IS_CHAN_QUARTER_RATE(chan))
> > +			pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
> >  
> > -	pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
> > +		pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
> > +	}
> >  
> >  	return pll;
> >  }
> NACK for this part. Take a look at what gets set for the older chips:
> 
> 0x5 << AR_RTC_9300_PLL_REFDIV_S == 0x1400
> 0x2c << AR_RTC_9300_PLL_DIV_S == 0x002c

True, but older ar9003 chips have half/quarter rate support (which is not
implemented right now), in that case pll configuration would differ
for AR9485.

Vasanth
