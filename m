Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:59288 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2CFTbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 14:31:51 -0500
Date: Tue, 6 Mar 2012 20:31:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Sven Joachim <svenjoac@gmx.de>,
	Greg KH <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
In-Reply-To: <alpine.LFD.2.02.1203060957140.2742@ionos>
Message-ID: <alpine.LFD.2.02.1203062019340.2742@ionos> (sfid-20120306_203210_740456_AC2C4165)
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org> <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de> <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com> <alpine.LFD.2.02.1203060927190.2742@ionos>
 <alpine.LFD.2.02.1203060957140.2742@ionos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Mar 2012, Thomas Gleixner wrote:
> On Tue, 6 Mar 2012, Thomas Gleixner wrote:
> 
> > On Mon, 5 Mar 2012, Linus Torvalds wrote:
> > 
> > > Thomas, should we just plan on reverting that commit from mainline? It
> > > clearly causes regressions.
> > 
> > Give me a day or two to figure out why it breaks stuff. I have no idea
> > why it should wreckage anything.
> 
> Hmm. This is interesting. The b43 driver has a primary handler which
> can return IRQ_NONE. So up to that change the interrupt line was kept
> disabled when that happened. Possibly the driver relies on that
> behaviour. Digging for a machine with a b43.

Does not reproduce. Now I was looking at the driver again, it does not
use IRQ_ONESHOT anyway.

So for handle_fasteoi_irq() this patch is actually a NOOP. So the only
affected handler would be handle_level_irq(). Still can't see how it
changes the !IRQ_ONESHOT behaviour :(

Stephan, Sven: Can you please provide the output of /proc/interrupts ?

Thanks,

	tglx



