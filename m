Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:59792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbdJRLVa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 07:21:30 -0400
Date: Wed, 18 Oct 2017 12:21:24 +0100 (WEST)
Message-Id: <20171018.122124.1275281623792997169.davem@davemloft.net> (sfid-20171018_132141_304475_E3FA5CEF)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ebiederman@twitter.com, johannes.berg@intel.com
Subject: Re: [PATCH] netlink: use NETLINK_CB(in_skb).sk instead of looking
 it up
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171016145749.31793-1-johannes@sipsolutions.net>
References: <20171016145749.31793-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 16 Oct 2017 16:57:49 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> When netlink_ack() reports an allocation error to the sending
> socket, there's no need to look up the sending socket since
> it's available in the SKB's CB. Use that instead of going to
> the trouble of looking it up.
> 
> Note that the pointer is only available since Eric Biederman's
> commit 3fbc290540a1 ("netlink: Make the sending netlink socket availabe in NETLINK_CB")
> which is far newer than the original lookup code (Oct 2003)
> (though the field was called 'ssk' in that commit and only got
> renamed to 'sk' later, I'd actually argue 'ssk' was better - or
> perhaps it should've been 'source_sk' - since there are so many
> different 'sk's involved.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied to net-next.
