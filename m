Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34368 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbLAIjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 03:39:13 -0500
Received: by ykfs79 with SMTP id s79so217759943ykf.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 00:39:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=k9NHd6KHt2qzgjs5g3B6Q58fX=hTRB-BvxcvjejmWog@mail.gmail.com>
References: <loom.20151201T071931-353@post.gmane.org> <CALhHN=o4xAhy9oz0Q7sy-Ubji-nBf6pdJ7OSj8xLU0mn86n1qQ@mail.gmail.com>
 <CADaZW1E42rnjaxjnjskW_j83m=moauNBttZ-M=oyWoiXXS2ZiQ@mail.gmail.com> <CA+BoTQ=k9NHd6KHt2qzgjs5g3B6Q58fX=hTRB-BvxcvjejmWog@mail.gmail.com>
From: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Date: Tue, 1 Dec 2015 09:38:43 +0100
Message-ID: <CADaZW1Eww2TNimciP5JxVam0y+-V4Ez2VfFXdT=_jh14TgOp0g@mail.gmail.com> (sfid-20151201_093919_896035_AD37F107)
Subject: Re: ath10k: device has crashed during init - qca6174 chipset
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have already tried with backports 4.2.6 and different combinations
of firmware.bin / board.bin. With differnt results, but none of them
works. I will redo the tests and summarize them.

Loading with irq_mode=1 gives me following result:
[55416.824364] ath10k_pci 0000:01:00.0: limiting irq mode to: 1
[55416.830102] ath10k_pci 0000:01:00.0: pci irq legacy interrupts 0
irq_mode 1 reset_mode 0
[55417.212048] ath10k_pci 0000:01:00.0: could not fetch firmware file
'ath10k/QCA6174/hw3.0/firmware-5.bin': -2
[55424.394422] ath10k_pci 0000:01:00.0: wmi unified ready event not received
[55424.436023] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
e082ac60-7c2d-4d14-9c49-fd5b0591c95c)
[55424.445008] ath10k_pci 0000:01:00.0: qca6174 hw3.2 (0x05030000,
0x00340aff sub 0000:0000) fw WLAN.RM.2.0-00180-QCARMSWPZ-1 fwapi 4
bdapi 1 htt-ver 0.0 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0
hwcrypto 1 features wowlan,ignore-otp,no-4addr-pad
[55424.466652] ath10k_pci 0000:01:00.0: debug 1 debugfs 1 tracing 0
dfs 0 testmode 0
[55424.476163] ath10k_pci 0000:01:00.0: firmware register dump:
[55424.481817] ath10k_pci 0000:01:00.0: [00]: 0x05030000 0x00000000
0x80914913 0x00000058
[55424.489740] ath10k_pci 0000:01:00.0: [04]: 0x80914913 0x0040EAB8
0x80000000 0x00000000
[55424.497661] ath10k_pci 0000:01:00.0: [08]: 0x80000000 0x00404070
0x00000000 0x00000010
[55424.505582] ath10k_pci 0000:01:00.0: [12]: 0x8091071F 0x0040EA88
0x00060523 0x00910940
[55424.513491] ath10k_pci 0000:01:00.0: [16]: 0x00002580 0x00000004
0x00000000 0x00952A00
[55424.521411] ath10k_pci 0000:01:00.0: [20]: 0x8091097C 0x0040EAE8
0x00400000 0x004117E0
[55424.529333] ath10k_pci 0000:01:00.0: [24]: 0x00000800 0x004117E0
0xFFFFFFFB 0x0091810C
[55424.537253] ath10k_pci 0000:01:00.0: [28]: 0x80914540 0x0040EAC8
0x0000001F 0x00400000
[55424.545174] ath10k_pci 0000:01:00.0: [32]: 0x00000000 0x00400000
0x00400000 0x004111B8
[55424.553082] ath10k_pci 0000:01:00.0: [36]: 0x00000000 0x00000000
0x00000000 0x00000000
[55424.561002] ath10k_pci 0000:01:00.0: [40]: 0x00000000 0x00000000
0x00000000 0x00000000
[55424.568922] ath10k_pci 0000:01:00.0: [44]: 0x00000000 0x00000000
0x00000000 0x00000000
[55424.576842] ath10k_pci 0000:01:00.0: [48]: 0x00000000 0x00000000
0x00000000 0x00000000
[55424.584763] ath10k_pci 0000:01:00.0: [52]: 0x00000000 0x00000000
0x00000000 0x00000000
[55424.592671] ath10k_pci 0000:01:00.0: [56]: 0x00000000 0x00000000
0x00000000 0x00000000
[55427.439381] ath10k_pci 0000:01:00.0: failed to receive initialized
event from target: 00000000
[55427.467842] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
6b37f354-65c8-4c76-a0ff-694f67a9d731)
[55427.476825] ath10k_pci 0000:01:00.0: qca6174 hw3.2 (0x05030000,
0x00340aff sub 0000:0000) fw WLAN.RM.2.0-00180-QCARMSWPZ-1 fwapi 4
bdapi 1 htt-ver 0.0 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0
hwcrypto 1 features wowlan,ignore-otp,no-4addr-pad
[55427.498468] ath10k_pci 0000:01:00.0: debug 1 debugfs 1 tracing 0
dfs 0 testmode 0
[55427.507975] ath10k_pci 0000:01:00.0: firmware register dump:
[55427.513628] ath10k_pci 0000:01:00.0: [00]: 0x05030000 0x00000000
0x80914913 0x00000058
[55427.521551] ath10k_pci 0000:01:00.0: [04]: 0x80914913 0x0040EAB8
0x80000000 0x00000000
[55427.529473] ath10k_pci 0000:01:00.0: [08]: 0x80000000 0x00404070
0x00000000 0x00000010
[55427.537395] ath10k_pci 0000:01:00.0: [12]: 0x8091071F 0x0040EA88
0x00060523 0x00910940
[55427.545316] ath10k_pci 0000:01:00.0: [16]: 0x00002580 0x00000004
0x00000000 0x00952A00
[55427.553225] ath10k_pci 0000:01:00.0: [20]: 0x8091097C 0x0040EAE8
0x00400000 0x004117E0
[55427.561145] ath10k_pci 0000:01:00.0: [24]: 0x00000800 0x004117E0
0xFFFFFFFB 0x0091810C
[55427.569066] ath10k_pci 0000:01:00.0: [28]: 0x80914540 0x0040EAC8
0x0000001F 0x00400000
[55427.576987] ath10k_pci 0000:01:00.0: [32]: 0x00000000 0x00400000
0x00400000 0x004111B8
[55427.584907] ath10k_pci 0000:01:00.0: [36]: 0x00000000 0x00000000
0x00000000 0x00000000
[55427.592816] ath10k_pci 0000:01:00.0: [40]: 0x00000000 0x00000000
0x00000000 0x00000000
[55427.600736] ath10k_pci 0000:01:00.0: [44]: 0x00000000 0x00000000
0x00000000 0x00000000
[55427.608657] ath10k_pci 0000:01:00.0: [48]: 0x00000000 0x00000000
0x00000000 0x00000000
[55427.616578] ath10k_pci 0000:01:00.0: [52]: 0x00000000 0x00000000
0x00000000 0x00000000
[55427.624498] ath10k_pci 0000:01:00.0: [56]: 0x00000000 0x00000000
0x00000000 0x00000000
[55430.470669] ath10k_pci 0000:01:00.0: failed to receive initialized
event from target: 00000000
[55430.479287] ath10k_pci 0000:01:00.0: failed to wait for target init: -110
[55430.489524] ath10k_pci 0000:01:00.0: could not init core (-110)
[55430.495709] ath10k_pci 0000:01:00.0: could not probe fw (-110)
[55430.534414] ath10k_pci 0000:01:00.0: cannot restart a device that
hasn't been started

2015-12-01 9:26 GMT+01:00 Michal Kazior <michal.kazior@tieto.com>:
> On 1 December 2015 at 09:13, Bartlomiej Grzeskowiak
> <bartlomiej.grzeskowiak@gmail.com> wrote:
>> Hi,
>>
>> Unfortunately I do have this patch in my code (backports-4.4-rc.2-1).
>> I have also tested the old reg_address/mask value (0x00009028) but the
>> result is the same.
>
> The problem actually looks a little different. The mentioned patch
> fixed a problem which would occur during early device init/probing.
> Your problem seems to occur while booting and configuring firmware.
>
> Did you try using older backports, firmware and/or board/board-2.bin
> files? This could be some sort of regression you're seeing with the
> exact combination you're testing.
>
> You could also try loading ath10k_pci with irq_mode=1.
>
>
> Michal
