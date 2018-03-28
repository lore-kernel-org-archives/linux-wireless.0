Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37366 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbeC1Eyo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 00:54:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 28 Mar 2018 10:24:43 +0530
From: vthiagar@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 2/4] nl80211/mac80211: Extend NoAck policy command with peer
 MAC address
In-Reply-To: <1522154870.3050.2.camel@sipsolutions.net>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <1522140171-10926-3-git-send-email-vthiagar@codeaurora.org>
 <1522154870.3050.2.camel@sipsolutions.net>
Message-ID: <bf1c7f4dc442e0e2807b520fe94d7ca2@codeaurora.org> (sfid-20180328_065447_872647_1FE68032)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-27 18:17, Johannes Berg wrote:
> On Tue, 2018-03-27 at 14:12 +0530, Vasanthakumar Thiagarajan wrote:
>> 
>> - * @set_noack_map: Set the NoAck Map for the TIDs.
>> + * @set_noack_map: Set the NoAck Map for the TIDs. When peer is not 
>> %NULL NoAck
>> + *	map will be applied for that particular peer. When peer is %NULL 
>> NoAck
>> + *	map will be applied for all the connected stations (except the 
>> ones
>> + *	which already have per-peer TID map configured) on the netdev.
>> + *	Driver should return -ENOSPC when the it does not have room for
>> + *	additional entries for per-peer NoAck map.
> 
> I guess it should also set the default for new stations when the peer 
> is
> not given? At least that's how mac80211 would behave now, afaict.

Sure. May be setting -1 as the default value when the per-peer NoAck 
policy is not
set would work.

> 
> The question is how that interacts with having enough space - are you
> sure this is a concern?

This will not be an issue at lest for ath10k. This is mainly for a 
(new)driver
which implements the offload but has limitation in supporting more than 
certain
number of peers. Perhaps we can remove it now and add it when such 
driver is
available?

> 
>>   * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs 
>> whether
>> - *      No Acknowledgement Policy should be applied.
>> + *	No Acknowledgement Policy should be applied. %NL80211_ATTR_MAC is 
>> used
>> + *	to apply No Acknowledgement policy for a particular connected 
>> station.
>> + *	Station specific NoAck policy configuration is valid only for 
>> STA's
>> + *	current connection, i.e. the configuration will not be used when 
>> the
>> + *	station connects back after disconnection/roaming.
>> + *	When user-space does not include %NL80211_ATTR_MAC, the No
>> + *	Acknowledgement Policy setting should be treated as per-netdev
>> + *	configuration.
> 
> Here you describe different semantics - i.e. you didn't describe the
> "previous per-station settings are kept" part. I'm not sure that part
> makes much sense anyhow?

Not sure I got this comment right. As mentioned in the doc, the previous 
settings
would be reset upon reconnection of the station and any ndev wide 
configuration
will be used. As mentioned above, additionally default value will be set 
to the
station to mark no per-station configuration is given so far.

Vasanth
