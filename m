Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:50744 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757464Ab3BSJid convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 04:38:33 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] design discussion: Collecting information for (non-peer) stations
From: =?windows-1252?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <20130215171938.GA4140@pandem0nium>
Date: Tue, 19 Feb 2013 10:32:29 +0100
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, antonio@open-mesh.com,
	marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Message-Id: <6A268FEF-5C88-4376-A701-09ECEAC1EF2A@net.t-labs.tu-berlin.de> (sfid-20130219_103844_097010_10C4AF75)
References: <20130215171938.GA4140@pandem0nium>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

You motivate your proposal of collecting several statistics from non-peering stations in IBBS networks with:
(1) "The statistics are then used to evaluate link quality and make some higher level decisions" 
& 
(2)"reading every packet from this monitor interface has a huge thoughput limitation"

Could you go into more details about what "higher level" decisions you have in mind ?
Until now you just listed a bunch of values you like to monitor on a per packet level without any concrete usage idea or algorithms that could make use of it.
I could guess that a common goal would be to increase performance in wireless networks, but lets get concrete about the approach you have in mind.
A lot of recent theoretical research in wireless goes towards interference management, multi-user and so the gains of using channel state information as feedback that is worth its overhead. But this direction would question the packet level granularity you described… so what about aggregated statistics ? 


Cheers 
	Thomas


On 15.02.2013, at 18:19, Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> wrote:

> Hello wireless folks,
> 
> Mathias Kretschmer and me would like to bring another new feature to the kernel:
> Collecting information for (non-peer) stations. As far as I know, at least
> Antonio and Thomas are interested in a similar feature as well, and it seems
> Antonio has already prepared some code. I'd like to present our ideas and
> requirements to this feature and would like to ask Antonio and Thomas, and everyone
> else interested in this feature, to do the same. Then we can hopefully come up
> with a design which is acceptable for upstream kernels and useful for everyone.
> 
> We would like to gather statistics for all peers, both connected and not connected
> to our current IBSS. We do the same in userspace currently using a monitor interface,
> but reading every packet from this monitor interface has a huge thoughput limitation
> on our routers, and is therefore not acceptable for productive use. The statistics are
> then used to evaluate link quality and make some higher level decisions.
> 
> The statistics we are interested in are, per station (identified by sender MAC address), for
> both peer and non-peer stations:
> * RSSI (*)
> * sequence number gap size (*) - monitors the sequence number of a 80211 packet, per queue
> * bad frame count (badFCS and such)
> * total frame count
> * bytes received
> * last seen - timestamp
> 
> Fields marked with (*) should capture min, max, avg, count, sum, sum_square. Other
> statistics (stddev, rms) can then be calculated in userspace using floating point numbers.
> The other fields can be normal counters. Some of the fields are already accesible for connected
> peers (like RSSI, last seen -> iw station dump), some of them are new, and none of them are currently
> available for non-peer stations. We probably don't need all of them integrated
> in mainline as they might be only interesting for us, but this is just to give you an idea.
> 
> Regarding the kernel interface, we don't have any requirements, from nl80211 to debugfs, everything
> would be fine. We will access the data with a custom program.
> 
> Commands we would like to propose are:
> * start collecting - this feature should not run by default to avoid bloating memory for users who
>   don't even need this
> * stop collecting
> * read - dumps the data for all stations
> * read + reset - dump the data and reset information for all stations. This should also clean up stations,
>   at least those which are not connected to the BSS, to not bloat the station table.
> 
> I guess the right position to implement this is mac80211 receive path. Our intended platform
> is ath9k/ath5k, but that feature should work with any mac80211 driver. We don't care if sta_info
> structs are allocated or custom structures are used, as long as we can receive a list of stations
> which includes peer and non-peer stations, along with their statistics.
> 
> We are looking forward to your thoughts. :)
> 
> Cheers,
>        Simon

