Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26523 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1DTEfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 00:35:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 21:35:16 -0700
Date: Wed, 20 Apr 2011 10:05:22 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 04/22] ath9k_hw: Configure pll control register
	accordingly for AR9340
Message-ID: <20110420043522.GF21802@vasanth-laptop>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com> <1303221560-25139-5-git-send-email-vasanth@atheros.com> <19885.39048.530052.347984@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19885.39048.530052.347984@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 07:43:28PM +0530, Sujith wrote:
> Vasanthakumar Thiagarajan wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/hw.c  |   52 ++++++++++++++++++++++++++++++++--
> >  drivers/net/wireless/ath/ath9k/hw.h  |    2 +-
> >  drivers/net/wireless/ath/ath9k/phy.h |    3 ++
> >  drivers/net/wireless/ath/ath9k/reg.h |    4 ++-
> >  4 files changed, 56 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> > index 8c0364f..013ffba 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
> > @@ -714,15 +714,48 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
> >  			      AR_CH0_BB_DPLL2_PLL_PWD, 0x0);
> >  		udelay(1000);
> >  
> > -		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
> > -			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
> 
> Should this be removed ?

Yes, that should be removed, but that should be different patch as
it is specific to AR9345. I'll split it. thanks.

Vasanth
