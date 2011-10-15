Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:52854 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751151Ab1JOJic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 05:38:32 -0400
Date: Sat, 15 Oct 2011 11:39:02 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111015093902.GA23520@ecki> (sfid-20111015_113838_028184_7F5723D6)
References: <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
 <CAD2nsn0Z2J4r4tN_fLjx5bbvz2bg6NVcQ8vppJbbNcgOF8pFew@mail.gmail.com>
 <CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
 <20111003084823.GA1521@ecki.lan>
 <CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
 <20111004181534.GA1502@ecki>
 <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
 <20111005062528.GA1403@ecki>
 <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
 <CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

On Wed, Oct 12, 2011 at 06:40:06PM +0530, Mohammed Shafi wrote:
> 
> please try this in case it helps anything
> to debug the issue.

With this, the previous instaces of 0xdeadbeaf are replaced with
zeroes, and I do not get any non-zero traces for SYNC_CAUSE or
ASYNC_CAUSE any more.

>  this should avoid dead beef and the interrupt when we access MAC
> registers when the MAC is asleep. also i did not see MAC irq being not
> triggerred in your case(AR_INTR_ASYNC_CAUSE should be 0x2) or may be
> its not an interrupt triggered by the chip itself. thanks

If it's not triggered by ath9k, I do wonder why it works if I
suspend in connected mode, and why reloading the driver usually
fixes the issue. Maybe there is something in the driver unloading
code that we could look at?

Clemens
