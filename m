Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:33948 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaICFDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 01:03:37 -0400
Date: Tue, 02 Sep 2014 15:03:26 -0700 (PDT)
Message-Id: <20140902.150326.1420682815750767731.davem@davemloft.net> (sfid-20140903_070345_892473_02D849D2)
To: hideaki.yoshifuji@miraclelinux.com
Cc: johannes@sipsolutions.net, hannes@stressinduktion.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	yoshfuji@linux-ipv6.org
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
From: David Miller <davem@davemloft.net>
In-Reply-To: <540675F2.1030308@miraclelinux.com>
References: <1409133238.26515.13.camel@localhost>
	<1409650573.1808.11.camel@jlt4.sipsolutions.net>
	<540675F2.1030308@miraclelinux.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Date: Wed, 03 Sep 2014 10:59:14 +0900

> Upper-layer needs to cope eith situation of seeing packets with
> "incorrect" L2 header anyway (e.g., in promiscous mode).
> I do not see much advantage to drop them here.

It's required to prevent wireless nodes from using the shared wireless
group keys (used for multicast transmission) to inject unicast frames.

The RFCs really do specify this at least on the ipv4 side.
