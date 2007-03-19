Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:59473 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbXCSUwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 16:52:30 -0400
Message-ID: <45FEF80B.9020107@warmcat.com>
Date: Mon, 19 Mar 2007 20:52:27 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Faking powersave for fun and realtime channel muxing
References: <45FEEB34.1000403@warmcat.com> <200703192108.43892.mb@bu3sch.de>
In-Reply-To: <200703192108.43892.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:

>> For example you could allow any logical network interface to have a 
>> different channel.  In this case, during the time that the channel you 
>> are associated on has been told you have gone into powersave mode, you 
>> can actually spend time on that other channel, before switching the 
>> channel back to check in with the AP.  So you could for example run 
>> monitor mode on channel 11 while being associated on channel 2, given 
>> the limitation that sometimes you aren't listening because you are 
> 
> And what's it good for to have a monitor device that randomly misses
> half of the packets? I mean... rather useless, no?

Well it would hopefully be much less than half the time you are away. 
If nothing much is going on in the associated channel, which a lot of 
the time is true, then you would be spending most of the time monitoring 
on the other channel.  Depending on the reason though even a 10% capture 
of another channel that you can currently see 0% of could be great... 
and it would be happening using a standard Monitor interface.

The immediate use for it is a continuous awareness of the kind of stuff 
going on around you on other channels, as I mentioned it could replace 
the current beacon "scan" concept with more of an eye of Sauron operated 
using the existing Monitor semantics.

But I can also use it for the penumbra broadcast stuff.  If it enables 
autodetection of other channels with the traffic on and automatic usage 
of those channels without really affecting the association to the user's 
AP on another channel, that is a very cool feature.

>> Is there something like firmware constraints or the detail of the 
>> powersaving protocol that kill this dead or is it possible to consider?
> 
> For software MAC devices this might work. But I think performance would suck.
> But it sounds like it's worth an experiment. So if you want to.. :)

Well, about general performance, it can modulate the amount of 
powersaving time it is willing to use according to the amount of packets 
coming to and going from the associated interface.

-Andy
