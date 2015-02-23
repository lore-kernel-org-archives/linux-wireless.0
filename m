Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54863 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbBWRiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 12:38:18 -0500
Message-ID: <54EB6589.6040803@candelatech.com> (sfid-20150223_183822_317203_48CAED2D)
Date: Mon, 23 Feb 2015 09:38:17 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211-hwsim:  Don't enqueue pkts that do not want
 txstatus.
References: <1423592732-17256-1-git-send-email-greearb@candelatech.com> <1424707739.3075.19.camel@sipsolutions.net>
In-Reply-To: <1424707739.3075.19.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2015 08:08 AM, Johannes Berg wrote:
> On Tue, 2015-02-10 at 10:25 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Otherwise, skb is not cleaned up until there is some timeout
>> and the tx-queue quickly becomes overly full.
> 
>> +++ b/drivers/net/wireless/mac80211_hwsim.c
>> @@ -928,10 +928,14 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
>>  	genlmsg_end(skb, msg_head);
>>  	genlmsg_unicast(&init_net, skb, dst_portid);
>>  
>> -	/* Enqueue the packet */
>> -	skb_queue_tail(&data->pending, my_skb);
>>  	data->tx_pkts++;
>>  	data->tx_bytes += my_skb->len;
>> +
>> +	/* Enqueue the packet if we are expecting a tx-status response */
>> +	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
>> +		skb_queue_tail(&data->pending, my_skb);
>> +	else
>> +		ieee80211_free_txskb(hw, my_skb);
> 
> This doesn't really seem right - essentially it means that whatever you
> just gave to userspace is now completely useless?
> 
> It seems skb_orphan() could/should be put here.

I don't understand your complaint, why is what I gave to user-space useless?

If we just orphan them, does that clean up the skb memory properly?

If not, what eventually frees the skb?

Thanks,
Ben

> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

