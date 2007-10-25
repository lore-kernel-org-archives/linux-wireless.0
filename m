Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbXJYNqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:46:52 -0400
Subject: Re: iwl4965 detection problem
From: Dan Williams <dcbw@redhat.com>
To: Jes Sorensen <jes@sgi.com>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <47209C0C.5010505@sgi.com>
References: <47209C0C.5010505@sgi.com>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 09:45:25 -0400
Message-Id: <1193319925.5542.8.camel@localhost.localdomain> (sfid-20071025_144655_565959_C130B8D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-25 at 15:37 +0200, Jes Sorensen wrote:
> Hi,
> 
> I just got my hands on a new Toshiba Portege R500 laptop, which comes
> with the Intel 4965 chip in it. After installing the latest Fedora Core
> 8 test 3 on it, and updating the kernel I am still seeing a problem with
> detection of the 4965 in my laptop.
> 
> Fedora Core 8 test 3 is based on a 2.6.23.1 kernel.
> 
> Basically on the first load of the iwl4965 module no interface is
> detected, but if I rmmod and modprobe it again, it shows up and works
> just fine.

You'll need to update more than just the kernel.  There were issues with
Test 3 for udev and network init scripts that didn't distinguish between
the wmasterX and wlanX interfaces, and since both have the same MAC
address things got confused.

Try updating to the latest Rawhide bits rather than using Test 3.  The
make sure you remove the following files:

rm -f /etc/sysconfig/network-scripts/ifcfg-wlan0*
rm -f /etc/udev/rules.d/70-persistent-net.rules

The initscripts don't care what's after the ifcfg- (because you could
name it ifcfg-Home or ifcfg-Some-Other-Place, it doesn't have to be the
device name) and therefore even a ifcfg-wlan0.bak will cause the problem
too.

Dan

> I haven't yet tried the latest kernel.org tree on this box, but looking
> through the git log, I don't see any commits that look like they were
> addressing this problem.
> 
> Is this a problem you have heard about before? Anything information I
> can provide to help?
> 
> I have attached the lspci -vv entry for this device, as well as the
> dmesg output.
> 
> Cheers,
> Jes
> 
> 02:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or 
> AGN Network Connection (rev 61)
> 	Subsystem: Intel Corporation Unknown device 1101
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
> <MAbort- >SERR- <PERR-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 2300
> 	Region 0: Memory at ff8fe000 (64-bit, non-prefetchable) [size=8K]
> 	Capabilities: [c8] Power Management version 3
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
> Enable+
> 		Address: 00000000fee0300c  Data: 41a9
> 	Capabilities: [e0] Express Endpoint IRQ 0
> 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
> 		Device: Latency L0s <512ns, L1 unlimited
> 		Device: AtnBtn- AtnInd- PwrInd-
> 		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
> 		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
> 		Link: Latency L0s <128ns, L1 <64us
> 		Link: ASPM L0s Enabled RCB 64 bytes CommClk+ ExtSynch-
> 		Link: Speed 2.5Gb/s, Width x1
> 
> dmesg output:
> 
> First time it's loaded:
> 
> firewire_ohci: Added fw-ohci device 0000:03:0b.1, OHCI version 1.10
> sdhci: SDHCI controller found at 0000:03:0b.3 [104c:803c] (rev 0)
> PCI: Enabling device 0000:03:0b.3 (0000 -> 0002)
> ACPI: PCI Interrupt 0000:03:0b.3[D] -> GSI 23 (level, low) -> IRQ 23
> mmc0: SDHCI at 0x90005800 irq 23 DMA
> iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.1.17kds
> iwl4965: Copyright(c) 2003-2007 Intel Corporation
> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:02:00.0 to 64
> iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> tpm_inf_pnp 00:0a: Found TPM with ID IFX0102
> tpm_inf_pnp 00:0a: TPM found: config base 0x4e, data base 0x680, chip 
> version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 
> TT 1.2)
> intel_rng: FWH not detected
> .......
> rmmod+modprobe'ing it again:
> 
> [drm] Initialized drm 1.1.0 20060810
> [drm] Initialized i915 1.6.0 20060119 on minor 0
> ACPI: PCI interrupt for device 0000:02:00.0 disabled
> iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.1.17kds
> iwl4965: Copyright(c) 2003-2007 Intel Corporation
> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:02:00.0 to 64
> iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
> phy1: Selected rate control algorithm 'iwl-4965-rs'
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

