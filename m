Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752851AbeDSO4p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 10:56:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ext.waldemar.rymarkiewicz@tieto.com,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: search DT for qcom, ath10k-calibration-variant
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
        <20170310080615.22958-2-sven.eckelmann@openmesh.com>
        <3853747.Q0JJmSnsYM@debian64>
Date: Thu, 19 Apr 2018 17:56:36 +0300
In-Reply-To: <3853747.Q0JJmSnsYM@debian64> (Christian Lamparter's message of
        "Fri, 10 Mar 2017 19:20:54 +0100")
Message-ID: <878t9jkzx7.fsf@kamboji.qca.qualcomm.com> (sfid-20180419_165651_174747_DD7FFAB0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> On Friday, March 10, 2017 9:06:15 AM CET Sven Eckelmann wrote:
>> Board Data File (BDF) is loaded upon driver boot-up procedure. The right
>> board data file is identified on QCA4019 using bus, bmi-chip-id and
>> bmi-board-id.
>> 
>> The problem, however, can occur when the (default) board data file cannot
>> fulfill with the vendor requirements and it is necessary to use a different
>> board data file.
>> 
>> This problem was solved for SMBIOS by adding a special SMBIOS type 0xF8.
>> Something similar has to be provided for systems without SMBIOS but with
>> device trees. No solution was specified by QCA and therefore a new one has
>> to be found for ath10k.
>> 
>> The device tree requires addition strings to define the variant name
>> 
>>     wifi@a000000 {
>>     	status = "okay";
>>     	qcom,ath10k-calibration-variant = "RT-AC58U";
>>     };
>> 
>>     wifi@a800000 {
>>     	status = "okay";
>>     	qcom,ath10k-calibration-variant = "RT-AC58U";
>>     };
>> 
>> This would create the boarddata identifiers for the board-2.bin search
>> 
>>  *  bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=RT-AC58U
>>  *  bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=RT-AC58U
>> 
>> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
>> ---
> I've attached a modified board-2.bin for the RT-AC58U variant:
>
> # ath10k-bdencoder -i board-2.bin
> FileSize: 48564
> FileCRC32: 7ac95dfd
> FileMD5: 825c8e7377b0d543024dbf62f2fd29ff
> BoardNames[0]: 'bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=RT-AC58U'
> BoardLength[0]: 12064
> BoardCRC32[0]: bd216dd3
> BoardMD5[0]: a12a4745c775beb5ab6ba1e4d711aea0
> BoardNames[1]: 'bus=ahb,bmi-chip-id=0,bmi-board-id=16'
> BoardLength[1]: 12064
> BoardCRC32[1]: 65a8a5b3
> BoardMD5[1]: cb5dcb0337706c313ea3342587b283ae
> BoardNames[2]: 'bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=RT-AC58U'
> BoardLength[2]: 12064
> BoardCRC32[2]: a7d74de3
> BoardMD5[2]: 17bbd05ee0cd9099a549c835b7399b3c
> BoardNames[3]: 'bus=ahb,bmi-chip-id=0,bmi-board-id=17'
> BoardLength[3]: 12064
> BoardCRC32[3]: 4fe93ca0
> BoardMD5[3]: 1aa45fad7a0d6f1c5774b251c712c67c
>
> And this is a patched ath10k loading it:
>
> [ 106.155058] ath10k_ahb a800000.wifi: boot get otp board id result
> 0x00004400 board_id 17 chip_id 0
> [  106.155092] ath10k_ahb a800000.wifi: SMBIOS bdf variant name not set.
> [ 106.155154] ath10k_ahb a800000.wifi: boot using board name
> 'bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=RT-AC58U'
> [  106.155570] ath10k_ahb a800000.wifi: board name
> [ 106.155607] ath10k_ahb a800000.wifi: 00000000: 62 75 73 3d 61 68 62
> 2c 62 6d 69 2d 63 68 69 70 bus=ahb,bmi-chip
> [ 106.155644] ath10k_ahb a800000.wifi: 00000010: 2d 69 64 3d 30 2c 62
> 6d 69 2d 62 6f 61 72 64 2d -id=0,bmi-board-
> [ 106.155681] ath10k_ahb a800000.wifi: 00000020: 69 64 3d 31 36 2c 76
> 61 72 69 61 6e 74 3d 52 54 id=16,variant=RT
> [ 106.155904] ath10k_ahb a800000.wifi: 00000030: 2d 41 43 35 38 55
> -AC58U
> [  106.155972] ath10k_ahb a800000.wifi: board name
> [ 106.156057] ath10k_ahb a800000.wifi: 00000000: 62 75 73 3d 61 68 62
> 2c 62 6d 69 2d 63 68 69 70 bus=ahb,bmi-chip
> [ 106.156142] ath10k_ahb a800000.wifi: 00000010: 2d 69 64 3d 30 2c 62
> 6d 69 2d 62 6f 61 72 64 2d -id=0,bmi-board-
> [ 106.156211] ath10k_ahb a800000.wifi: 00000020: 69 64 3d 31 36 id=16
> [  106.156662] ath10k_ahb a800000.wifi: board name
> [ 106.156700] ath10k_ahb a800000.wifi: 00000000: 62 75 73 3d 61 68 62
> 2c 62 6d 69 2d 63 68 69 70 bus=ahb,bmi-chip
> [ 106.156737] ath10k_ahb a800000.wifi: 00000010: 2d 69 64 3d 30 2c 62
> 6d 69 2d 62 6f 61 72 64 2d -id=0,bmi-board-
> [ 106.156773] ath10k_ahb a800000.wifi: 00000020: 69 64 3d 31 37 2c 76
> 61 72 69 61 6e 74 3d 52 54 id=17,variant=RT
> [ 106.156809] ath10k_ahb a800000.wifi: 00000030: 2d 41 43 35 38 55
> -AC58U
> [ 106.156845] ath10k_ahb a800000.wifi: boot found match for name
> 'bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=RT-AC58U'
> [ 106.156876] ath10k_ahb a800000.wifi: boot found board data for
> 'bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=RT-AC58U'
> [  106.156906] ath10k_ahb a800000.wifi: using board api 2
> [  106.163704] ath10k_ahb a800000.wifi: board_file api 2 bmi_id 0:17 crc32 f222ba02
> [  106.165037] ath10k_ahb a800000.wifi: boot push board extended data addr 0x0
> [  106.184867] ath10k_ahb a800000.wifi: boot cal file downloaded
> [  106.184905] ath10k_ahb a800000.wifi: boot using calibration mode pre-cal-file
> [ 106.184945] ath10k_ahb a800000.wifi: boot upload otp to 0x1234 len
> 4582 for board id
> [ 106.205657] ath10k_ahb a800000.wifi: boot get otp board id result
> 0x00004400 board_id 17 chip_id 0
> [  106.205811] ath10k_ahb a800000.wifi: boot push board extended data addr 0x0
> [  106.225685] ath10k_ahb a800000.wifi: boot upload otp to 0x1234 len 4582
> [  106.252294] ath10k_ahb a800000.wifi: boot otp execute result 0
>
> @Aeolus Yang / Kalle / QCA: Would it be possible to assign a variant string to
> the Asus RT-AC58U?
>
> I've attached the necessary bmi-board-id=16 and bmi-board-id=17 board 
> files to this mail as well. So, all that needs to be done is to add
> them to the board-2.bin on your codeaurora / ath10k-firmware project.
>
> Kalle: Can you please update the board-2.bin for the IPQ40XX on your
> ath10k-firmware project on github?

I have added them now, please check:

https://github.com/kvalo/ath10k-firmware/commit/a47bcf1e58c4d8914af0951a80fd8861368b700d

New:
bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=RT-AC58U

Changed:


Deleted:

1 board image(s) added, 0 changed, 0 deleted, 24 in total

New:
bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=RT-AC58U

Changed:


Deleted:

1 board image(s) added, 0 changed, 0 deleted, 25 in total

-- 
Kalle Valo
