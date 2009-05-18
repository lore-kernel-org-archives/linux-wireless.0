Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34398 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZERVMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 17:12:19 -0400
Subject: Re: [PATCH] iwlwifi: do not cancel delayed work inside
 spin_lock_irqsave
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1242674520-26331-1-git-send-email-linville@tuxdriver.com>
References: <1242429226-8313-5-git-send-email-reinette.chatre@intel.com>
	 <1242674520-26331-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 18 May 2009 14:18:40 -0700
Message-Id: <1242681520.32358.605.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Mon, 2009-05-18 at 12:22 -0700, John W. Linville wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> Calling cancel_delayed_work() from inside
> spin_lock_irqsave, introduces a potential deadlock.
> 
> As explained by Johannes Berg <johannes@sipsolutions.net>
> 
> A - lock
> T - timer
> 
> phase                   CPU 1           CPU 2
> ---------------------------------------------
> 
> some place that calls
> cancel_timer_sync()
> (which is the | code)
>                                         lock-irq(A)
> |                                       "lock-irq"(T)
> |                                       "unlock"(T)
> |                                       wait(T)
>                                         unlock(A)
> 
> timer softirq
>                         "lock"(T)
>                         run(T)
>                         "unlock"(T)
> 
> irq handler
>           lock(A)
>           unlock(A)
> 
> Now all that again, interleaved, leading to deadlock:
> 
>                                         lock-irq(A)
>                         "lock"(T)
>                          run(T)
> IRQ during or maybe
> before run(T) -->        lock(A)
>                                         "lock-irq"(T)
>                                         wait(T)
> 
> We fix this by moving the call to cancel_delayed_work() into workqueue.
> There are cases where the work may not actually be queued or running
> at the time we are trying to cancel it, but cancel_delayed_work() is
> able to deal with this.
> 
> Also cleanup iwl_set_mode related to this call. This function
> (iwl_set_mode) is only called when bringing interface up and there will
> thus not be any scanning done. No need to try to cancel scanning.
> 
> Fixes http://bugzilla.kernel.org/show_bug.cgi?id=13224, which was also
> reported at http://marc.info/?l=linux-wireless&m=124081921903223&w=2 .
> 
> Tested-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Acked-by: Zhu Yi <yi.zhu@intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Did not apply to 2.6.30-rc6 as posted -- please verify my fix-up!

I am very sorry - this patch was created against and tested with an
earlier rc release. Thank you very much for fixing it up. It looks good.

Reinette


