Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62020 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbHYM4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 08:56:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, twilightrook@gmail.com,
	vvanpo@gmail.com, linux-wireless@vger.kernel.org,
	oscarrydberg@gmail.com, joseph.salisbury@canonical.com
Subject: Re: [PATCH/RFT 0/2] ath10k: add qca6164 support
Date: Tue, 25 Aug 2015 14:56:06 +0200
Message-ID: <1889302.bvZ6s0xNZC@wuerfel> (sfid-20150825_145615_847747_282AA944)
In-Reply-To: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 August 2015 14:32:25 Michal Kazior wrote:
> Hi everyone,
> 
> Looks like ath10k is very close to finally support
> qca6164. Recent discussion[1] led to a working
> prototype[2][3].
> 
> I'm CCing everyone I've found in my mailbox that
> complained about QCA6164 not working. Hopefully I
> did not miss anyone.
> 
> I would really like to know if this patchset (in
> its current shape and form) of mine works for any
> of you who owns QCA6164. If it doesn't please try
> Patch [1/2] only.
> 
> Today Kalle posted QCA6174 (which is actually
> QCA61X4) firmware binary for ath10k[4]. Please use
> it to test QCA6164 (i.e. don't use sumdog's
> firmware nor your own assembled one).
> 
> However QCA6164 requires a different board.bin
> file[3]. This requires some additional changes in
> ath10k to support sanely but *for now* you can use
> board file vvanpo extracted from window driver[5]
> and place it as:
> 
>   /lib/firmware/ath10k/QCA6174/hw2.1/board-pci-168c:0041:17aa:3545.bin
> 
> This should work. If it doesn't, try replacing the
> existing board.bin - if you'll need to do please
> let me/us know and post the boot string which
> looks like this:
> 
>   ath10k_pci 0000:03:00.0: qca6174 hw2.1 (0x05010000, 0x003405ff, 168c:0041:17aa:3545 fallback) fw killer-n1525-fw api 5 htt-ver 0.0 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1 features
> 
> My guess is some devices may have different
> subsystem product/vendor ids. It'll be good to
> know at least a subset of those for reference.
> 

Hi Michael,

I have now put the qca6164 card back into my Lenovo Yoga 3 11 (1170)
and tried your first patch from your email on top of 4d43636271
("Merge remote-tracking branch 'wireless-testing/master'") from Kalle.

It looks like I'm still getting firmware crashes with the firmware
files you pointed to:

$ md5sum /lib/firmware/ath10k/QCA6174/hw2.1/*
e6adc90ecaf55edc656990c6c50193ac  /lib/firmware/ath10k/QCA6174/hw2.1/board.bin
e6adc90ecaf55edc656990c6c50193ac  /lib/firmware/ath10k/QCA6174/hw2.1/board-pci-168c:0041:17aa:3545.bin
8f5303e4b1afc818798425a700139133  /lib/firmware/ath10k/QCA6174/hw2.1/firmware-5.bin

$ sudo modprobe ath10k-core  debug_mask=0xffffbfff skip_otp=1
$ sudo modprobe ath10k-pci
$ dmesg

[ 2213.448180] ath10k_pci 0000:02:00.0: pci remove
[ 2217.606063] ath10k_pci 0000:02:00.0: pci probe
[ 2217.606231] ath10k_pci 0000:02:00.0: boot pci_mem 0xffffc90001800000
[ 2217.606623] ath10k_pci 0000:02:00.0: pci irq msi-x interrupts 8 irq_mode 0 reset_mode 0
[ 2217.606767] ath10k_pci 0000:02:00.0: boot qca6174 chip reset
[ 2217.606770] ath10k_pci 0000:02:00.0: boot cold reset
[ 2217.654621] ath10k_pci 0000:02:00.0: boot cold reset complete
[ 2217.654630] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2217.654638] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2217.654646] ath10k_pci 0000:02:00.0: boot target initialised
[ 2217.654650] ath10k_pci 0000:02:00.0: boot warm reset
[ 2217.686575] ath10k_pci 0000:02:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800977d4000
[ 2217.686597] ath10k_pci 0000:02:00.0: boot ce dest ring id 1 entries 512 base_addr ffff88002a03e000
[ 2217.686614] ath10k_pci 0000:02:00.0: boot ce dest ring id 2 entries 128 base_addr ffff880097110000
[ 2217.686633] ath10k_pci 0000:02:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800972a4000
[ 2217.686656] ath10k_pci 0000:02:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff880061030000
[ 2217.686675] ath10k_pci 0000:02:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880061246000
[ 2217.686690] ath10k_pci 0000:02:00.0: boot ce dest ring id 7 entries 2 base_addr ffff880061247000
[ 2217.686694] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2217.686699] ath10k_pci 0000:02:00.0: boot target indicator 0
[ 2217.696630] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2217.696636] ath10k_pci 0000:02:00.0: boot target initialised
[ 2217.710686] ath10k_pci 0000:02:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800977d4000
[ 2217.710708] ath10k_pci 0000:02:00.0: boot ce dest ring id 1 entries 512 base_addr ffff88002a03e000
[ 2217.710725] ath10k_pci 0000:02:00.0: boot ce dest ring id 2 entries 128 base_addr ffff880097110000
[ 2217.710744] ath10k_pci 0000:02:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800972a4000
[ 2217.710767] ath10k_pci 0000:02:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff880061030000
[ 2217.710785] ath10k_pci 0000:02:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880061246000
[ 2217.710801] ath10k_pci 0000:02:00.0: boot ce dest ring id 7 entries 2 base_addr ffff880061247000
[ 2217.710805] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2217.710811] ath10k_pci 0000:02:00.0: boot target indicator 0
[ 2217.720741] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2217.720747] ath10k_pci 0000:02:00.0: boot target initialised
[ 2217.720748] ath10k_pci 0000:02:00.0: boot warm reset complete
[ 2217.720749] ath10k_pci 0000:02:00.0: boot qca6174 chip reset complete (cold)
[ 2217.720781] ath10k_pci 0000:02:00.0: boot hif power up
[ 2217.720790] ath10k_pci 0000:02:00.0: boot qca6174 chip reset
[ 2217.720792] ath10k_pci 0000:02:00.0: boot cold reset
[ 2217.766698] ath10k_pci 0000:02:00.0: boot cold reset complete
[ 2217.766706] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2217.766714] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2217.766723] ath10k_pci 0000:02:00.0: boot target initialised
[ 2217.766726] ath10k_pci 0000:02:00.0: boot warm reset
[ 2217.798743] ath10k_pci 0000:02:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800977d4000
[ 2217.798766] ath10k_pci 0000:02:00.0: boot ce dest ring id 1 entries 512 base_addr ffff88002a03e000
[ 2217.798782] ath10k_pci 0000:02:00.0: boot ce dest ring id 2 entries 128 base_addr ffff880097110000
[ 2217.798801] ath10k_pci 0000:02:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800972a4000
[ 2217.798824] ath10k_pci 0000:02:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff880061030000
[ 2217.798843] ath10k_pci 0000:02:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880061246000
[ 2217.798858] ath10k_pci 0000:02:00.0: boot ce dest ring id 7 entries 2 base_addr ffff880061247000
[ 2217.798862] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2217.798868] ath10k_pci 0000:02:00.0: boot target indicator 0
[ 2217.808798] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2217.808804] ath10k_pci 0000:02:00.0: boot target initialised
[ 2217.822763] ath10k_pci 0000:02:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800977d4000
[ 2217.822786] ath10k_pci 0000:02:00.0: boot ce dest ring id 1 entries 512 base_addr ffff88002a03e000
[ 2217.822803] ath10k_pci 0000:02:00.0: boot ce dest ring id 2 entries 128 base_addr ffff880097110000
[ 2217.822822] ath10k_pci 0000:02:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800972a4000
[ 2217.822845] ath10k_pci 0000:02:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff880061030000
[ 2217.822863] ath10k_pci 0000:02:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880061246000
[ 2217.822879] ath10k_pci 0000:02:00.0: boot ce dest ring id 7 entries 2 base_addr ffff880061247000
[ 2217.822883] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2217.822888] ath10k_pci 0000:02:00.0: boot target indicator 0
[ 2217.832819] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2217.832825] ath10k_pci 0000:02:00.0: boot target initialised
[ 2217.832826] ath10k_pci 0000:02:00.0: boot warm reset complete
[ 2217.832828] ath10k_pci 0000:02:00.0: boot qca6174 chip reset complete (cold)
[ 2217.832841] ath10k_pci 0000:02:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800977d4000
[ 2217.832852] ath10k_pci 0000:02:00.0: boot ce dest ring id 1 entries 512 base_addr ffff88002a03e000
[ 2217.832864] ath10k_pci 0000:02:00.0: boot ce dest ring id 2 entries 128 base_addr ffff880097110000
[ 2217.832877] ath10k_pci 0000:02:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800972a4000
[ 2217.832891] ath10k_pci 0000:02:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff880061030000
[ 2217.832904] ath10k_pci 0000:02:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880061246000
[ 2217.832915] ath10k_pci 0000:02:00.0: boot ce dest ring id 7 entries 2 base_addr ffff880061247000
[ 2217.843910] ath10k_pci 0000:02:00.0: bmi get target info
[ 2217.844158] ath10k_pci 0000:02:00.0: Hardware name qca6174 hw2.1 version 0x5010000
[ 2217.844172] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/cal-pci-0000:02:00.0.bin failed with error -2
[ 2217.844174] ath10k_pci 0000:02:00.0: Falling back to user helper
[ 2217.844559] ath10k_pci 0000:02:00.0: found specific board file for 168c:0041:17aa:3545
[ 2217.844562] ath10k_pci 0000:02:00.0: trying fw api 5
[ 2217.844679] ath10k_pci 0000:02:00.0: found fw version WLAN.RM.1.1-00141
[ 2217.844681] ath10k_pci 0000:02:00.0: found fw timestamp 1439305604
[ 2217.844683] ath10k_pci 0000:02:00.0: found otp image ie (29533 B)
[ 2217.844684] ath10k_pci 0000:02:00.0: found fw image ie (469603 B)
[ 2217.844686] ath10k_pci 0000:02:00.0: found firmware features ie (2 B)
[ 2217.844687] ath10k_pci 0000:02:00.0: Enabling feature bit: 7
[ 2217.844688] ath10k_pci 0000:02:00.0: Enabling feature bit: 8
[ 2217.844690] ath10k_pci 0000:02:00.0: features
[ 2217.844692] ath10k_pci 0000:02:00.0: 00000000: 80 01 00 00 00 00 00 00                          ........
[ 2217.844693] ath10k_pci 0000:02:00.0: found fw ie wmi op version 4
[ 2217.844695] ath10k_pci 0000:02:00.0: using fw api 5
[ 2217.844697] ath10k_pci 0000:02:00.0: bmi start
[ 2217.844699] ath10k_pci 0000:02:00.0: bmi write address 0x400800 length 4
[ 2217.844707] ath10k_pci 0000:02:00.0: bmi read address 0x400810 length 4
[ 2217.844792] ath10k_pci 0000:02:00.0: bmi write address 0x400810 length 4
[ 2217.844799] ath10k_pci 0000:02:00.0: bmi write address 0x400844 length 4
[ 2217.844849] ath10k_pci 0000:02:00.0: bmi write address 0x400904 length 4
[ 2217.844892] This the patched kernel -Anish
[ 2217.844894] ath10k_pci 0000:02:00.0: bmi write address 0x4008bc length 4
[ 2217.844936] ath10k_pci 0000:02:00.0: boot did not find a calibration file, try DT next: -11
[ 2217.844937] ath10k_pci 0000:02:00.0: boot did not find DT entry, try OTP next: -2
[ 2217.844939] ath10k_pci 0000:02:00.0: bmi read address 0x4008ac length 4
[ 2217.845017] ath10k_pci 0000:02:00.0: boot push board extended data addr 0x0
[ 2217.845019] ath10k_pci 0000:02:00.0: bmi read address 0x400854 length 4
[ 2217.845070] ath10k_pci 0000:02:00.0: bmi write address 0x401d40 length 8124
[ 2217.860880] ath10k_pci 0000:02:00.0: bmi write address 0x400858 length 4
[ 2217.861043] ath10k_pci 0000:02:00.0: boot upload otp to 0x1234 len 29533
[ 2217.861047] ath10k_pci 0000:02:00.0: bmi fast download address 0x1234 buffer 0xffffc9000147003c length 29533
[ 2217.861049] ath10k_pci 0000:02:00.0: bmi lz stream start address 0x1234
[ 2217.861084] ath10k_pci 0000:02:00.0: bmi lz data buffer 0xffffc9000147003c length 29532
[ 2217.921837] ath10k_pci 0000:02:00.0: bmi lz data buffer 0xffff880156d1fd2c length 4
[ 2217.921914] ath10k_pci 0000:02:00.0: bmi lz stream start address 0x0
[ 2217.921959] ath10k_pci 0000:02:00.0: bmi execute address 0x1234 param 0x0
[ 2217.923520] ath10k_pci 0000:02:00.0: bmi execute result 0x3
[ 2217.923524] ath10k_pci 0000:02:00.0: boot otp execute result 3
[ 2217.923527] ath10k_pci 0000:02:00.0: boot using calibration mode otp
[ 2217.923531] ath10k_pci 0000:02:00.0: boot uploading firmware image ffffc900014773a4 len 469603 mode normal
[ 2217.923534] ath10k_pci 0000:02:00.0: bmi fast download address 0x1234 buffer 0xffffc900014773a4 length 469603
[ 2217.923537] ath10k_pci 0000:02:00.0: bmi lz stream start address 0x1234
[ 2217.923547] ath10k_pci 0000:02:00.0: bmi lz data buffer 0xffffc900014773a4 length 469600
[ 2218.992790] ath10k_pci 0000:02:00.0: bmi lz data buffer 0xffff880156d1fd2c length 4
[ 2218.993071] ath10k_pci 0000:02:00.0: bmi lz stream start address 0x0
[ 2218.993116] ath10k_pci 0000:02:00.0: bmi write address 0x400814 length 4
[ 2218.993150] ath10k_pci 0000:02:00.0: pci hif set callbacks
[ 2218.993153] ath10k_pci 0000:02:00.0: pci hif get default pipe
[ 2218.993155] ath10k_pci 0000:02:00.0: pci hif map service
[ 2218.993158] ath10k_pci 0000:02:00.0: bmi done
[ 2218.993193] ath10k_pci 0000:02:00.0: htt tx max num pending tx 1056
[ 2218.993212] ath10k_pci 0000:02:00.0: htt rx ring size 2048 fill_level 1023
[ 2218.993214] ath10k_pci 0000:02:00.0: boot hif start
[ 2218.993232] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt
[ 2218.993750] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt
[ 2219.992233] ath10k_pci 0000:02:00.0: failed to receive control response completion, polling..
[ 2219.992242] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992271] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992280] ath10k_pci 0000:02:00.0: pci rx ce pipe 1 len 20
[ 2219.992286] ath10k_pci 0000:02:00.0: pci rx: 00000000: 00 00 0c 00 00 00 00 00 01 00 02 00 00 07 16 00  ................
[ 2219.992291] ath10k_pci 0000:02:00.0: pci rx: 00000010: 01 00 00 00                                      ....
[ 2219.992301] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992307] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992313] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992319] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992323] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992327] ath10k_pci 0000:02:00.0: pci hif send complete check
[ 2219.992335] ath10k_pci 0000:02:00.0: Target ready! transmit resources: 2 size:1792
[ 2219.992339] ath10k_pci 0000:02:00.0: pci hif map service
[ 2219.992344] ath10k_pci 0000:02:00.0: boot htc service 'Control' ul pipe 0 dl pipe 1 eid 0 ready
[ 2219.992348] ath10k_pci 0000:02:00.0: boot htc ep 0 ul polled 0 dl polled 0
[ 2219.992352] ath10k_pci 0000:02:00.0: boot htc service 'Control' eid 0 TX flow control disabled
[ 2219.992357] ath10k_pci 0000:02:00.0: boot htc service HTT Data does not allocate target credits
[ 2219.992363] ath10k_pci 0000:02:00.0: ath10k_htc_build_tx_ctrl_skb: skb ffff88009738d900
[ 2219.992369] ath10k_pci 0000:02:00.0: pci tx item 0 paddr 0x9ae95800 len 16 n_items 1
[ 2219.992374] ath10k_pci 0000:02:00.0: pci tx data: 00000000: 00 01 08 00 74 00 0c 00 02 00 00 03 08 00 00 00  ....t...........
[ 2219.992401] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt
[ 2219.992431] ath10k_pci 0000:02:00.0: received unsolicited fw crash interrupt
[ 2220.993005] ath10k_pci 0000:02:00.0: Service connect timeout
[ 2220.993017] ath10k_pci 0000:02:00.0: failed to connect htt (-110)
[ 2220.993023] ath10k_pci 0000:02:00.0: boot hif stop
[ 2220.993028] ath10k_pci 0000:02:00.0: boot warm reset
[ 2221.025082] ath10k_pci 0000:02:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800977d4000
[ 2221.025103] ath10k_pci 0000:02:00.0: boot ce dest ring id 1 entries 512 base_addr ffff88002a03e000
[ 2221.025119] ath10k_pci 0000:02:00.0: boot ce dest ring id 2 entries 128 base_addr ffff880097110000
[ 2221.025137] ath10k_pci 0000:02:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800972a4000
[ 2221.025159] ath10k_pci 0000:02:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff880061030000
[ 2221.025177] ath10k_pci 0000:02:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880061246000
[ 2221.025191] ath10k_pci 0000:02:00.0: boot ce dest ring id 7 entries 2 base_addr ffff880061247000
[ 2221.025195] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2221.025200] ath10k_pci 0000:02:00.0: boot target indicator 0
[ 2221.035130] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2221.035137] ath10k_pci 0000:02:00.0: boot target initialised
[ 2221.049108] ath10k_pci 0000:02:00.0: boot init ce src ring id 0 entries 16 base_addr ffff8800977d4000
[ 2221.049133] ath10k_pci 0000:02:00.0: boot ce dest ring id 1 entries 512 base_addr ffff88002a03e000
[ 2221.049152] ath10k_pci 0000:02:00.0: boot ce dest ring id 2 entries 128 base_addr ffff880097110000
[ 2221.049173] ath10k_pci 0000:02:00.0: boot init ce src ring id 3 entries 32 base_addr ffff8800972a4000
[ 2221.049199] ath10k_pci 0000:02:00.0: boot init ce src ring id 4 entries 4096 base_addr ffff880061030000
[ 2221.049220] ath10k_pci 0000:02:00.0: boot init ce src ring id 7 entries 2 base_addr ffff880061246000
[ 2221.049237] ath10k_pci 0000:02:00.0: boot ce dest ring id 7 entries 2 base_addr ffff880061247000
[ 2221.049241] ath10k_pci 0000:02:00.0: boot waiting target to initialise
[ 2221.049247] ath10k_pci 0000:02:00.0: boot target indicator 0
[ 2221.059178] ath10k_pci 0000:02:00.0: boot target indicator 0
[ 2221.069108] ath10k_pci 0000:02:00.0: boot target indicator 2
[ 2221.069114] ath10k_pci 0000:02:00.0: boot target initialised
[ 2221.069116] ath10k_pci 0000:02:00.0: boot warm reset complete
[ 2221.069185] ath10k_pci 0000:02:00.0: ath10k_htc_notify_tx_completion: ep 0 skb ffff88009738d900
[ 2221.069522] ath10k_pci 0000:02:00.0: could not init core (-110)
[ 2221.069555] ath10k_pci 0000:02:00.0: boot hif power down
[ 2221.069556] ath10k_pci 0000:02:00.0: could not probe fw (-110)

It's quite possible that I did not follow all steps correctly

	Arnd
