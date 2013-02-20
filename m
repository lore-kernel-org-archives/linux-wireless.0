Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-relay12-muc.antispameurope.com ([217.64.175.212]:55218 "EHLO
	mx-relay12-muc.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759097Ab3BTSMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 13:12:06 -0500
Message-ID: <51251045.6030405@fokus.fraunhofer.de> (sfid-20130220_191215_013029_166E81F2)
Date: Wed, 20 Feb 2013 19:04:53 +0100
From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
MIME-Version: 1.0
To: =?windows-1252?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	<linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	<johannes@sipsolutions.net>, <antonio@open-mesh.com>,
	<marek@open-mesh.com>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
References: <20130215171938.GA4140@pandem0nium> <6A268FEF-5C88-4376-A701-09ECEAC1EF2A@net.t-labs.tu-berlin.de>
In-Reply-To: <6A268FEF-5C88-4376-A701-09ECEAC1EF2A@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas, all,

please see my comments in-line...

On 02/19/2013 10:32 AM, Thomas Hühn wrote:
> Hi all,
>
> You motivate your proposal of collecting several statistics from non-peering stations in IBBS networks with:
> (1) "The statistics are then used to evaluate link quality and make some higher level decisions"
> &
> (2)"reading every packet from this monitor interface has a huge thoughput limitation"
>
> Could you go into more details about what "higher level" decisions you have in mind ?

I could think of multiple scenarios.

A concrete one is a multi-radio multi-channel network, where at some 
point in time, the most suitable (i.e. 'free') channels are assigned to 
associated peers.

Over time, other nodes/sources/peers might decide to choose the same 
channels for their own purposes, thus potentially severely impacting the 
throughput/performance of this link.

By analyzing all frames received on an interface (no matter with BSS 
they belong to), one can determine (for example)

a) the number of transmitters on a channel
b) the pkt or bit rate
c) the signal level
d) MAC level errors (retransmissions, SEQ# gaps, etc.)
e) MCS/rate

Interpreting all or some of the above information, the control plane can 
determine/predict possible link issues, etc (and take appropriate 
counter measures).

I assume there are also other scenarios, such as load balancing between 
APs, etc.

> Until now you just listed a bunch of values you like to monitor on a per packet level without any concrete
 > usage idea or algorithms that could make use of it.

Our goal was to propose simple (light weight) statistics inside the 
kernel, which hold all required information relevant to further 
processing in user space.

> I could guess that a common goal would be to increase performance in wireless networks, but lets
 > get concrete about the approach you have in mind.
> A lot of recent theoretical research in wireless goes towards interference management,
 > multi-user and so the gains of using channel state information as 
feedback that is worth its overhead.
 > But this direction would question the packet level granularity you 
described… so what about aggregated statistics ?

I'm not following here. Who would perform the aggregation for you ?  The 
goal of our proposal is to lay the basis for aggregated statistics (to 
be computed and maintained in user space).

If people agree with the above idea/goals, our proposal would be to 
discuss (and eventually agree :) on a set of values, their 
representation and a standardized API (i.e. via NL) to (periodically) 
query such values.

The various applications could then (in user space) use this information 
for their specific purposes.

Cheers,

Mathias


>
> Cheers
> 	Thomas
>
>
> On 15.02.2013, at 18:19, Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
>
>> Hello wireless folks,
>>
>> Mathias Kretschmer and me would like to bring another new feature to the kernel:
>> Collecting information for (non-peer) stations. As far as I know, at least
>> Antonio and Thomas are interested in a similar feature as well, and it seems
>> Antonio has already prepared some code. I'd like to present our ideas and
>> requirements to this feature and would like to ask Antonio and Thomas, and everyone
>> else interested in this feature, to do the same. Then we can hopefully come up
>> with a design which is acceptable for upstream kernels and useful for everyone.
>>
>> We would like to gather statistics for all peers, both connected and not connected
>> to our current IBSS. We do the same in userspace currently using a monitor interface,
>> but reading every packet from this monitor interface has a huge thoughput limitation
>> on our routers, and is therefore not acceptable for productive use. The statistics are
>> then used to evaluate link quality and make some higher level decisions.
>>
>> The statistics we are interested in are, per station (identified by sender MAC address), for
>> both peer and non-peer stations:
>> * RSSI (*)
>> * sequence number gap size (*) - monitors the sequence number of a 80211 packet, per queue
>> * bad frame count (badFCS and such)
>> * total frame count
>> * bytes received
>> * last seen - timestamp
>>
>> Fields marked with (*) should capture min, max, avg, count, sum, sum_square. Other
>> statistics (stddev, rms) can then be calculated in userspace using floating point numbers.
>> The other fields can be normal counters. Some of the fields are already accesible for connected
>> peers (like RSSI, last seen -> iw station dump), some of them are new, and none of them are currently
>> available for non-peer stations. We probably don't need all of them integrated
>> in mainline as they might be only interesting for us, but this is just to give you an idea.
>>
>> Regarding the kernel interface, we don't have any requirements, from nl80211 to debugfs, everything
>> would be fine. We will access the data with a custom program.
>>
>> Commands we would like to propose are:
>> * start collecting - this feature should not run by default to avoid bloating memory for users who
>>    don't even need this
>> * stop collecting
>> * read - dumps the data for all stations
>> * read + reset - dump the data and reset information for all stations. This should also clean up stations,
>>    at least those which are not connected to the BSS, to not bloat the station table.
>>
>> I guess the right position to implement this is mac80211 receive path. Our intended platform
>> is ath9k/ath5k, but that feature should work with any mac80211 driver. We don't care if sta_info
>> structs are allocated or custom structures are used, as long as we can receive a list of stations
>> which includes peer and non-peer stations, along with their statistics.
>>
>> We are looking forward to your thoughts. :)
>>
>> Cheers,
>>         Simon
>


-- 
Fraunhofer FOKUS - RESourCe Optimised Networks
Dr. Mathias Kretschmer
Schloss Birlinghoven; D-53754 Sankt Augustin
T +49-2241-14-3466, F +49-2241-14-1050,
E mathias.kretschmer@fokus.fraunhofer.de
http://www.fokus.fraunhofer.de/en/rescon
