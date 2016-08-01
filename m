Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56692 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbcHAN1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 09:27:44 -0400
Message-ID: <579F4E4E.80103@candelatech.com> (sfid-20160801_152840_436696_15C0FDA5)
Date: Mon, 01 Aug 2016 06:27:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Ashok Raj Nagarajan <arnagara@codeaurora.org>
CC: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/2] cfg80211: Add support to set tx power for a station
 associated
References: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com> <1467110918.2493.9.camel@sipsolutions.net>	 <1cb3e2cc49b433fe5ed834a33adf64b6@codeaurora.org> <1470043740.3389.10.camel@sipsolutions.net>
In-Reply-To: <1470043740.3389.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/01/2016 02:29 AM, Johannes Berg wrote:
>
>> Sure.. First use case will be to help with the problem of legacy
>> client devices that roam across multiple APs. It is a classic
>> enterprise Wi-Fi AP problem,  often managed by a "network controller"
>> unit that is connected to all the APs.
>> The problem is how to handle seamless handoff of clients between
>> multiple  APs while maximizing the client throughput and minimizing
>> disruption of IP application services like VoIP calls and video
>> streaming. A legacy client will often  hold onto an AP association,
>> even down to 1 Mbps as it roams away. Instead,  if the AP can
>> recognise that the client RSSI (and therefore throughput) is poor, it
>> can "drop" the Tx power significantly (just to that client) such that
>> it forcesthe client to look for a better, closer, and therefore
>> higher-throughputassociation. It would "give it a kick" without
>> blacklisting it. It just needsto hold the power low for the small
>> amount of time it takes to convince it to go away.
>
> Not sure that *works* since implementations may just compare beacon
> signal strength and hold on to the AP based on that, but it does seem
> like a reasonable use case.

How is that better than just kicking the station deliberately and/or
refusing to send frames to it at all?

Thanks,
Ben

>
> How would this interact with automatic adjustment though?
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
