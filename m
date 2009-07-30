Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53955 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZG3Olo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 10:41:44 -0400
Message-ID: <4A71B10E.20808@candelatech.com>
Date: Thu, 30 Jul 2009 07:41:18 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>	 <4A70C17B.6090309@candelatech.com> <1248949853.29062.3.camel@johannes.local>
In-Reply-To: <1248949853.29062.3.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-07-29 at 14:39 -0700, Ben Greear wrote:
>   
>> On 07/29/2009 02:32 PM, Reinette Chatre wrote:
>>     
>>> From: Reinette Chatre<reinette.chatre@intel.com>
>>>
>>> The connection monitor currently relies on probe requests paired
>>> with probe responses to ensure that a connection is alive. This is
>>> fragile in some environments where probe responses can get lost.
>>> When we receive beacons we can also consider the connection to be
>>> alive, so cancel connection poll instance when we receive a beacon.
>>>       
>> I'm chasing a similar problem while working on virtual STA device
>> support in ath5k.  I was also going to try sending up to 3 polls before
>> giving up on the connection.  Does that seems like a valid thing to do?
>>     
>
> That seems somewhat better, yeah.
>
> I suspect the real cause of the issue is something else though, like the
> probe request not going out properly or the card being in a kind of
> 'temporary lock-up' state where it's not really doing anything for the
> time being -- I've never had a problem on any other (than iwlwifi)
> hardware.
>
> Of course, the virtual STA device support stuff potentially has similar
> issues, especially if it does channel switching like the ath9k virtual
> wiphy stuff.
>   
We're not trying any channel switching, though it does seem to stop 
transmitting
and/or receiving for a bit during some operations.  The retransmit logic 
was helping,
but it still isn't quite right.  Hopefully we'll make more progress today.

Thanks,
Ben
> johannes
>   


-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


