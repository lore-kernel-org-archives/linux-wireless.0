Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36284 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab0I3Qt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 12:49:27 -0400
Message-ID: <4CA4BF91.8070008@candelatech.com>
Date: Thu, 30 Sep 2010 09:49:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] wireless:  Show sta_flags for status in /proc/net/wireless
References: <1285804637-5400-1-git-send-email-greearb@candelatech.com>	 <1285832587.3639.1.camel@jlt3.sipsolutions.net>	 <4CA4AD40.1010309@candelatech.com> <1285861161.5137.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285861161.5137.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2010 08:39 AM, Johannes Berg wrote:
> On Thu, 2010-09-30 at 08:31 -0700, Ben Greear wrote:
>
>> It would of course be easy to map them to a stable set of flags, but if you
>> don't want to fix /proc/net/wireless anyway, then I might as well do minimal changes
>> to make it easier to keep the patch in my own tree.
>>
>> Aside from listening to 'iw event', is there any way to know if a STA is scanning,
>> authenticated, associated, etc?  Some of this can be obtained from debugfs, but
>> that's not a fun api to code against...
>
> You can't get scanning, but auth/assoc should be visible in "iw dev
> <iface>  scan dump"

I find it a bit frustrating that it takes so many different commands
to find the information I'm looking for.

It looks like I'll need to integrate at least:

The information for the in-use BSS from 'scan dump', the info
from 'info', 'survey dump' for the active channel,
'station dump' (with additional of at least the counters that
used to be found in /proc/net/wireless),

If I were only doing one or two STA interfaces, that's not so bad,
but if I want to do hundreds, and update info relatively often,
that's going to be a lot of overhead!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

