Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:45770 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZFRAal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 20:30:41 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
References: <1245263058.31588.38.camel@johannes.local>
	<m1y6rqwpur.fsf@fess.ebiederm.org>
	<1245276899.31588.57.camel@johannes.local>
	<m1r5xitpdh.fsf@fess.ebiederm.org>
	<1245282099.31588.69.camel@johannes.local>
	<m17hzato0r.fsf@fess.ebiederm.org>
	<1245283327.31588.74.camel@johannes.local>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 17:30:40 -0700
In-Reply-To: <1245283327.31588.74.camel@johannes.local> (Johannes Berg's message of "Thu\, 18 Jun 2009 02\:02\:06 +0200")
Message-ID: <m1my86qt73.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: [PATCH] wireless extensions: play with netns
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-06-17 at 16:54 -0700, Eric W. Biederman wrote:
>
>> > Subject: net: make namespace iteration possible under RCU
>> >
>> > We already call rcu_barrier(), so all we need to take
>> > care of is using proper RCU list add/del primitives.
>> 
>> This of course gives you a network namespace that can be found by for_each_net rcu
>> while the per net exit functions are running.  I think that opens up to races
>> that I don't want to think about.
>
> Indeed. Can we move the rcu_barrier() up? Or we could insert a
> synchronize_rcu() (which is sufficient for rcu_read_lock) before the
> exit functions are run?

I don't think we can move the barrier.   But adding an extra synchronize_rcu
should be fine.  We are talking about the slowest of the slow paths here.
It is so slow it even gets it's own kernel thread.

Eric
