Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:29542 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXIRUM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 16:12:57 -0400
Received: by py-out-1112.google.com with SMTP id u77so3965593pyb
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2007 13:12:57 -0700 (PDT)
Message-ID: <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com>
Date: Tue, 18 Sep 2007 16:12:56 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Jeff Garzik" <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
	 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
	 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/18/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> >
> > ACK -- driver developers use this just to save themselves a few lines
> > from calling pci_resource_start() and friends. How about having an
> > inline which does what pci_iomap() does except it doesn't call
> > ioport_map() ? I am just not sure where this would go..
>
> I'm not understanding what the problem is?
>
> Why don't these people just use "ioread*()/iowrite*()"?
>
> In other words, the whole point of *not* using "read*/write*()" is that
> you get a whole slew of much nicer interfaces.
>
> So can people explain this fundamental issue? Why do people insist on
> using the old interfaces (and matching them with the new setup)?

An extra branch is created on MMIO-only devices on read/writes on the
IO_COND macro using this interface -- or is this optimized out?

  Luis
