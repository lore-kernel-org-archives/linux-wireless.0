Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44935 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab0JEUwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 16:52:45 -0400
Message-ID: <4CAB9016.9050606@candelatech.com>
Date: Tue, 05 Oct 2010 13:52:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH wireless-2.6] mac80211: delete AddBA response timer
References: <1286307633.3641.29.camel@jlt3.sipsolutions.net>	 <1286309408.3641.31.camel@jlt3.sipsolutions.net>	 <4CAB8C39.5090201@candelatech.com> <1286311289.3641.34.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286311289.3641.34.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2010 01:41 PM, Johannes Berg wrote:
> On Tue, 2010-10-05 at 13:36 -0700, Ben Greear wrote:
>
>>>> I've reproduced the scenario and tested the fix.
>
>>> This fixes the crash reported at
>>> http://mid.gmane.org/4CAB6F96.6090701@candelatech.com
>>
>> I can no longer reproduce that problem, so it looks fixed
>> to me.
>
> Yeah .. I did actually go and reproduce the crash by strategically
> adding an msleep(200) to the mac80211 code and then doing some things
> from userspace :-)
>
>> The data corruption issue still exists, however...
>
> That looks very much like an ath9k issue, it seems like it's doing DMA
> into already freed SKBs. Come to think of it, maybe that wmb() patch
> might help?:

I can try it.  I've been trying to crawl through the rx path line by line,
and once you get into mac80211, it's a real slow slog for me :)

For what it's worth, ath9k looked pretty clean to me, but if it's
something clever like wmb() stuff, then I wouldn't notice anyway...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

