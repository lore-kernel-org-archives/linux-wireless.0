Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38572 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbcKGOSm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:18:42 -0500
Message-ID: <58208D40.8070406@candelatech.com> (sfid-20161107_151846_284172_3CEA6D06)
Date: Mon, 07 Nov 2016 06:18:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ashok Raj Nagarajan <arnagara@codeaurora.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/2] cfg80211: Add support to set tx power for a station
 associated
References: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com> <1467110918.2493.9.camel@sipsolutions.net> <1cb3e2cc49b433fe5ed834a33adf64b6@codeaurora.org> <1470043740.3389.10.camel@sipsolutions.net> <579F4E4E.80103@candelatech.com> <8908f6e7bb8ca043fbeb07ee8b004e8f@codeaurora.org>
In-Reply-To: <8908f6e7bb8ca043fbeb07ee8b004e8f@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/07/2016 06:10 AM, Ashok Raj Nagarajan wrote:
> On 2016-08-01 18:57, Ben Greear wrote:
>> On 08/01/2016 02:29 AM, Johannes Berg wrote:
>>>
>>>> Sure.. First use case will be to help with the problem of legacy
>>>> client devices that roam across multiple APs. It is a classic
>>>> enterprise Wi-Fi AP problem,  often managed by a "network controller"
>>>> unit that is connected to all the APs.
>>>> The problem is how to handle seamless handoff of clients between
>>>> multiple  APs while maximizing the client throughput and minimizing
>>>> disruption of IP application services like VoIP calls and video
>>>> streaming. A legacy client will often  hold onto an AP association,
>>>> even down to 1 Mbps as it roams away. Instead,  if the AP can
>>>> recognise that the client RSSI (and therefore throughput) is poor, it
>>>> can "drop" the Tx power significantly (just to that client) such that
>>>> it forcesthe client to look for a better, closer, and therefore
>>>> higher-throughputassociation. It would "give it a kick" without
>>>> blacklisting it. It just needsto hold the power low for the small
>>>> amount of time it takes to convince it to go away.
>>>
>>> Not sure that *works* since implementations may just compare beacon
>>> signal strength and hold on to the AP based on that, but it does seem
>>> like a reasonable use case.
>>
>> How is that better than just kicking the station deliberately and/or
>> refusing to send frames to it at all?
>>
>
> Ben, deliberately kicking out the station can potentially cause the black
> listing behaviour on the client side and results in connection failures. Each
> client handles the kickout logic differently. Reducing the tx power, causes the
> station to trigger its roaming algorithm.

We tested some phones a year or so ago, and used a variable attenuator
to decrease the signal of one AP while ramping up signal of a second AP.
They did not roam until they lost connection, and since we were not using an isolation
chamber, we could not get the AP signal less than around -75 DB, so in our test,
the phones often did not roam at all.

http://www.candelatech.com/cookbook.php?vol=wifire&book=Emulating+Station+Motion+with+Programmable+Attenuator

So, I am not sure you can assume much about scanning behaviour either.  Maybe newer
phones are better...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
