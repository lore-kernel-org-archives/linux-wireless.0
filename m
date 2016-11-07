Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752648AbcKGOKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:10:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 07 Nov 2016 19:40:24 +0530
From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/2] cfg80211: Add support to set tx power for a station
 associated
In-Reply-To: <579F4E4E.80103@candelatech.com>
References: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com>
 <1467110918.2493.9.camel@sipsolutions.net>
 <1cb3e2cc49b433fe5ed834a33adf64b6@codeaurora.org>
 <1470043740.3389.10.camel@sipsolutions.net> <579F4E4E.80103@candelatech.com>
Message-ID: <8908f6e7bb8ca043fbeb07ee8b004e8f@codeaurora.org> (sfid-20161107_151029_473897_72389CFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-08-01 18:57, Ben Greear wrote:
> On 08/01/2016 02:29 AM, Johannes Berg wrote:
>> 
>>> Sure.. First use case will be to help with the problem of legacy
>>> client devices that roam across multiple APs. It is a classic
>>> enterprise Wi-Fi AP problem,  often managed by a "network controller"
>>> unit that is connected to all the APs.
>>> The problem is how to handle seamless handoff of clients between
>>> multiple  APs while maximizing the client throughput and minimizing
>>> disruption of IP application services like VoIP calls and video
>>> streaming. A legacy client will often  hold onto an AP association,
>>> even down to 1 Mbps as it roams away. Instead,  if the AP can
>>> recognise that the client RSSI (and therefore throughput) is poor, it
>>> can "drop" the Tx power significantly (just to that client) such that
>>> it forcesthe client to look for a better, closer, and therefore
>>> higher-throughputassociation. It would "give it a kick" without
>>> blacklisting it. It just needsto hold the power low for the small
>>> amount of time it takes to convince it to go away.
>> 
>> Not sure that *works* since implementations may just compare beacon
>> signal strength and hold on to the AP based on that, but it does seem
>> like a reasonable use case.
> 
> How is that better than just kicking the station deliberately and/or
> refusing to send frames to it at all?
> 

Ben, deliberately kicking out the station can potentially cause the 
black
listing behaviour on the client side and results in connection failures. 
Each
client handles the kickout logic differently. Reducing the tx power, 
causes the
station to trigger its roaming algorithm.

>> 
>> How would this interact with automatic adjustment though?
>> 

Johannes,

In the case of manual intervention by user, the firmware will check 
three
values - regulatory domain, automatic tx power and user entered value. 
System
will always cap to the minimum of these values and see to that we do not 
exceed
the regulatory power limits.

If there are no more comments I will resent this patch series after 
rebase.

Thanks,
Ashok

>> johannes
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
