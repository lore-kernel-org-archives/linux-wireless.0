Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:58213 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbXFWIaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 04:30:05 -0400
Message-ID: <467CD9EC.1020405@warmcat.com>
Date: Sat, 23 Jun 2007 09:29:32 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	<20070621143558.68fc8e4a@griffin.suse.cz>	<1182429920.21939.1.camel@johannes.berg>	<20070621151441.500d62d5@griffin.suse.cz>	<20070622154545.29eeebdb@griffin.suse.cz>	<467BDCB1.1010604@warmcat.com> <20070622173940.30280046@griffin.suse.cz> <467C003C.30803@warmcat.com>
In-Reply-To: <467C003C.30803@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> Jiri Benc wrote:
> 
>> On Fri, 22 Jun 2007 15:29:05 +0100, Andy Green wrote:
>>> But for any nontrivial use, you need to capture RX and not blindly
>>> inject, and so you have a monitor mode interface up anyway.
>> No, why? You can encapsulate received management frames (only the ones
>> that need to go to user space or so) in the same way and send them
>> through the regular interface.
> 
> For my usage case I want specific unencrypted packets filtered by a MAC
> address that isn't part of the authenticated network, so the reception
> action needs to be effectively promisc a la Monitor mode, not just
> "received management frames".  But I guess it can be done with IFF_PROMISC.
> 
> By piping everything down "wlan0" normal packets will not have the
> radiotap metadata on their capture, but presumably the abnormal packets
> can have it via a special ethernet frame type + radiotap header.  Maybe
> it doesn't matter for any actual use.

I've converted the injection patches and packetspammer[1] to use this
encapsulation method.  I added

#define ETH_P_80211_RT	0x001B		/* Radiotap + 80211 encapsulation */

to ./include/linux/if_ether.h to define the new ethtype.

My results at the moment are that my encapsulated injected packets are
dropped before reaching wlan0's dev->hard_start_xmit(), but if I send
them to a second network interface for the same device configured into
monitor mode, then they are injected correctly and go out on the air.

Any ideas about where to look or what to do about the packets getting
dropped on wlan0?  wlan0 is "up" and has its channel set, but is not
associated to anything during this test.

-Andy

[1] in git at http://git.warmcat.com
