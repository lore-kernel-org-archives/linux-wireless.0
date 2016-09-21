Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36570 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934774AbcIUQ1k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 12:27:40 -0400
Received: by mail-qk0-f170.google.com with SMTP id z190so50758948qkc.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 09:27:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHdg3xa4Z0=WVMDtHv2KLtzAgB8fyiuefEodKZwUb=jjmNyppg@mail.gmail.com>
References: <CAF3cwD2jkXTbZAw7YPE2mDyZKgEUCdWOXDAqkt6zLbXLV6uT9g@mail.gmail.com>
 <CA+BoTQk91bgNVB0MA2TGuDhSr-fXtggysP+wTm9-V1XO6J314A@mail.gmail.com> <CAHdg3xa4Z0=WVMDtHv2KLtzAgB8fyiuefEodKZwUb=jjmNyppg@mail.gmail.com>
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Wed, 21 Sep 2016 18:27:39 +0200
Message-ID: <CAHdg3xYyEVAYEQimkjsPEUTcLD57KjcFYnkwbaPS0hHDmTZXbA@mail.gmail.com> (sfid-20160921_182744_526835_97E9CEE2)
Subject: Re: ath10k mesh mode issue
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Matteo Grandi <grn.matteo@gmail.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,
thanks for the reply:
I've already loaded the ath10k_core with the rowmode parameters, this
is the modinfo result:
root@Tam:~# modinfo ath10k_core
filename:
/lib/modules/3.14.48-g408ccb9/kernel/drivers/net/wireless/ath/ath10k/ath10k=
_core.ko
license:        Dual BSD/GPL
description:    Core module for QCA988X PCIe devices.
author:         Qualcomm Atheros
srcversion:     407804E6D5A63597F137E9B
depends:        mac80211,cfg80211,compat,ath
vermagic:       3.14.48-g408ccb9 SMP mod_unload modversions ARMv7 p2v8
parm:           debug_mask:Debugging mask (uint)
parm:           uart_print:Uart target debugging (bool)
parm:           skip_otp:Skip otp failure for calibration in testmode (bool=
)
parm:           cryptmode:Crypto mode: 0-hardware, 1-software (uint)
parm:           rawmode:Use raw 802.11 frame datapath (bool)

root@Tam:~# modinfo ath10k_pci
filename:
/lib/modules/3.14.48-g408ccb9/kernel/drivers/net/wireless/ath/ath10k/ath10k=
_pci.ko
firmware:       ath10k/QCA9377/hw1.0/board.bin
firmware:       ath10k/QCA9377/hw1.0/firmware-5.bin
firmware:       ath10k/QCA6174/hw3.0/board-2.bin
firmware:       ath10k/QCA6174/hw3.0/board.bin
firmware:       ath10k/QCA6174/hw3.0/firmware-5.bin
firmware:       ath10k/QCA6174/hw3.0/firmware-4.bin
firmware:       ath10k/QCA6174/hw2.1/board-2.bin
firmware:       ath10k/QCA6174/hw2.1/board.bin
firmware:       ath10k/QCA6174/hw2.1/firmware-5.bin
firmware:       ath10k/QCA6174/hw2.1/firmware-4.bin
firmware:       ath10k/QCA988X/hw2.0/board-2.bin
firmware:       ath10k/QCA988X/hw2.0/board.bin
firmware:       ath10k/QCA988X/hw2.0/firmware-5.bin
firmware:       ath10k/QCA988X/hw2.0/firmware-4.bin
firmware:       ath10k/QCA988X/hw2.0/firmware-3.bin
firmware:       ath10k/QCA988X/hw2.0/firmware-2.bin
firmware:       ath10k/QCA988X/hw2.0/firmware.bin
license:        Dual BSD/GPL
description:    Driver support for Atheros QCA988X PCIe devices
author:         Qualcomm Atheros
version:        backported from Linux (v4.4.2-0-g1cb8570) using
backports v4.4.2-1-0-gbec4037
srcversion:     EBB3D4E36DE49B7EC8057D0
alias:          pci:v0000168Cd00000042sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000040sv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000003Esv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000041sv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000003Csv*sd*bc*sc*i*
depends:        ath10k_core,compat
vermagic:       3.14.48-g408ccb9 SMP mod_unload modversions ARMv7 p2v8
parm:           irq_mode:0: auto, 1: legacy, 2: msi (default: 0) (uint)
parm:           reset_mode:0: auto, 1: warm only (default: 0) (uint)


I've loaded adding the line ath10k_core rawmode=3D1 to the file etc/modules

The problem persists... maybe it's a firmware issue or even a fault of
the wifi card?

Really many thanks

Matteo


>
> 2016-09-19 13:22 GMT+02:00 Michal Kazior <michal.kazior@tieto.com>:
>>
>> On 16 September 2016 at 12:56, Matteo Grandi <grn.matteo@gmail.com> wrot=
e:
>> > Hello all,
>> [...]
>> > [    8.589474] ath10k_pci 0000:07:00.0: qca988x hw2.0 (0x4100016c,
>> > 0x043222ff sub 0000:0000) fw 10.2.4.70.54 fwapi 5 bdapi 1 htt-ver 2.1
>> > wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1 features
>> > no-p2p,raw-mode
>>
>> The "raw-mode" here only hints the firmware is capable of raw mode
>> operation which needs to be explicitly enabled.
>>
>>
>> > [    8.589491] ath10k_pci 0000:07:00.0: debug 1 debugfs 1 tracing 0
>> > dfs 0 testmode 1
>> > [    8.691670] ath: EEPROM regdomain: 0x0
>> > [    8.691680] ath: EEPROM indicates default country code should be us=
ed
>> > [    8.691686] ath: doing EEPROM country->regdmn map search
>> > [    8.691695] ath: country maps to regdmn code: 0x3a
>> > [    8.691702] ath: Country alpha2 being used: US
>> > [    8.691706] ath: Regpair used: 0x3a
>> > [  176.983250] ath10k_pci 0000:07:00.0: must load driver with
>> > rawmode=3D1 to add mesh interfaces
>> [...]
>> > - I've also tried to load the ath10k modules adding the parameter
>> > rowmode=3D1 but I had an error "rawmode unknown parameter"
>>
>> Only ath10k_core needs to be loaded with rawmode=3D1.
>>
>> You can check available module parameters with:
>>   modinfo ath10k_core
>>   modinfo ath10k_pci
>>
>>
>> Micha=C5=82
>
>
