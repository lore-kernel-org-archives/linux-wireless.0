Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53535 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3AUOaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 09:30:20 -0500
Date: Mon, 21 Jan 2013 09:27:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Paul Freeman <linux-net@lists-in.noc4.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Intel Wifi 6200 N  iwlwifi (Unsupported (too old) EEPROM
 VER=0x416 < 0x423 CALIB=0x5 < 0x4)
Message-ID: <20130121142750.GA2212@tuxdriver.com> (sfid-20130121_153024_623546_CF2149DC)
References: <10f63cd798eeb6fa6168f6342af3c373@noc4.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <10f63cd798eeb6fa6168f6342af3c373@noc4.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last time we saw something like that, the Intel folks said it was
a device that was not supposed to have been released to the wild...?

On Mon, Jan 21, 2013 at 01:30:41PM +0000, Paul Freeman wrote:
> Hi,
>  I seem to be having and odd issue with iwlwifi (Unsupported (too
> old) EEPROM VER=0x416 < 0x423 CALIB=0x5 < 0x4) on a recently
> purchased Intel Wifi 6200 N mini pci-e card, is anyone aware of a
> fix for this ?
> 
> I did notice on older 2.6.* kernels it sort of worked (this may have
> been iwlagn though?)
> 
> uname -a
> ---------------------------------------------
> Linux cache-Inspiron-910 3.5.0-22-generic #34-Ubuntu SMP Tue Jan 8
> 21:41:11 UTC 2013 i686 i686 i686 GNU/Linux
> 
> lspci
> ---------------------------------------------
> 03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6200
> Subsystem: Intel Corporation Centrino Advanced-N 6200 2x2 AGN
> Flags: fast devsel, IRQ 17
> Memory at f0200000 (64-bit, non-prefetchable) [size=8K]
> Capabilities: [c8] Power Management version 3
> Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
> Capabilities: [e0] Express Endpoint, MSI 00
> Capabilities: [100] Advanced Error Reporting
> Capabilities: [140] Device Serial Number 00-15-00-ff-ff-5f-aa-59
> Kernel modules: iwlwifi
> 
> 
> firmware version 9.221.4.1 build 25532
> ---------------------------------------------
> [    3.636659] cfg80211: Calling CRDA to update world regulatory domain
> [    3.899749] iwlwifi: Intel(R) Wireless WiFi Link AGN driver for
> Linux, in-tree:
> [    3.899758] iwlwifi: Copyright(c) 2003-2012 Intel Corporation
> [    3.900111] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
> [    3.900120] iwlwifi 0000:03:00.0: pci_resource_base = f843c000
> [    3.900128] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
> [    3.900459] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
> 
> [    6.365912] cfg80211: World regulatory domain updated:
> [    6.365922] cfg80211:   (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [    6.365931] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [    6.365938] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [    6.365945] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [    6.365952] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [    6.365959] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> 
> [    6.683215] iwlwifi 0000:03:00.0: loaded firmware version
> 9.221.4.1 build 25532
> [    6.684588] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [    6.684599] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [    6.684607] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING
> enabled
> [    6.684614] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE
> enabled
> [    6.684622] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
> [    6.684631] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
> Advanced-N 6200 AGN, REV=0x74
> [    6.684856] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    6.716302] iwlwifi 0000:03:00.0: Unsupported (too old) EEPROM
> VER=0x416 < 0x423 CALIB=0x5 < 0x4
> 
> 
> as they were there I also tried the other firmwares from:
> http://wireless.kernel.org/en/users/Drivers/iwlwifi?n=downloads#Firmware
> 
> firmware version 9.193.4.1 build 19710
> ---------------------------------------------
> [ 2030.767040] iwlwifi: Intel(R) Wireless WiFi Link AGN driver for
> Linux, in-tree:
> [ 2030.767050] iwlwifi: Copyright(c) 2003-2012 Intel Corporation
> [ 2030.767332] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
> [ 2030.767340] iwlwifi 0000:03:00.0: pci_resource_base = f843c000
> [ 2030.767346] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
> [ 2030.767547] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
> [ 2030.797131] iwlwifi 0000:03:00.0: loaded firmware version
> 9.193.4.1 build 19710
> [ 2030.798313] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [ 2030.798327] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [ 2030.798335] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING
> enabled
> [ 2030.798344] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE
> enabled
> [ 2030.798352] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
> [ 2030.798363] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
> Advanced-N 6200 AGN, REV=0x74
> [ 2030.798555] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 2030.827866] iwlwifi 0000:03:00.0: Unsupported (too old) EEPROM
> VER=0x416 < 0x423 CALIB=0x5 < 0x4
> 
> firmware version 9.176.4.1 build 15835
> ---------------------------------------------
> [ 2263.767690] iwlwifi: Intel(R) Wireless WiFi Link AGN driver for
> Linux, in-tree:
> [ 2263.767701] iwlwifi: Copyright(c) 2003-2012 Intel Corporation
> [ 2263.767988] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
> [ 2263.767998] iwlwifi 0000:03:00.0: pci_resource_base = f843c000
> [ 2263.768005] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
> [ 2263.772210] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
> [ 2263.799205] iwlwifi 0000:03:00.0: loaded firmware version
> 9.176.4.1 build 15835
> [ 2263.800449] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [ 2263.800462] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [ 2263.800470] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING
> enabled
> [ 2263.800479] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE
> enabled
> [ 2263.800487] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
> [ 2263.800498] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
> Advanced-N 6200 AGN, REV=0x74
> [ 2263.800714] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 2263.829269] iwlwifi 0000:03:00.0: Unsupported (too old) EEPROM
> VER=0x416 < 0x423 CALIB=0x5 < 0x4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
