Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [66.209.47.173] ([66.209.47.173]:43066 "EHLO mythtv.ewol.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758297AbYG0VyS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 17:54:18 -0400
Message-ID: <488CEDD1.1000901@cortland.com> (sfid-20080727_235421_454487_EA7F9B3D)
Date: Sun, 27 Jul 2008 17:51:13 -0400
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: [PATCH 4/4] mac80211: revamp beacon configuration
References: <20080709124033.781606000@sipsolutions.net> <20080709124255.193524000@sipsolutions.net> <200807091529.20656.mb@bu3sch.de>
In-Reply-To: <200807091529.20656.mb@bu3sch.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 09 July 2008 14:40:37 Johannes Berg wrote:
>   
>> This patch changes mac80211's beacon configuration handling
>> to never pass skbs to the driver directly but rather always
>> require the driver to use ieee80211_beacon_get(). Additionally,
>> it introduces "change flags" on the config_interface() call
>> to enable drivers to figure out what is changing. Finally, it
>> removes the beacon_update() driver callback in favour of
>> having IBSS beacon delivered by ieee80211_beacon_get() as well.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>>
>>     
I tested using the current wireless-testing and beacons are gone.

If I revert this patch they reappear.

I'm using the zd1211rw driver on an x86. I also confirmed the missing 
beacons using b43, although I haven't tried the reverted patch on that 
machine.

I'm not sure what other info to provide. Let me know if anything else is 
needed and I'll send post it.

Steve

