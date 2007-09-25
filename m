Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40778
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbXIYV1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 17:27:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Miller <davem@davemloft.net>
Subject: Re: zd1211 or mac80211: SKB invalid truesize
Date: Tue, 25 Sep 2007 23:25:02 +0200
Cc: johannes@sipsolutions.net, kune@deine-taler.de, dsd@gentoo.org,
	linux-wireless@vger.kernel.org
References: <200709252242.12331.mb@bu3sch.de> <20070925.141816.71108553.davem@davemloft.net>
In-Reply-To: <20070925.141816.71108553.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709252325.03360.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 September 2007 23:18:16 David Miller wrote:
> From: Michael Buesch <mb@bu3sch.de>
> Date: Tue, 25 Sep 2007 22:42:11 +0200
> 
> > I get dmesg spammed with the following message when
> > I connect to an open network with zd1211rw-mac80211.
> > I'm not sure if that's a bug in zd or mac80211.
> > Any idea how to debug this?
> > 
> > [  280.915811] SKB BUG: Invalid truesize (840) len=1440, sizeof(sk_buff)=168
> > 
> > The device keeps working fine while this spams dmesg.
> 
> For anyone who investigates this, the issue is that if there is a
> socket associated with an skb (ie. skb->sk is non-NULL) you cannot
> change the skb->truesize without also adjusting the memory accounted
> to the socket.
> 
> Otherwise when the SKB gets freed, the wrong amount of socket buffer
> memory allocation will be given back to the socket.
> 
> When the above message triggers, it means the skb->truesize is
> smaller than skb->len plus the size of struct sk_buff which is
> obviously completely bogus.

Yeah, well. But how can this happen? Someone assigning to skb->len?
zd1211 doesn't do this.
Any slight idea which (kind of) code could trigger this?

-- 
Greetings Michael.
