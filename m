Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45506 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbbKPSQm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 13:16:42 -0500
Subject: Re: [question] Rate control algorithm for mesh
To: ferran <ranker72@gmail.com>, linux-wireless@vger.kernel.org
References: <5649FE1F.4060203@gmail.com>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <564A1D7F.6050201@openwrt.org> (sfid-20151116_191645_843087_0DAC3B64)
Date: Mon, 16 Nov 2015 19:16:31 +0100
MIME-Version: 1.0
In-Reply-To: <5649FE1F.4060203@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-11-16 17:02, ferran wrote:
> Hello everybody,
> 
> I would like to know if there is a transmit rate control algorithm out
> there that takes into account the destination MAC address. My setting is
> like this:
> 
> [node0]·  ·  ·  ·  ·[node1]············[node2]
> 
> Where the spaced pattern means a poor connection and the densely dotted
> pattern means a good connection.
> 
> The problem here is that node1 oscillates between fast rates and slow
> rates, as when transmitting to node0 it must reduce the rate, and when
> transmitting to node2 it increases the rate since it must take profit of
> the channel. I am therefore getting many re-tx between n1 and n0, and
> n1-->n2 isn't as fast as it could.
> 
> Currently I am using the PID-based RC, but I'm afraid that this problem
> isn't adressed at Minstrel neither.
> Am I wrong?
Rate control instances are always per sta (so per 802.11 destination).
The problem you are describing either doesn't exist, or is something
different from what you're describing.
I would recommend running a test with latest mac80211 and minstrel(_ht),
it should perform much better than PID.

- Felix
