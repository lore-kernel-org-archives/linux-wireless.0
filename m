Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:55400 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388944AbeIUPXz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 11:23:55 -0400
Subject: Re: Netgear R7800 - ath10k QCA 9984 firmware crash
To: Bruno Rosset <bruno.rosset@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <CAKMn2kT6+4iX72jLSnCrXWMJ+pBHrMpZtigqWjzFRLKWRoxrkA@mail.gmail.com>
 <532c137e-729d-bf06-7103-e2c141bc0c0b@newmedia-net.de>
 <CAKMn2kTyyM1F1JLOi3sJ+_7emJG-JMm=gPjgqD0yFfcJLMuDnw@mail.gmail.com>
 <2783b4e8-401a-876f-cce7-bf56723b423f@newmedia-net.de>
 <CAKMn2kRi-Ob-y8HKf_smgrmuq52m6XMZf_86tR__tiQu8nMQpg@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <81bd43cb-898d-9181-718a-d30091febe89@newmedia-net.de> (sfid-20180921_113558_882574_C07D2C7B)
Date: Fri, 21 Sep 2018 11:35:43 +0200
MIME-Version: 1.0
In-Reply-To: <CAKMn2kRi-Ob-y8HKf_smgrmuq52m6XMZf_86tR__tiQu8nMQpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

you may use the backup function at Administration->backup which creates 
a file for download

or from commandline use "nvram backup /tmp/mybackup.bin"

for full flash backup on the r7800 do

cat /proc/mtd which shows

mtd0: 00c80000 00020000 "qcadata"
mtd1: 00500000 00020000 "APPSBL"
mtd2: 00080000 00020000 "APPSBLENV"
mtd3: 00140000 00020000 "art"
mtd4: 00140000 00020000 "artbak"
mtd5: 01e00000 00020000 "linux"
mtd6: 01be0000 00020000 "rootfs"
mtd7: 00200000 00020000 "nvram"
mtd8: 02000000 00020000 "ddwrt"
mtd9: 00640000 00020000 "reserved"


then do a backup of all partitions with

cat /dev/mtdblock0 > /tmp/mtdblock0.bin and so on

then copy them with scp to your local computer. you may need to enable 
ssh server first at services->ssh

Am 20.09.2018 um 14:02 schrieb Bruno Rosset:
> Hi Sebastian,
>
> OK no problem. I can do that.
> Can you just tell me what you need ; I mean which commands to export data ?
> For nvram I guess you need 'nvram show' results ?
>
> How I can do a "full flash transfer" ?
>
> As you're dd-wrt dev,  I add that I try last dd-wrt build  (this one :
> https://download1.dd-wrt.com/dd-wrtv2/downloads/betas/2018/08-22-2018-r36698/netgear-r7800/factory-to-ddwrt.img)
> which not even boot. Same with kong one (this one :
> http://www.desipro.de/ddwrt/K3-AC-IPQ806X/Test/R7800-factory-to-ddwrt.img)

thats not the latest

ftp://ftp.dd-wrt.com/betas/2018/09-19-2018-r36995/netgear-r7800/factory-to-ddwrt.img

i tested this also on my devices

so if these other versions you mentioned wont boot on your device it 
already looks strange since i test the r7800 always with each released 
build. the builds from desipro.de are external and not watched by me

these are test builds by a contributor


>
> What I made is that I extract the board-2.bin & fiurmware-5.bin from
> the ddwrt's squashfs image and try them on the openWRT install, but
> without success also.

the board-2.bin is not the one you need. the real board data is 
generated at /tmp folder from flash partition content and named 
/tmp/board1.bin and /tmp/board2.bin for each of both wireless devices


>
> Best regards,
> Bruno
> Le jeu. 20 sept. 2018 à 13:07, Sebastian Gottschall
> <s.gottschall@newmedia-net.de> a écrit :
>> since i'm mainly the dd-wrt developer and you tested it as well with the
>> same reproduceable crash it would be nice if you could provide me a
>> nvram backup with a reproduceable crash (you should change passwords of
>> course) to my private email. so i can apply it to my device and to see
>> whats happen. if you have a beta device i just can guess that the
>> calibration data which is stored in flash memory has maybe a different
>> location, so openwrt as well as dd-wrt uses crap to initialize the
>> hardware. this is just a guess. but i have 2 r7800 factory models. you
>> can also send me a full flash backup of your device using wetransfer, so
>> i can compare the content with my device and check if there is a flash
>> layout specific different. this would help to track down the problem
>> cause and maybe find a specific workaround for such devices by detecting
>> them well
>>
>> Sebastian
>>
>> Am 20.09.2018 um 09:44 schrieb Bruno Rosset:
>>> HI Sebastian,
>>>
>>> I just flash the r7800 with the openwrt 18.06.1 factory image (here :
>>> https://downloads.openwrt.org/releases/18.06.1/targets/ipq806x/generic/openwrt-18.06.1-ipq806x-netgear_r7800-squashfs-factory.img)
>>>
>>> I forgot to mention that I get a beta hardware of the R7800, perhaps
>>> there is something different in my hardware compared to the released
>>> one.
>>>
>>> Regards,
>>> Bruno
>>> Le jeu. 20 sept. 2018 à 08:36, Sebastian Gottschall
>>> <s.gottschall@newmedia-net.de> a écrit :
>>>> can you tell me how to reproduce this crash? i have 2 r7800 running with
>>>> dd-wrt but no crashes
>>>>
>>>> Am 19.09.2018 um 22:37 schrieb Bruno Rosset:
>>>>> Hi all,
>>>>>
>>>>> I get a firmware crash using latest openwrt 18.06.1 on the Netgear
>>>>> R7800 with stock firmware
>>>>> Dmesg is :
>>>>> [   13.804366] ath10k_pci 0000:01:00.0: assign IRQ: got 67
>>>>> [   13.804805] ath10k_pci 0000:01:00.0: enabling device (0140 -> 0142)
>>>>> [   13.804887] ath10k_pci 0000:01:00.0: enabling bus mastering
>>>>> [   13.805346] ath10k_pci 0000:01:00.0: pci irq msi oper_irq_mode 2
>>>>> irq_mode 0 reset_mode 0
>>>>> [   13.974787] ath10k_pci 0000:01:00.0: Direct firmware load for
>>>>> ath10k/pre-cal-pci-0000:01:00.0.bin failed with error -2
>>>>> [   13.974827] ath10k_pci 0000:01:00.0: Falling back to user helper
>>>>> [   14.304794] ath10k_pci 0000:01:00.0: Direct firmware load for
>>>>> ath10k/QCA9984/hw1.0/firmware-6.bin failed with error -2
>>>>> [   14.304857] ath10k_pci 0000:01:00.0: Falling back to user helper
>>>>> [   14.337111] firmware ath10k!QCA9984!hw1.0!firmware-6.bin:
>>>>> firmware_loading_store: map pages failed
>>>>> [   14.702947] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [   14.702997] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [   14.716459] ath10k_pci 0000:01:00.0: firmware ver 10.4-3.5.3-00053
>>>>> api 5 features no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps
>>>>> crc32 4c56a386
>>>>> [   15.973104] ath10k_pci 0000:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [   19.753460] ath10k_pci 0000:01:00.0: firmware crashed! (guid
>>>>> ca7089d2-df9a-4f9d-8fa6-d1b908cf3220)
>>>>> [   19.753494] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [   19.761307] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [   19.773202] ath10k_pci 0000:01:00.0: firmware ver 10.4-3.5.3-00053
>>>>> api 5 features no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps
>>>>> crc32 4c56a386
>>>>> [   19.779887] ath10k_pci 0000:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [   19.793511] ath10k_pci 0000:01:00.0: htt-ver 0.0 wmi-op 6 htt-op 4
>>>>> cal pre-cal-file max-sta 32 raw 0 hwcrypto 1
>>>>> [   19.803176] ath10k_pci 0000:01:00.0: firmware register dump:
>>>>> [   19.810956] ath10k_pci 0000:01:00.0: [00]: 0x01000000 0x000015B3
>>>>> 0x009CBB38 0x00975B31
>>>>> [   19.816861] ath10k_pci 0000:01:00.0: [04]: 0x009CBB38 0x00060530
>>>>> 0x00000011 0x00415760
>>>>> [   19.824587] ath10k_pci 0000:01:00.0: [08]: 0x00417E6C 0x00400000
>>>>> 0x00000001 0x00422990
>>>>> [   19.832485] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0xFFFFFFFF
>>>>> 0x00973B25 0x00973B47
>>>>> [   19.840384] ath10k_pci 0000:01:00.0: [16]: 0x009CBB38 0x000CEEA7
>>>>> 0x00000000 0x00000000
>>>>> [   19.848284] ath10k_pci 0000:01:00.0: [20]: 0x409CBB38 0x004068DC
>>>>> 0x00000001 0x00403628
>>>>> [   19.856183] ath10k_pci 0000:01:00.0: [24]: 0x809814EF 0x0040693C
>>>>> 0x00000049 0xC09CBB38
>>>>> [   19.864083] ath10k_pci 0000:01:00.0: [28]: 0x800DF216 0x004069AC
>>>>> 0x00000004 0x00415300
>>>>> [   19.871983] ath10k_pci 0000:01:00.0: [32]: 0x800C383A 0x004069DC
>>>>> 0x00415160 0x00400000
>>>>> [   19.879881] ath10k_pci 0000:01:00.0: [36]: 0x809800A3 0x00406A0C
>>>>> 0x00415170 0x009C41F8
>>>>> [   19.887781] ath10k_pci 0000:01:00.0: [40]: 0x8098003A 0x00406A5C
>>>>> 0x00400000 0x00400600
>>>>> [   19.895680] ath10k_pci 0000:01:00.0: [44]: 0x809607C1 0x00406A8C
>>>>> 0xD8400100 0x00406A9C
>>>>> [   19.903579] ath10k_pci 0000:01:00.0: [48]: 0x80960892 0x00406AAC
>>>>> 0x00000000 0x00000008
>>>>> [   19.911479] ath10k_pci 0000:01:00.0: [52]: 0x80960E39 0x00406ACC
>>>>> 0x00400000 0x00400600
>>>>> [   19.919378] ath10k_pci 0000:01:00.0: [56]: 0x80960E9D 0x00406AEC
>>>>> 0x00000000 0x00400600
>>>>> [   19.927277] ath10k_pci 0000:01:00.0: Copy Engine register dump:
>>>>> [   19.935181] ath10k_pci 0000:01:00.0: [00]: 0x0004a000  11  11  12  11
>>>>> [   19.940994] ath10k_pci 0000:01:00.0: [01]: 0x0004a400  11  11  10  11
>>>>> [   19.947590] ath10k_pci 0000:01:00.0: [02]: 0x0004a800   0   0  63   0
>>>>> [   19.954014] ath10k_pci 0000:01:00.0: [03]: 0x0004ac00   0   0   0   0
>>>>> [   19.960439] ath10k_pci 0000:01:00.0: [04]: 0x0004b000   0   0   0   0
>>>>> [   19.966862] ath10k_pci 0000:01:00.0: [05]: 0x0004b400   0   0   0   0
>>>>> [   19.973285] ath10k_pci 0000:01:00.0: [06]: 0x0004b800   0   0   0   0
>>>>> [   19.979709] ath10k_pci 0000:01:00.0: [07]: 0x0004bc00   1   1   1   1
>>>>> [   19.986132] ath10k_pci 0000:01:00.0: [08]: 0x0004c000   0   0 127   0
>>>>> [   19.992556] ath10k_pci 0000:01:00.0: [09]: 0x0004c400   1   1   1   1
>>>>> [   19.998980] ath10k_pci 0000:01:00.0: [10]: 0x0004c800   0   0   0   0
>>>>> [   20.005403] ath10k_pci 0000:01:00.0: [11]: 0x0004cc00   0   0   0   0
>>>>> [   20.795948] ath10k_pci 0000:01:00.0: failed to receive control
>>>>> response completion, polling..
>>>>> [   21.835766] ath10k_pci 0000:01:00.0: ctl_resp never came in (-110)
>>>>> [   21.835810] ath10k_pci 0000:01:00.0: failed to connect to HTC: -110
>>>>> [   21.915174] ath10k_pci 0000:01:00.0: could not init core (-110)
>>>>> [   21.915620] ath10k_pci 0000:01:00.0: could not probe fw (-110)
>>>>> [   21.920266] ath10k_pci 0001:01:00.0: assign IRQ: got 100
>>>>> [   21.921197] ath10k_pci 0001:01:00.0: enabling device (0140 -> 0142)
>>>>> [   21.926032] ath10k_pci 0001:01:00.0: enabling bus mastering
>>>>> [   21.926715] ath10k_pci 0001:01:00.0: pci irq msi oper_irq_mode 2
>>>>> irq_mode 0 reset_mode 0
>>>>> [   21.962217] ath10k_pci 0000:01:00.0: cannot restart a device that
>>>>> hasn't been started
>>>>> [   22.104728] ath10k_pci 0001:01:00.0: Direct firmware load for
>>>>> ath10k/pre-cal-pci-0001:01:00.0.bin failed with error -2
>>>>> [   22.104769] ath10k_pci 0001:01:00.0: Falling back to user helper
>>>>> [   22.424677] ath10k_pci 0001:01:00.0: Direct firmware load for
>>>>> ath10k/QCA9984/hw1.0/firmware-6.bin failed with error -2
>>>>> [   22.424736] ath10k_pci 0001:01:00.0: Falling back to user helper
>>>>> [   22.462387] firmware ath10k!QCA9984!hw1.0!firmware-6.bin:
>>>>> firmware_loading_store: map pages failed
>>>>> [   22.463844] ath10k_pci 0001:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [   22.470250] ath10k_pci 0001:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [   22.483627] ath10k_pci 0001:01:00.0: firmware ver 10.4-3.5.3-00053
>>>>> api 5 features no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps
>>>>> crc32 4c56a386
>>>>> [   23.743494] ath10k_pci 0001:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [   27.528777] ath10k_pci 0001:01:00.0: firmware crashed! (guid
>>>>> 2112523e-3948-4925-b383-9e672937c6d5)
>>>>> [   27.528819] ath10k_pci 0001:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [   27.536696] ath10k_pci 0001:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [   27.548985] ath10k_pci 0001:01:00.0: firmware ver 10.4-3.5.3-00053
>>>>> api 5 features no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps
>>>>> crc32 4c56a386
>>>>> [   27.555303] ath10k_pci 0001:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [   27.568835] ath10k_pci 0001:01:00.0: htt-ver 0.0 wmi-op 6 htt-op 4
>>>>> cal pre-cal-file max-sta 32 raw 0 hwcrypto 1
>>>>> [   27.578512] ath10k_pci 0001:01:00.0: firmware register dump:
>>>>> [   27.586281] ath10k_pci 0001:01:00.0: [00]: 0x01000000 0x000015B3
>>>>> 0x009CBB38 0x00975B31
>>>>> [   27.592186] ath10k_pci 0001:01:00.0: [04]: 0x009CBB38 0x00060530
>>>>> 0x00000011 0x00415760
>>>>> [   27.599910] ath10k_pci 0001:01:00.0: [08]: 0x00417E6C 0x00400000
>>>>> 0x00000001 0x00422990
>>>>> [   27.607809] ath10k_pci 0001:01:00.0: [12]: 0x00000009 0xFFFFFFFF
>>>>> 0x00973B25 0x00973B47
>>>>> [   27.615708] ath10k_pci 0001:01:00.0: [16]: 0x009CBB38 0x000CEEAC
>>>>> 0x00000000 0x00000000
>>>>> [   27.623608] ath10k_pci 0001:01:00.0: [20]: 0x409CBB38 0x004068DC
>>>>> 0x00000001 0x00403628
>>>>> [   27.631507] ath10k_pci 0001:01:00.0: [24]: 0x809814EF 0x0040693C
>>>>> 0x00000049 0xC09CBB38
>>>>> [   27.639405] ath10k_pci 0001:01:00.0: [28]: 0x800DF216 0x004069AC
>>>>> 0x00000004 0x00415300
>>>>> [   27.647305] ath10k_pci 0001:01:00.0: [32]: 0x800C383A 0x004069DC
>>>>> 0x00415160 0x00400000
>>>>> [   27.655205] ath10k_pci 0001:01:00.0: [36]: 0x809800A3 0x00406A0C
>>>>> 0x00415170 0x009C41F8
>>>>> [   27.663104] ath10k_pci 0001:01:00.0: [40]: 0x8098003A 0x00406A5C
>>>>> 0x00400000 0x00400600
>>>>> [   27.671004] ath10k_pci 0001:01:00.0: [44]: 0x809607C1 0x00406A8C
>>>>> 0xD8400100 0x00406A9C
>>>>> [   27.678902] ath10k_pci 0001:01:00.0: [48]: 0x80960892 0x00406AAC
>>>>> 0x00000000 0x00000008
>>>>> [   27.686801] ath10k_pci 0001:01:00.0: [52]: 0x80960E39 0x00406ACC
>>>>> 0x00400000 0x00400600
>>>>> [   27.694700] ath10k_pci 0001:01:00.0: [56]: 0x80960E9D 0x00406AEC
>>>>> 0x00000000 0x00400600
>>>>> [   27.702603] ath10k_pci 0001:01:00.0: Copy Engine register dump:
>>>>> [   27.710506] ath10k_pci 0001:01:00.0: [00]: 0x0004a000  11  11  12  11
>>>>> [   27.716322] ath10k_pci 0001:01:00.0: [01]: 0x0004a400  11  11  10  11
>>>>> [   27.722917] ath10k_pci 0001:01:00.0: [02]: 0x0004a800   0   0  63   0
>>>>> [   27.729340] ath10k_pci 0001:01:00.0: [03]: 0x0004ac00   0   0   0   0
>>>>> [   27.735764] ath10k_pci 0001:01:00.0: [04]: 0x0004b000   0   0   0   0
>>>>> [   27.742188] ath10k_pci 0001:01:00.0: [05]: 0x0004b400   0   0   0   0
>>>>> [   27.748611] ath10k_pci 0001:01:00.0: [06]: 0x0004b800   0   0   0   0
>>>>> [   27.755035] ath10k_pci 0001:01:00.0: [07]: 0x0004bc00   1   1   1   1
>>>>> [   27.761459] ath10k_pci 0001:01:00.0: [08]: 0x0004c000   0   0 127   0
>>>>> [   27.767884] ath10k_pci 0001:01:00.0: [09]: 0x0004c400   1   1   1   1
>>>>> [   27.774304] ath10k_pci 0001:01:00.0: [10]: 0x0004c800   0   0   0   0
>>>>> [   27.780731] ath10k_pci 0001:01:00.0: [11]: 0x0004cc00   0   0   0   0
>>>>> [   28.567840] ath10k_pci 0001:01:00.0: failed to receive control
>>>>> response completion, polling..
>>>>> [   29.616315] ath10k_pci 0001:01:00.0: ctl_resp never came in (-110)
>>>>> [   29.616341] ath10k_pci 0001:01:00.0: failed to connect to HTC: -110
>>>>> [   29.695567] ath10k_pci 0001:01:00.0: could not init core (-110)
>>>>> [   29.695988] ath10k_pci 0001:01:00.0: could not probe fw (-110)
>>>>> [   29.703824] kmodloader: done loading kernel modules from /etc/modules.d/*
>>>>> [   29.732245] ath10k_pci 0001:01:00.0: cannot restart a device that
>>>>> hasn't been started
>>>>>
>>>>> Replacing stock firmware with latest from kvalo github (here :
>>>>> https://github.com/kvalo/ath10k-firmware/tree/master/QCA9984/hw1.0/3.6.0.1)
>>>>> I get the same result
>>>>> Dmesg is :
>>>>> [  235.442819] ath10k_pci 0001:01:00.0: disabling bus mastering
>>>>> [  235.482588] ath10k_pci 0000:01:00.0: disabling bus mastering
>>>>> [  260.586372] ath10k_pci 0000:01:00.0: assign IRQ: got 67
>>>>> [  260.586771] ath10k_pci 0000:01:00.0: enabling bus mastering
>>>>> [  260.587218] ath10k_pci 0000:01:00.0: pci irq msi oper_irq_mode 2
>>>>> irq_mode 0 reset_mode 0
>>>>> [  260.754869] ath10k_pci 0000:01:00.0: Direct firmware load for
>>>>> ath10k/QCA9984/hw1.0/firmware-6.bin failed with error -2
>>>>> [  260.754917] ath10k_pci 0000:01:00.0: Falling back to user helper
>>>>> [  260.786271] firmware ath10k!QCA9984!hw1.0!firmware-6.bin:
>>>>> firmware_loading_store: map pages failed
>>>>> [  260.787219] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [  260.794202] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [  260.806246] ath10k_pci 0000:01:00.0: firmware ver
>>>>> 10.4-3.6.0.1-00003 api 5 features
>>>>> no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps crc32
>>>>> 266d70b0
>>>>> [  262.065148] ath10k_pci 0000:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [  265.858256] ath10k_pci 0000:01:00.0: firmware crashed! (guid
>>>>> 2b6addfc-915e-437a-a7fa-3691cbf4b39e)
>>>>> [  265.858347] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [  265.866136] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [  265.881167] ath10k_pci 0000:01:00.0: firmware ver
>>>>> 10.4-3.6.0.1-00003 api 5 features
>>>>> no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps crc32
>>>>> 266d70b0
>>>>> [  265.885460] ath10k_pci 0000:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [  265.898696] ath10k_pci 0000:01:00.0: htt-ver 0.0 wmi-op 6 htt-op 4
>>>>> cal pre-cal-file max-sta 32 raw 0 hwcrypto 1
>>>>> [  265.908193] ath10k_pci 0000:01:00.0: firmware register dump:
>>>>> [  265.915961] ath10k_pci 0000:01:00.0: [00]: 0x01000000 0x000015B3
>>>>> 0x009CC074 0x00975B31
>>>>> [  265.921864] ath10k_pci 0000:01:00.0: [04]: 0x009CC074 0x00060530
>>>>> 0x00000011 0x004142FC
>>>>> [  265.929590] ath10k_pci 0000:01:00.0: [08]: 0x00416AFC 0x00400000
>>>>> 0x00000001 0x00421F90
>>>>> [  265.937488] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0xFFFFFFFF
>>>>> 0x00973B25 0x00973B47
>>>>> [  265.945389] ath10k_pci 0000:01:00.0: [16]: 0x009CC074 0x000CFE13
>>>>> 0x00000000 0x00000000
>>>>> [  265.953289] ath10k_pci 0000:01:00.0: [20]: 0x409CC074 0x004068DC
>>>>> 0x00000001 0x00403628
>>>>> [  265.961187] ath10k_pci 0000:01:00.0: [24]: 0x8098153B 0x0040693C
>>>>> 0x0000004E 0xC09CC074
>>>>> [  265.969087] ath10k_pci 0000:01:00.0: [28]: 0x800E026F 0x004069AC
>>>>> 0x00000004 0x00413E60
>>>>> [  265.976984] ath10k_pci 0000:01:00.0: [32]: 0x800C383A 0x004069DC
>>>>> 0x00413CB0 0x00400000
>>>>> [  265.984884] ath10k_pci 0000:01:00.0: [36]: 0x809800A3 0x00406A0C
>>>>> 0x00413CC0 0x009C4750
>>>>> [  265.992784] ath10k_pci 0000:01:00.0: [40]: 0x8098003A 0x00406A5C
>>>>> 0x00400000 0x00400600
>>>>> [  266.000684] ath10k_pci 0000:01:00.0: [44]: 0x809607C1 0x00406A8C
>>>>> 0xD8400100 0x00406A9C
>>>>> [  266.008582] ath10k_pci 0000:01:00.0: [48]: 0x80960892 0x00406AAC
>>>>> 0x00000000 0x00000008
>>>>> [  266.016482] ath10k_pci 0000:01:00.0: [52]: 0x80960E39 0x00406ACC
>>>>> 0x00400000 0x00400600
>>>>> [  266.024381] ath10k_pci 0000:01:00.0: [56]: 0x80960E9D 0x00406AEC
>>>>> 0x00000000 0x00400600
>>>>> [  266.032279] ath10k_pci 0000:01:00.0: Copy Engine register dump:
>>>>> [  266.040186] ath10k_pci 0000:01:00.0: [00]: 0x0004a000  12  12  29  28
>>>>> [  266.045999] ath10k_pci 0000:01:00.0: [01]: 0x0004a400  11  11  10  11
>>>>> [  266.052595] ath10k_pci 0000:01:00.0: [02]: 0x0004a800   0   0  63   0
>>>>> [  266.059018] ath10k_pci 0000:01:00.0: [03]: 0x0004ac00   0   0   0   0
>>>>> [  266.065441] ath10k_pci 0000:01:00.0: [04]: 0x0004b000   0   0   0   0
>>>>> [  266.071865] ath10k_pci 0000:01:00.0: [05]: 0x0004b400   0   0   0   0
>>>>> [  266.078289] ath10k_pci 0000:01:00.0: [06]: 0x0004b800   0   0   0   0
>>>>> [  266.084713] ath10k_pci 0000:01:00.0: [07]: 0x0004bc00   1   1   1   1
>>>>> [  266.091136] ath10k_pci 0000:01:00.0: [08]: 0x0004c000   0   0 127   0
>>>>> [  266.097559] ath10k_pci 0000:01:00.0: [09]: 0x0004c400   1   1   1   1
>>>>> [  266.103982] ath10k_pci 0000:01:00.0: [10]: 0x0004c800   0   0   0   0
>>>>> [  266.110408] ath10k_pci 0000:01:00.0: [11]: 0x0004cc00   0   0   0   0
>>>>> [  266.876609] ath10k_pci 0000:01:00.0: failed to receive control
>>>>> response completion, polling..
>>>>> [  267.915918] ath10k_pci 0000:01:00.0: ctl_resp never came in (-110)
>>>>> [  267.915970] ath10k_pci 0000:01:00.0: failed to connect to HTC: -110
>>>>> [  267.996406] ath10k_pci 0000:01:00.0: could not init core (-110)
>>>>> [  267.996972] ath10k_pci 0000:01:00.0: could not probe fw (-110)
>>>>> [  268.001578] ath10k_pci 0001:01:00.0: assign IRQ: got 100
>>>>> [  268.002612] ath10k_pci 0001:01:00.0: enabling bus mastering
>>>>> [  268.003292] ath10k_pci 0001:01:00.0: pci irq msi oper_irq_mode 2
>>>>> irq_mode 0 reset_mode 0
>>>>> [  268.032241] ath10k_pci 0000:01:00.0: cannot restart a device that
>>>>> hasn't been started
>>>>> [  268.174893] ath10k_pci 0001:01:00.0: Direct firmware load for
>>>>> ath10k/QCA9984/hw1.0/firmware-6.bin failed with error -2
>>>>> [  268.174936] ath10k_pci 0001:01:00.0: Falling back to user helper
>>>>> [  268.206575] firmware ath10k!QCA9984!hw1.0!firmware-6.bin:
>>>>> firmware_loading_store: map pages failed
>>>>> [  268.207955] ath10k_pci 0001:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [  268.214521] ath10k_pci 0001:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [  268.227852] ath10k_pci 0001:01:00.0: firmware ver
>>>>> 10.4-3.6.0.1-00003 api 5 features
>>>>> no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps crc32
>>>>> 266d70b0
>>>>> [  269.485480] ath10k_pci 0001:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [  273.282901] ath10k_pci 0001:01:00.0: firmware crashed! (guid
>>>>> 28f0a68b-f881-40cb-b515-f4320b412b7a)
>>>>> [  273.282982] ath10k_pci 0001:01:00.0: qca9984/qca9994 hw1.0 target
>>>>> 0x01000000 chip_id 0x00000000 sub 168c:cafe
>>>>> [  273.290780] ath10k_pci 0001:01:00.0: kconfig debug 0 debugfs 1
>>>>> tracing 0 dfs 1 testmode 1
>>>>> [  273.306323] ath10k_pci 0001:01:00.0: firmware ver
>>>>> 10.4-3.6.0.1-00003 api 5 features
>>>>> no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps crc32
>>>>> 266d70b0
>>>>> [  273.310039] ath10k_pci 0001:01:00.0: board_file api 2 bmi_id 0:31
>>>>> crc32 dd6d039c
>>>>> [  273.323420] ath10k_pci 0001:01:00.0: htt-ver 0.0 wmi-op 6 htt-op 4
>>>>> cal pre-cal-file max-sta 32 raw 0 hwcrypto 1
>>>>> [  273.332841] ath10k_pci 0001:01:00.0: firmware register dump:
>>>>> [  273.340604] ath10k_pci 0001:01:00.0: [00]: 0x01000000 0x000015B3
>>>>> 0x009CC074 0x00975B31
>>>>> [  273.346508] ath10k_pci 0001:01:00.0: [04]: 0x009CC074 0x00060530
>>>>> 0x00000011 0x004142FC
>>>>> [  273.354234] ath10k_pci 0001:01:00.0: [08]: 0x00416AFC 0x00400000
>>>>> 0x00000001 0x00421F90
>>>>> [  273.362135] ath10k_pci 0001:01:00.0: [12]: 0x00000009 0xFFFFFFFF
>>>>> 0x00973B25 0x00973B47
>>>>> [  273.370033] ath10k_pci 0001:01:00.0: [16]: 0x009CC074 0x000CFE13
>>>>> 0x00000000 0x00000000
>>>>> [  273.377932] ath10k_pci 0001:01:00.0: [20]: 0x409CC074 0x004068DC
>>>>> 0x00000001 0x00403628
>>>>> [  273.385833] ath10k_pci 0001:01:00.0: [24]: 0x8098153B 0x0040693C
>>>>> 0x0000004E 0xC09CC074
>>>>> [  273.393732] ath10k_pci 0001:01:00.0: [28]: 0x800E026F 0x004069AC
>>>>> 0x00000004 0x00413E60
>>>>> [  273.401631] ath10k_pci 0001:01:00.0: [32]: 0x800C383A 0x004069DC
>>>>> 0x00413CB0 0x00400000
>>>>> [  273.409529] ath10k_pci 0001:01:00.0: [36]: 0x809800A3 0x00406A0C
>>>>> 0x00413CC0 0x009C4750
>>>>> [  273.417429] ath10k_pci 0001:01:00.0: [40]: 0x8098003A 0x00406A5C
>>>>> 0x00400000 0x00400600
>>>>> [  273.425329] ath10k_pci 0001:01:00.0: [44]: 0x809607C1 0x00406A8C
>>>>> 0xD8400100 0x00406A9C
>>>>> [  273.433227] ath10k_pci 0001:01:00.0: [48]: 0x80960892 0x00406AAC
>>>>> 0x00000000 0x00000008
>>>>> [  273.441127] ath10k_pci 0001:01:00.0: [52]: 0x80960E39 0x00406ACC
>>>>> 0x00400000 0x00400600
>>>>> [  273.449027] ath10k_pci 0001:01:00.0: [56]: 0x80960E9D 0x00406AEC
>>>>> 0x00000000 0x00400600
>>>>> [  273.456924] ath10k_pci 0001:01:00.0: Copy Engine register dump:
>>>>> [  273.464831] ath10k_pci 0001:01:00.0: [00]: 0x0004a000  12  12  29  28
>>>>> [  273.470647] ath10k_pci 0001:01:00.0: [01]: 0x0004a400  11  11  10  11
>>>>> [  273.477243] ath10k_pci 0001:01:00.0: [02]: 0x0004a800   0   0  63   0
>>>>> [  273.483664] ath10k_pci 0001:01:00.0: [03]: 0x0004ac00   0   0   0   0
>>>>> [  273.490088] ath10k_pci 0001:01:00.0: [04]: 0x0004b000   0   0   0   0
>>>>> [  273.496512] ath10k_pci 0001:01:00.0: [05]: 0x0004b400   0   0   0   0
>>>>> [  273.502936] ath10k_pci 0001:01:00.0: [06]: 0x0004b800   0   0   0   0
>>>>> [  273.509360] ath10k_pci 0001:01:00.0: [07]: 0x0004bc00   1   1   1   1
>>>>> [  273.515783] ath10k_pci 0001:01:00.0: [08]: 0x0004c000   0   0 127   0
>>>>> [  273.522208] ath10k_pci 0001:01:00.0: [09]: 0x0004c400   1   1   1   1
>>>>> [  273.528632] ath10k_pci 0001:01:00.0: [10]: 0x0004c800   0   0   0   0
>>>>> [  273.535054] ath10k_pci 0001:01:00.0: [11]: 0x0004cc00   0   0   0   0
>>>>> [  274.326491] ath10k_pci 0001:01:00.0: failed to receive control
>>>>> response completion, polling..
>>>>> [  275.356625] ath10k_pci 0001:01:00.0: ctl_resp never came in (-110)
>>>>> [  275.356672] ath10k_pci 0001:01:00.0: failed to connect to HTC: -110
>>>>> [  275.436389] ath10k_pci 0001:01:00.0: could not init core (-110)
>>>>> [  275.436925] ath10k_pci 0001:01:00.0: could not probe fw (-110)
>>>>> [  275.472295] ath10k_pci 0001:01:00.0: cannot restart a device that
>>>>> hasn't been started
>>>>>
>>>>> Various tests with others firmware from candelatech , stock LEDE 17.01
>>>>> or dd-wrt give me firmware crash also
>>>>>
>>>>> I already tried to enable debug info for firmware crash with 'rmmod
>>>>> ath10k_pci; rmmod ath10k_core; modprobe ath10k_core
>>>>> debug_mask=0xffffffff ; modprobe ath10k_pci ' but without success
>>>>>
>>>>> Flashing back netgear factory firmware is OK, and all is functionnal
>>>>>
>>>>> What can I do next ?
>>>>>
>>>>> Thanks all
>>>>>
