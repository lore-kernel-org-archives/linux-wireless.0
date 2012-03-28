Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53686 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2C1TKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 15:10:13 -0400
Message-ID: <4F73620D.507@candelatech.com> (sfid-20120328_211018_039571_C9F11B1E)
Date: Wed, 28 Mar 2012 12:10:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bryan Phillippe <Bryan.Phillippe@watchguard.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
References: <4F57B7E6.1050103@candelatech.com>  <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>  <4F735EF5.3010708@candelatech.com> <1332961193.3479.40.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332961193.3479.40.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2012 11:59 AM, Johannes Berg wrote:
> On Wed, 2012-03-28 at 11:56 -0700, Ben Greear wrote:
>> On 03/07/2012 11:45 AM, Bryan Phillippe wrote:
>>>
>>> Yes, it's a known problem.  It's very reproducible for me on a non-hacked 3.3-rc1 as well: changing from AP to client mode, or setting up multiple APs, or changing from 2.4Ghz to 5Ghz all seem to trigger this warning with various stack traces.
>>
>> I'm still seeing this and related warnings on 3.3.0.  At least some
>> of them comes from calls the 'hostapd' process makes (I printed
>> current->comm in the warning).
>>
>> I am not having luck writing a simple script that reproduce this,
>> but my application that creates a VAP and bunch of virtual station
>> hits it every time on startup.
>>
>> Bryan:  Do you have a simple script that reproduces this problem?
>>
>> Johannes:  Any ideas on likely causes of this problem?  Might help
>> me zero in on the problem quicker...
>
> Hm. Maybe this is the problem?
>
> http://p.sipsolutions.net/d432de678ae3ff17.txt

I don't see any code that matches that in 3.3.0 (nothing with nl80211_start_ap, for instance)

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

