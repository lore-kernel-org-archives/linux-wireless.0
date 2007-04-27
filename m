Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:47197 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395AbXD0Edh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 00:33:37 -0400
Message-ID: <46317888.9040909@linux.intel.com>
Date: Thu, 26 Apr 2007 21:14:00 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704251634.16604.flamingice@sourmilk.net> <46312067.9090005@linux.intel.com> <200704262023.52833.flamingice@sourmilk.net>
In-Reply-To: <200704262023.52833.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 26 April 2007 17:57, James Ketrenos wrote:
>> With a penalty to battery life and an increase in the amount of time a scan
>> takes.  There are improvements that can be made to make the software
>> scanning faster, but at a penalty of added complexity on both the driver
>> and the stack side -- for no *real* gain for users that have cards that can
>> offload the scan.
>>
> Sure there is. Smaller firmware means firmware that's less likely to 
> malfunction, which seems to be an issue.

I haven't seen that as an issue; I've seen bugs in the driver that are misconfiguring the hardware or with the driver/stack trying to reconfigure things while a hardware scan is already occurring.

> I don't see what you're saying about 
> added complexity on the driver side. 

Right now the scanning in mac80211 is slow.  I haven't really dug into it to see if it will transition from passive to active if it detects RF activity on an otherwise passive channel, etc. but I have seen that if we turn on hw scanning we can get results back in a few seconds vs. 10 or more.  

The more passive channels you add (most of 802.11a) the slower the scanning gets.

>Eliminating the hw_scan callback reduces driver complexity. 

If done right, the stack would set up the list of channels to scan, whether to scan the channel active or passive, and the template for the probe request to use.  

For sw based scans, the stack would then have a mechanism for executing that scan through a series of tunes, transmits, etc.  For hw scans, it would pass that structure to the driver which would package it for the hardware and pass it down.

Upon completion of the scan (sw or hw) the notification would come back to the stack to let it know scanning is complete.  

The sw scan engine would be tied into the rest of the transmit infrastructure to manage off channel time, etc. (which you don't have to do with hw scanning since the hardware/uCode does it all for you)

> The increase in complexity on the stack side is offset by 
> the fact that no driver/firmware/hardware needs to implement their own clever 
> scanning algorithm.

Maybe yes and maybe no.

In order to do it all as fast as possible on the host you need access to all channel activity during the scan, especially on passive channels.  If traffic is detected a probe request can be sent and then that channel can be given up on faster if it had to sit around for an arbitrary amount of time (110ms perhaps to ensure you catch beacons being transmitted at the vendor default interval of 100ms)  Or if there is no traffic at all for some interval you could assume nothing is on that channel.  Every 10 channels that's a full second you have to sit around...

Unless there is a mechanism to quickly and easily toggle between filter and don't  filter, you'll end up turning off hw/uCode filtering of packets all the time.  

Which means the hardware would be set to full promiscuous mode and every packet Rx'd would get tossed to the host to then either process or discard--which keeps the host CPU awake (which isn't good on laptops or anywhere else folks care about power consumption)  And scanning is one of those things that happens more frequently when you are not plugged in and are moving around the home, school, office, etc.

>>> Calling hw_scan starts a
>>> hardware scan, but there is no way to know when the scan is completed.
>> That needs to be improved.
>>
> This is exactly the issue.
> 
>>> Even if that problem were addressed, I still wouldn't like it as the
>>> design of the hw_scan callback is deficient in a number of other ways and
>>> is completely inapplicable to all other hardware/firmware softmac designs
>>> that I know.
>> Given that there are things we can do as a result of the hw_scan that we
>> can't do on the host without imposing greater system load and slower scan
>> results, I really don't want to lose the ability to support hardware
>> offloading of scanning.
>>
> How fast is hardware scanning? What part of software scanning is slowing 
> things down? 

Passive scanning is the worst.  802.11a takes *forever* if you have to sit around on a channel waiting for beacons without issuing a probe request -- and you can't issue a probe request until other traffic is seen.

> What's the big bottleneck that justifies moving this to 
> hardware? 

With the 3945 its mainly power consumption.

> Are you sure it cannot be eliminated? 

Not without an impact to power use.  When 802.11n and 802.11e gets added to the mix, I'm not sure if it can realistically be eliminated through a host implementation without impacting performance.

> Why haven't any other vendors chosen to offload scanning like this?

I don't know how other vendors justify a lot of what they do and don't do.

>> Could you voice some of the "other ways" the current hw_scan callback is
>> deficient?
>>
> Sure. In addition to not being able to find out when the scan is completed..
> 
> - There is no way to specify what channels to scan.
> - There is no way to specify a passive scan.
> - The probe frame that is used is fixed with the exception of the SSID.
> - There is no corresponding interface for the userspace MLME.

The interface to the uCode supports configuring all of the above elements--I'll look at how mac80211 currently sets up its scanning algorithm and see if there is a clean spot to have it push that data to the driver if hw scan is supported.  That way the user MLME *could* customize it.

> This isn't very important, however. I am more interested in what problems in 
> software scanning need to be solved by moving to hardware scanning.

Latency on getting scan results (especially as more passive channels are added) and platform power utilization while mobile.

>> In the short term, I would rather we leave hw_scan in the code and have the
>> users that currently rely on hw_scan just have to manually configure the AP
>> selection until such time as the in-kernel-AP-selection-policy code works
>> with hw offloaded scan.
>>
> What incentive does that give to fix the code? 

I want userspace to be able to fully configure the set of channels and parameters to pass to the hardware.  But overhauling scan component to better support hardware scanning will likely take time.

> Leaving broken things in for 
> the sake of out-of-tree drivers does not appeal to me.

Nor to me--and we plan on getting iwlwifi in-tree.  We also plan on using hw_scan.  Keeping it in the stack for now helps me out.  Removing it will make my life harder.  

James
