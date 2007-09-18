Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:26476 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXIRTHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 15:07:24 -0400
Received: by py-out-1112.google.com with SMTP id u77so3933694pyb
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2007 12:07:23 -0700 (PDT)
Message-ID: <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
Date: Tue, 18 Sep 2007 15:07:23 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Jeff Garzik" <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/18/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> >
> > Alright, here is the same patch inline with s/recommended/required/ language:
>
> Well, the thing is, I'm not at all sure that I agree with this.
>
> If you use ioport_map/unmap, then you really *should* access them with the
> proper iomem accessors (ioread/iowrite). The fact that it may happen to
> work (when using the default lib/iomap.c implementation, at least) on
> some architectures and with the current implementation still doesn't mean
> that you should necessarily use readb/writeb.
>
> After all, you cannot use "inb/outb" on it, even if would happen to be an
> IO address.
>
> So what is this usage that wants to use the bogus accessor? Why not fix
> that instead of adding documentation for something that is very arguably
> something we want to *avoid* having people do!

ACK -- driver developers use this just to save themselves a few lines
from calling pci_resource_start() and friends. How about having an
inline which does what pci_iomap() does except it doesn't call
ioport_map() ? I am just not sure where this would go..

  Luis
