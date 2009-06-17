Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:53705 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763485AbZFQXZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 19:25:02 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
References: <1245263058.31588.38.camel@johannes.local>
	<m1y6rqwpur.fsf@fess.ebiederm.org>
	<1245276899.31588.57.camel@johannes.local>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 16:24:58 -0700
In-Reply-To: <1245276899.31588.57.camel@johannes.local> (Johannes Berg's message of "Thu\, 18 Jun 2009 00\:14\:59 +0200")
Message-ID: <m1r5xitpdh.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: [PATCH] wireless extensions: play with netns
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-06-17 at 13:46 -0700, Eric W. Biederman wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > This makes wireless extensions netns aware.
>> >
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> > ---
>> > Is this ok, or is this racy? I guess what I'm asking is -- will
>> > for_each_net() stop iterating over a netns that is going away before the
>> > pernet exit op is called? If yes, this should be fine.
>> 
>> for_each_net requires the rtnl_lock or the net_mutex to be safe.
>> You aren't taking either so your code is racy.
>
> So it looks like I can also use rcu_read_lock(), but there's no
> for_each_net_rcu(), should there be?

I'm not using rcu safe list manipulation.  What makes it look like
rcu_read_lock() is safe?

Eric
