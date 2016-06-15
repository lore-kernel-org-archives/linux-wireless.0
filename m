Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39882 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbcFORqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 13:46:21 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id DDF5240A959
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2016 10:46:20 -0700 (PDT)
Subject: Re: mac80211 splat with pktgen on hacked 4.4 kernel.
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <576192B2.3000304@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5761946C.80101@candelatech.com> (sfid-20160615_194625_284077_634E2EC3)
Date: Wed, 15 Jun 2016 10:46:20 -0700
MIME-Version: 1.0
In-Reply-To: <576192B2.3000304@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2016 10:38 AM, Ben Greear wrote:
> On 4.4.11 + local hacks, including fairly extensive pktgen changes....
>
> When I overdrive transmit on a station with pktgen, I see this
> splat hit below repeatedly.  Any ideas on what kinds of things
> might cause this?
>
>          while (!skb_queue_empty(&local->pending[i])) {
>              struct sk_buff *skb = __skb_dequeue(&local->pending[i]);
>              struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>
>              if (WARN_ON(!info->control.vif)) {
>                  ieee80211_free_txskb(&local->hw, skb);
>                  continue;
>              }
>

For instance, should this method below set the vif when it is queueing up a backlogged
frame when the queue is stopped?  Seems it only sets the vif it it is transmitting
the frame?

static bool ieee80211_tx_frags(struct ieee80211_local *local,
                                struct ieee80211_vif *vif,
                                struct ieee80211_sta *sta,
                                struct sk_buff_head *skbs,
                                bool txpending)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

