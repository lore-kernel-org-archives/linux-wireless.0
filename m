Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36665 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1ANXZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 18:25:04 -0500
Message-ID: <4D30DB49.8030708@candelatech.com>
Date: Fri, 14 Jan 2011 15:24:57 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [RFC 1/2] ath9k: Fix up hardware mode and beacons with multiple
 vifs.
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com> <AANLkTi=WTUiy1DYNhE12_KZp8QFUrWebY2Cpzud5P0b3@mail.gmail.com>
In-Reply-To: <AANLkTi=WTUiy1DYNhE12_KZp8QFUrWebY2Cpzud5P0b3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2011 03:19 PM, Björn Smedman wrote:
> On Fri, Jan 14, 2011 at 6:27 PM,<greearb@candelatech.com>  wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> When using a mixture of AP and Station interfaces,
>> the hardware mode was using the type of the
>> last VIF registered.  Instead, we should keep track
>> of the number of different types of vifs and set the
>> mode accordingly.
>
> Thank you for your efforts to get multi-vifs working better.
>
> This is another comment that is a little out of place but when I see
> the identifier beacon_interval in this context I cannot help bringing
> up per-vif settings as a related problem: If I read the code (or
> rather the lack of code) correctly the beacon interval of the last (or
> first?) beaconing vif added will be used to set up beacon tx, whereas
> the actual beacon contents will reflect the beacon intervals
> configured for individual vifs which may all be different... The same
> goes for e.g. tx queue configuration, no?
>
> It feels like we need a general multi-vif cleanup here but it's too
> big for me unfortunately.

I haven't looked at beacons in that detail yet.

If I can get agreement on the current patch (and the dozen or so preceding it),
then I can take a closer look at beacon intervals.  I don't think that needs to
be done as part of this vif/opmode/beaconing cleanup though.

New patch is coming shortly, as soon as I get some testing completed.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

