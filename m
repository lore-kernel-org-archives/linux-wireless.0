Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47980 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1BGSDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 13:03:20 -0500
Message-ID: <4D5033DE.4070701@candelatech.com>
Date: Mon, 07 Feb 2011 10:03:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org> <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org> <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com> <4D4F0D83.4040401@candelatech.com> <4D4F0DFF.9010703@openwrt.org> <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com>
In-Reply-To: <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2011 09:42 PM, Daniel Halperin wrote:
> Right. I think there is a function something like "send_rate_low" that
> sends the lowest entry in the mac80211 enabled rates table for control
> and mgmt packets.  If the NIC is associated to an HT Only AP then that
> lowest entry should be HT20 MCS 1, I'd think.
>
> Also, does circumventing "set channel type" code work properly across
> bands?  If you start on 5 GHz will it send 6 Mbps probes or 1 Mbps
> probes?

I did some tests with a sniffer set up:

I have 8 STA vifs.

1)  AP is setup to run on channel 11, HT40-
     Let all associate on channel 11, radio goes to HT40- mode.
     Run Scan on operating channel:
     Probe request is reported as 1Mbps data rate on ch 11.

2)  Scan on all channels:
     Probe requests on 2.4Ghz channels are 1Mbps data rate.
     Probe requests on 5Ghz channels (channel 40 in this case)
     are reported as 6Mbps data rate.

3)  Kill AP, no VIFS are associated (radio goes to NO_HT)
     Run scan on all channels.
     Probe request on channel 40 is 6Mbps data rate.


Please note that with my patches, the channel-type is still set to NO_HT
if we are scanning off the operating channel.  Since test 1 appears to
function properly, I think that verifies that we can safely send NO_HT
requests while leaving the radio at HT40-.

Please let me know if this answers your concerns.  If you can think of
other combinations I should try, please let me know that as well.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

