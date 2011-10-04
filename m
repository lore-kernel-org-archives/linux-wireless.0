Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:39169 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932539Ab1JDTPl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 15:15:41 -0400
Date: Tue, 4 Oct 2011 20:15:34 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111004181534.GA1502@ecki> (sfid-20111004_211544_511397_60F6AF94)
References: <CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
 <14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com>
 <CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
 <20110927214245.GA1416@ecki>
 <CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
 <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
 <CAD2nsn0Z2J4r4tN_fLjx5bbvz2bg6NVcQ8vppJbbNcgOF8pFew@mail.gmail.com>
 <CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
 <20111003084823.GA1521@ecki.lan>
 <CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 04, 2011 at 03:58:09PM +0800, Adrian Chadd wrote:
> 
> On 3 October 2011 16:48, Clemens Buchacher <drizzd@aon.at> wrote:
> 
> > for 1, 2, ..., 99, 128, 256:
> > AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
> > AR_IMR: 0xdeadbeef, AR_ISR: 0xdeadbeef
> 
> .. that says some part of the MAC is very asleep. But no interrupt
> cause bits are set. So I bet it's a shared interrupt.

Unfortunately, that's not it. From /proc/interrupts:

            CPU0       CPU1       CPU2       CPU3       
  17:      24958      25047      25012      24984   IO-APIC-fasteoi   ath9k
  
This is right after the IRQ is disabled because of too many
unhandled interrupts.

> > If I suspend/resume first, then load the module, then wait for 500
> > ms after request_irq I get only zeroes, repeated 109 times:
> >
> > for 1, 2, ..., 99, 2^7, 2^8, ..., 2^16:
> > AR_IMR: 0x00000000, AR_ISR: 0x00000000
> > AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
> 
> Would you mind also printing the contents of AR_IER there? I wonder if
> AR_IER is incorrectly being enabled.

Not much more helpful, I'm afraid:

AR_IMR: 0x00000000, AR_ISR: 0x00000000, AR_IER: 0x00000000
AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
(repeated 109 times)

It seems that at this point the device is in a bad state.

Clemens
