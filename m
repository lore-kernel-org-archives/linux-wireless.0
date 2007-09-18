Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:15333 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXIRTDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 15:03:49 -0400
Received: by an-out-0708.google.com with SMTP id d31so298852and
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2007 12:03:49 -0700 (PDT)
Message-ID: <43e72e890709181203x30144451hf332da4032b5b770@mail.gmail.com>
Date: Tue, 18 Sep 2007 15:03:48 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] revert ath5k ioread32()/iowrite32() usage - use readl()/writel(), we're MMIO-only
Cc: "Jeff Garzik" <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46EEF543.7060901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com>
	 <46EEE735.5050306@gmail.com> <46EEEA9B.70407@garzik.org>
	 <46EEF543.7060901@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/17/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/17/2007 10:59 PM, Jeff Garzik wrote:
> > Jiri Slaby wrote:
> >> NACK, this is wrong. iomap returns platform dependant return value,
> >> which may or
> >
> > Incorrect.  readl() and writel() work just fine on all existing
> > platforms where Atheros may be used.
>
> Ok, this is what Alan Cox wrote about that and you didn't reply to it, so I
> thought he's right. Anyway I wouldn't rely on iomap that it will never be
> changed even on x86 -- what's the (performance) impact of having ioread instead
> of readl? How much data are transferred this way?
>
> <cite from="http://lkml.org/lkml/2007/8/25/50">
> On Sat, 25 Aug 2007 04:56:19 -0400
> Jeff Garzik <jgarzik@pobox.com> wrote:
>
> > If the driver knows its MMIO, using readX/writeX after pci_iomap() is
> > just fine, for all current implementations, and it makes sense that way.
>
> There is nothing that guarantees this is permitted, any more than there
> is anything saying not to use outb/outl. Some of the implementations do
> quite strange things. It may happen to work but its not in the
> documentation or the comments.

I posted a patch to update the documentation with this.

> Please, can anybody clarify it?

Based on Alan's 'Review-by' remarks on my patch for updating the
documenation on pci_iomap() it seems this validates this patch. Please
see thread with subject:

[PATCH] Clarify pci_iomap() usage for MMIO-only devices

   Luis
