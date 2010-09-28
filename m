Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34551 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0I1Nue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 09:50:34 -0400
Message-ID: <4CA1F2A4.2090005@candelatech.com>
Date: Tue, 28 Sep 2010 06:50:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211:  Allow scanning single channel if other
 VIF is associated.
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>	 <1285632457-27539-2-git-send-email-greearb@candelatech.com> <1285658564.3885.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285658564.3885.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 12:22 AM, Johannes Berg wrote:
> On Mon, 2010-09-27 at 17:07 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This patch aims to decrease channel switching when there is at least one
>> interface associated.  This should help multiple station interfaces co-exist
>> on the same hardware, especially in WPA mode.
>
> Totally NACK. The code is ugly, complex, and unnecessary.
>
> You can make wpa_s scan the channels one by one, or you can improve the
> off-channel behaviour, but this is a workaround that just isn't
> appropriate.

At best, it would be a race for wpa_s to determine if any other interface
on it's interface's hardware is associated, so I don't see a good way to
do this in user-space.

When at least one is associated, I don't want the NIC to go offchannel at all,
at least not for wpa_s scanning.  Anything else is going to interrupt other
stations's traffic, and for no good reason that I can see, since the scanning
interface must associate on the same channel as the rest of the stations
anyway.

If you have any suggestions for how to accomplish this, please let me know..
otherwise, I can just carry this patch in my tree.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
