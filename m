Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3555 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbeC0NKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:10:55 -0400
Message-ID: <1522156252.3786.272.camel@intel.com> (sfid-20180327_151058_913975_95CF37BC)
Subject: Re: [PATCH] iwlwifi: add device ID for Rivet Networks Killer
 Wireless-AC 1550
From: Luciano Coelho <luciano.coelho@intel.com>
To: Izzy Kulbe <kernel@unikorn.me>, Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 16:10:52 +0300
In-Reply-To: <a7f17e2bd232252004f71cbbc719781d68e735a4.camel@unikorn.me>
References: <1522148065.12122.5.camel@unikorn.me>
         <87370lrb7y.fsf@kamboji.qca.qualcomm.com>
         <2c826451177bbcb8fe033631dc7b87eb92f5e42d.camel@unikorn.me>
         <1522154254.3786.269.camel@intel.com> <1522154331.3786.270.camel@intel.com>
         <a7f17e2bd232252004f71cbbc719781d68e735a4.camel@unikorn.me>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 14:48 +0200, Izzy Kulbe wrote:
> On Tue, 2018-03-27 at 15:38 +0300, Luciano Coelho wrote:
> > On Tue, 2018-03-27 at 15:37 +0300, Luciano Coelho wrote:
> > > On Tue, 2018-03-27 at 14:03 +0200, Izzy Kulbe wrote:
> > > Wait a bit.  This ID looks strange, someone else reported this
> > > already
> > > and it looked strange, with an incorrect subsystem vendor ID.
> > > 
> > > Can you run lspci like this and let us know the results?
> > > weird 
> > > lspci -nv -s 3b:00.0
> > 
> > Sorry, please substitute the 3b:00.0 with the correct PCI slot in
> > your
> > system.  If you're not sure, remove the '-s 3b:00.0' entirely so
> > we'll
> > get the results for all devices.
> > 
> > --
> > Luca.
> 
> The subsystem device in lspci itself reports "Bigfoot Networks, 
> Inc. Wireless-AC 9260" instead of when lookup is enabled. AFAIR this
> was a company that was bought by Qualcomm? So not Rivet/Killer. 
> 
> Here's the lspci output:
> 
> root@dokidoki $> # lspci-nv -s 04:00.0
> 04:00.0 0280: 8086:2526 (rev 29)
> 	Subsystem: 1a56:1550
> 	Flags: bus master, fast devsel, latency 0, IRQ 17
> 	Memory at d3d00000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: [c8] Power Management version 3
> 	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
> 	Capabilities: [40] Express Endpoint, MSI 00
> 	Capabilities: [80] MSI-X: Enable+ Count=16 Masked-
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [14c] Latency Tolerance Reporting
> 	Capabilities: [154] L1 PM Substates
> 	Kernel driver in use: iwlwifi
> 	Kernel modules: iwlwifi

Thanks!

Yeah, this looks wrong and the same as someone else reported. :(

This value is coming from the OTP in the NIC and seems to be wrong.  I
have to contact our engineer who is responsible for the OTP data.  I'll
let you know once I get back some more information.

--
Cheers,
Luca.
