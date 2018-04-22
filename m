Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:39934 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753426AbeDVSyW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 14:54:22 -0400
Date: Sun, 22 Apr 2018 14:54:20 -0400 (EDT)
Message-Id: <20180422.145420.1197041027922699603.davem@davemloft.net> (sfid-20180422_205426_785810_8822E20A)
To: johannes@sipsolutions.net
Cc: greearb@candelatech.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1524151617.3024.25.camel@sipsolutions.net>
References: <1524119910.3024.12.camel@sipsolutions.net>
        <173c5f98-36bc-2e52-1e64-3a5f89008d46@candelatech.com>
        <1524151617.3024.25.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 19 Apr 2018 17:26:57 +0200

> On Thu, 2018-04-19 at 08:25 -0700, Ben Greear wrote:
>> 
>> Maybe this could be in followup patches?  It's going to touch a lot of files,
>> and might be hell to get merged all at once, and I've never used spatch, so
>> just maybe someone else will volunteer that part :)
> 
> I guess you'll have to ask davem. :)

Well, first of all, I really don't like this.

The first reason is that every time I see interface foo become foo2,
foo3 is never far behind it.

If foo was not extensible enough such that we needed foo2, we beter
design the new thing with explicitly better extensibility in mind.

Furthermore, what you want here is a specific filter.  Someone else
will want to filter on another criteria, and the next person will
want yet another.

This needs to be properly generalized.

And frankly if we had moved to ethtool netlink/devlink by now, we
could just add a netlink attribute for filtering and not even be
having this conversation.
