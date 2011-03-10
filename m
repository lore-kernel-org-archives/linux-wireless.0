Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55370 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1CJJdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 04:33:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 01:32:54 -0800
Date: Thu, 10 Mar 2011 15:02:54 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 2/4] ath9k: fix stopping tx dma on reset
Message-ID: <20110310093254.GD28100@vasanth-laptop>
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org> <1299717303-42430-2-git-send-email-nbd@openwrt.org> <20110310085847.GB28100@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110310085847.GB28100@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2011 at 02:28:47PM +0530, Vasanthakumar Thiagarajan wrote:
> On Thu, Mar 10, 2011 at 06:05:01AM +0530, Felix Fietkau wrote:
> > +bool ath9k_hw_abort_tx_dma(struct ath_hw *ah)
> > +{
> > +	int i, q;
> > +
> > +	REG_WRITE(ah, AR_Q_TXD, AR_Q_TXD_M);
> > +
> > +	REG_SET_BIT(ah, AR_PCU_MISC, AR_PCU_FORCE_QUIET_COLL | AR_PCU_CLEAR_VMF);
> > +	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
> > +	REG_SET_BIT(ah, AR_D_GBL_IFS_MISC, AR_D_GBL_IFS_MISC_IGNORE_BACKOFF);
> > +
> > +	for (q = 0; q < AR_NUM_QCU; q++) {
> > +		for (i = 1000; i > 0; i--) {
> > +			if (!ath9k_hw_numtxpending(ah, q))
> > +				break;
> > +
> > +			udelay(5);
> > +		}
> > +	}
> > +	if (!i)
> > +		return false;
> 
> Here the assumption looks like a reset would follow to configure
> those registers back, may be some comment will be useful.
> 

Also a hw reset is not guaranteed to follow this,
call of ath_drain_all_txq() in .flush(), for ex.

Vasanth
