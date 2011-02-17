Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab1BQMXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 07:23:38 -0500
Date: Thu, 17 Feb 2011 13:23:26 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Takashi Kawamoto <tkawamoto@silex.jp>
Cc: linux-wireless@vger.kernel.org, Yoshitaka Imura <imura@silex.jp>,
	Yasuo Bato <bato@silex.jp>, Yuji Sasaki <sasaki@silex.jp>,
	Ryou Matsuura <matsuura@silex.jp>, ath9k-devel@atheros.com
Subject: Re: BUG: AR9271 cause a Kernel Panic on ARM11 SMP environment
Message-ID: <20110217122325.GA7373@redhat.com>
References: <20110216141657.9270.9AD4E5EB@silex.jp>
 <20110216145201.GB10287@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110216145201.GB10287@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 16, 2011 at 09:52:01AM -0500, John W. Linville wrote:
> On Wed, Feb 16, 2011 at 02:17:07PM +0900, Takashi Kawamoto wrote:
[snip]
> My guess would be that somehow you are leaking hif_dev->tx.tx_lock,
> and then hanging when trying to retake it in hif_usb_send_tx.
> Unfortunately, it is not obvious to me how that might happen...
Perhaps CONFIG_LOCKDEP could give some more info.

> > CPU         : ARM11MP
> > Kernel      : 2.6.33 (SMP enabled)
What about newer kernels .35 , .37, .38-rcX ?

> > (2) When multi processor mode is enabled
> >     When SMP option of the kernel is disabled (CONFIG_SMP=m), this 
> >     panic doesn't occur.
For CONFIG_PREEMPT=n and CONFIG_SMP=n spin locks are compiled out from
kernel, they are simply not needed.

Stanislaw
