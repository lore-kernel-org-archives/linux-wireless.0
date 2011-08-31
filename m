Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53670 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab1HaOrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 10:47:09 -0400
Message-ID: <4E5E4967.8070401@openwrt.org> (sfid-20110831_164717_105640_BCBD1066)
Date: Wed, 31 Aug 2011 16:47:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] mac80211: retry sending failed BAR frames later instead
 of tearing down aggr
References: <1314558661-28454-1-git-send-email-nbd@openwrt.org> <1314792948.4161.23.camel@jlt3.sipsolutions.net>
In-Reply-To: <1314792948.4161.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-31 2:15 PM, Johannes Berg wrote:
> On Sun, 2011-08-28 at 21:11 +0200, Felix Fietkau wrote:
>>  Unfortunately failed BAR tx attempts happen more frequently than I
>>  expected, and the resulting aggregation teardowns cause performance
>>  issues, as the aggregation session does not always get re-established
>>  properly.
>
> I find this curious. How can tons of traffic go through, but BAR frames
> fail? These are unicast and should be retried a bunch...
I think it mostly happens when the client goes to powersave (triggered 
by background scans, etc).

>>  Instead of tearing down the entire aggr session, we can simply store the
>>  SSN of the last failed BAR tx attempt, wait for the first successful
>>  tx status event, and then send another BAR with the same SSN.
>
> So what if it keeps failing? I think eventually we'd want to kill the
> session?
If it keeps failing, then the connection is probably so bad that it 
doesn't matter if we kill the session or not.

- Felix
