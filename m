Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:58669 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbXCEBCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 20:02:54 -0500
Message-ID: <45EB6C3B.2060408@warmcat.com>
Date: Mon, 05 Mar 2007 01:02:51 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about PRISM2 header rate field
References: <45EA9E39.6080706@warmcat.com>  <45EAF559.5070701@warmcat.com> <1173053744.6131.40.camel@johannes.berg>
In-Reply-To: <1173053744.6131.40.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

Hi Johannes -

>> Well, I discover in fact you need to inject starting only from the 
>> IEEE802.11 header... and indeed that does work if you do it on the 
>> "Management Interface".  I found this from hostapd sources, since 
>> wpa_supplicant doesn't seem to inject packets from userspace,
> 
> Never versions of wpa_supplicant should do this in the userspace MLME
> part.

I was looking at 0.5.7 but it can easily be I missed it.

> Looks like you're right, there doesn't seem to be a way. I always
> thought this was possible.
> 
> I think you should raise this point on the mailing list again. I've
> proposed doing this through nl80211 to allow extensibility of the meta
> information (frame rate, ....) for an injected frame instead of
> conjuring up yet another meta information framework that transports
> frame across netdevs, but Michael strongly opposes the idea of
> transporting frames via anything but a netdev.

Hmm, right.

> I could post some code for nl80211 inject that doesn't control any meta
> information yet but at least has the capability of carrying it over to
> the stack.

These injected broadcasts will ultimately be used for bulk data 
transfer: I have had 300kBytes/sec using the addressless file transfer 
protocol on the patched wireless drivers.  In such a case, it is 
critical that netdev-like stuff especially select() and tx blocking down 
in usermode works properly: the progress of the usermode transmission 
thread must be regulated only by the driver and stack managing the 
descriptors and blocking when things are getting backed up.  If the 
nl80211 injection "side channel" for sending packets doesn't inherit the 
interface stop and start stuff in a clean way from whatever it calls 
through to then it could get messy getting the netdev interfaces and the 
side channel to block in sync I can imagine.

Here are a couple of ideas to consider anyway.

#1 The rate and so on metadata for the sending action has to belong 
unambiguously with the payload, because multiple packet rates can be in 
use at the same time as part of an anonymous selfconfiguring rate 
optimization scheme, and so it would be no good selecting the injection 
rate asynchronously on some ioctl or via another nl80211 api separate 
from the payload.

How about for injection on the Management interface, it expects to find 
a PRISM2 header prepended to the ieee80211 one and the payload, in 
exactly the same format as is delivered by Monitor Mode?  The PRISM2 
capture header structure has a bunch of fields for things like rate and 
antenna selection already.  This has the satisfying aspect that you can 
literally replay the whole Monitor Mode packet capture down the 
Management Interface and get it to go out at the same rate.

#2 The whole management interface magic summoning hoodoo is a bit 
strange compared to echo -n newinterfacename > 
/sys/class/whatever/add_iface.  How about regularizing the situation by 
allowing one or more normal mac80211 interfaces to be added and then set 
like iwconfig wmgmt0 mode Management.  Perhaps it can then be possible 
to associate the interface with a rate, like iwconfig wmgmt0 rate 54M or 
iwconfig wmgmt1 rate 11M.  Depending on which one you send your packet 
to, it goes out at the rate associated with the interface.  There can 
still only be one real Management Interface per physical device if that 
is important, the others are just thin wrappers over the single good one 
to hold the rate (and antenna if possible) info.  In this way there are 
no new magic headers needed, it is all done as a netdev and the 
situation for Management Interface creation is normalized a bit.  The 
drawback is that it is not quite as flexible as being able to specify 
the rate and which antenna packet by packet.

-Andy

