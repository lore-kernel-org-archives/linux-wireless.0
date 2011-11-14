Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57481 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab1KNTKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 14:10:22 -0500
Message-ID: <4EC16797.40208@hauke-m.de> (sfid-20111114_201025_819377_9702CE5E)
Date: Mon, 14 Nov 2011 20:10:15 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless: backporting kfree_rcu()?
References: <1318925897.3958.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1318925897.3958.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

now your patch using kfree_rcu went into linux-next. ;-)

On 10/18/2011 10:18 AM, Johannes Berg wrote:
> So I was looking at backporting kfree_rcu(), and came up with this:
> 
> #define kfree_rcu(data, rcuhead)                do {                    \
>                 void __kfree_rcu_fn(struct rcu_head *rcu_head)  \
>                 {                                                       \
>                         void *___ptr;                                   \
>                         ___ptr = container_of(rcu_head, typeof(*(data)), rcuhead);\
>                         kfree(___ptr);                                  \
>                 }                                                       \
>                 call_rcu(&(data)->rcuhead, __kfree_rcu_fn);             \
>         } while (0)
> 
> 
> This works, thanks to gcc supporting nested functions, but has one major
> issue: any module using call_rcu() must have an rcu_barrier() in its
> module_exit() because __kfree_rcu_fn() might be called after the module
> is unloaded. For kfree_rcu() this isn't needed since the function called
> lives in the base kernel.

This looks nice to me.

> I played around with injecting a call to rcu_barrier() into module exit
> by modifying module_exit() but I couldn't make the CPP do that. Anyone
> else have any ideas?

I played around with module_exit and modified the define into the
following. Now rcu_barrier() gets called on every module_exit. As
modules are not unloaded so often it should not hurd that this is also
done when unloading a module not using kfree_rcu().

#undef module_exit
#define module_exit(exitfn)					\
	void __exit __exit_rcu_barrier(void)			\
		{						\
			exitfn();				\
			rcu_barrier();				\
		}						\
	static inline exitcall_t __exittest(void)		\
	{ return exitfn; }					\
	void cleanup_module(void) __attribute__((alias("__exit_rcu_barrier")));

> 
> Another idea I had was to insert the __kfree_rcu_fn() code into the
> compat module instead, but I can't see how to do that short of using
> some source post-processing scripts.

Johannes are you fine with this?

Hauke
