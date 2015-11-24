Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34942 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbbKXV3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 16:29:14 -0500
Subject: Re: ATH10 firmware question
To: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	ath10k@lists.infradead.org
References: <773DB8A82AB6A046AE0195C68612A31901C5AFA5@sbs2003.acksys.local>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5654D6A8.9050002@candelatech.com> (sfid-20151124_222917_871491_8B2EFE1B)
Date: Tue, 24 Nov 2015 13:29:12 -0800
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901C5AFA5@sbs2003.acksys.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2015 10:07 AM, Cedric VONCKEN wrote:
> 	Hi,
>
> 	I have a simple test platform.
> 	One PC connected to an equipment. This equipment is set in AP
> mode.
> 	Another PC connected to another equipment. This equipment is set
> in STA + WDS mode.
>
> 	Both equipment use the same openwrt Firmware (compat
> 2015-07-21), I only changed the ath10k firmware (in
> /lib/firmware/ath10k/...).
> 	Both equipment has the same hardware.
> 	I used a clear channel, and VHT80.
> 	The radio was connected with a coaxial cable and I placed 40 dBm
> attenuation per Rf chain.
> 	I used the WLN350NX radio card from compex.
> 	
> 	First test : ATH10K firmware 10.2.4.70-2 on both equipment
> 		An iperf from PC connected to the AP to the PC connected
> to the STA give 919 Mbps.
> 		An iperf from PC connected to the STA to the PC
> connected to the AP give 500 Mbps.
>
> 	Second test : ATHK firmware 10.2.4.70.10-2 on both equipment
> 		An iperf from PC connected to the AP to the PC connected
> to the STA give 921 Mbps.
> 		An iperf from PC connected to the STA to the PC
> connected to the AP give 441 Mbps.
>
> 	If I cross the computer I have the same result. I did several
> time these test and I always have the same result.

We see similar.  One thing we notice is that if you actually try to send less
throughput, then you get better overall throughput.

In other words, trying to send 1Gbps UDP frames will give you more poor
throughput than trying to send 650Mbps (in the upload direction).

I thought it might be a poor interaction regarding backoff in the
ath10k driver/firmware (see the congestion bins in firmware for why
this is the case), but even fixing that in firmware didn't improve
the situation in my testing.

Thanks,
Ben

>
> 	Is it the expected result?
> 	What is the recommanded firmware version for each mode?
> 	
> 	Thanks for your help.
>
> 	Cedric Voncken.
> 	
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

