Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41821 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab0JDMYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 08:24:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 05:24:42 -0700
Date: Mon, 4 Oct 2010 17:54:32 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/4] ath9k_hw: merge codepaths that access the cycle
	counter registers
Message-ID: <20101004122432.GA25423@vasanth-laptop>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org> <1286125639-15137-2-git-send-email-nbd@openwrt.org> <20101004063446.GA16078@vasanth-laptop> <4CA9BC4B.4010503@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CA9BC4B.4010503@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 05:06:43PM +0530, Felix Fietkau wrote:
> On 2010-10-04 8:34 AM, Vasanthakumar Thiagarajan wrote:
> >> +	/* freeze counters */
> >> +	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
> >> +
> >> +	ah->cc.cycles = REG_READ(ah, AR_CCCNT);
> >> +	if (ah->cc.cycles < cc.cycles) {
> >> +		clear = true;
> >> +		goto skip;
> >>  	}
> >>  
> >> -	cycles = cc;
> >> -	rx_frame = rf;
> >> -	rx_clear = rc;
> >> -	tx_frame = tf;
> >> +	ah->cc.rx_clear = REG_READ(ah, AR_RCCNT);
> >> +	ah->cc.rx_frame = REG_READ(ah, AR_RFCNT);
> >> +	ah->cc.tx_frame = REG_READ(ah, AR_TFCNT);
> >> +
> >> +	/* prevent wraparound */
> >> +	if (ah->cc.cycles & BIT(31))
> >> +		clear = true;
> > 
> > This does not look right, previous if should take care of 
> > any wrap around.
> This is not for correcting an existing wraparound. This is for making
> sure that a wraparound never occurs.

ok.
> 
> >> +
> >> +#define CC_DELTA(_field, _reg) ah->cc_delta._field += ah->cc._field - cc._field
> > _reg is not used.
> > 
> >> 
> >> +skip:
> >> +	if (clear) {
> >> +		REG_WRITE(ah, AR_CCCNT, 0);
> >> +		REG_WRITE(ah, AR_RFCNT, 0);
> >> +		REG_WRITE(ah, AR_RCCNT, 0);
> >> +		REG_WRITE(ah, AR_TFCNT, 0);
> > 
> > should be able to do with single write in AR_MIBC.
> No, the clear bit in AR_MIBC does not clear these counters. I tested that.

ok.
> 
> >> +	/* unfreeze counters */
> >> +	REG_WRITE(ah, AR_MIBC, 0);
> > 
> > Please configure the relevant bit to unfreeze the counters.
> What do you mean?

AR_MIBC does more than just freeze/unfreeze the counters, though I
dont see any issues with setting the whole register to zero, it
looks buggy. Please configure only the relevant bit to
freeze/unfreeze the counters.

Vasanth
