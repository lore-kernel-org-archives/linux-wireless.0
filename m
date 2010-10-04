Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38532 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab0JDR5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:57:45 -0400
Message-ID: <4CAA158F.10108@candelatech.com>
Date: Mon, 04 Oct 2010 10:57:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: wireless-testing (2.6.36-rc6):  inconsistent {IN-SOFTIRQ-W} ->
 {SOFTIRQ-ON-W} usage.
References: <4CA4F000.2060509@candelatech.com> <1285933789.3739.34.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285933789.3739.34.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2010 04:49 AM, Johannes Berg wrote:
> On Thu, 2010-09-30 at 13:16 -0700, Ben Greear wrote:
>> We saw this on a system that has two ath9k APs, some extra routing tables
>> and rules to use them, and a user-space 'bridge' that uses packet-sockets.
>>
>> Aside from a few patches to help virtualize wireless devices (and none directly to ath9k),
>> this is today's wireless-testing tree.
>>
>> =================================
>> [ INFO: inconsistent lock state ]
>> 2.6.36-rc6-wl+ #20
>> ---------------------------------
>> inconsistent {IN-SOFTIRQ-W} ->  {SOFTIRQ-ON-W} usage.
>> kworker/u:0/5 [HC0[0]:SC0[0]:HE1:SE1] takes:
>>    (&(&list->lock)->rlock){+.?...}, at: [<c0741066>] packet_rcv+0x1f3/0x27a
>
> I think this is due to
>
> commit 5ed3bc7288487bd4f891f420a07319e0b538b4fe
> Author: John W. Linville<linville@tuxdriver.com>
> Date:   Thu Jun 24 14:38:30 2010 -0400
>
>      mac80211: use netif_receive_skb in ieee80211_tx_status callpath

Before I go hacking on this, is anyone already working on it?

Thanks,
Ben

>
>
> since
>
> /**
>   *      netif_receive_skb - process receive buffer from network
>   *      @skb: buffer to process
>   *
>   *      netif_receive_skb() is the main receive data processing function.
>   *      It always succeeds. The buffer may be dropped during processing
>   *      for congestion control or by the protocol layers.
>   *
>   *      This function may only be called from softirq context and interrupts
>   *      should be enabled.
>
> but we don't explicitly disable BHs. I suppose we should impose the same
> on drivers calling ieee80211_tx_status().
>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

