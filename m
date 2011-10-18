Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1JRISV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 04:18:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RG4sO-00053j-KV
	for linux-wireless@vger.kernel.org; Tue, 18 Oct 2011 10:18:20 +0200
Subject: compat-wireless: backporting kfree_rcu()?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 10:18:17 +0200
Message-ID: <1318925897.3958.11.camel@jlt3.sipsolutions.net> (sfid-20111018_101825_645167_3C966770)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I was looking at backporting kfree_rcu(), and came up with this:

#define kfree_rcu(data, rcuhead)                do {                    \
                void __kfree_rcu_fn(struct rcu_head *rcu_head)  \
                {                                                       \
                        void *___ptr;                                   \
                        ___ptr = container_of(rcu_head, typeof(*(data)), rcuhead);\
                        kfree(___ptr);                                  \
                }                                                       \
                call_rcu(&(data)->rcuhead, __kfree_rcu_fn);             \
        } while (0)


This works, thanks to gcc supporting nested functions, but has one major
issue: any module using call_rcu() must have an rcu_barrier() in its
module_exit() because __kfree_rcu_fn() might be called after the module
is unloaded. For kfree_rcu() this isn't needed since the function called
lives in the base kernel.

I played around with injecting a call to rcu_barrier() into module exit
by modifying module_exit() but I couldn't make the CPP do that. Anyone
else have any ideas?

Another idea I had was to insert the __kfree_rcu_fn() code into the
compat module instead, but I can't see how to do that short of using
some source post-processing scripts.

johannes

