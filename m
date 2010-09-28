Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57337 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0I1Nkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 09:40:49 -0400
Message-ID: <4CA1F05C.10705@candelatech.com>
Date: Tue, 28 Sep 2010 06:40:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Given an interface, how to tell if it's associated?
References: <4CA12600.5070304@candelatech.com> <1285658613.3885.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285658613.3885.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 12:23 AM, Johannes Berg wrote:
> On Mon, 2010-09-27 at 16:17 -0700, Ben Greear wrote:
>> I need to iterate through all local->interfaces and
>> if they are stations, figure out if they are associated
>> or not.
>>
>> I tried checking for existence of sdata->u.mgd.associated,
>> but it is always null (I'm using non-encrypted links
>> currently, in case that matters.)
>
> That's correct, if it's always NULL then you're not associated properly
> I guess?

Well, it seemed to work and passed traffic fine, so I'm at a loss.  Perhaps
it just wasn't associated while one of the stations was scanning.

Either way, I added logic to iterate through all stas and check it's
flags, and that seems to work (see the can_scan_one patch logic I posted).

Thanks,
Ben


>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
