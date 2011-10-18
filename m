Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1JRKHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 06:07:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RG6aH-0006XA-Ew
	for linux-wireless@vger.kernel.org; Tue, 18 Oct 2011 12:07:45 +0200
Subject: Re: compat-wireless: backporting kfree_rcu()?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1318925897.3958.11.camel@jlt3.sipsolutions.net> (sfid-20111018_101825_645167_3C966770)
References: <1318925897.3958.11.camel@jlt3.sipsolutions.net>
	 (sfid-20111018_101825_645167_3C966770)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 12:07:41 +0200
Message-ID: <1318932461.3958.17.camel@jlt3.sipsolutions.net> (sfid-20111018_120749_784933_38430D67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A complete different idea:

/* a larger rcu head struct */
struct compat_rcu_head {
	struct rcu_head rh; /* must be first */
	void *free_ptr;
};

/* define kfree_rcu */
extern void compat_free_rcu(struct rcu_head *rh);

#define kfree_rcu(ptr, head)	\
	do {
		(ptr)->head.free_ptr = ptr;
		call_rcu(&(ptr)->head.rh, compat_free_rcu);
	} while (0)

/* use it in all code */
#define rcu_head compat_rcu_head


and somewhere in a compat.ko file:

#undef rcu_head
void compat_free_rcu(struct rcu_head *rh)
{
	struct compat_rcu_head *crh = (void *)rh;
	kfree(crh->free_ptr);
}


thoughts?

johannes

