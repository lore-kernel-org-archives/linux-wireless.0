Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:47946 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422727AbXCWI5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 04:57:35 -0400
Message-ID: <46039679.6080401@warmcat.com>
Date: Fri, 23 Mar 2007 08:57:29 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 0/4] Try #5: Radiotap on Monitor Mode interfaces for rx  and tx
References: <20070320103955.600509703@warmcat.com> <1174500637.3944.9.camel@johannes.berg>
In-Reply-To: <1174500637.3944.9.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2007-03-20 at 10:39 +0000, andy@warmcat.com wrote:
> 
>> For injecting packets, the you issue a packet using libpcap or a SOCK_PACKET
>> socket down an interface to the wireless device that is in Monitor Mode.
> 
> Ok so people don't want to have this in cfg80211, all the better for me
> since it's less work.

$ cd wireless-dev
$ grep cfg80211 Documentation/* -R

As a Johnny-come-lately noob, how should I find out that cfg80211 either 
exists or how it works?  Far from some kind of turf war initiating 
gauntlet throwing, I was unaware cfg80211 was an option.

My interest is being able to inject broadcast packets from userspace 
with fine control over how it goes out.  I have now tried several ways 
to get that to happen with varying success, patching drivers in the old 
stack (worked but impractical for wide uptake), using the management 
interface in the new stack (works but it is heading towards deprecation 
and did not allow rate control) and finally the Monitor mode injection 
(works perfectly but requires to convince you guys to include it).

send()ing packets back up a Monitor Mode interface with the same 
radiotap semantics as the came out of it with is the most natural and 
portable (libpcap pcap_inject() just works with it on the same network 
interface as it can capture on) way to do injection from a usermode and 
architectural standpoint.

I wouldn't say it is the "best" way to push the weirdo wext/prism Ioctls 
out of the stack, I don't know enough about the details of it, but I 
don't think this and the cfg80211 methods need to be in conflict.  In a 
real sense you can look at this patchset as intending to max out the 
promise of libpcap to usermode.  Sine they then have enough tools, if 
someone wants to implement a userspace MLME or other unthinkable hacks 
in userspace their way is open without any more kernelside cooperation 
needed.

> I urge you to solve the issues with this injection interface, we've
> established that you can use packet filters to grab only management
> frames but monitor interfaces definitely still interact very badly with
> power management, and when the hardware has a BSS filter then this will
> also be disabled with a monitor interface (if monitor during operation
> is supported) which again puts more load on the host.

Those aren't issues with "this injection interface" but in optimizing 
the receive action for the existing Monitor mode.

> I have previously suggested to use the IFF_PROMISC bit for this, but
> this will also need good driver/stack API since currently drivers that
> support monitor during operation will just turn off BSS filters and such
> when a monitor interface is added. That will have to be changed in
> drivers as well.

Sure.  Monitor mode can deliver sensible default results with 
IFF_PROMISC off: it will just show traffic that was flying about inside 
the associated connection with the client anyway.  Just making the only 
way to enable hardware promisc being via IFF_PROMISC ioctl handler will 
allow control over whether you want to see everything with the power hit 
(the power hit doesn't matter for a box wired to the mains) or you just 
want to see things aimed at you.  So it sounds like a good enhancement 
exploiting an existing traditional attribute whatever way you look at it.

> Also, and I'm going to reply to your patches as well, this is not
> something that should be restricted to mac80211 since cfg80211
> generically supports virtual interfaces and anybody could in theory use
> a userspace MLME even with a full-mac card given a special no-management
> firmware mode. Hence, this should be documented for cfg80211 users.

I don't understand why Monitor Mode injection needs to fly under the 
cfg80211 flag.  It seems to belong to mac80211 code and would continue 
to work if cfg80211 was disabled.  Can you explain a bit more why it 
logically belongs in that category?

-Andy
