Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46375 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762742Ab2DLUqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 16:46:14 -0400
Message-ID: <4F873F10.6010207@candelatech.com> (sfid-20120412_224619_547532_531D01EB)
Date: Thu, 12 Apr 2012 13:46:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Florian Fainelli <florian@openwrt.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] mac80211: Add more ethtools stats: survey, rates,
 etc
References: <1334248375-22967-1-git-send-email-greearb@candelatech.com>  <1334248375-22967-5-git-send-email-greearb@candelatech.com>  <4F8705E3.2010902@openwrt.org> <4F870828.4020708@candelatech.com> <1334259053.2497.18.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1334259053.2497.18.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2012 12:30 PM, Ben Hutchings wrote:
> On Thu, 2012-04-12 at 09:51 -0700, Ben Greear wrote:
>> On 04/12/2012 09:42 AM, Florian Fainelli wrote:
>>> Hi,
>>>
>>> Le 04/12/12 18:32, greearb@candelatech.com a écrit :
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> The signal and noise are forced to be positive since ethtool
>>>> deals in unsigned 64-bit values and this number should be human
>>>> readable. This gives easy access to some of the data formerly
>>>> exposed in the deprecated /proc/net/wireless file.
>>>
>>> Uh, that's misleading, the signal and noise values are typically negative, so one needs to think about mentally adding a minus sign if he/she wants to
>>> understand it. Does not ethtool know about 32-bits signed integers?
>>
>> Ethtool stats only supports u64.  I think it's easy enough for
>> humans or programs to add the negative sign.  Can signal or noise
>> ever be>  0?  If so, that could actually break something that depends
>> on flipping the value to negative....
>
> So far as I can see, the ethtool stats were expected to be counters,
> which obviously cannot become negative (or fractional).  Maybe it's time
> to define another command and string-set to cover other types of status
> information.  The ethtool utility could ask for those typed statistics
> as well, so 'ethtool -S' would get all of them.

One nice thing about ethtool stats API is that it is backwards and forwards
compatible for a long while.  Also, adding a new API means a second call
into the kernel (most likely) for the other set of strings, which effectively
doubles the cost of getting stats (and allows the stats to be updated
out-of-sync with each other more easily).

I wonder if instead we could add a convention where we add a short
prefix (or suffix) to a string to denote it's type (and cast the value
into u64).  So, an old ethtool might see:

foo:s32: 4294967295

while a new one understand that the s32: prefix is special, do
some casting, and could show:
foo: -1

Both are still at least somewhat human readable, and probably wouldn't
confuse anyone that is parsing the output of existing ethtool output.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

