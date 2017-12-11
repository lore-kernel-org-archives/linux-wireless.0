Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdLKNUU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 08:20:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 11 Dec 2017 18:50:09 +0530
From: akolli@codeaurora.org
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: akolli@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add BMI parameters to fix calibration from
 DT/pre-cal
In-Reply-To: <3432385.m9oFIzB3n7@sven-edge>
References: <1495709483-29793-1-git-send-email-akolli@qti.qualcomm.com>
 <6476910.M9FJQ0px1r@bentobox>
 <637ab47b1794b409e595b7e219cd904f@codeaurora.org>
 <3432385.m9oFIzB3n7@sven-edge>
Message-ID: <6b494081c2606c8e523e2c426ab949ed@codeaurora.org> (sfid-20171211_142023_920016_3955B59A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-08 19:10, Sven Eckelmann wrote:
> On Freitag, 8. Dezember 2017 18:05:38 CET akolli@codeaurora.org wrote:
>> On 2017-12-08 17:42, Sven Eckelmann wrote:
>> > On Donnerstag, 25. Mai 2017 16:21:23 CET akolli@qti.qualcomm.com wrote:
>> >> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>> >>
>> >> QCA99X0, QCA9888, QCA9984 supports calibration data in
>> >> either OTP or DT/pre-cal file. Current ath10k supports
>> >> Calibration data from OTP only.
> [...]
>> > Just tried this on an QCA9984 which doesn't seem to have the
>> > calibration data in the PCI EEPROM.
>> >
>> >     [   71.728929] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0
>> > target 0x01000000 chip_id 0x00000000 sub 168c:cafe
>> >     [   71.732926] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1
>> > tracing 0 dfs 1 testmode 1
>> >     [   71.752282] ath10k_pci 0000:01:00.0: firmware ver
>> > 10.4-ct-9984-fW-009-dfa0083 api 5 features peer-flow-ctrl crc32
>> > 7198d117
>> >     [   73.805730] ath10k_pci 0000:01:00.0: unable to read from the
>> > device
>> >     [   73.805769] ath10k_pci 0000:01:00.0: could not execute otp for
>> > board id check: -110
>> >
>> 
>> 'ATH10K driver <-> 10.4 firmware' expects cal data to be either in
>> EEPROM or pre-cal-file or DT.
>> Hope the error is observed when there is no cal data loaded.
> 
> The problem happens when pre-cal data file is loaded using the 
> userspace
> helper on the QCA9984. I was only able to use the device when I (for a 
> test)
> used the pre-cal data as cal-data (file).
> 
> The EEPROM on the on the PCI device doesn't seem to be populated with a 
> valid
> pre-cal data. I've already tested it with a QCA9984 device which had 
> pre-cal
> data in the PCI device's EEPROM and this worked fine (without cal file 
> and
> without pre-cal file).
> 
>> > It works when I use the pre-cal data as calibration data. The checksum
>> > in the
>> > pre-cal seems to be correct. Also the pre-cal data from 0:ART for the
>> > 2.4GHz
>> > and 5GHz QCA4019 seem to work perfectly fine.
>> >
>> 
>> Do you mean this patch works for only QCA4019 and not working for
>> QCA9984 ?
> 
> Worked fine for QCA4019 and QCA9888 - but I had no luck with QCA9984. 
> The
> error shown above it the only thing I get.
> 

I tested this on QCA9984 and it worked with below config,

pre-cal file location: /lib/firmware/ath10k/pre-cal-pci-0000:01:00.0.bin
FW: 
https://github.com/kvalo/ath10k-firmware/raw/master/QCA9984/hw1.0/firmware-5.bin_10.4-3.2-00072
BDF: 
https://github.com/kvalo/ath10k-firmware/raw/master/QCA9984/hw1.0/board-2.bin

Logs:

ath10k_pci 0000:01:00.0: found calibration file 
ath10k/pre-cal-pci-0000:01:00.0.bin
ath10k_pci 0000:01:00.0: found fw version 10.4-3.2-00072
ath10k_pci 0000:01:00.0: boot cal file downloaded
ath10k_pci 0000:01:00.0: boot using calibration mode pre-cal-file
ath10k_pci 0000:01:00.0: boot upload otp to 0x1234 len 8919 for board id
bmi execute address 0x1234 param 0x8000
ath10k_pci 0000:01:00.0: bmi execute result 0x2800
ath10k_pci 0000:01:00.0: boot get otp board id result 0x00002800 
board_id 10 chip_id 0
ath10k_pci 0000:01:00.0: boot using board name 
'bus=pci,bmi-chip-id=0,bmi-board-id=10'
ath10k_pci 0000:01:00.0: Firmware loaded from user helper succesfully
ath10k_pci 0000:01:00.0: boot fw request 
'ath10k/QCA9984/hw1.0/board-2.bin': 0

Kindly try with the latest firmware from Kalle's git mentioned above.

Thanks
Anil.
