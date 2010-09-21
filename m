Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33960 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab0IUT36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:29:58 -0400
Message-ID: <4C9907B2.4050503@candelatech.com>
Date: Tue, 21 Sep 2010 12:29:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211/ath9k] mac80211/ath9k:  Support AMPDU with multiple
 VIFs.
References: <1285095455-29081-1-git-send-email-greearb@candelatech.com>	 <1285096048.12764.9.camel@jlt3.sipsolutions.net>	 <4C9904AE.7060107@candelatech.com> <1285096749.12764.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285096749.12764.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 12:19 PM, Johannes Berg wrote:
> On Tue, 2010-09-21 at 12:17 -0700, Ben Greear wrote:
>> The tx path doesn't seem to pass in more than the hardware and the skb,
>> and we don't always need to lookup the VIF, so looking it up early is
>> probably a waste.
>>
>> mac80211 could be changed to pass in the VIF in the xmit path,
>> and then we could make sure that is passed through the entire
>> xmit process, but that would touch a lot of drivers and code.
>
> It does pass this through in the skb's CB.

>> I'm more than happy to test any patches if someone thinks up
>> a different approach.
>
> I just don't want drivers using struct net_device pointers anywhere,
> because they shouldn't have to worry about them.

Can we just use:
sta = tx_info->control.sta
in ath_tx_complete_aggr()
?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

