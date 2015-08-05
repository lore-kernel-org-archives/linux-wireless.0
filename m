Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38439 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbHERwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 13:52:40 -0400
Received: by wibxm9 with SMTP id xm9so77790848wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 10:52:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQd7mZm7LG2-iCQe2-KJLtA3Y7NwzAk_0N9JN3Cn3qjSC7GpA@mail.gmail.com>
References: <CAMQd7mbWC7rj8-eU7Jv21ehT8KrpC=L=xWxzDQxHEU_ePNSdUg@mail.gmail.com>
	<CA+BoTQmd0Uoi=2MNMsDXYe1yKsYa3P8uvVzWwXoMynQGtjeD4w@mail.gmail.com>
	<CAMQd7maioLviTaLHp+f03HafABijKD_d92K_SRO8XS51poKGqg@mail.gmail.com>
	<CA+BoTQkA0k1RBwzKFchcWebuWUmdoaqvaAq4BRz2o3C-GGUCog@mail.gmail.com>
	<CAMQd7ma7hehYLBf-5hUD0sViUwWGX8vy7ENXuBi8Q49F88A45Q@mail.gmail.com>
	<CA+BoTQkqttvPkk6qk6YV8SYPVnEcADfcUkLBCpjFoZBab81Byg@mail.gmail.com>
	<871tfr8ne9.fsf@kamboji.qca.qualcomm.com>
	<CAMQd7mY+upL+t9q0yJ0uL_jw_STEKL+hhe1PF_D5yPwfTkcgZg@mail.gmail.com>
	<874mkn71ls.fsf@kamboji.qca.qualcomm.com>
	<CAMQd7mYa4egNdyRq+8Wnv96L1aEU2esyfb0EEDjkbKO7O-9qDQ@mail.gmail.com>
	<CAMQd7mZm7LG2-iCQe2-KJLtA3Y7NwzAk_0N9JN3Cn3qjSC7GpA@mail.gmail.com>
Date: Wed, 5 Aug 2015 19:52:39 +0200
Message-ID: <CAMQd7mZfkLiML3QgPfi9Kjh0=fRdOu-C=5tB0FBzdH_Na7xWnw@mail.gmail.com> (sfid-20150805_195244_483132_D5DF4C22)
Subject: Re: QCA6174 hw2.1 irq_mode=0 broken on 4.2-rc3, working on 4.1.2
From: Enrico Tagliavini <enrico.tagliavini@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bisect is done, unfortunately I think there is no good news

$ git bisect log
git bisect start '--' 'drivers/net/wireless/ath/ath10k/'
# bad: [86ea07ca846a7c352f39dd0b7d81f15f403c7db8] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect bad 86ea07ca846a7c352f39dd0b7d81f15f403c7db8
# good: [b953c0d234bc72e8489d3bf51a276c5c4ec85345] Linux 4.1
git bisect good b953c0d234bc72e8489d3bf51a276c5c4ec85345
# good: [8e9904f5b9e5e0a126020211218c401d601ef74b] ath10k: mac: match
wait_for_completion_timeout return type
git bisect good 8e9904f5b9e5e0a126020211218c401d601ef74b
# good: [8e9904f5b9e5e0a126020211218c401d601ef74b] ath10k: mac: match
wait_for_completion_timeout return type
git bisect good 8e9904f5b9e5e0a126020211218c401d601ef74b
# good: [0cd9bc147f0b8d805972cbb4b7b5e5529f9624e0] ath10k: enable ibss-rsn
git bisect good 0cd9bc147f0b8d805972cbb4b7b5e5529f9624e0
# good: [48f4ca34f36bb947d8a7cd4ff8c8e282f14d51e6] ath10k: add new
4addr related fw_feature
git bisect good 48f4ca34f36bb947d8a7cd4ff8c8e282f14d51e6
# good: [163f52647a0f7e34e803b51456c60deedd26ca1d] ath10k: bypass PLL
setting on target init for QCA9888
git bisect good 163f52647a0f7e34e803b51456c60deedd26ca1d
# good: [d7bf4b4aba056f3e7eb88a3d8d45ee1a6f4873e9] ath10k: fix
ar->rx_channel updating logic
git bisect good d7bf4b4aba056f3e7eb88a3d8d45ee1a6f4873e9
# good: [0e6eb417fc1facda1c9a9189be85f16cb5b8b69f] ath10k: fix channel switching
git bisect good 0e6eb417fc1facda1c9a9189be85f16cb5b8b69f
# good: [30686bf7f5b3c30831761e188a6e3cb33580fa48] mac80211: convert
HW flags to unsigned long bitmap
git bisect good 30686bf7f5b3c30831761e188a6e3cb33580fa48
# good: [469d479f91b8277cc921d7525f31c832b25d9efb] ath10k: prevent
memory leak in wmi rx ops
git bisect good 469d479f91b8277cc921d7525f31c832b25d9efb
# good: [fa433354f042105fc7a299253f904bb48dae0950] Merge tag
'wireless-drivers-next-for-davem-2015-06-18' of
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
git bisect good fa433354f042105fc7a299253f904bb48dae0950

as you can see I tried to restrict the bisect to the ath10k folder
only and none of the commit was faulty. Probably because all the
commit were actually still on kernel 4.1 rc, none of them was on 4.2
except the starting bad one (which was the latest when I cloned the
repo for rc4).

So I guess we are switching to plan B here and bisecting the entire
tree right? If so, starting from the same bad commit as for this one
and using the newest good commit I tested (so last entry in the bisect
I just did)

$ git bisect good fa433354f042105fc7a299253f904bb48dae0950
Bisecting: 6373 revisions left to test after this (roughly 13 steps)
[4aa705b18bf17c4ff33ff7bbcd3f0c596443fa81] Merge tag 'armsoc-soc' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc

13 steps are not crazy.... sigh. Give me enough days, in the weekend
I'll be on the road the I'll see if I can get few quiet hours to get
this done.

Any last minute advise or question before I reset this bisect?

On 1 August 2015 at 14:30, Enrico Tagliavini
<enrico.tagliavini@gmail.com> wrote:
> Hi there,
>
> I got 4.2 rc4 running and I'm going to start the bisect. Before
> compiling I enabled ath10k debug and this is the output for with
> default irq_mode:
>
> enrico@alientux ~ $ dmesg | grep ath
> [   16.234853] ath10k_pci 0000:03:00.0: enabling device (0000 -> 0002)
> [   16.234979] ath10k_pci 0000:03:00.0: boot pci_mem 0xffffc90002000000
> [   16.235351] ath10k_pci 0000:03:00.0: pci irq msi-x interrupts 8
> irq_mode 0 reset_mode 0
> [   16.235517] ath10k_pci 0000:03:00.0: boot qca6174 chip reset
> [   16.235518] ath10k_pci 0000:03:00.0: boot cold reset
> [   16.239030] ath10k_pci 0000:03:00.0: boot cold reset complete
> [   16.239032] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   16.239037] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   16.249046] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   16.249055] ath10k_pci 0000:03:00.0: boot target initialised
> [   16.249057] ath10k_pci 0000:03:00.0: boot warm reset
> [   16.271106] ath10k_pci 0000:03:00.0: boot init ce src ring id 0
> entries 16 base_addr ffff88003f00a000
> [   16.271128] ath10k_pci 0000:03:00.0: boot ce dest ring id 1 entries
> 512 base_addr ffff88003f3c8000
> [   16.271146] ath10k_pci 0000:03:00.0: boot ce dest ring id 2 entries
> 128 base_addr ffff88003eb6a000
> [   16.271166] ath10k_pci 0000:03:00.0: boot init ce src ring id 3
> entries 32 base_addr ffff88003f349000
> [   16.271187] ath10k_pci 0000:03:00.0: boot init ce src ring id 4
> entries 4096 base_addr ffff8800ba940000
> [   16.271207] ath10k_pci 0000:03:00.0: boot init ce src ring id 7
> entries 2 base_addr ffff8800c4888000
> [   16.271223] ath10k_pci 0000:03:00.0: boot ce dest ring id 7 entries
> 2 base_addr ffff8800ba889000
> [   16.271224] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   16.271229] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   16.281316] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   16.281373] ath10k_pci 0000:03:00.0: boot target initialised
> [   16.292100] ath10k_pci 0000:03:00.0: boot init ce src ring id 0
> entries 16 base_addr ffff88003f00a000
> [   16.292169] ath10k_pci 0000:03:00.0: boot ce dest ring id 1 entries
> 512 base_addr ffff88003f3c8000
> [   16.292186] ath10k_pci 0000:03:00.0: boot ce dest ring id 2 entries
> 128 base_addr ffff88003eb6a000
> [   16.292206] ath10k_pci 0000:03:00.0: boot init ce src ring id 3
> entries 32 base_addr ffff88003f349000
> [   16.292228] ath10k_pci 0000:03:00.0: boot init ce src ring id 4
> entries 4096 base_addr ffff8800ba940000
> [   16.292248] ath10k_pci 0000:03:00.0: boot init ce src ring id 7
> entries 2 base_addr ffff8800c4888000
> [   16.292265] ath10k_pci 0000:03:00.0: boot ce dest ring id 7 entries
> 2 base_addr ffff8800ba889000
> [   16.292267] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   16.292272] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   16.302326] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   16.302335] ath10k_pci 0000:03:00.0: boot target initialised
> [   16.302336] ath10k_pci 0000:03:00.0: boot warm reset complete
> [   16.302337] ath10k_pci 0000:03:00.0: boot qca6174 chip reset complete (cold)
> [   16.302350] ath10k_pci 0000:03:00.0: boot hif power up
> [   16.302408] ath10k_pci 0000:03:00.0: boot qca6174 chip reset
> [   16.302409] ath10k_pci 0000:03:00.0: boot cold reset
> [   16.306030] ath10k_pci 0000:03:00.0: boot cold reset complete
> [   16.306033] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   16.306037] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   16.316044] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   16.316056] ath10k_pci 0000:03:00.0: boot target initialised
> [   16.316057] ath10k_pci 0000:03:00.0: boot warm reset
> [   16.338057] ath10k_pci 0000:03:00.0: boot init ce src ring id 0
> entries 16 base_addr ffff88003f00a000
> [   16.338075] ath10k_pci 0000:03:00.0: boot ce dest ring id 1 entries
> 512 base_addr ffff88003f3c8000
> [   16.338092] ath10k_pci 0000:03:00.0: boot ce dest ring id 2 entries
> 128 base_addr ffff88003eb6a000
> [   16.338111] ath10k_pci 0000:03:00.0: boot init ce src ring id 3
> entries 32 base_addr ffff88003f349000
> [   16.338132] ath10k_pci 0000:03:00.0: boot init ce src ring id 4
> entries 4096 base_addr ffff8800ba940000
> [   16.338152] ath10k_pci 0000:03:00.0: boot init ce src ring id 7
> entries 2 base_addr ffff8800c4888000
> [   16.338169] ath10k_pci 0000:03:00.0: boot ce dest ring id 7 entries
> 2 base_addr ffff8800ba889000
> [   16.338169] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   16.338174] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   16.348187] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   16.348196] ath10k_pci 0000:03:00.0: boot target initialised
> [   16.359038] ath10k_pci 0000:03:00.0: boot init ce src ring id 0
> entries 16 base_addr ffff88003f00a000
> [   16.359055] ath10k_pci 0000:03:00.0: boot ce dest ring id 1 entries
> 512 base_addr ffff88003f3c8000
> [   16.359072] ath10k_pci 0000:03:00.0: boot ce dest ring id 2 entries
> 128 base_addr ffff88003eb6a000
> [   16.359092] ath10k_pci 0000:03:00.0: boot init ce src ring id 3
> entries 32 base_addr ffff88003f349000
> [   16.359113] ath10k_pci 0000:03:00.0: boot init ce src ring id 4
> entries 4096 base_addr ffff8800ba940000
> [   16.359133] ath10k_pci 0000:03:00.0: boot init ce src ring id 7
> entries 2 base_addr ffff8800c4888000
> [   16.359149] ath10k_pci 0000:03:00.0: boot ce dest ring id 7 entries
> 2 base_addr ffff8800ba889000
> [   16.359150] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   16.359155] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   16.369166] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   16.369174] ath10k_pci 0000:03:00.0: boot target initialised
> [   16.369175] ath10k_pci 0000:03:00.0: boot warm reset complete
> [   16.369175] ath10k_pci 0000:03:00.0: boot qca6174 chip reset complete (cold)
> [   16.369195] ath10k_pci 0000:03:00.0: boot init ce src ring id 0
> entries 16 base_addr ffff88003f00a000
> [   16.369212] ath10k_pci 0000:03:00.0: boot ce dest ring id 1 entries
> 512 base_addr ffff88003f3c8000
> [   16.369228] ath10k_pci 0000:03:00.0: boot ce dest ring id 2 entries
> 128 base_addr ffff88003eb6a000
> [   16.369248] ath10k_pci 0000:03:00.0: boot init ce src ring id 3
> entries 32 base_addr ffff88003f349000
> [   16.369268] ath10k_pci 0000:03:00.0: boot init ce src ring id 4
> entries 4096 base_addr ffff8800ba940000
> [   16.369288] ath10k_pci 0000:03:00.0: boot init ce src ring id 7
> entries 2 base_addr ffff8800c4888000
> [   16.369304] ath10k_pci 0000:03:00.0: boot ce dest ring id 7 entries
> 2 base_addr ffff8800ba889000
> [   16.380484] ath10k_pci 0000:03:00.0: bmi get target info
> [   16.380731] ath10k_pci 0000:03:00.0: Hardware name qca6174 hw2.1
> version 0x5010000
> [   16.381072] ath10k_pci 0000:03:00.0: Direct firmware load for
> ath10k/cal-pci-0000:03:00.0.bin failed with error -2
> [   16.382103] ath10k_pci 0000:03:00.0: Direct firmware load for
> ath10k/QCA6174/hw2.1/board-pci-168c:003e:1a56:1525.bin failed with
> error -2
> [   16.382107] ath10k_pci 0000:03:00.0: failed to load spec board
> file, falling back to generic: -2
> [   16.383013] ath10k_pci 0000:03:00.0: trying fw api 5
> [   16.383028] ath10k_pci 0000:03:00.0: Direct firmware load for
> ath10k/QCA6174/hw2.1/firmware-5.bin failed with error -2
> [   16.383030] ath10k_pci 0000:03:00.0: could not fetch firmware file
> 'ath10k/QCA6174/hw2.1/firmware-5.bin': -2
> [   16.383032] ath10k_pci 0000:03:00.0: trying fw api 4
> [   16.384382] ath10k_pci 0000:03:00.0: found fw version killer-n1525-fw
> [   16.384384] ath10k_pci 0000:03:00.0: found firmware features ie (4 B)
> [   16.384385] ath10k_pci 0000:03:00.0: features
> [   16.384387] ath10k_pci 0000:03:00.0: 00000000: 00 00 00 00 00 00 00
> 00                          ........
> [   16.384388] ath10k_pci 0000:03:00.0: found fw ie wmi op version 4
> [   16.384390] ath10k_pci 0000:03:00.0: found fw image ie (464383 B)
> [   16.384391] ath10k_pci 0000:03:00.0: found otp image ie (29533 B)
> [   16.384392] ath10k_pci 0000:03:00.0: using fw api 4
> [   16.384394] ath10k_pci 0000:03:00.0: bmi start
> [   16.384395] ath10k_pci 0000:03:00.0: bmi write address 0x400800 length 4
> [   16.384414] ath10k_pci 0000:03:00.0: bmi read address 0x400810 length 4
> [   16.384497] ath10k_pci 0000:03:00.0: bmi write address 0x400810 length 4
> [   16.384507] ath10k_pci 0000:03:00.0: bmi write address 0x400844 length 4
> [   16.384556] ath10k_pci 0000:03:00.0: bmi write address 0x400904 length 4
> [   16.384598] ath10k_pci 0000:03:00.0: boot did not find a
> calibration file, try DT next: -2
> [   16.384600] ath10k_pci 0000:03:00.0: boot did not find DT entry,
> try OTP next: -2
> [   16.384601] ath10k_pci 0000:03:00.0: bmi read address 0x4008ac length 4
> [   16.384678] ath10k_pci 0000:03:00.0: boot push board extended data addr 0x0
> [   16.384679] ath10k_pci 0000:03:00.0: bmi read address 0x400854 length 4
> [   16.384732] ath10k_pci 0000:03:00.0: bmi write address 0x401d40 length 8124
> [   16.400967] ath10k_pci 0000:03:00.0: bmi write address 0x400858 length 4
> [   16.401133] ath10k_pci 0000:03:00.0: boot upload otp to 0x1234 len 29533
> [   16.401134] ath10k_pci 0000:03:00.0: bmi fast download address
> 0x1234 buffer 0xffffc9000166f64c length 29533
> [   16.401135] ath10k_pci 0000:03:00.0: bmi lz stream start address 0x1234
> [   16.401173] ath10k_pci 0000:03:00.0: bmi lz data buffer
> 0xffffc9000166f64c length 29532
> [   16.463523] ath10k_pci 0000:03:00.0: bmi lz data buffer
> 0xffff8800c4763d2c length 4
> [   16.463602] ath10k_pci 0000:03:00.0: bmi lz stream start address 0x0
> [   16.463647] ath10k_pci 0000:03:00.0: bmi execute address 0x1234 param 0x0
> [   16.465226] ath10k_pci 0000:03:00.0: bmi execute result 0x3
> [   16.465231] ath10k_pci 0000:03:00.0: boot otp execute result 3
> [   16.465232] ath10k_pci 0000:03:00.0: boot using calibration mode otp
> [   16.465234] ath10k_pci 0000:03:00.0: boot uploading firmware image
> ffffc900015fe044 len 464383 mode normal
> [   16.465235] ath10k_pci 0000:03:00.0: bmi fast download address
> 0x1234 buffer 0xffffc900015fe044 length 464383
> [   16.465237] ath10k_pci 0000:03:00.0: bmi lz stream start address 0x1234
> [   16.465257] ath10k_pci 0000:03:00.0: bmi lz data buffer
> 0xffffc900015fe044 length 464380
> [   17.548533] ath10k_pci 0000:03:00.0: bmi lz data buffer
> 0xffff8800c4763d2c length 4
> [   17.548792] ath10k_pci 0000:03:00.0: bmi lz stream start address 0x0
> [   17.548837] ath10k_pci 0000:03:00.0: bmi write address 0x400814 length 4
> [   17.548871] ath10k_pci 0000:03:00.0: bmi done
> [   17.548913] ath10k_pci 0000:03:00.0: htt tx max num pending tx 1056
> [   17.548922] ath10k_pci 0000:03:00.0: htt rx ring size 2048 fill_level 1023
> [   17.548923] ath10k_pci 0000:03:00.0: boot hif start
> [   17.548959] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
> [   17.548981] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
> [   18.549028] ath10k_pci 0000:03:00.0: failed to receive control
> response completion, polling..
> [   18.549192] ath10k_pci 0000:03:00.0: boot htc service 'Control' ul
> pipe 0 dl pipe 1 eid 0 ready
> [   18.549193] ath10k_pci 0000:03:00.0: boot htc ep 0 ul polled 0 dl polled 0
> [   18.549194] ath10k_pci 0000:03:00.0: boot htc service 'Control' eid
> 0 TX flow control disabled
> [   18.549195] ath10k_pci 0000:03:00.0: boot htc service HTT Data does
> not allocate target credits
> [   18.549280] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
> [   18.549294] ath10k_pci 0000:03:00.0: received unsolicited fw crash interrupt
> [   19.549038] ath10k_pci 0000:03:00.0: Service connect timeout
> [   19.549042] ath10k_pci 0000:03:00.0: failed to connect htt (-110)
> [   19.549044] ath10k_pci 0000:03:00.0: boot hif stop
> [   19.549045] ath10k_pci 0000:03:00.0: boot warm reset
> [   19.571100] ath10k_pci 0000:03:00.0: boot init ce src ring id 0
> entries 16 base_addr ffff88003f00a000
> [   19.571117] ath10k_pci 0000:03:00.0: boot ce dest ring id 1 entries
> 512 base_addr ffff88003f3c8000
> [   19.571133] ath10k_pci 0000:03:00.0: boot ce dest ring id 2 entries
> 128 base_addr ffff88003eb6a000
> [   19.571153] ath10k_pci 0000:03:00.0: boot init ce src ring id 3
> entries 32 base_addr ffff88003f349000
> [   19.571172] ath10k_pci 0000:03:00.0: boot init ce src ring id 4
> entries 4096 base_addr ffff8800ba940000
> [   19.571190] ath10k_pci 0000:03:00.0: boot init ce src ring id 7
> entries 2 base_addr ffff8800c4888000
> [   19.571206] ath10k_pci 0000:03:00.0: boot ce dest ring id 7 entries
> 2 base_addr ffff8800ba889000
> [   19.571207] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   19.571212] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   19.581273] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   19.581282] ath10k_pci 0000:03:00.0: boot target initialised
> [   19.592126] ath10k_pci 0000:03:00.0: boot init ce src ring id 0
> entries 16 base_addr ffff88003f00a000
> [   19.592202] ath10k_pci 0000:03:00.0: boot ce dest ring id 1 entries
> 512 base_addr ffff88003f3c8000
> [   19.592222] ath10k_pci 0000:03:00.0: boot ce dest ring id 2 entries
> 128 base_addr ffff88003eb6a000
> [   19.592245] ath10k_pci 0000:03:00.0: boot init ce src ring id 3
> entries 32 base_addr ffff88003f349000
> [   19.592269] ath10k_pci 0000:03:00.0: boot init ce src ring id 4
> entries 4096 base_addr ffff8800ba940000
> [   19.592294] ath10k_pci 0000:03:00.0: boot init ce src ring id 7
> entries 2 base_addr ffff8800c4888000
> [   19.592314] ath10k_pci 0000:03:00.0: boot ce dest ring id 7 entries
> 2 base_addr ffff8800ba889000
> [   19.592316] ath10k_pci 0000:03:00.0: boot waiting target to initialise
> [   19.592321] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   19.602378] ath10k_pci 0000:03:00.0: boot target indicator 0
> [   19.612445] ath10k_pci 0000:03:00.0: boot target indicator 2
> [   19.612455] ath10k_pci 0000:03:00.0: boot target initialised
> [   19.612456] ath10k_pci 0000:03:00.0: boot warm reset complete
> [   19.612779] ath10k_pci 0000:03:00.0: could not init core (-110)
> [   19.612810] ath10k_pci 0000:03:00.0: boot hif power down
> [   19.612811] ath10k_pci 0000:03:00.0: could not probe fw (-110)
>
> Maybe this trigger some bell.
>
> On 29 July 2015 at 16:22, Enrico Tagliavini <enrico.tagliavini@gmail.com> wrote:
>> Sound! I'll keep a copy of the log then. If the bisect on ath10k
>> folder will lead nowhere I'll see if I can make it over the whole
>> tree. At least by doing it on the ath10k tree I hope to narrow down
>> the number of commit.
>>
>> Ok then I'll use Linus' master, no problem with this.
>>
>> I hope to at least get started this weekend.
>>
>> On 29 July 2015 at 11:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Enrico Tagliavini <enrico.tagliavini@gmail.com> writes:
>>>
>>>> Yeah that's what I meant. My idea was to first bisect only the ath10k
>>>> directory, so restricting the bisect on the commits touching stuff
>>>> there. I guess if the issue is more broad it will come up somewhere
>>>> else as well, so this is a good starting point, I hope. Thank you for
>>>> pointing it out though, this will actually be the first time I do a
>>>> proper bisect.
>>>
>>> And remember to always to mention if you have restricted the bisect
>>> somehow, that's important information. And better if you provide 'git
>>> bisect log' output as well.
>>>
>>>> Also do you want me to bisect Kalle's sources or Linus' master? By
>>>> what Michał said I guess Kalle's but I ask to be sure.
>>>>
>>>> Also to be clear: I'm using Linus' sources at the moment, as provided
>>>> by Fedora rawhide.
>>>>
>>>> For me it's the same, so let me know what you prefer and is more
>>>> useful to solve this issue.
>>>
>>> Good that you brought this up. As ath.git master branch gets rebased
>>> every rc1 release you really cannot use that for bisect. Either you
>>> should use ath.git ath-next branch or Linus' tree. To be on the safe
>>> side I always recommend to use Linus' tree if at all possible.
>>>
>>> --
>>> Kalle Valo
