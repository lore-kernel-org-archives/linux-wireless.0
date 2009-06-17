Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:58390 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZFQXyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 19:54:14 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] wireless extensions: play with netns
References: <1245263058.31588.38.camel@johannes.local>
	<m1y6rqwpur.fsf@fess.ebiederm.org>
	<1245276899.31588.57.camel@johannes.local>
	<m1r5xitpdh.fsf@fess.ebiederm.org>
	<1245282099.31588.69.camel@johannes.local>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 16:54:12 -0700
In-Reply-To: <1245282099.31588.69.camel@johannes.local> (Johannes Berg's message of "Thu\, 18 Jun 2009 01\:41\:38 +0200")
Message-ID: <m17hzato0r.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-06-17 at 16:24 -0700, Eric W. Biederman wrote:
>
>> > So it looks like I can also use rcu_read_lock(), but there's no
>> > for_each_net_rcu(), should there be?
>> 
>> I'm not using rcu safe list manipulation.  What makes it look like
>> rcu_read_lock() is safe?
>
> Indeed. I was looking at rcu_barrier() only. How about the patch below?
>
> johannes
>
> Subject: net: make namespace iteration possible under RCU
>
> We already call rcu_barrier(), so all we need to take
> care of is using proper RCU list add/del primitives.

This of course gives you a network namespace that can be found by for_each_net rcu
while the per net exit functions are running.  I think that opens up to races
that I don't want to think about.

I still haven't tracked down how I am occasionally getting time wait sockets
with an invalid network namespace.

Eric
