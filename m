Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:59141 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbXD0HoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 03:44:15 -0400
Message-ID: <4631A9C8.5040003@warmcat.com>
Date: Fri, 27 Apr 2007 08:44:08 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704251634.16604.flamingice@sourmilk.net> <46312067.9090005@linux.intel.com> <200704262023.52833.flamingice@sourmilk.net> <46317888.9040909@linux.intel.com>
In-Reply-To: <46317888.9040909@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:

>> Sure there is. Smaller firmware means firmware that's less likely to
>> malfunction, which seems to be an issue.
> 
> I haven't seen that as an issue; I've seen bugs in the driver that are
> misconfiguring the hardware or with the driver/stack trying to
> reconfigure things while a hardware scan is already occurring.

It seems that by definition this class of bugs would disappear if what
we should perhaps call "firmware scan" went away.

>> I don't see what you're saying about added complexity on the driver side. 
> 
> Right now the scanning in mac80211 is slow.  I haven't really dug into
> it to see if it will transition from passive to active if it detects RF
> activity on an otherwise passive channel, etc. but I have seen that if
> we turn on hw scanning we can get results back in a few seconds vs. 10
> or more. 
> The more passive channels you add (most of 802.11a) the slower the
> scanning gets.

Well just a datapoint on that (zd1211rw, presumably mac80211 scanned)

$ time iwlist mon0 scan

...

real    0m0.857s
user    0m0.001s
sys     0m0.004s
$

(I saw your other post also)

>> Eliminating the hw_scan callback reduces driver complexity. 
> 
> If done right, the stack would set up the list of channels to scan,
> whether to scan the channel active or passive, and the template for the
> probe request to use. 

I think one can reasonably say that's a lot of stuff to support what is
a vendor-specific feature that only optimizes what can already be done.

> In order to do it all as fast as possible on the host you need access to
> all channel activity during the scan, especially on passive channels. 
> If traffic is detected a probe request can be sent and then that channel
> can be given up on faster if it had to sit around for an arbitrary
> amount of time (110ms perhaps to ensure you catch beacons being
> transmitted at the vendor default interval of 100ms)  Or if there is no
> traffic at all for some interval you could assume nothing is on that
> channel.  Every 10 channels that's a full second you have to sit around...
> 
> Unless there is a mechanism to quickly and easily toggle between filter
> and don't  filter, you'll end up turning off hw/uCode filtering of
> packets all the time.

Maybe a simpler, more granular way to come at that is in the firmware to
allow selection of "beacon only" filtering, or maybe a count of valid
CRC packets that got filtered so you can assess if you should look
closer at that channel.

> Which means the hardware would be set to full promiscuous mode and every
> packet Rx'd would get tossed to the host to then either process or
> discard--which keeps the host CPU awake (which isn't good on laptops or
> anywhere else folks care about power consumption)  And scanning is one
> of those things that happens more frequently when you are not plugged in
> and are moving around the home, school, office, etc.

Well a major thing for power saving is the duty cycle of the thing you
try to optimize.  If scans take up 0.1% of the usage of the device even
(dubious), then making the system consume zero power during the scan
will make an extremely hard to measure difference.  I don't think it
will be accepted by the Guardians Of The Code here to run the stack
always in hardware promisc as part of its standard operation, so have no
fear about that ;-)

> Not without an impact to power use.  When 802.11n and 802.11e gets added
> to the mix, I'm not sure if it can realistically be eliminated through a
> host implementation without impacting performance.

I don't know anything about these new standards, but if they support the
powersave mode at the AP then Michael's fake powersave method (while we
tune the radio elsewhere for a while) would presumably handle it.

> Latency on getting scan results (especially as more passive channels are
> added) and platform power utilization while mobile.
> 
>>> In the short term, I would rather we leave hw_scan in the code and
>>> have the
>>> users that currently rely on hw_scan just have to manually configure
>>> the AP
>>> selection until such time as the in-kernel-AP-selection-policy code
>>> works
>>> with hw offloaded scan.
>>>
>> What incentive does that give to fix the code? 
> 
> I want userspace to be able to fully configure the set of channels and
> parameters to pass to the hardware.  But overhauling scan component to
> better support hardware scanning will likely take time.

Ultimately if it is possible to leverage the fake powersave mode to
allow monitor mode virtual interfaces to run on different frequencies on
the same hardware, then it will be possible to throw out the whole
concept of scanning from the stack.  I just took a look at iwlist and
surely the combination of the code in there and the code in the stack to
package the results would be made radically simpler removing the stack
code entirely and bringing up a monitor mode virtual interface and
moving it around channels from usermode, filtering on beacon packets
using the pcap BPF stuff, and injecting probes if you want.  The device
need only be in hardware promisc during the scan action.

For result latency, at the moment the monolithic scan is atomic, you sit
there with nothing and get your results all at once.  With a usermode
driven scan, you will get results as you scan a channel, improving the
perception of latency.

>> Leaving broken things in for the sake of out-of-tree drivers does not
>> appeal to me.
> 
> Nor to me--and we plan on getting iwlwifi in-tree.  We also plan on
> using hw_scan.  Keeping it in the stack for now helps me out.  Removing
> it will make my life harder. 

It seems it won't make your life that much harder, mac80211-based
scanning appears to work for you already, and we talk about 2 seconds
instead of 1 for results now and again.

-Andy
