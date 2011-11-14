Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1KNUYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 15:24:38 -0500
Subject: Re: compat-wireless: backporting kfree_rcu()?
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EC16797.40208@hauke-m.de>
References: <1318925897.3958.11.camel@jlt3.sipsolutions.net>
	 <4EC16797.40208@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 21:24:35 +0100
Message-ID: <1321302275.10264.20.camel@jlt3.sipsolutions.net> (sfid-20111114_212441_775622_0E9BD782)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > #define kfree_rcu(data, rcuhead)                do {                    \
> >                 void __kfree_rcu_fn(struct rcu_head *rcu_head)  \
> >                 {                                                       \
> >                         void *___ptr;                                   \
> >                         ___ptr = container_of(rcu_head, typeof(*(data)), rcuhead);\
> >                         kfree(___ptr);                                  \
> >                 }                                                       \
> >                 call_rcu(&(data)->rcuhead, __kfree_rcu_fn);             \
> >         } while (0)
> > 
> > 
> > This works, thanks to gcc supporting nested functions, but has one major
> > issue: any module using call_rcu() must have an rcu_barrier() in its
> > module_exit() because __kfree_rcu_fn() might be called after the module
> > is unloaded. For kfree_rcu() this isn't needed since the function called
> > lives in the base kernel.
> 
> This looks nice to me.

:-)

> > I played around with injecting a call to rcu_barrier() into module exit
> > by modifying module_exit() but I couldn't make the CPP do that. Anyone
> > else have any ideas?
> 
> I played around with module_exit and modified the define into the
> following. Now rcu_barrier() gets called on every module_exit. As
> modules are not unloaded so often it should not hurd that this is also
> done when unloading a module not using kfree_rcu().

Ok.

> #undef module_exit
> #define module_exit(exitfn)					\
> 	void __exit __exit_rcu_barrier(void)			\
> 		{						\
> 			exitfn();				\
> 			rcu_barrier();				\
> 		}						\
> 	static inline exitcall_t __exittest(void)		\
> 	{ return exitfn; }					\
> 	void cleanup_module(void) __attribute__((alias("__exit_rcu_barrier")));

> Johannes are you fine with this?

Frankly, I don't think I really understand it, but if it works, why not?
I guess I could stick a printk into that function there to verify it ;-)

johannes

