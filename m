Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48066 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0IVM6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 08:58:47 -0400
Received: by fxm3 with SMTP id 3so238966fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 05:58:46 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex Mihaylov <minimumlaw@gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
Date: Wed, 22 Sep 2010 14:58:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com> <201009221424.39949.chunkeey@googlemail.com> <AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
In-Reply-To: <AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009221458.43434.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 14:33:54 Alex Mihaylov wrote:
> 2010/9/22 Christian Lamparter <chunkeey@googlemail.com>:
> > why polling? They even say "14. Wait for the READY interrupt".
> 
> This code from Sagrad:

be careful with code... Haven't you read the comical license?!
I'm not sure how ST react once they figured out that Sagrad
leaked parts of the secret code, which might even cost them
the FCC badge?! 

> SPIDRVReadReg32(SPI_ADRS_HOST_INTERRUPTS) - poll SPI register. IRQ
> from STLC chip disabled.

so what you are trying to say is that they have knowingly ignored
their own specification? But who cares, as long as they do provide
a "complete" driver+stack solution for their paying customers.

> > Also, on power_on the driver currently waits just 10 and not 240 ms,
> > maybe this could just be the problem...
> 
> OK. I try change this.
> 

note:

2.6.25.4 is very old and the spi subsystem (which isn't backported in cw)
has changed quite a bit since then.
