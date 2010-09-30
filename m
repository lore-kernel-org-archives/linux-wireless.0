Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44626 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab0I3Pb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 11:31:29 -0400
Message-ID: <4CA4AD40.1010309@candelatech.com>
Date: Thu, 30 Sep 2010 08:31:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] wireless:  Show sta_flags for status in /proc/net/wireless
References: <1285804637-5400-1-git-send-email-greearb@candelatech.com> <1285832587.3639.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285832587.3639.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2010 12:43 AM, Johannes Berg wrote:
> On Wed, 2010-09-29 at 16:57 -0700, greearb@candelatech.com wrote:
>
>> User-space can then decode the flags to determine associated,
>> scanning, and other states.
>
> I really don't think we should be extending the useful life of wireless
> extensions.
>
>
>>    * @signal: signal strength of last received packet in dBm
>> + * @status: ieee80211_sta_info_flags plus:  (1<<15) Scanning.
>
>
> And are you seriously proposing to make internal mac80211 flags part of
> the externally visible cfg80211 API??

It would of course be easy to map them to a stable set of flags, but if you
don't want to fix /proc/net/wireless anyway, then I might as well do minimal changes
to make it easier to keep the patch in my own tree.

Aside from listening to 'iw event', is there any way to know if a STA is scanning,
authenticated, associated, etc?  Some of this can be obtained from debugfs, but
that's not a fun api to code against...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
