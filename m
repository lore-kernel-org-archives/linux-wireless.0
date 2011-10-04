Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50843 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776Ab1JDVLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:11:01 -0400
Received: by ggnv2 with SMTP id v2so422799ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 14:11:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111004181534.GA1502@ecki>
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
	<20111004181534.GA1502@ecki>
Date: Wed, 5 Oct 2011 05:11:00 +0800
Message-ID: <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com> (sfid-20111004_231107_226907_6B765D12)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 October 2011 02:15, Clemens Buchacher <drizzd@aon.at> wrote:
>> Would you mind also printing the contents of AR_IER there? I wonder if
>> AR_IER is incorrectly being enabled.
>
> Not much more helpful, I'm afraid:
>
> AR_IMR: 0x00000000, AR_ISR: 0x00000000, AR_IER: 0x00000000
> AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
> (repeated 109 times)
>
> It seems that at this point the device is in a bad state.

Well, the question now is whether the device itself is actually firing
off interrupts.

>From what you've shown there, the device _isn't_ firing off interrupts
the normal way.
So I wonder if it's the card or whether it's something else (eg the
PCI bus glue.)

Here, you could try inserting this in the SC_OP_INVALID bit, right
after you do some logging. I'm still assuming your AR9285 is somehow
firing off interrupts.
At this point however I'm all just guessing here. It'd be nice to know
whether the device is _really_ sending interrupts or not.

/* Mark _all_ async interrupts as serviced */
REG_WRITE(ah, AR_INTR_ASYNC_CAUSE, 0xffffffff);
REG_READ(ah, AR_INTR_ASYNC_CAUSE);

/* Disable sync interrupt sources */
REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
/* Mark _all_ sync interrupts as serviced */
REG_WRITE(ah, AR_INTR_SYNC_CAUSE, 0xffffffff);
REG_READ(ah, AR_INTR_SYNC_CAUSE);

/* Do a reset of the AHB and host interface */
REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
DELAY(100);
REG_WRITE(ah, AR_RC, 0);
