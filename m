Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mow300.securemx.jp ([210.130.202.48]:45869 "EHLO
	mow.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1BQMrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 07:47:52 -0500
Date: Thu, 17 Feb 2011 21:53:18 +0900
From: Takashi Kawamoto <tkawamoto@silex.jp>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: BUG: AR9271 cause a Kernel Panic on ARM11 SMP environment
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Yoshitaka Imura <imura@silex.jp>,
	Yasuo Bato <bato@silex.jp>, Yuji Sasaki <sasaki@silex.jp>,
	Ryou Matsuura <matsuura@silex.jp>, ath9k-devel@atheros.com
In-Reply-To: <20110217122325.GA7373@redhat.com>
References: <20110216145201.GB10287@tuxdriver.com> <20110217122325.GA7373@redhat.com>
Message-Id: <20110217214732.6830.9AD4E5EB@silex.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Stanislaw,

Thank you.

On Thu, 17 Feb 2011 13:23:26 +0100
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Wed, Feb 16, 2011 at 09:52:01AM -0500, John W. Linville wrote:
> > On Wed, Feb 16, 2011 at 02:17:07PM +0900, Takashi Kawamoto wrote:
> [snip]
> > My guess would be that somehow you are leaking hif_dev->tx.tx_lock,
> > and then hanging when trying to retake it in hif_usb_send_tx.
> > Unfortunately, it is not obvious to me how that might happen...
> Perhaps CONFIG_LOCKDEP could give some more info.

I see. I'll try it.

> 
> > > CPU         : ARM11MP
> > > Kernel      : 2.6.33 (SMP enabled)
> What about newer kernels .35 , .37, .38-rcX ?

I've not tried to use those.

> 
> > > (2) When multi processor mode is enabled
> > >     When SMP option of the kernel is disabled (CONFIG_SMP=m), this 
> > >     panic doesn't occur.
> For CONFIG_PREEMPT=n and CONFIG_SMP=n spin locks are compiled out from
> kernel, they are simply not needed.

The same goes on CONFIG_PREEMPT=n and CONFIG_SMP=y ?
I want to avoid this crash with SMP enabled.



Best Regards,
Takashi Kawamoto

> 
> Stanislaw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

==================================================
 Takashi Kawamoto (E-Mail : tkawamoto@silex.jp)
 silex technology,Inc. 
 Software Engineering Division
 Phone:+81-774-98-3877 FAX:+81-774-98-3678
==================================================

