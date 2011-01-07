Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:56503 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751383Ab1AGPLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 10:11:51 -0500
Message-ID: <20110107151148.7315.qmail@stuge.se>
Date: Fri, 7 Jan 2011 16:11:48 +0100
From: Peter Stuge <peter@stuge.se>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "greearb@candelatech.com" <greearb@candelatech.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 2/3] ath9k: Re-start xmit logic in xmit
	watchdog timer.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-2-git-send-email-greearb@candelatech.com> <20110107065101.GB13800@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110107065101.GB13800@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> > +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> > @@ -2110,6 +2110,27 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
> >  				} else {
> >  					txq->axq_tx_inprogress = true;
> >  				}
> > +			} else {
..
> > +				if (!list_empty(&txq->axq_acq)) {
..
> > +					ath_txq_schedule(sc, txq);
> 
> NAK. This complete work monitors the hw q periodically and does a
> reset if a hang is detected.

Could you please point to that hang check?


//Peter
