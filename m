Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp28.msg.oleane.net ([62.161.4.28]:49673 "EHLO
	smtp28.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbbKYKlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:41:32 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Ben Greear'" <greearb@candelatech.com>,
	"'Michal Kazior'" <michal.kazior@tieto.com>
Cc: <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A31901C5AFA5@sbs2003.acksys.local>	<5654D6A8.9050002@candelatech.com> <CA+BoTQk2UXskCOPafxmd-2YzAceg=oMd1BKkDpwcX2LwazVQ-A@mail.gmail.com> <5655530B.9030407@candelatech.com>
In-Reply-To: <5655530B.9030407@candelatech.com>
Subject: RE: ATH10 firmware question
Date: Wed, 25 Nov 2015 11:41:05 +0100
Message-ID: <04a201d1276d$c9a6b7c0$5cf42740$@acksys.fr> (sfid-20151125_114139_746829_F3CED181)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

Thanks for your answer.

> >>>
> >>>          Hi,
> >>>
> >>>          I have a simple test platform.
> >>>          One PC connected to an equipment. This equipment is set in
> >>> AP mode.
> >>>          Another PC connected to another equipment. This equipment
> >>> is set in STA + WDS mode.
> >>>
> >>>          Both equipment use the same openwrt Firmware (compat
> >>> 2015-07-21), I only changed the ath10k firmware (in
> >>> /lib/firmware/ath10k/...).
> >>>          Both equipment has the same hardware.
> >>>          I used a clear channel, and VHT80.
> >>>          The radio was connected with a coaxial cable and I placed
> >>> 40 dBm attenuation per Rf chain.
> >>>          I used the WLN350NX radio card from compex.
> >>>
> >>>          First test : ATH10K firmware 10.2.4.70-2 on both equipment
> >>>                  An iperf from PC connected to the AP to the PC
> >>> connected to the STA give 919 Mbps.
> >>>                  An iperf from PC connected to the STA to the PC
> >>> connected to the AP give 500 Mbps.
> >>>
> >>>          Second test : ATHK firmware 10.2.4.70.10-2 on both equipment
> >>>                  An iperf from PC connected to the AP to the PC
> >>> connected to the STA give 921 Mbps.
> >>>                  An iperf from PC connected to the STA to the PC
> >>> connected to the AP give 441 Mbps.
> >>>
> >>>          If I cross the computer I have the same result. I did
> >>> several time these test and I always have the same result.
> >>
> >>
> >> We see similar.  One thing we notice is that if you actually try to
> >> send less throughput, then you get better overall throughput.
> >>
> >> In other words, trying to send 1Gbps UDP frames will give you more
> >> poor throughput than trying to send 650Mbps (in the upload direction).
> >>
> >> I thought it might be a poor interaction regarding backoff in the
> >> ath10k driver/firmware (see the congestion bins in firmware for why
> >> this is the case), but even fixing that in firmware didn't improve
> >> the situation in my testing.
> >
> > If CPU is the bottleneck on DUT than overcommiting the UDP traffic at
> > the source may lead the ethernet driver to waste CPU cycles on the
> > DUT.
> 
> You are correct about the overcommit in general, but our systems are quite
> overpowered.
> 
> We are testing with 3.5Ghz E5 quad-core systems...it is not just a CPU
> usage issue.  And, exact same hardware runs great (close to 900Mbps) in AP
> download mode.
>
In my case I'm testing with mips 64 dual core at 1.2 GHz. The CPU load is around 50% during my test. I'm agree with Ben, the issue is not in CPU.

I tried this morning with different firmware version. I only change the ath10K firmware in client side and I only test the client Tx performance.

Test with firmware 999.999.0.636
Unfortunately this firmware does not support the WDS mode, I need to update my setting. With this firmware I have a better performance, I can reach 700 Mbps. 

Test with firmware 10.1.467-ct-15 from candelatech (full community version)
I tested in WDS setting and the same setting of previous firmware to be sure the setting have no impact on the performance. In both case I can reach around 650 Mbps.
I tested with beta-16 firmware from candelatech, but I have a similar performance.

Thanks
Cedric.

