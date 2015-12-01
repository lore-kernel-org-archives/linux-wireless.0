Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34415 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbLAK2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:28:55 -0500
Received: by ykfs79 with SMTP id s79so1700256ykf.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 02:28:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADaZW1Fy_7z8sHDjML1G_u8F3jyNrbSvLKRmxnCPw6M2HYc8oA@mail.gmail.com>
References: <loom.20151201T071931-353@post.gmane.org> <CALhHN=o4xAhy9oz0Q7sy-Ubji-nBf6pdJ7OSj8xLU0mn86n1qQ@mail.gmail.com>
 <CADaZW1E42rnjaxjnjskW_j83m=moauNBttZ-M=oyWoiXXS2ZiQ@mail.gmail.com>
 <CA+BoTQ=k9NHd6KHt2qzgjs5g3B6Q58fX=hTRB-BvxcvjejmWog@mail.gmail.com>
 <CADaZW1Eww2TNimciP5JxVam0y+-V4Ez2VfFXdT=_jh14TgOp0g@mail.gmail.com>
 <CA+BoTQk0Y+djSBNMonhkpZ3Aw8aKuxefdgSa9zUa-vgV9HTL4A@mail.gmail.com>
 <CACKGw+GPjr1fQ_u5yHfsAa=GBJmk7vRfcTUS3nt1N+id7UoPzg@mail.gmail.com> <CADaZW1Fy_7z8sHDjML1G_u8F3jyNrbSvLKRmxnCPw6M2HYc8oA@mail.gmail.com>
From: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Date: Tue, 1 Dec 2015 11:28:25 +0100
Message-ID: <CADaZW1F=5NcMomcxKczb92rvxYR=kcwpSo8yu25C7AHQ4UHK3A@mail.gmail.com> (sfid-20151201_112900_354372_D3EB6F01)
Subject: Re: ath10k: device has crashed during init - qca6174 chipset
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have tested borad-2.bin file with my module, by forcing
ar->id.subsystem_vendor = 0x168c;
ar->id.subsystem_device = 0x3363; (1,2,3)
in ath/ath10k/pci.c file.

All the tests failed with:
ath10k_pci 0000:01:00.0: failed to receive initialized event from
target: 00000000
ath10k_pci 0000:01:00.0: firmware crashed! (uuid
5506e81c-d538-4492-91d7-dc899fed8d8c)

Does it mean, that this module is not supported?
I will need to dump firmware from windows driver, when I get it from
the vendor ?

Thank you for the support

2015-12-01 10:53 GMT+01:00 Bartlomiej Grzeskowiak
<bartlomiej.grzeskowiak@gmail.com>:
> HI,
>
> Yes, I am testing it now:
>
> ath10k_pci 0000:01:00.0: boot get otp board id result 0x00000001
> board_id 0 chip_id 0
> ath10k_pci 0000:01:00.0: boot using board name
> 'bus=pci,vendor=168c,device=003e,subsystem-vendor=0000,subsystem-device=0000'
> ath10k_pci 0000:01:00.0: board name
> ath10k_pci 0000:01:00.0: 00000000: 62 75 73 3d 70 63 69 2c 76 65 6e 64
> 6f 72 3d 31  bus=pci,vendor=1
> ath10k_pci 0000:01:00.0: 00000010: 36 38 63 2c 64 65 76 69 63 65 3d 30
> 30 33 65 2c  68c,device=003e,
> ath10k_pci 0000:01:00.0: 00000020: 73 75 62 73 79 73 74 65 6d 2d 76 65
> 6e 64 6f 72  subsystem-vendor
> ath10k_pci 0000:01:00.0: 00000030: 3d 31 36 38 63 2c 73 75 62 73 79 73
> 74 65 6d 2d  =168c,subsystem-
> ath10k_pci 0000:01:00.0: 00000040: 64 65 76 69 63 65 3d 33 33 36 31
>              device=3361
> ath10k_pci 0000:01:00.0: board name
> ath10k_pci 0000:01:00.0: 00000000: 62 75 73 3d 70 63 69 2c 76 65 6e 64
> 6f 72 3d 31  bus=pci,vendor=1
> ath10k_pci 0000:01:00.0: 00000010: 36 38 63 2c 64 65 76 69 63 65 3d 30
> 30 33 65 2c  68c,device=003e,
> ath10k_pci 0000:01:00.0: 00000020: 73 75 62 73 79 73 74 65 6d 2d 76 65
> 6e 64 6f 72  subsystem-vendor
> ath10k_pci 0000:01:00.0: 00000030: 3d 31 36 38 63 2c 73 75 62 73 79 73
> 74 65 6d 2d  =168c,subsystem-
> ath10k_pci 0000:01:00.0: 00000040: 64 65 76 69 63 65 3d 33 33 36 32
>              device=3362
> ath10k_pci 0000:01:00.0: board name
> ath10k_pci 0000:01:00.0: 00000000: 62 75 73 3d 70 63 69 2c 76 65 6e 64
> 6f 72 3d 31  bus=pci,vendor=1
> ath10k_pci 0000:01:00.0: 00000010: 36 38 63 2c 64 65 76 69 63 65 3d 30
> 30 33 65 2c  68c,device=003e,
> ath10k_pci 0000:01:00.0: 00000020: 73 75 62 73 79 73 74 65 6d 2d 76 65
> 6e 64 6f 72  subsystem-vendor
> ath10k_pci 0000:01:00.0: 00000030: 3d 31 36 38 63 2c 73 75 62 73 79 73
> 74 65 6d 2d  =168c,subsystem-
> ath10k_pci 0000:01:00.0: 00000040: 64 65 76 69 63 65 3d 33 33 36 33
>              device=3363
> ath10k_pci 0000:01:00.0: failed to fetch board data for
> ath10k/QCA6174/hw3.0 from
> bus=pci,vendor=168c,device=003e,subsystem-vendor=0000,subsystem-device=0000/board-2.bin,
> board_len= 0, board_data= 0x0
> ath10k_pci 0000:01:00.0: failed to fetch board data
> ath10k_pci 0000:01:00.0: failed to fetch board file: -2
> ath10k_pci 0000:01:00.0: boot hif power down
> ath10k_pci 0000:01:00.0: could not probe fw (-2)
> ath10k_pci 0000:01:00.0: pci ps timer refcount 0 awake 1
> ath10k_pci 0000:01:00.0: pci ps sleep reg refcount 0 awake 1
>
> Strange that my card is subsystem-vendor=0000,subsystem-device=0000...
>
> 2015-12-01 10:43 GMT+01:00 Bartosz Markowski <bartosz.markowski@tieto.com>:
>> On 1 December 2015 at 09:42, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> On 1 December 2015 at 09:38, Bartlomiej Grzeskowiak
>>> <bartlomiej.grzeskowiak@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I have already tried with backports 4.2.6 and different combinations
>>>> of firmware.bin / board.bin. With differnt results, but none of them
>>>> works. I will redo the tests and summarize them.
>>>>
>>>> Loading with irq_mode=1 gives me following result:
>>>> [55416.824364] ath10k_pci 0000:01:00.0: limiting irq mode to: 1
>>>> [55416.830102] ath10k_pci 0000:01:00.0: pci irq legacy interrupts 0
>>>> irq_mode 1 reset_mode 0
>>>> [55417.212048] ath10k_pci 0000:01:00.0: could not fetch firmware file
>>>> 'ath10k/QCA6174/hw3.0/firmware-5.bin': -2
>>>> [55424.394422] ath10k_pci 0000:01:00.0: wmi unified ready event not received
>>>> [55424.436023] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
>>>> e082ac60-7c2d-4d14-9c49-fd5b0591c95c)
>>>> [55424.445008] ath10k_pci 0000:01:00.0: qca6174 hw3.2 (0x05030000,
>>>
>>> Oh, wait.
>>>
>>> You have hw3.2? I haven't noticed that earlier.
>>>
>>> If memory serves right it needs a different board.bin (compared to
>>> e.g. hw3.0). I'm not sure if it's available in Kalle's repository.
>>> Wrong board.bin can cause firmware to hang or crash during init.
>>
>> Could you give a try to the board-2.bin file, which is sort of a
>> container for the board bins, ath10k shall support.. and say if it
>> solves your card problem?
>>
>> *) https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/board-2.bin
>>
>> --
>> Bartosz
