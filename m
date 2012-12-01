Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:47579 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab2LAEP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 23:15:56 -0500
Date: Fri, 30 Nov 2012 23:15:50 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Tejun Heo <tj@kernel.org>
cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
In-Reply-To: <20121130225619.GD6021@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1211302234410.25064@dr-wily.mit.edu> (sfid-20121201_051620_133365_E8C4228B)
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu> <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu> <20121130211435.GJ3873@htj.dyndns.org> <20121130225619.GD6021@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 30 Nov 2012, Tejun Heo wrote:
> Hey, again.
> 
> Can you please test whether the following patch makes any difference?
> 
> Thanks!
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 042d221..26368ef 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1477,7 +1477,10 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
>  	} while (unlikely(ret == -EAGAIN));
>  
>  	if (likely(ret >= 0)) {
> -		__queue_delayed_work(cpu, wq, dwork, delay);
> +		if (!delay)
> +			__queue_work(cpu, wq, &dwork->work);
> +		else
> +			__queue_delayed_work(cpu, wq, dwork, delay);
>  		local_irq_restore(flags);
>  	}
>  

Yes.  I tested that both directly on top of the bad commit, and on 
v3.7-rc7, and it fixes the bug in both cases.

Thanks,
Anders
