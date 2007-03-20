Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:46581 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbXCTQtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2007 12:49:04 -0400
Message-ID: <46001E55.3040504@linux.intel.com>
Date: Tue, 20 Mar 2007 09:48:05 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: Faking powersave for fun and realtime channel muxing
References: <45FEEB34.1000403@warmcat.com> <200703192108.43892.mb@bu3sch.de> <45FEF80B.9020107@warmcat.com>
In-Reply-To: <45FEF80B.9020107@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> Michael Buesch wrote:
...
>> And what's it good for to have a monitor device that randomly misses
>> half of the packets? I mean... rather useless, no?
...
> The immediate use for it is a continuous awareness of the kind of stuff 
> going on around you on other channels, as I mentioned it could replace 
> the current beacon "scan" concept with more of an eye of Sauron operated 
> using the existing Monitor semantics.

This is how the background scanning works in the ipw adapters.  You configure the 
sleep intervals and it then hops to other channels with the AP set to queue frames 
for you.  We removed the functionality from being the default in the driver when 
users complained about ping latency being erratic...

> But I can also use it for the penumbra broadcast stuff.  If it enables 
> autodetection of other channels with the traffic on and automatic usage 
> of those channels without really affecting the association to the user's 
> AP on another channel, that is a very cool feature.

Having spectrum usage knowledge (even with a low sampling rate) for user space to 
make intelligent decisions is *very* useful, and something that we completely lack 
today with Linux.  Anyone that has ever been at OLS knows wireless there sucks -- 
and the #1 reason is because of the AP selection heuristics currently in use... you 
may have an AP in the corner of the room completely unused at a weaker signal but 
with the full channel available for use.  Having this type of measurement kick in 
when congestion is detected (and latency would already suck) and then have user 
space make a decision to pro actively re-associate to a new AP -- and if it 
succeeds, disassociate with the current -- would be great.

> 
>>> Is there something like firmware constraints or the detail of the 
>>> powersaving protocol that kill this dead or is it possible to consider?
>>
>> For software MAC devices this might work. But I think performance 
>> would suck.
>> But it sounds like it's worth an experiment. So if you want to.. :)
> 
> Well, about general performance, it can modulate the amount of 
> powersaving time it is willing to use according to the amount of packets 
> coming to and going from the associated interface.

You can almost do it today with iwlwifi and the hardware/uCode assisted scanning.

Currently the driver has that code path inactive due to a bug that keeps it from 
working at all; but once hooked in you can configure the amount of time to leave 
the active channel and then the uCode will hop around to other channels in the 
background.

James
