Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36609 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab1AGPU6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 10:20:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 07:20:41 -0800
Date: Fri, 7 Jan 2011 20:50:26 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Peter Stuge <peter@stuge.se>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"greearb@candelatech.com" <greearb@candelatech.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 2/3] ath9k: Re-start xmit logic in xmit
	watchdog timer.
Message-ID: <20110107152026.GA5656@vasanth-laptop>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-2-git-send-email-greearb@candelatech.com> <20110107065101.GB13800@vasanth-laptop> <20110107151148.7315.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110107151148.7315.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 08:41:48PM +0530, Peter Stuge wrote:
> Vasanthakumar Thiagarajan wrote:
> > > +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> > > @@ -2110,6 +2110,27 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
> > >  				} else {
> > >  					txq->axq_tx_inprogress = true;
> > >  				}
> > > +			} else {
> ..
> > > +				if (!list_empty(&txq->axq_acq)) {
> ..
> > > +					ath_txq_schedule(sc, txq);
> > 
> > NAK. This complete work monitors the hw q periodically and does a
> > reset if a hang is detected.
> 
> Could you please point to that hang check?

It not exactly a hang check. It is monitoring tx intr when hw q is
non-empty.

Vasanth
