Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:53422 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbZKDVM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 16:12:26 -0500
Date: Thu, 5 Nov 2009 10:01:39 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: Christian Lamparter <chunkeey@googlemail.com>
cc: Adam Wozniak <awozniak@irobot.com>, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
In-Reply-To: <200911041653.33737.chunkeey@googlemail.com>
Message-ID: <alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz>
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
On Wed, 4 Nov 2009, Christian Lamparter wrote:

> On Wednesday 04 November 2009 02:13:49 Adam Wozniak wrote:
>> I have two systems under test, both Dell laptops (a Latitude D630 and an
>> Inspiron 600m) both running Ubuntu 9.10 with the latest updates, and
>> bleeding edge compat-wireless-2009-11-02.  I'm using identical AR9170
>> based D-Link DWA-160 USB 802.11adapters.  I'm using nuttcp to measure
>> throughput.  I'm running in ad-hoc mode.  Both machines have the same
>> ar9170 files in /lib/firmware.  The machines are sitting about 5 feet
>> apart in my office.
>>
>> I'm having occasional problems where throughput drops through the floor
>> (0.5Mbps - 1.5Mbps).  When I cat
>> /sys/kernel/debug/ieee80211/*/stations/*/rc_stats, one of the machines
>> lists the full set of rates, but the other only lists 1M and 54M.  After
>> a period of time, that machine drops 54M and lists only one rate
>> (1Mbps), and the throughput listed by nuttcp drops accordingly.  I
>> assume that, for whatever reason, the rates drop off the list and
>> minstrel uses the only one left available to it.
>>
>> If I modify include/net/mac80211.h and force the inline function
>> rate_supported to always return 1, this fixes the problem.  However, I
>> think this is a band aid around some other issue.
>>
>> Any clues or ideas what the real issue might be here?

My guess::

When an adhoc node (call it A) merges with a second adhoc node (call it 
B) there is a capability comparison.
Node A looks at the rates supported by B and says,
   "I must only transmit at rates supported by B"

Some management frames don't contain a full report of the rates supported 
by the sender.
My view is that node A (in this example) is incorrectly determining that B 
only supports the 1mb/sec rate. Consequently, node A fills the 
rate_supported  array with one rate - 1mb/sec.

=====

There is no evidence that Minstrel is doing anything wrong.

The original poster's report of examining
>> /sys/kernel/debug/ieee80211/*/stations/*/rc_stats
is very important, as it shows exactly what minstrel is doing.

When examining network problems, one should always check the rc_stats 
file. This tells you much about what is going on in the radio medium.

Derek.

Derek Smithies Ph.D. 
IndraNet Technologies Ltd. 
ph +64 3 365 6485 
Web: http://www.indranet-technologies.com/

"The only thing IE should be used for is to download Fire Fox"

"My favorite language is call STAR. It's extremely concise. It has
  exactly one verb '*', which does exactly what I want at the moment."
     --Larry Wall
