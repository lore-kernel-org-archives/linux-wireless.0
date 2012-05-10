Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49192 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751030Ab2EJBsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 21:48:06 -0400
Message-ID: <1336614484.1905.19.camel@joe2Laptop> (sfid-20120510_034913_960412_23C461B6)
Subject: Re: [PATCH 00/13] net: Add and use ether_addr_equal
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>,
	Julia Lawall <julia.lawall@lip6.fr>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Date: Wed, 09 May 2012 18:48:04 -0700
In-Reply-To: <20120509.212110.437114897180819434.davem@davemloft.net>
References: <cover.1336538937.git.joe@perches.com>
	 <20120509.212110.437114897180819434.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 21:21 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Tue,  8 May 2012 21:56:44 -0700
> 
> > Add a boolean function to test 2 ethernet addresses for equality
> > Convert compare_ether_addr uses to ether_addr_equal
> 
> This series looks great, I'll apply all of it.

coccinelle is a nifty, better sed, tool.  Thanks Julia et al.

> That case you didn't convert in mac80211 is probably the
> bug Johannes was talking about which started this whole
> discussion.

Looks like it.

Do you want a similar patch/patches for drivers/net?

If I break it out by nominal driver/maintainer,
it'll be a highish number of low density patches.

$ git grep -w compare_ether_addr drivers/net | wc -l
59
$ git grep -w -l compare_ether_addr drivers/net | wc -l
31

Maybe just a single patch?

Also the compare_ether_addr_64bits function is
still used a couple dozen times.  Maybe another
patch for those?  ether_addr_equal_64bits?


