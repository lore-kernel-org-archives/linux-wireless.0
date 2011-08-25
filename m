Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36761 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1HYSR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 14:17:59 -0400
Message-ID: <4E5691D3.6060800@candelatech.com> (sfid-20110825_201803_199365_D896026B)
Date: Thu, 25 Aug 2011 11:17:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sam Leffler <sleffler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bridging wired to STA interfaces.
References: <4E38DDB3.1030801@candelatech.com>	<CA+yqC4YvAMLaao4dy2aXM7H5zPXySk4eAUZ2KSM4QnP+kQqF-A@mail.gmail.com>	<4E39EB52.1090401@candelatech.com>	<CA+yqC4a1xCPM4WN5U5Oth9PUqGSg+h6qZ4u2sV80h3zcEtzazg@mail.gmail.com>	<4E43816D.6080005@candelatech.com> <CAJ-VmomygMyc-DxP7btY7yitiZ4Esw17goEo0BXcC8Bj_toqbQ@mail.gmail.com>
In-Reply-To: <CAJ-VmomygMyc-DxP7btY7yitiZ4Esw17goEo0BXcC8Bj_toqbQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2011 01:48 AM, Adrian Chadd wrote:
> On 11 August 2011 15:14, Ben Greear<greearb@candelatech.com>  wrote:
>
>> I think I'll just force user to create an STA with matching MAC (for the
>> MAC of the PC/whatever to be bridged).  Ath9k and ath5k can support at
>> least 128 stations, so that will be plenty for our uses...
>>
>> We saw some problems changing MAC on STA after they were created, but
>> it seems to be ok if we just create it with correct STA the first time,
>> and we'll try to figure out why changing MAC was acting weird as well.
>
> Oh wow, that's a cool use of multi-STA support. Now I want to get it
> working in FreeBSD.
>
> I think I may need to corner you sometime and sort out exactly how
> this works. Nice thinking Ben!

Just to follow up on this, I believe I now have this working
with a user-space bridge.  It's part of my proprietary app, but
here's the basic algorithm in case someone else wants to try
this:

Network setup:

server -- AP {{{}}} station-bridge  -- clients

For each client, create a virtual station on the station-bridge machine
with the same MAC as the client.

Packets coming in a station interface are sent out the wired interface
unless they are 802.1X frames (0x888e ethernet type).  These
are just dropped.  If destination MAC is broadcast, it is changed
to be that of the STA's MAC.  This is probably not required, but seems
a good optimization and I cannot think of any reason not to...I may be
wrong however.

Packets coming in the ethernet interface are mapped onto the STA that
matches the source MAC of the ethernet frame.  Packets that do not match
are silently discarded.

You have to explicitly disable IPv4/6 routing on the bridge interfaces
or the OS might try to route them.  You should also disable ARP and such.
You must remove all IP addresses from the bridge interfaces.  You should
probably disable LRO and such as well.  In general, the idea is to make
the packet socket the only active consumer of the packets so that the OS
doesn't muck with things and toss un-expected packets onto the network.

Use packet sockets to read/write the packets.


This could all be done in the kernel, but aside from saving some packet
copies to/from user-space, it seems like a user-space app is sufficient.

I tested this with ath9k in the AP and virtual station machines.  The
pertinent bits should be available in standard upstream kernels,
but we're using our hacked kernels.

If anyone writes a stand-alone app to do this, I'm interested to know.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

