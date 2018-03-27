Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.unikorn.me ([176.9.143.13]:46372 "EHLO mail.unikorn.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbeC0Ms0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 08:48:26 -0400
Message-ID: <a7f17e2bd232252004f71cbbc719781d68e735a4.camel@unikorn.me> (sfid-20180327_144830_544794_F2B69BC8)
Subject: Re: [PATCH] iwlwifi: add device ID for Rivet Networks Killer
 Wireless-AC 1550
From: Izzy Kulbe <kernel@unikorn.me>
To: Luciano Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 14:48:16 +0200
In-Reply-To: <1522154331.3786.270.camel@intel.com>
References: <1522148065.12122.5.camel@unikorn.me>
         <87370lrb7y.fsf@kamboji.qca.qualcomm.com>
         <2c826451177bbcb8fe033631dc7b87eb92f5e42d.camel@unikorn.me>
         <1522154254.3786.269.camel@intel.com> <1522154331.3786.270.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 15:38 +0300, Luciano Coelho wrote:
> On Tue, 2018-03-27 at 15:37 +0300, Luciano Coelho wrote:
> > On Tue, 2018-03-27 at 14:03 +0200, Izzy Kulbe wrote:
> > Wait a bit.  This ID looks strange, someone else reported this
> > already
> > and it looked strange, with an incorrect subsystem vendor ID.
> > 
> > Can you run lspci like this and let us know the results?
> > weird 
> > lspci -nv -s 3b:00.0
> 
> Sorry, please substitute the 3b:00.0 with the correct PCI slot in your
> system.  If you're not sure, remove the '-s 3b:00.0' entirely so we'll
> get the results for all devices.
> 
> --
> Luca.

The subsystem device in lspci itself reports "Bigfoot Networks, 
Inc. Wireless-AC 9260" instead of when lookup is enabled. AFAIR this
was a company that was bought by Qualcomm? So not Rivet/Killer. 

Here's the lspci output:

root@dokidoki $> # lspci-nv -s 04:00.0
04:00.0 0280: 8086:2526 (rev 29)
	Subsystem: 1a56:1550
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at d3d00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [c8] Power Management version 3
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] MSI-X: Enable+ Count=16 Masked-
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [14c] Latency Tolerance Reporting
	Capabilities: [154] L1 PM Substates
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi
