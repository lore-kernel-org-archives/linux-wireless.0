Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33322 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752405AbcHAJ3L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 05:29:11 -0400
Message-ID: <1470043740.3389.10.camel@sipsolutions.net> (sfid-20160801_112921_391521_38DD5CDB)
Subject: Re: [PATCH 1/2] cfg80211: Add support to set tx power for a station
 associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@codeaurora.org>
Cc: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Mon, 01 Aug 2016 11:29:00 +0200
In-Reply-To: <1cb3e2cc49b433fe5ed834a33adf64b6@codeaurora.org>
References: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com>
 <1467110918.2493.9.camel@sipsolutions.net>
	 <1cb3e2cc49b433fe5ed834a33adf64b6@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Sure.. First use case will be to help with the problem of legacy
> client devices that roam across multiple APs. It is a classic
> enterprise Wi-Fi AP problem,  often managed by a "network controller"
> unit that is connected to all the APs. 
> The problem is how to handle seamless handoff of clients between
> multiple  APs while maximizing the client throughput and minimizing
> disruption of IP application services like VoIP calls and video
> streaming. A legacy client will often  hold onto an AP association,
> even down to 1 Mbps as it roams away. Instead,  if the AP can
> recognise that the client RSSI (and therefore throughput) is poor, it
> can "drop" the Tx power significantly (just to that client) such that
> it forcesthe client to look for a better, closer, and therefore
> higher-throughputassociation. It would "give it a kick" without
> blacklisting it. It just needsto hold the power low for the small
> amount of time it takes to convince it to go away.

Not sure that *works* since implementations may just compare beacon
signal strength and hold on to the AP based on that, but it does seem
like a reasonable use case.

How would this interact with automatic adjustment though?

johannes

