Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56814 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2E3QES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 12:04:18 -0400
Message-ID: <4FC644F8.8020606@candelatech.com> (sfid-20120530_180422_148301_113C3AC5)
Date: Wed, 30 May 2012 09:04:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Limit number of pending skbs.
References: <1338332576-26427-1-git-send-email-greearb@candelatech.com>  <4FC55A83.6030602@openwrt.org> <4FC55BE7.7010807@candelatech.com>  (sfid-20120530_012950_634296_DA1EEA8E) <1338361388.4511.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338361388.4511.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 12:03 AM, Johannes Berg wrote:
> On Tue, 2012-05-29 at 16:29 -0700, Ben Greear wrote:
>> On 05/29/2012 04:23 PM, Felix Fietkau wrote:
>>> On 2012-05-30 1:02 AM, greearb@candelatech.com wrote:
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> Current code will allow any number of pending skbs, and
>>>> this can OOM the system when used with something like
>>>> the pktgen tool (which may not back off properly if
>>>> queue is stopped).
>>>>
>>>> Possibly this is just a bug in our version of pktgen,
>>>> but either way, it seems reasonable to add a limit
>>>> so that it is not possible to go OOM in this manner.
>>>>
>>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>> Adding a module parameter in a workaround for a possibly broken module
>>> seems a bit excessive to me.
>>>
>>> Also, I'm not sure adding such a silent packet drop is a good idea. At
>>> the very least, it should complain loudly to encourage people to fix the
>>> actual bug instead of just papering over it.
>>>
>>> When the driver cannot accept more packets, the queue stop should
>>> prevent the network stack from spamming mac80211 with more packets. Your
>>> pktgen seems to be ignoring this, so please fix it instead of adding
>>> workarounds to mac80211.
>>
>> Ok, I'll work on pktgen next time I get a chance.
>>
>> I recall I had to add a hack (that was not wanted upstream)
>> to get pktgen to even work with mac80211 interfaces w/out crashing
>> the kernel, so probably no one else is using it anyway.
>
> There used to be bugs in this area in mac80211 and/or pktgen, and I
> remember crashing my machine very trivially. I don't think that this is
> still a problem though, but I haven't tried in a long time. FWIW, the
> time-frame of this must've been ~2-3 years ago.

I think it's still broken..I've been carrying this patch for a year or two:

 From 5ad8e96ace28d798214ba6e203d143e6380e0605 Mon Sep 17 00:00:00 2001
From: Ben Greear <greearb@candelatech.com>
Date: Tue, 14 Jun 2011 11:01:50 -0700
Subject: [PATCH 016/102] mac80211: Set up tx-queue-mapping in subif_start_xmit.

Otherwise, ath9k gets confused about which queue to use
and spews a warning like this when driving traffic with
pktgen.

WARNING: at /home/greearb/git/linux.wireless-testing-ct/drivers/net/wireless/ath/ath9k/xmit.c:1748 ath_tx_start+0x4a2/0x662 [ath9k]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 nfs lockd bluetooth cryptd aes_i586 aes_generic veth 8021q garp stp l]
Pid: 1729, comm: kpktgend_0 Tainted: G        W   2.6.38-rc4-wl+ #21
Call Trace:
  [<c043091b>] ? warn_slowpath_common+0x65/0x7a
  [<fabe784e>] ? ath_tx_start+0x4a2/0x662 [ath9k]
  [<c043093f>] ? warn_slowpath_null+0xf/0x13
  [<fabe784e>] ? ath_tx_start+0x4a2/0x662 [ath9k]
  [<fabe14d0>] ? ath9k_tx+0x14f/0x183 [ath9k]
  [<fab9026d>] ? __ieee80211_tx+0x10c/0x18c [mac80211]
  [<fab90397>] ? ieee80211_tx+0xaa/0x188 [mac80211]
  [<fab905f3>] ? ieee80211_xmit+0x17e/0x186 [mac80211]
  [<fab8ecc0>] ? ieee80211_skb_resize+0x8e/0xd2 [mac80211]
  [<fab9148b>] ? ieee80211_subif_start_xmit+0x643/0x65c [mac80211]
  [<c0440000>] ? rescuer_thread+0x25/0x1c8
  [<f92cd354>] ? pktgen_thread_worker+0x114c/0x1b44 [pktgen]
  [<fab90e48>] ? ieee80211_subif_start_xmit+0x0/0x65c [mac80211]
  [<c042d612>] ? default_wake_function+0xb/0xd
  [<c04254c7>] ? __wake_up_common+0x34/0x5c
  [<c0443a29>] ? autoremove_wake_function+0x0/0x2f
  [<f92cc208>] ? pktgen_thread_worker+0x0/0x1b44 [pktgen]
  [<c044371a>] ? kthread+0x62/0x67
  [<c04436b8>] ? kthread+0x0/0x67
  [<c04035f6>] ? kernel_thread_helper+0x6/0x10

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 e05667c... 1f026b5... M	net/mac80211/tx.c
  net/mac80211/tx.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e05667c..1f026b5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2072,6 +2072,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
  	} else
  		memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);

+	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
+
  	nh_pos += hdrlen;
  	h_pos += hdrlen;

-- 
1.7.3.4

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

