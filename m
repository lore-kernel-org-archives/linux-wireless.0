Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:46263 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbZG1Mbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 08:31:44 -0400
Received: by rv-out-0506.google.com with SMTP id k40so762446rvb.5
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 05:31:44 -0700 (PDT)
Subject: iwlagn - compat-wireless (5GHz) and fglrx modules
From: Greg Oliver <oliver.greg@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 28 Jul 2009 07:31:35 -0500
Message-Id: <1248784295.7020.2.camel@ghost-linux>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am experiencing a very odd issue between the ilagn and fglrx modules.
I am writing here since the ubuntu devs are not supporting running
either modules (fglrx since I am not using their packages, or iwlagn
since I am using the compat-wireless frmo linux-wireless.org).

The results are very reproducible - here is what is happening:

I can successfully use any version of compat-wireless with the OSS ATI
video modules.  I can successfully run the closed source fglrx ATI
module with the Ubuntu provided (albeit ancient) iwlagn and related
modules.  Once I try to run the closed fglrx module alongside the
compat-wireless packages from linux-wireless, ONLY the 5GHz channels
(both wide and narrow) fail.  Association works, but debug outputs over
and over:

[  470.128306] iwlagn 0000:04:00.0: ERROR: No TX rate available.

over and over....  Switching to a 2.4 channel works like a champ, but
the laptop in general is unstable and sometimes becomes unusable, and
others kard kernel locks (blinking caps lock)..

I have tried All Ubuntu kernel PPA kernels as well as latest git and
released compat-wireless relases with same effect, as well as all ATI
catalyst drivers from 9.4 - 9.7.

Hardware invloved:

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility
HD 3670
    Subsystem: Dell Device 0272
    Flags: bus master, fast devsel, latency 0, IRQ 2296
    Memory at d0000000 (32-bit, prefetchable) [size=256M]
    I/O ports at 2000 [size=256]
    Memory at cfef0000 (32-bit, non-prefetchable) [size=64K]
    [virtual] Expansion ROM at cfe00000 [disabled] [size=128K]
    Capabilities: <access denied>
    Kernel driver in use: fglrx_pci
    Kernel modules: fglrx

04:00.0 Network controller: Intel Corporation PRO/Wireless 5300 AGN
[Shiloh] Network Connection
    Subsystem: Intel Corporation Device 1101
    Flags: bus master, fast devsel, latency 0, IRQ 2297
    Memory at f8000000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: <access denied>
    Kernel driver in use: iwlagn
    Kernel modules: iwlagn

BAD Module combo:

filename:       /lib/modules/2.6.28-13-generic/updates/dkms/fglrx.ko
license:        Proprietary. (C) 2002 - ATI Technologies, Starnberg,
GERMANY
description:    ATI Fire GL
author:         Fire GL - ATI Research GmbH, Germany
srcversion:     2C2CE01E2172B42D35D1980
alias:          pci:v00001002d000095CFsv*sd*bc*sc*i*
alias:          pci:v00001002d000095CEsv*sd*bc*sc*i*
alias:          pci:v00001002d000095CDsv*sd*bc*sc*i*
alias:          pci:v00001002d00009446sv*sd*bc*sc*i*
alias:          pci:v00001002d00009456sv*sd*bc*sc*i*
alias:          pci:v00001002d00009444sv*sd*bc*sc*i*
alias:          pci:v00001002d0000949Csv*sd*bc*sc*i*
alias:          pci:v00001002d0000949Esv*sd*bc*sc*i*
alias:          pci:v00001002d0000949Fsv*sd*bc*sc*i*
alias:          pci:v00001002d00009511sv*sd*bc*sc*i*
alias:          pci:v00001002d0000958Dsv*sd*bc*sc*i*
alias:          pci:v00001002d0000958Csv*sd*bc*sc*i*
alias:          pci:v00001002d000095CCsv*sd*bc*sc*i*
alias:          pci:v00001002d00009447sv*sd*bc*sc*i*
alias:          pci:v00001002d0000944Fsv*sd*bc*sc*i*
alias:          pci:v00001002d0000940Asv*sd*bc*sc*i*
alias:          pci:v00001002d0000940Bsv*sd*bc*sc*i*
alias:          pci:v00001002d0000940Fsv*sd*bc*sc*i*
alias:          pci:v00001002d0000946Bsv*sd*bc*sc*i*
alias:          pci:v00001002d0000946Asv*sd*bc*sc*i*
alias:          pci:v00001002d0000947Bsv*sd*bc*sc*i*
alias:          pci:v00001002d0000947Asv*sd*bc*sc*i*
alias:          pci:v00001002d000094A3sv*sd*bc*sc*i*
alias:          pci:v00001002d00009489sv*sd*bc*sc*i*
alias:          pci:v00001002d0000959Bsv*sd*bc*sc*i*
alias:          pci:v00001002d00009595sv*sd*bc*sc*i*
alias:          pci:v00001002d0000958Fsv*sd*bc*sc*i*
alias:          pci:v00001002d0000945Bsv*sd*bc*sc*i*
alias:          pci:v00001002d0000945Asv*sd*bc*sc*i*
alias:          pci:v00001002d0000944Bsv*sd*bc*sc*i*
alias:          pci:v00001002d0000944Asv*sd*bc*sc*i*
alias:          pci:v00001002d000094A1sv*sd*bc*sc*i*
alias:          pci:v00001002d000094A0sv*sd*bc*sc*i*
alias:          pci:v00001002d00009488sv*sd*bc*sc*i*
alias:          pci:v00001002d00009480sv*sd*bc*sc*i*
alias:          pci:v00001002d00009491sv*sd*bc*sc*i*
alias:          pci:v00001002d00009555sv*sd*bc*sc*i*
alias:          pci:v00001002d00009552sv*sd*bc*sc*i*
alias:          pci:v00001002d00009553sv*sd*bc*sc*i*
alias:          pci:v00001002d00009509sv*sd*bc*sc*i*
alias:          pci:v00001002d00009508sv*sd*bc*sc*i*
alias:          pci:v00001002d00009506sv*sd*bc*sc*i*
alias:          pci:v00001002d00009504sv*sd*bc*sc*i*
alias:          pci:v00001002d00009593sv*sd*bc*sc*i*
alias:          pci:v00001002d00009591sv*sd*bc*sc*i*
alias:          pci:v00001002d000095C2sv*sd*bc*sc*i*
alias:          pci:v00001002d000095C4sv*sd*bc*sc*i*
alias:          pci:v00001002d0000958Bsv*sd*bc*sc*i*
alias:          pci:v00001002d00009583sv*sd*bc*sc*i*
alias:          pci:v00001002d00009581sv*sd*bc*sc*i*
alias:          pci:v00001002d000094C8sv*sd*bc*sc*i*
alias:          pci:v00001002d000094CBsv*sd*bc*sc*i*
alias:          pci:v00001002d000094C9sv*sd*bc*sc*i*
alias:          pci:v00001002d00009462sv*sd*bc*sc*i*
alias:          pci:v00001002d00009460sv*sd*bc*sc*i*
alias:          pci:v00001002d00009440sv*sd*bc*sc*i*
alias:          pci:v00001002d0000944Esv*sd*bc*sc*i*
alias:          pci:v00001002d00009442sv*sd*bc*sc*i*
alias:          pci:v00001002d00009452sv*sd*bc*sc*i*
alias:          pci:v00001002d0000944Csv*sd*bc*sc*i*
alias:          pci:v00001002d00009450sv*sd*bc*sc*i*
alias:          pci:v00001002d000094B1sv*sd*bc*sc*i*
alias:          pci:v00001002d000094B3sv*sd*bc*sc*i*
alias:          pci:v00001002d000094B5sv*sd*bc*sc*i*
alias:          pci:v00001002d00009495sv*sd*bc*sc*i*
alias:          pci:v00001002d00009490sv*sd*bc*sc*i*
alias:          pci:v00001002d00009498sv*sd*bc*sc*i*
alias:          pci:v00001002d0000948Fsv*sd*bc*sc*i*
alias:          pci:v00001002d00009487sv*sd*bc*sc*i*
alias:          pci:v00001002d0000954Fsv*sd*bc*sc*i*
alias:          pci:v00001002d0000954Esv*sd*bc*sc*i*
alias:          pci:v00001002d00009542sv*sd*bc*sc*i*
alias:          pci:v00001002d00009541sv*sd*bc*sc*i*
alias:          pci:v00001002d00009540sv*sd*bc*sc*i*
alias:          pci:v00001002d00009517sv*sd*bc*sc*i*
alias:          pci:v00001002d00009519sv*sd*bc*sc*i*
alias:          pci:v00001002d00009515sv*sd*bc*sc*i*
alias:          pci:v00001002d00009500sv*sd*bc*sc*i*
alias:          pci:v00001002d00009507sv*sd*bc*sc*i*
alias:          pci:v00001002d00009501sv*sd*bc*sc*i*
alias:          pci:v00001002d00009505sv*sd*bc*sc*i*
alias:          pci:v00001002d00009597sv*sd*bc*sc*i*
alias:          pci:v00001002d00009596sv*sd*bc*sc*i*
alias:          pci:v00001002d00009599sv*sd*bc*sc*i*
alias:          pci:v00001002d00009598sv*sd*bc*sc*i*
alias:          pci:v00001002d00009590sv*sd*bc*sc*i*
alias:          pci:v00001002d00009589sv*sd*bc*sc*i*
alias:          pci:v00001002d00009588sv*sd*bc*sc*i*
alias:          pci:v00001002d00009580sv*sd*bc*sc*i*
alias:          pci:v00001002d00009587sv*sd*bc*sc*i*
alias:          pci:v00001002d00009586sv*sd*bc*sc*i*
alias:          pci:v00001002d0000958Esv*sd*bc*sc*i*
alias:          pci:v00001002d0000958Asv*sd*bc*sc*i*
alias:          pci:v00001002d000095C6sv*sd*bc*sc*i*
alias:          pci:v00001002d000095C9sv*sd*bc*sc*i*
alias:          pci:v00001002d000095C7sv*sd*bc*sc*i*
alias:          pci:v00001002d000095C5sv*sd*bc*sc*i*
alias:          pci:v00001002d000095C0sv*sd*bc*sc*i*
alias:          pci:v00001002d000094CCsv*sd*bc*sc*i*
alias:          pci:v00001002d000094C6sv*sd*bc*sc*i*
alias:          pci:v00001002d000094C5sv*sd*bc*sc*i*
alias:          pci:v00001002d000094C4sv*sd*bc*sc*i*
alias:          pci:v00001002d000094C3sv*sd*bc*sc*i*
alias:          pci:v00001002d000094C1sv*sd*bc*sc*i*
alias:          pci:v00001002d000094C7sv*sd*bc*sc*i*
alias:          pci:v00001002d000094C0sv*sd*bc*sc*i*
alias:          pci:v00001002d00009443sv*sd*bc*sc*i*
alias:          pci:v00001002d00009441sv*sd*bc*sc*i*
alias:          pci:v00001002d00009451sv*sd*bc*sc*i*
alias:          pci:v00001002d00009513sv*sd*bc*sc*i*
alias:          pci:v00001002d0000950Fsv*sd*bc*sc*i*
alias:          pci:v00001002d00009405sv*sd*bc*sc*i*
alias:          pci:v00001002d00009403sv*sd*bc*sc*i*
alias:          pci:v00001002d00009402sv*sd*bc*sc*i*
alias:          pci:v00001002d00009401sv*sd*bc*sc*i*
alias:          pci:v00001002d00009400sv*sd*bc*sc*i*
alias:          pci:v00001002d00009714sv*sd*bc*sc*i*
alias:          pci:v00001002d00009713sv*sd*bc*sc*i*
alias:          pci:v00001002d00009712sv*sd*bc*sc*i*
alias:          pci:v00001002d00009711sv*sd*bc*sc*i*
alias:          pci:v00001002d00009710sv*sd*bc*sc*i*
alias:          pci:v00001002d00009616sv*sd*bc*sc*i*
alias:          pci:v00001002d00009615sv*sd*bc*sc*i*
alias:          pci:v00001002d00009614sv*sd*bc*sc*i*
alias:          pci:v00001002d00009613sv*sd*bc*sc*i*
alias:          pci:v00001002d00009612sv*sd*bc*sc*i*
alias:          pci:v00001002d00009611sv*sd*bc*sc*i*
alias:          pci:v00001002d00009610sv*sd*bc*sc*i*
depends:        
vermagic:       2.6.28-13-generic SMP mod_unload modversions 
parm:           firegl:charp


filename:       /lib/modules/2.6.28-13-generic/updates/drivers/net/wireless/iwlwifi/iwlagn.ko
alias:          iwl4965
license:        GPL
author:         Copyright(c) 2003-2009 Intel Corporation
<ilw@linux.intel.com>
version:        1.3.27ks
description:    Intel(R) Wireless WiFi Link AGN driver for Linux
firmware:       iwlwifi-4965-2.ucode
firmware:       iwlwifi-5150-2.ucode
firmware:       iwlwifi-5000-2.ucode
firmware:       iwlwifi-6050-2.ucode
firmware:       iwlwifi-6000-2.ucode
srcversion:     B87DD476B37C73CA673C6F4
alias:          pci:v00008086d00000084sv*sd*bc*sc*i*
alias:          pci:v00008086d00000083sv*sd*bc*sc*i*
alias:          pci:v00008086d00000089sv*sd*bc*sc*i*
alias:          pci:v00008086d00000088sv*sd*bc*sc*i*
alias:          pci:v00008086d00000087sv*sd*bc*sc*i*
alias:          pci:v00008086d00000086sv*sd*bc*sc*i*
alias:          pci:v00008086d00000085sv*sd*bc*sc*i*
alias:          pci:v00008086d00000082sv*sd*bc*sc*i*
alias:          pci:v00008086d00004239sv*sd*bc*sc*i*
alias:          pci:v00008086d00004238sv*sd*bc*sc*i*
alias:          pci:v00008086d0000422Csv*sd*bc*sc*i*
alias:          pci:v00008086d0000422Bsv*sd*bc*sc*i*
alias:          pci:v00008086d00000082sv*sd00001122bc*sc*i*
alias:          pci:v00008086d00000085sv*sd00001112bc*sc*i*
alias:          pci:v00008086d00000082sv*sd00001102bc*sc*i*
alias:          pci:v00008086d0000423Dsv*sd*bc*sc*i*
alias:          pci:v00008086d0000423Csv*sd*bc*sc*i*
alias:          pci:v00008086d0000423Bsv*sd00001011bc*sc*i*
alias:          pci:v00008086d0000423Asv*sd00001021bc*sc*i*
alias:          pci:v00008086d0000423Asv*sd00001001bc*sc*i*
alias:          pci:v00008086d00004237sv*sd*bc*sc*i*
alias:          pci:v00008086d00004236sv*sd*bc*sc*i*
alias:          pci:v00008086d00004235sv*sd*bc*sc*i*
alias:          pci:v00008086d00004232sv*sd*bc*sc*i*
alias:          pci:v00008086d00004237sv*sd00001216bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001326bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001306bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001206bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001305bc*sc*i*
alias:          pci:v00008086d00004232sv*sd00001205bc*sc*i*
alias:          pci:v00008086d00004230sv*sd*bc*sc*i*
alias:          pci:v00008086d00004229sv*sd*bc*sc*i*
depends:        iwlcore,mac80211,cfg80211
vermagic:       2.6.28-13-generic SMP mod_unload modversions 
parm:           swcrypto50:using software crypto engine (default 0
[hardware])
 (bool)
parm:           debug50:50XX debug output mask (uint)
parm:           queues_num50:number of hw queues in 50xx series (int)
parm:           11n_disable50:disable 50XX 11n functionality (int)
parm:           amsdu_size_8K50:enable 8K amsdu size in 50XX series
(int)
parm:           fw_restart50:restart firmware in case of error (int)
parm:           antenna:select antenna (1=Main, 2=Aux, default 0 [both])
(int)
parm:           swcrypto:using crypto in software (default 0 [hardware])
(int)
parm:           debug:debug output mask (uint)
parm:           disable_hw_scan:disable hardware scanning (default 0)
(int)
parm:           queues_num:number of hw queues. (int)
parm:           11n_disable:disable 11n functionality (int)
parm:           amsdu_size_8K:enable 8K amsdu size (int)
parm:           fw_restart4965:restart firmware in case of error (int)

[   18.189913] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
1.3.27ks
[   18.189915] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   18.189993] iwlagn 0000:04:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[   18.190000] iwlagn 0000:04:00.0: setting latency timer to 64
[   18.190061] iwlagn 0000:04:00.0: Detected Intel Wireless WiFi Link
5300AGN REV=0x24
[   18.227051] iwlagn 0000:04:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[   18.227114] iwlagn 0000:04:00.0: irq 2297 for MSI/MSI-X
[   18.270223] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   78.738523] iwlagn 0000:04:00.0: firmware: requesting
iwlwifi-5000-2.ucode
[   78.845574] iwlagn 0000:04:00.0: loaded firmware version 8.24.2.12
[   79.026242] Registered led device: iwl-phy0::radio
[   79.027598] Registered led device: iwl-phy0::assoc
[   79.027624] Registered led device: iwl-phy0::RX
[   79.027640] Registered led device: iwl-phy0::TX

Easiest way to remedy is to simply remove the compat-wireless "extra"
modules and reload the originals.

Thanks, and I can provide any info needed to try to get somewhere with
this.

-Greg

