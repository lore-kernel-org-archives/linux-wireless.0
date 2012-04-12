Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39177 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762772Ab2DLVVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:21:40 -0400
Message-ID: <4F874760.3070900@candelatech.com> (sfid-20120412_232149_900649_F4D82B9D)
Date: Thu, 12 Apr 2012 14:21:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Florian Fainelli <florian@openwrt.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] mac80211: Add more ethtools stats: survey, rates,
 etc
References: <1334248375-22967-1-git-send-email-greearb@candelatech.com>   <1334248375-22967-5-git-send-email-greearb@candelatech.com>   <4F8705E3.2010902@openwrt.org> <4F870828.4020708@candelatech.com>  <1334259053.2497.18.camel@bwh-desktop.uk.solarflarecom.com>  <4F873F10.6010207@candelatech.com> <1334264733.2497.35.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1334264733.2497.35.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2012 02:05 PM, Ben Hutchings wrote:
> On Thu, 2012-04-12 at 13:46 -0700, Ben Greear wrote:
>> On 04/12/2012 12:30 PM, Ben Hutchings wrote:
>>> On Thu, 2012-04-12 at 09:51 -0700, Ben Greear wrote:
>>>> On 04/12/2012 09:42 AM, Florian Fainelli wrote:
>>>>> Hi,
>>>>>
>>>>> Le 04/12/12 18:32, greearb@candelatech.com a écrit :
>>>>>> From: Ben Greear<greearb@candelatech.com>
>>>>>>
>>>>>> The signal and noise are forced to be positive since ethtool
>>>>>> deals in unsigned 64-bit values and this number should be human
>>>>>> readable. This gives easy access to some of the data formerly
>>>>>> exposed in the deprecated /proc/net/wireless file.
>>>>>
>>>>> Uh, that's misleading, the signal and noise values are typically negative, so one needs to think about mentally adding a minus sign if he/she wants to
>>>>> understand it. Does not ethtool know about 32-bits signed integers?
>>>>
>>>> Ethtool stats only supports u64.  I think it's easy enough for
>>>> humans or programs to add the negative sign.  Can signal or noise
>>>> ever be>   0?  If so, that could actually break something that depends
>>>> on flipping the value to negative....
>>>
>>> So far as I can see, the ethtool stats were expected to be counters,
>>> which obviously cannot become negative (or fractional).  Maybe it's time
>>> to define another command and string-set to cover other types of status
>>> information.  The ethtool utility could ask for those typed statistics
>>> as well, so 'ethtool -S' would get all of them.
>>
>> One nice thing about ethtool stats API is that it is backwards and forwards
>> compatible for a long while.
>
> Agreed.

> Actually it would be:
>
> foo:s32: 18446744073709551615
>
>> while a new one understand that the s32: prefix is special, do
>> some casting, and could show:
>> foo: -1
>>
>> Both are still at least somewhat human readable,
>
> I don't think many humans can mentally substract 2^64.

Well, if we add a new API, then anyone on older ethtool
won't see it at all, which is even more useless than a
large ugly number.

Those of us using ethtool API directly would have to add new
ioctl calls (and the performance is important to me, even
if atomicity isn't so important).  That is more work than
adding some logic to parse suffixes on the strings I think.

>> and probably wouldn't confuse anyone that is parsing the output of
>> existing ethtool output.
>
> I think you have this backwards: printing numbers in two different ways
> (old and new versions of ethtool) is likely to confuse scripts that are
> parsing and doing calculations with these numbers.  While I try to avoid
> gratuitous changes in output formatting, scripts should use the ethtool
> API if they really want interface stability.  It's not difficult (there
> are at least Python and Perl bindings available) and it's a lot more
> efficient.

If the new ethtool -S is going to nicely present things (ie, show "foo: -1"),
then the negative numbers are there anyway, so maybe the compatibility issue
for anyone parsing the output of 'ethtool -S' is moot.  Anyone parsing the
binary API sees no changes, but *could* update code to look at the suffix
if they cared.

That said, I *would* like a new 'ethool get-stats' API that took a 'verbose'
argument so that we could return more or less verbose results (dependent on the
driver to determine what that means).  That way, we could probe easy-to-obtain
information quickly and often, and if there is something more expensive to obtain,
that could be probed less often.  If this idea is worth pursuing, then perhaps
it could also include a new binary API that includes a type identifier.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

