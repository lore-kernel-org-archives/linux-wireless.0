Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47671 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3FOTSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 15:18:52 -0400
Message-ID: <51BCBE17.1020703@candelatech.com> (sfid-20130615_211909_079531_A46F93B9)
Date: Sat, 15 Jun 2013 12:18:47 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kmemleak report in 3.9.5+, related to cfg80211_inform_bss_frame
References: <51B773B7.5090301@candelatech.com>  <51B77594.20000@candelatech.com> <51B7C29C.1060701@candelatech.com>  <51BB9DC5.2020509@candelatech.com> (sfid-20130615_004841_632650_1CE63E73) <1371316275.8319.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371316275.8319.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2013 10:11 AM, Johannes Berg wrote:
> On Fri, 2013-06-14 at 15:48 -0700, Ben Greear wrote:
>
>> I've instrumented all (as far as I can tell) allocation points
>> and destruction points for the ies, and I am keeping a separate
>> list of structures to record some info about each ies.
>>
>> I loaded up lots of stations, let them bounce around for a while,
>> and then did an 'rmmod ath9k'.
>>
>> I still see 14 ies entries in my debug list.  Should
>> I expect to see zero ies data structures left after
>> I rmmod all wifi drivers, or is it normal for a few
>> to be left around?
>
> No, that's decidedly not normal, but that's pretty much just what
> kmemleak already told us, no? Good to verify, but doesn't really help
> pinpoint the problem either, I'd say :-(

Well, I wanted to make sure it wasn't false-positive in kmemleak.

Sometime around March someone reported a similar issue but decided
kmemleak was wrong (and you fixed one corner case that was reported
at the same time)..

I tried instrumenting the bss as well.  From what I can tell, we are
leaking them, as when I print out all bss for the phy* objects, I only
get 14.  But, I see several hundred that were allocated and never freed.

kmemleak didn't show leaked bss, so possibly I am wrong about this, or
maybe they are still (properly?) referenced from the virtual station
interfaces.

Is there any good reason that there would be a significant amount of bss
objects in the system that are not in the bss_list for the wiphys?

This is from my debug code, but perhaps it gives an idea (actually,
the ies are undercounted, as 31500 was the buffer size I
allowed for debugfs...I'll work on better instrumentation to
give an accurate count of still-allocated ies.)

[root@LEC2220-1 ~]# cat /debug/ieee80211/wiphy*/bss|wc
      14     112    1288
[root@LEC2220-1 ~]# cat /debug/ieee80211/ies |wc
     642    1286   31500
[root@LEC2220-1 ~]# cat /debug/ieee80211/all_bss|wc
     382     764   16044


The good news is that it appears the bss growth (at least) does not grow too fast..this
is after around 20 hours of running the torture test that constantly is trying to
(re)associate 400 stations with an AP that can handle only 127.

Thanks,
Ben


>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

