Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:52492 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753336Ab1I2SLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 14:11:51 -0400
Date: Thu, 29 Sep 2011 19:11:47 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org, beta992@gmail.com
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20110929171147.GA6788@ecki> (sfid-20110929_201200_785441_2A09D4F0)
References: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
 <CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
 <CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com>
 <20110830064137.GA4719@ecki>
 <CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
 <14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com>
 <CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
 <20110927214245.GA1416@ecki>
 <CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
 <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

On Thu, Sep 29, 2011 at 06:33:42PM +0800, Adrian Chadd wrote:
> 
> Has someone figured out which ISR bits are being triggered?

No.

I tried to move the SC_OP_INVALID check until after the call to
ath9k_hw_getisr in ath_isr. But that caused the kernel to freeze
IIRC.

What I also tried and failed to do a hardware reset before
request_irq gets called. For ath9k_hw_reset I need an initialized
ath_hw struct, but that's done after request_irq in
ath9k_init_device. I remember I tried to delay request_irq, but for
some reason that did not work out either.

> If not, I can likely whip up a patch which adds some relevant
> printk's. I think it's worth establishing:
> 
> * is it a sync/async interrupt;
> * is it a fatal interrupt (eg something like a PCI bus error or
> transaction timeout) or is it a normal ISR bit that keeps firing;
> * .. and which one is firing.

If you have an idea how to do this, I think that would be most
helpful.

Clemens
