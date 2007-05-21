Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:18721 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761261AbXEUOvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 10:51:52 -0400
Received: by an-out-0708.google.com with SMTP id d18so379400and
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2007 07:51:51 -0700 (PDT)
Message-ID: <4651B1FA.3010201@gmail.com>
Date: Mon, 21 May 2007 10:51:38 -0400
From: Florin Malita <fmalita@gmail.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jeff@garzik.org, dcbw@redhat.com, linville@tuxdriver.com,
	marcelo@kvack.org, linville@redhat.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: skb dereferenced after netif_rx
References: <20070518180903.GC3492@tuxdriver.com>	<1179622601.9453.4.camel@xo-28-0B-88.localdomain>	<464FA894.8090008@garzik.org> <20070520.003832.59470116.davem@davemloft.net>
In-Reply-To: <20070520.003832.59470116.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Sat, 19 May 2007 21:47:00 -0400
>   
>> According to the implementation, netif_rx() can fail.
>>     
>
> It doesn't exactly "fail", but it does give return values
> which indicate RX congestion.
>   

Assuming you're referring to NET_RX_CN_*, this doesn't seem to be the 
case anymore: it appears netif_rx can only return NET_RX_SUCCESS or 
NET_RX_DROP.

The congestion level constants are hardly used at all - if they are 
left-overs, would it make sense ripping them out completely?

Either way I believe the following should be OK:


Remove inaccurate netif_rx() return value comments.

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 dev.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f2b6111..79f5d90 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1628,9 +1628,6 @@ DEFINE_PER_CPU(struct netif_rx_stats, netdev_rx_stat) = { 0, };
  *
  *	return values:
  *	NET_RX_SUCCESS	(no congestion)
- *	NET_RX_CN_LOW   (low congestion)
- *	NET_RX_CN_MOD   (moderate congestion)
- *	NET_RX_CN_HIGH  (high congestion)
  *	NET_RX_DROP     (packet was dropped)
  *
  */

