Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:49056 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXFUX2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 19:28:09 -0400
Message-ID: <467B097F.4030806@warmcat.com>
Date: Fri, 22 Jun 2007 00:27:59 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	<20070621143558.68fc8e4a@griffin.suse.cz>	<1182429920.21939.1.camel@johannes.berg> <20070621151441.500d62d5@griffin.suse.cz>
In-Reply-To: <20070621151441.500d62d5@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Thu, 21 Jun 2007 14:45:19 +0200, Johannes Berg wrote:
>> On Thu, 2007-06-21 at 14:35 +0200, Jiri Benc wrote:
>>
>>> 1. I'm still not sure if using monitor interface for this purpose is a
>>> good idea. Given the fact we want to switch to user space MLME, this
>>> will mean that at least one monitor interface is always present. So we
>>> got rid of management interface just to introduce another user visible
>>> magic interface.
>> Well, that's not a bad point, but at least it's not created via magic
>> ioctls etc.
> 
> That's true. Still, couldn't we find a better solution?

There probably isn't a better solution for passing actual packets back
and forth than an actual network interface.  They are made for the task,
solid and well debugged, and can deal with heavy traffic cleanly.

> I know that netlink isn't designed for this kind of things. But if we
> don't have any other idea, I'd still prefer that over a dedicated
> network interface.

If the only objection to the network interface is purely cosmetic in
usermode, and there is no technical complaint about it otherwise, maybe
changing it is not the right answer.  For example if the spawned
interface naming followed a convention like .wlan0_mlme consistently,
usermode apps could filter on that.  Although I admit the 2001 release
date of latest net-tools does not hold out much hope for ifconfig...

http://www.tazenda.demon.co.uk/phil/net-tools/

-Andy
