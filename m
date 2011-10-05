Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:55475 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753750Ab1JEG2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 02:28:13 -0400
Date: Wed, 5 Oct 2011 08:28:43 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111005062528.GA1403@ecki> (sfid-20111005_082816_913540_468E52B4)
References: <CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
 <20110927214245.GA1416@ecki>
 <CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
 <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
 <CAD2nsn0Z2J4r4tN_fLjx5bbvz2bg6NVcQ8vppJbbNcgOF8pFew@mail.gmail.com>
 <CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
 <20111003084823.GA1521@ecki.lan>
 <CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
 <20111004181534.GA1502@ecki>
 <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 05, 2011 at 05:11:00AM +0800, Adrian Chadd wrote:
> 
> Well, the question now is whether the device itself is actually firing
> off interrupts.
> 
> From what you've shown there, the device _isn't_ firing off interrupts
> the normal way.
> So I wonder if it's the card or whether it's something else (eg the
> PCI bus glue.)
> 
> Here, you could try inserting this in the SC_OP_INVALID bit, right
> after you do some logging. I'm still assuming your AR9285 is somehow
> firing off interrupts.
> At this point however I'm all just guessing here. It'd be nice to know
> whether the device is _really_ sending interrupts or not.

No change with the code below, except that the timing is slightly
different.

> /* Mark _all_ async interrupts as serviced */
> REG_WRITE(ah, AR_INTR_ASYNC_CAUSE, 0xffffffff);
> REG_READ(ah, AR_INTR_ASYNC_CAUSE);
> 
> /* Disable sync interrupt sources */
> REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
> /* Mark _all_ sync interrupts as serviced */
> REG_WRITE(ah, AR_INTR_SYNC_CAUSE, 0xffffffff);
> REG_READ(ah, AR_INTR_SYNC_CAUSE);
> 
> /* Do a reset of the AHB and host interface */
> REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
> DELAY(100);

Since I could not find a suitable DELAY macro, I used this instead:

 int delay = 100;
 DO_DELAY(delay);

> REG_WRITE(ah, AR_RC, 0);

For the record, instead of going to full sleep, I can reproduce the
issue with

 echo devices >/sys/power/pm_test
 echo mem >/sys/power/state

but not with

 echo freezer >/sys/power/pm_test
 echo mem >/sys/power/state

So it could still be a different device that's causing the issue? I
can try unloading all kinds of modules. Or is there an option to
suspend just one device?

Clemens
