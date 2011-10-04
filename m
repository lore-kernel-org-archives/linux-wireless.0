Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:36980 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933314Ab1JDTgq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 15:36:46 -0400
Date: Tue, 4 Oct 2011 20:36:42 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111004183601.GA1395@ecki> (sfid-20111004_213650_222360_4D7B92E9)
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
> There's a function further down in the isr routine which checks
> whether the NIC itself posted the interrupt (it checks
> SYNC_CAUSE/ASYNC_CAUSE.) That should cut down the spam quite a
> bit and only log the relevant entries for ath9k.

If I do this no interrupts are logged at all.

In previous traces SYNC_CAUSE became non-zero only because the
debugging output delayed the interrupt handler enough to give the
initialization code a chance to run.

Clemens
