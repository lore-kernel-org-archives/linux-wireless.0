Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:41986 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1BGSc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 13:32:57 -0500
Received: by pxi15 with SMTP id 15so955675pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 10:32:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D5033DE.4070701@candelatech.com>
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org>
 <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org>
 <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com>
 <4D4F0D83.4040401@candelatech.com> <4D4F0DFF.9010703@openwrt.org>
 <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com> <4D5033DE.4070701@candelatech.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 7 Feb 2011 10:32:37 -0800
Message-ID: <AANLkTimzp3nL=vbxnhH2ZYZtGNFqMsKKqTw1+pfjkUMu@mail.gmail.com>
Subject: Re: Scanning and channel types.
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start on 2.4 GHz AP with HT Only (not just HT40) set.  That is, AP
that doesn't allow 1 Mbps packets to be sent.  Scan, make sure 1 mbps
packets are sent.

Start on 5 GHZ AP with HT Only set.  Scan.  What rate are probes sent
at for 2.4 GHz?

Dan

On Mon, Feb 7, 2011 at 10:03 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 02/06/2011 09:42 PM, Daniel Halperin wrote:
>>
>> Right. I think there is a function something like "send_rate_low" that
>> sends the lowest entry in the mac80211 enabled rates table for control
>> and mgmt packets.  If the NIC is associated to an HT Only AP then that
>> lowest entry should be HT20 MCS 1, I'd think.
>>
>> Also, does circumventing "set channel type" code work properly across
>> bands?  If you start on 5 GHz will it send 6 Mbps probes or 1 Mbps
>> probes?
>
> I did some tests with a sniffer set up:
>
> I have 8 STA vifs.
>
> 1)  AP is setup to run on channel 11, HT40-
>    Let all associate on channel 11, radio goes to HT40- mode.
>    Run Scan on operating channel:
>    Probe request is reported as 1Mbps data rate on ch 11.
>
> 2)  Scan on all channels:
>    Probe requests on 2.4Ghz channels are 1Mbps data rate.
>    Probe requests on 5Ghz channels (channel 40 in this case)
>    are reported as 6Mbps data rate.
>
> 3)  Kill AP, no VIFS are associated (radio goes to NO_HT)
>    Run scan on all channels.
>    Probe request on channel 40 is 6Mbps data rate.
>
>
> Please note that with my patches, the channel-type is still set to NO_HT
> if we are scanning off the operating channel.  Since test 1 appears to
> function properly, I think that verifies that we can safely send NO_HT
> requests while leaving the radio at HT40-.
>
> Please let me know if this answers your concerns.  If you can think of
> other combinations I should try, please let me know that as well.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
