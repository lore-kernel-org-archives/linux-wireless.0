Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40191 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0EWG3c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 02:29:32 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 22 May 2010 23:29:32 -0700
Date: Sat, 22 May 2010 23:29:04 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Kalle Valo <kvalo@adurom.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath9k: Make sure null func frame is acked before
 going into PS for ar9003
Message-ID: <20100523062902.GA21298@vasanth-laptop>
References: <1274147876-9228-1-git-send-email-vasanth@atheros.com>
 <877hmvixp1.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <877hmvixp1.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 23, 2010 at 12:13:54AM +0530, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vasanth@atheros.com> writes:
> 
> > Add missing code to handle nullfunc frame completion in
> > ath_tx_edma_tasklet().
> 
> [...]
> 
> > +		/*
> > +		 * Make sure null func frame is acked before configuring
> > +		 * hw into ps mode.
> > +		 */
> > +		if (bf->bf_isnullfunc && txok) {
> > +			if ((sc->ps_flags & PS_ENABLED))
> > +				ath9k_enable_ps(sc);
> > +			else
> > +				sc->ps_flags |= PS_NULLFUNC_COMPLETED;
> > +		}
> 
> Few months ago a similar test was added to mac80211. Why does ath9k
> need this also in the driver?
> 

Right, but this patch is needed unless the logic which checks for
completion of null func in driver is cleaned up. I'll do this clean
up later. thanks.

Vasanth
