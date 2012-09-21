Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:50565 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab2IURYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 13:24:48 -0400
Date: Fri, 21 Sep 2012 13:24:45 -0400 (EDT)
Message-Id: <20120921.132445.72763806946072284.davem@davemloft.net> (sfid-20120921_192455_962856_BF59CC54)
To: eric.dumazet@gmail.com
Cc: artem.bityutskiy@linux.intel.com, edumazet@google.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348151149.31352.109.camel@edumazet-glaptop>
References: <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com>
	<1348147353.2388.19.camel@sauron.fi.intel.com>
	<1348151149.31352.109.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 20 Sep 2012 16:25:49 +0200

> Please remove this hack and try the following bugfix in raw handler
> 
> icmp_filter() should not modify skb, or else its caller should not
> assume ip_hdr() is unchanged.

Right, good catch.

Please submit this fix formally Eric, thanks a lot.
