Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab0JALtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 07:49:51 -0400
Subject: Re: wireless-testing (2.6.36-rc6):  inconsistent {IN-SOFTIRQ-W} ->
 {SOFTIRQ-ON-W} usage.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	NetDev <netdev@vger.kernel.org>
In-Reply-To: <4CA4F000.2060509@candelatech.com>
References: <4CA4F000.2060509@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 13:49:49 +0200
Message-ID: <1285933789.3739.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 13:16 -0700, Ben Greear wrote:
> We saw this on a system that has two ath9k APs, some extra routing tables
> and rules to use them, and a user-space 'bridge' that uses packet-sockets.
> 
> Aside from a few patches to help virtualize wireless devices (and none directly to ath9k),
> this is today's wireless-testing tree.
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.36-rc6-wl+ #20
> ---------------------------------
> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> kworker/u:0/5 [HC0[0]:SC0[0]:HE1:SE1] takes:
>   (&(&list->lock)->rlock){+.?...}, at: [<c0741066>] packet_rcv+0x1f3/0x27a

I think this is due to

commit 5ed3bc7288487bd4f891f420a07319e0b538b4fe
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu Jun 24 14:38:30 2010 -0400

    mac80211: use netif_receive_skb in ieee80211_tx_status callpath


since

/**
 *      netif_receive_skb - process receive buffer from network
 *      @skb: buffer to process
 *
 *      netif_receive_skb() is the main receive data processing function.
 *      It always succeeds. The buffer may be dropped during processing   
 *      for congestion control or by the protocol layers.
 *
 *      This function may only be called from softirq context and interrupts
 *      should be enabled.

but we don't explicitly disable BHs. I suppose we should impose the same
on drivers calling ieee80211_tx_status().

johannes

