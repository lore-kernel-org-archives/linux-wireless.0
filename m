Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45382
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095Ab1CPRiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 13:38:15 -0400
Date: Wed, 16 Mar 2011 10:38:52 -0700 (PDT)
Message-Id: <20110316.103852.193714733.davem@davemloft.net>
To: tgraf@infradead.org
Cc: jpirko@redhat.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
	eric.dumazet@gmail.com, linville@tuxdriver.com, kaber@trash.net
Subject: Re: net-next-2.6 status...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110316084739.GD26145@canuck.infradead.org>
References: <20110316073803.GB2780@psychotron.redhat.com>
	<20110316084022.GA2845@psychotron.brq.redhat.com>
	<20110316084739.GD26145@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Graf <tgraf@infradead.org>
Date: Wed, 16 Mar 2011 04:47:39 -0400

> On Wed, Mar 16, 2011 at 09:40:23AM +0100, Jiri Pirko wrote:
>> >What do you suggest? To remove unused flags and leave gaps there or to
>> >not to remove the flags at all?
>> 
>> Well, the following comment:
>> <quote>
>> /* Private (from user) interface flags (netdevice->priv_flags). */
>> </quote>
>> leads me to think that these flags should not be used by userspace.
>> So maybe it may not be problem to change those values.
> 
> These flags should be moved to linux/netdevice.h

We've had them exposed in a header file without __KERNEL__ protection
for a long time, the cat is therefore out of the bag and it's too late
to just remove them from user visibility as if they were not there.
