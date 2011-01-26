Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58863 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZR2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 12:28:36 -0500
Message-ID: <4D4059BE.4020701@candelatech.com>
Date: Wed, 26 Jan 2011 09:28:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating channel.
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com>	 <1295774293.3639.15.camel@jlt3.sipsolutions.net>	 <4D3DF93B.1030702@candelatech.com> <1296055323.3635.34.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296055323.3635.34.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2011 07:22 AM, Johannes Berg wrote:
> On Mon, 2011-01-24 at 14:12 -0800, Ben Greear wrote:
>> On 01/23/2011 01:18 AM, Johannes Berg wrote:
>>
>>> Also, are you sure the filter configuration works correctly this way? If
>>> you can, I'd like to look at a binary trace of the commands going to the
>>> device with this change: "trace-cmd record -e mac80211".
>>
>> I uploaded two trace files.  One that scans the single operating
>> channel, and a second that scans all channels.  This is with my -v2
>> patch applied, using ath9k as the driver.  There are two virtual
>> STA interfaces configured on this system for this test.
>>
>>
>> http://www.candelatech.com/~greearb/trace-scan-all.dat.bz2
>> http://www.candelatech.com/~greearb/trace-scan-one.dat.bz2
>>
>> Please let me know what you think.
>
> Thanks. I don't think the -one one really is just a single scan? But
> anyway, looking at it now.

No, sorry..it's probably several scans and other things..but it should
not scan more than one (operating) channel.

Also, I'm seeing problems where sometimes wpa_supplicant doesn't
see scan results when scanning a single operating channel.  I think this is
probably a bug in my mac80211 patch.  I plan to look at that in
detail today.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

