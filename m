Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29198 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121AbcFONr6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 09:47:58 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Problems with mwifiex_pcie firmware activation
Date: Wed, 15 Jun 2016 13:47:53 +0000
Message-ID: <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com> (sfid-20160615_154802_238456_0F39E784)
References: <20160614135015.GB4962@redhat.com>
In-Reply-To: <20160614135015.GB4962@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Tuesday, June 14, 2016 7:20 PM
> To: Amitkumar Karwar
> Cc: Nishant Sarmukadam; linux-wireless@vger.kernel.org
> Subject: Problems with mwifiex_pcie firmware activation
> 
> I have two systems with this device:
> 
> 03:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
> 88W8897 [AVASTAR] 802.11ac Wireless [11ab:2b38]
> 	Flags: bus master, fast devsel, latency 0, IRQ 92
> 	Memory at 90700000 (64-bit, prefetchable) [size=1M]
> 	Memory at 90600000 (64-bit, prefetchable) [size=1M]
> 	Capabilities: [40] Power Management version 3
> 	Capabilities: [50] MSI: Enable+ Count=1/32 Maskable+ 64bit+
> 	Capabilities: [70] Express Endpoint, MSI 00
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [140] Device Serial Number 00-00-00-00-00-00-00-00
> 	Capabilities: [150] Power Budgeting <?>
> 	Capabilities: [160] Latency Tolerance Reporting
> 	Capabilities: [168] L1 PM Substates
> 	Kernel driver in use: mwifiex_pcie
> 
> Originally mwifiex_pcie driver from linux-4.7-rc3 fails to initialize
> the device with messages:
> 
> [   18.057875] mwifiex_pcie: try set_consistent_dma_mask(32)
> [   18.068694] mwifiex_pcie: PCI memory map Virt0: ffffc90000c00000 PCI
> memory map Virt2: ffffc90001c00000
> [   18.089754] mwifiex: rx work enabled, cpus 2
> [   18.317941] mwifiex_pcie 0000:02:00.0: PCI-E is not the winner
> <0x0,0>, exit dnld
> [   18.325531] mwifiex_pcie 0000:02:00.0: WLAN is not the winner! Skip
> FW dnld
> [   33.460842] mwifiex_pcie 0000:02:00.0: FW failed to be active in time
> [   33.467424] mwifiex_pcie 0000:02:00.0: info: mwifiex_fw_dpc:
> unregister device
> 
> On one system, I modify driver to skip check_winner_status() in
> mwifiex_dnld_fw() i.e. force firmware upload to device. On first boot of
> that modified kernel, system soft hang - there was very long or infinite
> loop on some mwifiex procedure (I fail to get exact logs from this
> problem). On second boot, soft hang was gone and device still fail (with
> different messages):
> 
> [    8.167830] mwifiex_pcie: try set_consistent_dma_mask(32)
> [    8.174098] mwifiex_pcie: PCI memory map Virt0: ffffc90001c00000 PCI
> memory map Virt2: ffffc90001e00000
> [    8.195099] mwifiex: rx work enabled, cpus 2
> [    9.595060] mwifiex_pcie 0000:03:00.0: info: FW download over, size
> 820212 bytes
> [    9.714066] mwifiex_pcie 0000:03:00.0: FW failed to be active in time
> [    9.720598] mwifiex_pcie 0000:03:00.0: info: mwifiex_fw_dpc:
> unregister device
> 
> However now on unmodified kernel on the same system, driver is capable
> to initialize the device:
> 
> [    8.751231] mwifiex_pcie: try set_consistent_dma_mask(32)
> [    8.792175] mwifiex_pcie: PCI memory map Virt0: ffffc90001c00000 PCI
> memory map Virt2: ffffc90001e00000
> [    8.814868] mwifiex: rx work enabled, cpus 2
> [   10.218692] mwifiex_pcie 0000:03:00.0: info: FW download over, size
> 820212 bytes
> [   10.937332] mwifiex_pcie 0000:03:00.0: WLAN FW is active
> [   11.052624] mwifiex_pcie 0000:03:00.0: info: MWIFIEX VERSION: mwifiex
> 1.0 (15.68.7.p77)
> [   11.060810] mwifiex_pcie 0000:03:00.0: driver_version = mwifiex 1.0
> (15.68.7.p77)
> [   11.218702] mwifiex_pcie 0000:03:00.0 wlp3s0: renamed from mlan0
> 
> Hence looks like forcing firmware upload somehow changed device, now it
> is capable to initialize. On my second system device is on pristine
> state and original problem is still reproducible. Do you have good
> solution for this problem ?
> 

Could you please share complete dmesg log for failure and successful cases?
Probably mwifiex is trying to download the firmware through USB. We had fixed this problem with below patch. Check if it's part of your codebase.
https://patchwork.kernel.org/patch/7154601/

Regards,
Amitkumar
