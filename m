Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42593 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0I1PRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:17:09 -0400
Message-ID: <4CA206F0.40607@candelatech.com>
Date: Tue, 28 Sep 2010 08:17:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211:  Allow scanning single channel if other
 VIF is associated.
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>	 <1285632457-27539-2-git-send-email-greearb@candelatech.com>	 <1285658564.3885.1.camel@jlt3.sipsolutions.net>	 <4CA1F2A4.2090005@candelatech.com> <1285682224.3885.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285682224.3885.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 06:57 AM, Johannes Berg wrote:
> On Tue, 2010-09-28 at 06:50 -0700, Ben Greear wrote:
>
>> At best, it would be a race for wpa_s to determine if any other interface
>> on it's interface's hardware is associated, so I don't see a good way to
>> do this in user-space.
>>
>> When at least one is associated, I don't want the NIC to go offchannel at all,
>> at least not for wpa_s scanning.  Anything else is going to interrupt other
>> stations's traffic, and for no good reason that I can see, since the scanning
>> interface must associate on the same channel as the rest of the stations
>> anyway.
>>
>> If you have any suggestions for how to accomplish this, please let me know..
>> otherwise, I can just carry this patch in my tree.
>
> You can run all networks in a single wpa_s instance, I believe, and then
> it'd know about all this, right?

But then, if you want to add an additional interface, you have to restart
everything.

I was thinking that maybe I could keep the logic in wpa_s, but instead of
all the special casing, just locate the current associated channel for the
phy in question and populate the scan-req with that single channel.

Then, I think I wouldn't have to muck with much of the scan logic..just
a bit of code on the entry point to select the proper channel.

Does that sound like a possible solution to you?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
