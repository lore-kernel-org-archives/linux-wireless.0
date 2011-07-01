Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:38422 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab1GAWqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:46:21 -0400
Date: Fri, 01 Jul 2011 15:40:29 -0700 (PDT)
Message-Id: <20110701.154029.1235465964568585857.davem@davemloft.net> (sfid-20110702_004629_953370_717E0C4E)
To: tgraf@infradead.org
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, samuel@sortiz.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com,
	tgraf@suug.ch
Subject: Re: [PATCH] rtnl: provide link dump consistency info
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110621131120.GA19486@canuck.infradead.org>
References: <1308570046.4322.5.camel@jlt3.sipsolutions.net>
	<20110621131120.GA19486@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Graf <tgraf@infradead.org>
Date: Tue, 21 Jun 2011 09:11:20 -0400

> This patch adds a change sequence counter to each net namespace
> which is bumped whenever a netdevice is added or removed from
> the list. If such a change occurred while a link dump took place,
> the dump will have the NLM_F_DUMP_INTR flag set in the first
> message which has been interrupted and in all subsequent messages
> of the same dump.
> 
> Note that links may still be modified or renamed while a dump is
> taking place but we can guarantee for userspace to receive a
> complete list of links and not miss any.
> 
> Testing:
> I have added 500 VLAN netdevices to make sure the dump is split
> over multiple messages. Then while continuously dumping links in
> one process I also continuously deleted and re-added a dummy
> netdevice in another process. Multiple dumps per seconds have
> had the NLM_F_DUMP_INTR flag set.
> 
> I guess we can wait for Johannes patch to hit net-next via the
> wireless tree.  I just wanted to give this some testing right away.
> 
> Signed-off-by: Thomas Graf <tgraf@infradead.org>

Applied.
