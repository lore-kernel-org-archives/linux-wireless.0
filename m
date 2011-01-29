Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54122 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1A2Ant (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 19:43:49 -0500
Message-ID: <4D4362BF.7050208@candelatech.com>
Date: Fri, 28 Jan 2011 16:43:43 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: hti->control_chan is 15??
References: <4D4345A8.6060806@candelatech.com> <4D435D76.2040703@candelatech.com> <AANLkTimji+Y0KfDCzWDX63KfOjRFzxgKbVAq6HhMcw20@mail.gmail.com>
In-Reply-To: <AANLkTimji+Y0KfDCzWDX63KfOjRFzxgKbVAq6HhMcw20@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2011 04:35 PM, Daniel Halperin wrote:
> On Fri, Jan 28, 2011 at 4:21 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 01/28/2011 02:39 PM, Ben Greear wrote:
>>>
>>> When testing with 60 stations, 30 against a netgear running HT40
>>> and 30 against a cheap cisco AP, using HT20, I notice that the
>>> stations on the netgear often choose NO_HT instead of HT40
>>> for their channel type.
>>>
>>> The root cause appears to be that the hti->control_chan is 15
>>> in the ieee80211_enable_ht method.
>>>
>>> Everything *should* be running on channel 11.
>>>
>>> Is this just a bug with the AP, or could this be a local
>>> issue?
>>
>> I sniffed on a separate machine (using ath9k NIC), and it agrees
>> that the beacon's control_channel is 14 (I have since set the AP to channel
>> 10 instead of 11, but the control_channel remains 4 higher than expected.)
>>
>
> How did you configure the AP to HT40 mode? Did you put HT40+ or HT40-
> in the hostapd.conf file?
>
> Look at IEEE 802.11n-2009, Annex I and J.  They explain what these
> mean and which combinations are valid in which sets.
>
> Looks like you're using a weird domain and/or disabled ath's
> regulatory checks? I'd think that they would catch this otherwise.
> Or, it could also be a bug related to the Japan regulatory stuff that
> seemed to cause problems for iwlwifi also.

My AP is an off-the-shelf Netgear:
WNDR3700

It's only rate configuration option is '300Mbps', which appears to
turn on HT40.

It is configured for channel 10 (for the packet capture) and actually
passes traffic there.  It's just this HT Info thing with (primary-channel == (real_channel + 4))
that seems wrong.  Note that when I had the channel set to 11, it was reporting
15 for the primary channel in the HT info.

Looks like a bug in that AP to me...but would be nice if there were a way to
work around it, in case others have similar issues.

Thanks,
Ben

>
> Dan


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

