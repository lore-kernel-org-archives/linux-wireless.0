Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49602 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbcGEMbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:31:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Jul 2016 18:01:45 +0530
From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/2] cfg80211: Add support to set tx power for a station
 associated
In-Reply-To: <1467110918.2493.9.camel@sipsolutions.net>
References: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com>
 <1467110918.2493.9.camel@sipsolutions.net>
Message-ID: <1cb3e2cc49b433fe5ed834a33adf64b6@codeaurora.org> (sfid-20160705_143150_988458_84A7F884)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-28 16:18, Johannes Berg wrote:
> On Tue, 2016-06-14 at 23:14 +0530, Ashok Raj Nagarajan wrote:
>> This patch adds support to set transmit power setting type and
>> transmit power level attributes to NL80211_CMD_SET_STATION in order
>> to facilitate adjusting the transmit power level of a station
>> associated to the AP.
> 
> Why would you ever need to do that manually? Please give more
> explanation in the commit message.
> 
> We have minstrel-blues (which never made it into the code, but that's
> just because the submitter went away) doing power adjustments, so you
> need to explain why this should be necessary.
> 

Hi Johannes,

Sure.. First use case will be to help with the problem of legacy client 
devices that
roam across multiple APs. It is a classic enterprise Wi-Fi AP problem, 
often
managed by a "network controller" unit that is connected to all the APs. 
The
problem is how to handle seamless handoff of clients between multiple 
APs while
maximizing the client throughput and minimizing disruption of IP 
application
services like VoIP calls and video streaming. A legacy client will often 
hold
onto an AP association, even down to 1 Mbps as it roams away. Instead, 
if the
AP can recognise that the client RSSI (and therefore throughput) is 
poor, it
can "drop" the Tx power significantly (just to that client) such that it 
forces
the client to look for a better, closer, and therefore higher-throughput
association. It would "give it a kick" without blacklisting it. It just 
needs
to hold the power low for the small amount of time it takes to convince 
it to
go away.

Other use cases may be
         - Support a form of QoS per STA since a higher MCS rate might be
           achievable, and CW delays might be reduced
         - The optimal power can be negotiated (closed loop) or observed 
(open
           loop) for a given STA, reducing needless congestion on the 
overall channel
         - Reduce power to a STA that does not support certain radio 
features
           (e.g.  11b clients)

Thanks,
Ashok

> johannes
