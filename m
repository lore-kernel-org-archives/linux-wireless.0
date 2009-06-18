Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:48299 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZFRA1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 20:27:23 -0400
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
	<1245282315.31588.71.camel@johannes.local>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 17:27:19 -0700
In-Reply-To: <1245282315.31588.71.camel@johannes.local> (Johannes Berg's message of "Thu\, 18 Jun 2009 01\:45\:15 +0200")
Message-ID: <m18wjqs7x4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: [PATCH] wireless extensions: play with netns
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-06-18 at 01:41 +0200, Johannes Berg wrote:
>> On Wed, 2009-06-17 at 16:24 -0700, Eric W. Biederman wrote:
>> 
>> > > So it looks like I can also use rcu_read_lock(), but there's no
>> > > for_each_net_rcu(), should there be?
>> > 
>> > I'm not using rcu safe list manipulation.  What makes it look like
>> > rcu_read_lock() is safe?
>> 
>> Indeed. I was looking at rcu_barrier() only. How about the patch below?
>
> With that, my genl patch can look like this:
>
> Subject: genetlink: make netns aware
>
> This makes generic netlink network namespace aware.
> No actual generic netlink families are made namespace
> aware, they need to be checked one by one and then
> set the family->netnsok member to true.

Are skb_clone and nlmsg_multicast really guaranteed not to sleep?

That seems like a lot of code and a lot of code paths.

Eric
