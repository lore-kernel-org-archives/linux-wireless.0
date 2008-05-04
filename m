Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39264
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbYEDWpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 18:45:40 -0400
Date: Sun, 04 May 2008 15:45:40 -0700 (PDT)
Message-Id: <20080504.154540.214129591.davem@davemloft.net> (sfid-20080505_004506_457145_60687AC9)
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209909990.3753.0.camel@johannes.berg>
References: <1209904088.4065.11.camel@johannes.berg>
	<20080504124542.GA1455@gondor.apana.org.au>
	<1209909990.3753.0.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 04 May 2008 16:06:30 +0200

> [  256.241496] KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc))
> failed at net/packet/af_packet.c (225)
> 
> any ideas about that?

This is exactly what happens if you change skb->truesize
when a socket is still attached to the skb.
