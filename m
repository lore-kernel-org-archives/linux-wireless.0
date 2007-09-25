Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57238
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbXIYVSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 17:18:32 -0400
Date: Tue, 25 Sep 2007 14:18:16 -0700 (PDT)
Message-Id: <20070925.141816.71108553.davem@davemloft.net>
To: mb@bu3sch.de
Cc: johannes@sipsolutions.net, kune@deine-taler.de, dsd@gentoo.org,
	linux-wireless@vger.kernel.org
Subject: Re: zd1211 or mac80211: SKB invalid truesize
From: David Miller <davem@davemloft.net>
In-Reply-To: <200709252242.12331.mb@bu3sch.de>
References: <200709252242.12331.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>
Date: Tue, 25 Sep 2007 22:42:11 +0200

> I get dmesg spammed with the following message when
> I connect to an open network with zd1211rw-mac80211.
> I'm not sure if that's a bug in zd or mac80211.
> Any idea how to debug this?
> 
> [  280.915811] SKB BUG: Invalid truesize (840) len=1440, sizeof(sk_buff)=168
> 
> The device keeps working fine while this spams dmesg.

For anyone who investigates this, the issue is that if there is a
socket associated with an skb (ie. skb->sk is non-NULL) you cannot
change the skb->truesize without also adjusting the memory accounted
to the socket.

Otherwise when the SKB gets freed, the wrong amount of socket buffer
memory allocation will be given back to the socket.

When the above message triggers, it means the skb->truesize is
smaller than skb->len plus the size of struct sk_buff which is
obviously completely bogus.
