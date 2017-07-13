Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54673 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdGMKeq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Jul 2017 06:34:46 -0400
Date: Thu, 13 Jul 2017 19:14:46 +0900
From: Carsten Haitzler (The Rasterman) <raster@rasterman.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath10k QCA6174 not working -> missing data in board2.bin?
Message-Id: <20170713191446.aa186386ba1f4a7c2b8d8b96@rasterman.com> (sfid-20170713_123450_584133_D073ED51)
In-Reply-To: <20170705205258.a5ca8ca700de06c5e3c33677@rasterman.com>
References: <20170705205258.a5ca8ca700de06c5e3c33677@rasterman.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 5 Jul 2017 20:52:58 +0900 Carsten Haitzler (The Rasterman)
<raster@rasterman.com> said:

... and info on this? i'm wondering if this variant requires custom firmware? board-2.bin isn't happy and i can't find pointers/info on what this is and where the data came from...

i've built the linux wireless master tree and got firmware-6 working ... but
same results. i can get a bit more out of the qualcomm wifi device if i switch
irq mode:

[  365.108503] ath10k_pci 0000:01:00.0: limiting irq mode to: 1
[  365.108505] ath10k_pci 0000:01:00.0: pci irq legacy oper_irq_mode 1 irq_mode 1 reset_mode 1
[  365.444164] ath10k_pci 0000:01:00.0: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 144d:c14f
[  365.444166] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
[  365.444587] ath10k_pci 0000:01:00.0: firmware ver WLAN.RM.4.4.1-00014-QCARMSWP-1 api 6 features wowlan,ignore-otp crc32 f26d4f5b
[  365.509151] ath10k_pci 0000:01:00.0: failed to fetch board data for bus=pci,vendor=168c,device=003e,subsystem-vendor=144d,subsystem-device=c14f,variant=K from ath10k/QCA6174/hw3.0/board-2.bin
[  365.509167] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A crc32 ed5f849a
[  366.084214] ath10k_pci 0000:01:00.0: Unknown eventid: 118809
[  366.087206] ath10k_pci 0000:01:00.0: Unknown eventid: 90118
[  366.087699] ath10k_pci 0000:01:00.0: htt-ver 3.44 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
[  369.119046] ath10k_pci 0000:01:00.0: could not suspend target (-11)
[  369.231789] ath: EEPROM regdomain: 0x0
[  369.231790] ath: EEPROM indicates default country code should be used
[  369.231791] ath: doing EEPROM country->regdmn map search
[  369.231792] ath: country maps to regdmn code: 0x3a
[  369.231792] ath: Country alpha2 being used: US
[  369.231793] ath: Regpair used: 0x3a
[  369.981913] ath10k_pci 0000:01:00.0: Unknown eventid: 118809
[  369.984910] ath10k_pci 0000:01:00.0: Unknown eventid: 90118
[  373.172159] ath10k_pci 0000:01:00.0: failed to enable dynamic BW: -11
[  379.572152] ath10k_pci 0000:01:00.0: could not suspend target (-11)
[  379.686241] ath10k_pci 0000:01:00.0 wlp1s0: renamed from wlan0

there's something up here and i'm not sure where to begin other than "grab the windows driver firmware and use that" ... but i dont know if that's possible or even how to transform it into a usable form.

any advice?

> I've scored myself a new laptop. With that come new problems.
> 
> I updated to 4.12.0 to make sure i'm on the latest.
> 
> lspci says:
> 
> 01:00.0 Network controller: Qualcomm Atheros QCA6174 802.11ac Wireless
> Network Adapter (rev 32)
> 
> So relevant bits from dmesg:
> 
> [  124.268483] ath10k_pci 0000:01:00.0: pci irq msi oper_irq_mode 2 irq_mode
> 0 reset_mode 0 [  124.524661] ath10k_pci 0000:01:00.0: qca6174 hw3.2 target
> 0x05030000 chip_id 0x00340aff sub 144d:c14f [  124.524668] ath10k_pci
> 0000:01:00.0: kconfig debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
> [  124.526309] ath10k_pci 0000:01:00.0: firmware ver
> WLAN.RM.4.4.1-00008-QCARMSWP-1 api 6 features wowlan,ignore-otp crc32
> bdced4e9 [  124.590884] ath10k_pci 0000:01:00.0: failed to fetch board data
> for
> bus=pci,vendor=168c,device=003e,subsystem-vendor=144d,subsystem-device=c14f,variant=K
> from ath10k/QCA6174/hw3.0/board-2.bin [  124.590901] ath10k_pci 0000:01:00.0:
> board_file api 1 bmi_id N/A crc32 ed5f849a [  125.164076] ath10k_pci
> 0000:01:00.0: Unknown eventid: 118809 [  125.167113] ath10k_pci 0000:01:00.0:
> Unknown eventid: 90118
> 
> I've tried firmware-6 from:
> 
>   https://github.com/kvalo/ath10k-firmware/tree/master/QCA6174/hw3.0
> 
> Specifically firmware-6.bin_WLAN.RM.4.4.1-00008-QCARMSWP-1. firmware-4.bin
> also is a no go.
> 
> How can I help make this work? I have all the windows .bin's but none of them
> match the same header that the Linux fw bin files have (but a chunk of the
> binary seems familiar having a quick binary dump of it). There is some
> mysterious way of generating the Linux firmware files I can't google for.
> 
> I also have some help from the OEM - the engineers who made the laptop (not
> the chip wifi maker though). I have already verified which GPIO lines control
> RFkill on this device (and they are clear and unkilled by default - both lines
> up at 1 and it's confirmed that this means RF is unblocked from the engineers.
> It took me a while to figure out their GPIO mapping table/naming onto kernel
> GPIO numbering). So the Wifi (an BT actually) should be powered on. It's a
> combo chip.
> 
> So how can I help. What data do I need to scrounge to provide. How are
> firmware files built to work for Linux (based off the windows ones) for
> ath10k?
> 
> -- 
> ------------- Codito, ergo sum - "I code, therefore I am" --------------
> The Rasterman (Carsten Haitzler)    raster@rasterman.com
> 


-- 
------------- Codito, ergo sum - "I code, therefore I am" --------------
The Rasterman (Carsten Haitzler)    raster@rasterman.com
