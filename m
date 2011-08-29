Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5638 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1H2LLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 07:11:47 -0400
Date: Mon, 29 Aug 2011 16:41:31 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: fix checks for first subframe delimiter padding
Message-ID: <20110829111130.GB29376@vasanth-laptop> (sfid-20110829_131150_645886_D4A28E95)
References: <1314615061-6354-1-git-send-email-nbd@openwrt.org> <20110829110427.GA29376@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110829110427.GA29376@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 04:34:28PM +0530, Vasanthakumar Thiagarajan wrote:
> On Mon, Aug 29, 2011 at 12:51:01PM +0200, Felix Fietkau wrote:
> > The commit "ath9k_hw: Fix exceed transmission burst-time of 5GHz" added
> > a padding of 60 delimiters on the first subframe to work around an issue
> > on AR9380, but it lacked the checks to prevent it from being applied to
> > pre-AR9380, enterprise AR9380 or AR9580+
> > 
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/reg.h  |    1 +
> >  drivers/net/wireless/ath/ath9k/xmit.c |    4 +++-
> >  2 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
> > index a3b8bbc..989514a 100644
> > --- a/drivers/net/wireless/ath/ath9k/reg.h
> > +++ b/drivers/net/wireless/ath/ath9k/reg.h
> > @@ -1131,6 +1131,7 @@ enum {
> >  #define AR_INTR_PRIO_ASYNC_ENABLE (AR_SREV_9340(ah) ? 0x4094 : 0x40d4)
> >  #define AR_ENT_OTP		  0x40d8
> >  #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
> > +#define AR_ENT_OTP_MIN_PKT_SIZE_DISABLE		0x00800000
> >  #define AR_ENT_OTP_MPSD		0x00800000
> 
> Looks like AR_ENT_OTP_MPSD was defined for this purpose,
> unfortunately it so difficult to understand anything from this
> macro. Can you also this redundant definition?

I mean, Can you also remove this redundant definition?, thanks.

Vasanth
