Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:40069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbcDZQZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 12:25:17 -0400
Date: Tue, 26 Apr 2016 12:25:15 -0400 (EDT)
Message-Id: <20160426.122515.1389035390419695445.davem@davemloft.net> (sfid-20160426_182537_714161_EF495989)
To: lars.ellenberg@linbit.com
Cc: nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
	sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	drbd-dev@lists.linbit.com
Subject: Re: [PATCH net-next 0/8] netlink: align attributes when needed
 (patchset #3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20160426115427.GB20950@soda.linbit>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
	<20160426115427.GB20950@soda.linbit>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lars Ellenberg <lars.ellenberg@linbit.com>
Date: Tue, 26 Apr 2016 13:54:27 +0200

> On Tue, Apr 26, 2016 at 10:06:10AM +0200, Nicolas Dichtel wrote:
>> 
>> This is the continuation (series #3) of the work done to align netlink
>> attributes when these attributes contain some 64-bit fields.
>> 
>> It's the last patchset from what I've seen.
>> 
>> The last user of nla_put_u64() is block/drbd. This module does not use
>> standard netlink API (see all the stuff in include/linux/genl_magic_struct.h
>> and include/linux/genl_magic_func.h). I didn't modify it because it's seems
>> hard to do it whithout testing and fully understanding the context
> 
> Something like this should just work.

Unfortunately we had problems using unspec, that's why an explicit new
padding attribute is added for each netlink attribute set.
