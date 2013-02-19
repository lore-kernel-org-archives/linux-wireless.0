Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50626 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020Ab3BSWxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 17:53:05 -0500
Message-ID: <51240249.6060801@candelatech.com> (sfid-20130219_235310_043517_BFB97404)
Date: Tue, 19 Feb 2013 14:52:57 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash on removal of 400 interfaces (3.7.6+)
References: <5122A7C7.3070508@candelatech.com>  (sfid-20130218_231436_933191_3F8FE600) <1361225773.8555.50.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361225773.8555.50.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 02:16 PM, Johannes Berg wrote:
> On Mon, 2013-02-18 at 14:14 -0800, Ben Greear wrote:
>> We often see crashes in work-queue processing when deleting
>> lots of wifi station interfaces.  I'm guessing that there is probably
>> a work item that was not properly un-registered before deleting
>> memory.  I have backported some wifi fixes from upstream, so
>> maybe they are to blame, but in case anyone has any suggestions
>> for places to look, please let me know.
>
> Enable CONFIG_DEBUG_OBJECTS and CONFIG_DEBUG_OBJECTS_WORK :)

That did not catch anything.

I have another data point that may shed some light:  The test
case actually deletes the AP (on another machine) at the same
time it starts tearing down 200 stations on the first machine.

So, we are manually tearing down stations at the same time they
start timing out due to the AP disappearing, and any un-registering
that the stations might try are probably going to hit some failure cases
because the AP is of course not answering.


I could not reproduce this on a system that continually created
and tore down 400 stations against APs that remained stable and
active....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

