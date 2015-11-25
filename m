Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41443 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbbKYGT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 01:19:56 -0500
Message-ID: <5655530B.9030407@candelatech.com> (sfid-20151125_072029_983167_61288C02)
Date: Tue, 24 Nov 2015 22:19:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ATH10 firmware question
References: <773DB8A82AB6A046AE0195C68612A31901C5AFA5@sbs2003.acksys.local>	<5654D6A8.9050002@candelatech.com> <CA+BoTQk2UXskCOPafxmd-2YzAceg=oMd1BKkDpwcX2LwazVQ-A@mail.gmail.com>
In-Reply-To: <CA+BoTQk2UXskCOPafxmd-2YzAceg=oMd1BKkDpwcX2LwazVQ-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/24/2015 08:19 PM, Michal Kazior wrote:
> On 24 November 2015 at 22:29, Ben Greear <greearb@candelatech.com> wrote:
>> On 11/24/2015 10:07 AM, Cedric VONCKEN wrote:
>>>
>>>          Hi,
>>>
>>>          I have a simple test platform.
>>>          One PC connected to an equipment. This equipment is set in AP
>>> mode.
>>>          Another PC connected to another equipment. This equipment is set
>>> in STA + WDS mode.
>>>
>>>          Both equipment use the same openwrt Firmware (compat
>>> 2015-07-21), I only changed the ath10k firmware (in
>>> /lib/firmware/ath10k/...).
>>>          Both equipment has the same hardware.
>>>          I used a clear channel, and VHT80.
>>>          The radio was connected with a coaxial cable and I placed 40 dBm
>>> attenuation per Rf chain.
>>>          I used the WLN350NX radio card from compex.
>>>
>>>          First test : ATH10K firmware 10.2.4.70-2 on both equipment
>>>                  An iperf from PC connected to the AP to the PC connected
>>> to the STA give 919 Mbps.
>>>                  An iperf from PC connected to the STA to the PC
>>> connected to the AP give 500 Mbps.
>>>
>>>          Second test : ATHK firmware 10.2.4.70.10-2 on both equipment
>>>                  An iperf from PC connected to the AP to the PC connected
>>> to the STA give 921 Mbps.
>>>                  An iperf from PC connected to the STA to the PC
>>> connected to the AP give 441 Mbps.
>>>
>>>          If I cross the computer I have the same result. I did several
>>> time these test and I always have the same result.
>>
>>
>> We see similar.  One thing we notice is that if you actually try to send
>> less
>> throughput, then you get better overall throughput.
>>
>> In other words, trying to send 1Gbps UDP frames will give you more poor
>> throughput than trying to send 650Mbps (in the upload direction).
>>
>> I thought it might be a poor interaction regarding backoff in the
>> ath10k driver/firmware (see the congestion bins in firmware for why
>> this is the case), but even fixing that in firmware didn't improve
>> the situation in my testing.
>
> If CPU is the bottleneck on DUT than overcommiting the UDP traffic at
> the source may lead the ethernet driver to waste CPU cycles on the
> DUT.

You are correct about the overcommit in general, but our systems are quite
overpowered.

We are testing with 3.5Ghz E5 quad-core systems...it is not just a CPU usage
issue.  And, exact same hardware runs great (close to 900Mbps) in AP download mode.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
