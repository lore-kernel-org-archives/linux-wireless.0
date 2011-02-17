Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab1BQNxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 08:53:05 -0500
Date: Thu, 17 Feb 2011 14:52:18 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Takashi Kawamoto <tkawamoto@silex.jp>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Yoshitaka Imura <imura@silex.jp>,
	Yasuo Bato <bato@silex.jp>, Yuji Sasaki <sasaki@silex.jp>,
	Ryou Matsuura <matsuura@silex.jp>, ath9k-devel@atheros.com
Subject: Re: BUG: AR9271 cause a Kernel Panic on ARM11 SMP environment
Message-ID: <20110217135212.GA2215@redhat.com>
References: <20110216145201.GB10287@tuxdriver.com>
 <20110217122325.GA7373@redhat.com>
 <20110217214732.6830.9AD4E5EB@silex.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110217214732.6830.9AD4E5EB@silex.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, Feb 17, 2011 at 09:53:18PM +0900, Takashi Kawamoto wrote:
> > What about newer kernels .35 , .37, .38-rcX ?
> 
> I've not tried to use those.
I think you should try at least .37 to see if bug is not
fixed there by chance. If it is, finding fix for .33
would be easier.

> > > > (2) When multi processor mode is enabled
> > > >     When SMP option of the kernel is disabled (CONFIG_SMP=m), this 
> > > >     panic doesn't occur.
> > For CONFIG_PREEMPT=n and CONFIG_SMP=n spin locks are compiled out from
> > kernel, they are simply not needed.
> 
> The same goes on CONFIG_PREEMPT=n and CONFIG_SMP=y ?
No, spin locks are wiped out only with both disabled.

Cheers
Stanislaw
