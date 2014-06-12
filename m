Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:54279 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaFLToi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 15:44:38 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so1060904wes.23
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 12:44:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFAGBW2ckNFLb17WV-QZ=up2KHOQYjhCvd2jh94Rf28LEuMhnA@mail.gmail.com>
References: <CAFAGBW2ckNFLb17WV-QZ=up2KHOQYjhCvd2jh94Rf28LEuMhnA@mail.gmail.com>
Date: Thu, 12 Jun 2014 12:44:36 -0700
Message-ID: <CAFAGBW2HyLsy5kS_rwZXdNCoXxww5fjrd0=zdpVWHHFGduR+2Q@mail.gmail.com> (sfid-20140612_214442_329387_3E4853A6)
Subject: Fwd: Coaxing Meditek MT7601U drivers to build in 3.14
From: Corey Mcguire <corey@typeamachines.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preface: I am trying to build out-of-tree kernel drivers with newer
kernels than are intended.  I have been slowly patching the drivers to
work and this may be a help to this list or may benefit from help of
the list.

Hello everyone.

I am new to kernel hacking (though I've been building kernels for a
decade) so please bear with me if my kernel list netiquette-fu is
poor, I'll try to be a quick learner. ;-)  Please let me know if I
excluded anything or if I am barking up the wrong tree.

I am massaging kernels for the Beaglebone Black (arm-linux-gnueabihf-)
using the fine work of RCN and his
https://github.com/RobertCNelson/linux-dev repo.

We use the BBB in our Network Attached 3D printers
(http://www.typeamachines.com/) and we are happily running 3.12 on our
production machines, but it's time to move forward.

3.14 fixes some very critical bugs for the BBB, particularly a USB
babble bug.  I'd really like to put that bug behind us.

The wireless component of our printer is the UWN200 (MT7601U) from Logic Supply.
http://www.logicsupply.com/components/networking/wireless/uwn200/

This adapter is awesome and we are quite happy with it.  The only
caveat is, the out-of-tree kernel drivers
(http://www.mediatek.com/en/downloads/mt7601u-usb/ 3.0.0.3 or 3.0.0.4)
are a big mess.  Both drivers, from the original source, fail to build
on kernels beyond 3.12.2.  A combination of fixes from the following
links have gotten the drivers to build against later kernels:

http://www.ubuntu-kr.org/viewtopic.php?p=118503
http://ubuntuforums.org/showthread.php?t=2218061&page=3
https://aur.archlinux.org/packages/dkms-mt7601u/?setlang=ru

Here are the patches:

3.0.0.4
https://drive.google.com/file/d/0B6ysY_fJn-vRZlBQUWIwMktiM2s/edit?usp=sharing
3.0.0.3
https://drive.google.com/file/d/0B6ysY_fJn-vReUtjQzlXbDVuQWc/edit?usp=sharing

With these fixes:

3.0.0.3 version of the driver builds against and works well on kernels
up to 3.12.13 (3.12.13-bone12)
3.0.0.3 version of the driver FAILS to build against kernels after
3.13 (3.13-rc6-bone1)
3.0.0.4 version of the driver builds against and works well on all
kernels up to 3.13.9 (3.13.10-bone9)
3.0.0.4 version of the driver builds against and works POORLY (slow
performance) on all kernels after 3.14 (3.14-rc1-bone0)
3.0.0.4 segfaults on all version of kernels during certain operations

3.0.0.3 is more stable, 3.0.0.4 is a big improvement as far as ease of
building, but the segfaults are a big issue.

Below are relevant files:

Kernels with modules, dtbs's, firmware, configs, and MT7601U driver
version as described in the filename:

3.12.13-bone12-and-MT7601U-3.0.0.3.tar.bz2 -
https://drive.google.com/file/d/0B6ysY_fJn-vRZGFoVmZZRUEzejg/edit?usp=sharing
3.14.2-bone2-and-MT7601U-3.0.0.4.tar.bz2 -
https://drive.google.com/file/d/0B6ysY_fJn-vRVzAtTUJlSFZ6RFU/edit?usp=sharing

Ubuntu filesytems (8GB) based on
http://elinux.org/Beagleboard:Ubuntu_On_BeagleBone_Black#Main_Process
with the packages from above put in place, ready to boot on a BBB with
an SD card of 8GB or bigger (4GB or bigger would work, the last
filesystem is empty and it doesn't matter if it gets truncated)

3.12.13-bone12-and-MT7601U-3.0.0.3-and-ubuntu-13.04.image.bz2 -
https://drive.google.com/file/d/0B6ysY_fJn-vRRHg5S3VrVUhKMG8/edit?usp=sharing
3.14.2-bone2-and-MT7601U-3.0.0.4-and-ubuntu-13.04.image.bz2 -
https://drive.google.com/file/d/0B6ysY_fJn-vRQmx4SjJtSGJwYmc/edit?usp=sharing

Execute "bzcat <filename> | sudo dd of=/dev/sd? bs=4M" to extract to SD card.


How I build :

Download https://drive.google.com/file/d/0B6ysY_fJn-vRSklIOXlkNmdXaTg/edit?usp=sharing
 to /usr/src/files/linux-dev-system-sh.patch
Download https://drive.google.com/file/d/0B6ysY_fJn-vRZlBQUWIwMktiM2s/edit?usp=sharing
to /usr/src/files/3.0.0.4.patch
Download https://drive.google.com/file/d/0B6ysY_fJn-vReUtjQzlXbDVuQWc/edit?usp=sharing
to /usr/src/files/3.0.0.3.patch
Download
https://googledrive.com/host/0B_JlgOR4VNe0Sjg4ei0ySEY4aUE/DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS.tar.bz2
to /usr/src/files/
Download http://www.mediatek.com/en/downloads/mt7610u-usb/ to
/usr/src/files/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2

root@gruumsh:~# cd /usr/src
root@gruumsh:/usr/src# git clone
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
root@gruumsh:/usr/src# git clone https://github.com/RobertCNelson/linux-dev.git
root@gruumsh:/usr/src# cd linux-dev
root@gruumsh:/usr/src/linux-dev# git checkout 3.12.13-bone12
root@gruumsh:/usr/src/linux-
dev# cp system.sh.sample system.sh
root@gruumsh:/usr/src/linux-dev# patch system.sh <
/usr/src/files/linux-dev-system-sh.patch
root@gruumsh:/usr/src/linux-dev# ./build_kernel.sh
root@gruumsh:/usr/src/linux-dev# cd ..
root@gruumsh:/usr/src# mkdir -p deploy/boot/dtbs
root@gruumsh:/usr/src# cd deploy
root@gruumsh:/usr/src/deploy# tar -xzf
/usr/src/linux-dev/deploy/3.12.13-bone12-modules.tar.gz
root@gruumsh:/usr/src/deploy# cd boot/dtbs
root@gruumsh:/usr/src/deploy/boot/dtbs# tar -xzf
/usr/src/linux-dev/deploy/3.12.13-bone12-dtbs.tar.gz
root@gruumsh:/usr/src/deploy/boot/dtbs# cd ..
root@gruumsh:/usr/src/deploy/boot# cp
/usr/src/linux-dev/deploy/3.12.13-bone12.zImage .
root@gruumsh:/usr/src/deploy/boot# ln -s 3.12.13-bone12.zImage zImage
root@gruumsh:/usr/src/deploy/boot# cd ../lib/firmware
root@gruumsh:/usr/src/deploy/lib/firmware# tar -xzf
/usr/src/linux-dev/deploy/3.12.13-bone12-firmware.tar.gz
root@gruumsh:/usr/src/deploy/lib/firmware# cd /usr/src

for 3.0.0.3 driver

root@gruumsh:/usr/src# tar -xjf
files/DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS.tar.bz2
root@gruumsh:/usr/src# cd DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS/
root@gruumsh:/usr/src/DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS# patch
-p1 < ../files/3.0.0.3.patch
root@gruumsh:/usr/src/DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS#
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make all -j7
root@gruumsh:/usr/src/DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS# find
-iname \*ko -exec cp {} ../deploy/lib/modules/3.12.13-bone12/. \;
root@gruumsh:/usr/src/DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS# mkdir
-p ../deploy/etc/wireless/RT2870STA/
root@gruumsh:/usr/src/DPA_MT7601U_LinuxSTA_3.0.0.3_20130717_LS# find
-iname \*DAT -exec cp {} ../deploy/etc/wireless/RT2870STA/. \;

for 3.0.0.4 driver

root@gruumsh:/usr/src# tar -xJf
files/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.xz
root@gruumsh:/usr/src# cd DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/
root@gruumsh:/usr/src/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913# patch -p1
< ../files/3.0.0.4.patch
root@gruumsh:/usr/src/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913# ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- make all -j7
root@gruumsh:/usr/src/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913# find
-iname \*ko -exec cp {} ../deploy/lib/modules/3.12.13-bone12/. \;
root@gruumsh:/usr/src/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913# mkdir -p
../deploy/etc/wireless/RT2870STA/
root@gruumsh:/usr/src/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913# find
-iname \*DAT -exec cp {} ../deploy/etc/wireless/RT2870STA/. \;


Here are the segfaults from MT7601U 3.0.0.4 drivers across multiple
kernels.  Versions include Kernel 3.12.2-bone9 (last to require no
fixes), Kernel 3.12.3-bone9 (first to require patches), and Kernel
3.14.2-bone2 (the one we want) :

Kernel 3.12.2-bone9

Will now halt
[ 125.919278] -----------[ cut here ]-----------
[ 125.924175] kernel BUG at net/core/dev.c:5280!
[ 125.928862] Internal error: Oops - BUG: 0 1 SMP ARM
[ 125.934280] Modules linked in: usb_f_acm u_serial g_multi
libcomposite u_rndis u_ether snd_soc_omap snd_pcm_dmaengine
snd_soc_core regmap_spi snd_compress snd_pcm snd_timer snd soundcore
snd_page_alloc mt7601Usta(O)
[ 125.954602] CPU: 0 PID: 968 Comm: halt Tainted: G O 3.12.2-bone9 #1
[ 125.962128] task: ddf40400 ti: dde94000 task.ti: dde94000
[ 125.967840] PC is at rollback_registered_many+0xa4/0x204
[ 125.973443] LR is at rollback_registered_many+0x20/0x204
[ 125.979046] pc : [<c04d77a4>] lr : [<c04d7720>] psr: 20000013
[ 125.979046] sp : dde95cd8 ip : c0db4a28 fp : 00000000
[ 125.991147] : df39f244 : 00200200 : 00100100
[ 125.996656] : 00000001 : dde95cb8 : dde95cf8 : ddbe9000
[ 126.003533] : 00000003 : dde95cf8 : 00000000 : 00000001
[ 126.010414] Flags: nzCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment user
[ 126.017937] Control: 10c5387d Table: 9b030019 DAC: 00000015
[ 126.023994] Process halt (pid: 968, stack limit = 0xdde94248)
[ 126.030052] Stack: (0xdde95cd8 to 0xdde96000)
[ 126.034649] 5cc0: ddbe9040 ddbe9000
[ 126.043276] 5ce0: 00000000 c08dfdb8 df7e5800 bf0716b4 00000000
c04d7928 ddbe9040 ddbe9040
[ 126.051906] 5d00: dde95d10 c04d9bac ddf40400 ddbe9000 e0f4f000
c04d9c04 ddbe9000 bf04494c
[ 126.060534] 5d20: 00000000 bf053300 dde95d34 00000000 df7e5800
ddbe9000 df7eb420 df7eb420
[ 126.069161] 5d40: df7e5800 df7eb400 00000000 c04069b4 c0406954
df7eb420 bf0716b4 c08f1a80
[ 126.077791] 5d60: df39f000 df7eb400 00000000 c0388460 ddf40400
df7eb454 df7eb420 c03884c4
[ 126.086418] 5d80: df7eb444 df7eb420 df231c3c c0387ea8 df7eb420
00000000 df7e5868 c0385a08
[ 126.095046] 5da0: df7e5800 00000000 00000000 c0404b00 00000000
df7e5800 df7e589c 00000000
[ 126.103672] 5dc0: df7e5868 df7dfa00 00000000 c03fc8b8 df7ee440
df460000 df46009c 00000001
[ 126.112299] 5de0: df460068 df3a4600 df7f1000 c03fc8a4 df3bae40
df3a6c00 df3a6c9c 00000000
[ 126.120928] 5e00: df3a6c68 dde95e34 df3a4800 c03fc8a4 ddf40400
df39f000 df39f0c4 df39f074
[ 126.129554] 5e20: c097cf48 c090911c c097cf48 c0400ce0 df39f000
df3a6c00 df3ae010 0000118c
[ 126.138181] 5e40: df39f410 c041ceec c04186d8 df3ae010 df39f210
c04186fc c04186d8 df39f21c
[ 126.146808] 5e60: df39f210 c0386ca4 cdef0123 00000000 c08d1ab8
00000003 fee1dead dde94000
[ 126.155433] 5e80: 00000000 c0056a40 cdef0123 c0056c18 de803964
00000001 00000101 00000000
[ 126.164059] 5ea0: dde95f04 c00b33d8 dda15740 de803968 dde95f54
00000000 00000000 c0db1e80
[ 126.172685] 5ec0: dde95ed4 dde95f08 00000000 de8038c8 de803964
000748ff 00000000 de803964
[ 126.181309] 5ee0: 00000000 c00bc9a4 00000020 00000000 00000000
c00b2dd0 0000000e c02d806c
[ 126.189936] 5f00: 00000000 00000000 00000000 00000000 dde95f10
dde95f10 dde95f18 dde95f18
[ 126.198561] 5f20: 00000000 00000000 00000000 c00b41a0 7fffffff
00000000 00000000 00000000
[ 126.207190] 5f40: ffffffff 7fffffff 00000001 de803870 de803870
de8038c8 c089a300 240a2409
[ 126.215818] 5f60: df01a86c df01a7a8 de803870 c05c2e9c 00000000
de803870 de8038c8 c0101b68
[ 126.224445] 5f80: df01a86c 00000000 00000000 bec37e44 00000002
00000000 bec37e44 00000058
[ 126.233070] 5fa0: c000db64 c000d9e0 00000002 00000000 fee1dead
28121969 4321fedc 00000003
[ 126.241696] 5fc0: 00000002 00000000 bec37e44 00000058 00000000
00000000 b6f27f3c 00000000
[ 126.250318] 5fe0: 00000058 bec37cb4 b6e88f0d b6e13276 20000030
fee1dead 14141414 14141414
[ 126.258963] [<c04d77a4>] (rollback_registered_many+0xa4/0x204) from
[<c04d7928>] (rollback_registered+0x24/0x38)
[ 126.269706] [<c04d7928>] (rollback_registered+0x24/0x38) from
[<c04d9bac>] (unregister_netdevice_queue+0x68/0xa8)
[ 126.280535] [<c04d9bac>] (unregister_netdevice_queue+0x68/0xa8) from
[<c04d9c04>] (unregister_netdev+0x18/0x20)
[ 126.291575] [<c04d9c04>] (unregister_netdev+0x18/0x20) from
[<bf04494c>] (RtmpOSNetDevFree+0x20/0x2c [mt7601Usta])
[ 126.302941] [<bf04494c>] (RtmpOSNetDevFree+0x20/0x2c [mt7601Usta])
from [<bf053300>] (rtusb_disconnect+0xcc/0xf4 [mt7601Usta])
[ 126.315220] [<bf053300>] (rtusb_disconnect+0xcc/0xf4 [mt7601Usta])
from [<c04069b4>] (usb_unbind_interface+0x60/0x160)
[ 126.326549] [<c04069b4>] (usb_unbind_interface+0x60/0x160) from
[<c0388460>] (__device_release_driver+0x7c/0xc4)
[ 126.337286] [<c0388460>] (__device_release_driver+0x7c/0xc4) from
[<c03884c4>] (device_release_driver+0x1c/0x28)
[ 126.348020] [<c03884c4>] (device_release_driver+0x1c/0x28) from
[<c0387ea8>] (bus_remove_device+0xdc/0xec)
[ 126.358216] [<c0387ea8>] (bus_remove_device+0xdc/0xec) from
[<c0385a08>] (device_del+0x108/0x16c)
[ 126.367592] [<c0385a08>] (device_del+0x108/0x16c) from [<c0404b00>]
(usb_disable_device+0x84/0x190)
[ 126.377139] [<c0404b00>] (usb_disable_device+0x84/0x190) from
[<c03fc8b8>] (usb_disconnect+0x80/0x154)
[ 126.386960] [<c03fc8b8>] (usb_disconnect+0x80/0x154) from
[<c03fc8a4>] (usb_disconnect+0x6c/0x154)
[ 126.396410] Code: ea000003 e3530001 e5c47285 0a000000 (e7f001f2)
[ 126.402839] --[ end trace 993ab42a2e4297a7 ]--
Segmentation fault

Kernel 3.12.3-bone9

Will now halt
[ 104.361130] -----------[ cut here ]-----------
[ 104.366038] kernel BUG at net/core/dev.c:5280!
[ 104.370737] Internal error: Oops - BUG: 0 1 SMP ARM
[ 104.376170] Modules linked in: usb_f_acm u_serial g_multi
libcomposite u_rndis u_ether snd_soc_omap snd_pcm_dmaengine
snd_soc_core regmap_spi snd_compress snd_pcm snd_timer snd soundcore
snd_page_alloc mt7601Usta(O)
[ 104.396548] CPU: 0 PID: 1145 Comm: halt Tainted: G O 3.12.3-bone9 #1
[ 104.404189] task: df516e80 ti: ddcce000 task.ti: ddcce000
[ 104.409923] PC is at rollback_registered_many+0xa4/0x204
[ 104.415545] LR is at rollback_registered_many+0x20/0x204
[ 104.421166] pc : [<c04c772c>] lr : [<c04c76a8>] psr: 20000013
[ 104.421166] sp : ddccfcd8 ip : c0da2a28 fp : 00000000
[ 104.433300] : df3a1a44 : 00200200 : 00100100
[ 104.438825] : 00000001 : ddccfcb8 : ddccfcf8 : ddd34000
[ 104.445725] : 00000003 : ddccfcf8 : 00000000 : 00000001
[ 104.452627] Flags: nzCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment user
[ 104.460171] Control: 10c5387d Table: 9f4cc019 DAC: 00000015
[ 104.466245] Process halt (pid: 1145, stack limit = 0xddcce248)
[ 104.472412] Stack: (0xddccfcd8 to 0xddcd0000)
[ 104.477021] fcc0: ddd34040 ddd34000
[ 104.485673] fce0: 00000000 c08d60c0 df7f0400 bf0716b4 00000000
c04c78b0 ddd34040 ddd34040
[ 104.494326] fd00: ddccfd10 c04c9b34 df516e80 ddd34000 e0e09000
c04c9b8c ddd34000 bf04494c
[ 104.502978] fd20: 00000000 bf053300 ddccfd34 00000000 df7f0400
ddd34000 df7a4820 df7a4820
[ 104.511630] fd40: df7f0400 df7a4800 00000000 c03f5eec c03f5e8c
df7a4820 bf0716b4 c08e7db0
[ 104.520282] fd60: df3a1800 df7a4800 00000000 c0377974 df516e80
df7a4854 df7a4820 c03779d8
[ 104.528935] fd80: df7a4844 df7a4820 df231c3c c03773bc df7a4820
00000000 df7f0468 c0374f00
[ 104.537586] fda0: df7f0400 00000000 00000000 c03f4038 00000000
df7f0400 df7f049c 00000000
[ 104.546238] fdc0: df7f0468 df7dec00 00000000 c03ebdf0 df7ebc80
df42e800 df42e89c 00000003
[ 104.554890] fde0: df42e868 df3a6e00 df7e3600 c03ebddc df3a3680
df391400 df39149c 00000000
[ 104.563543] fe00: df391468 ddccfe34 df3a1000 c03ebddc df516e80
df3a1800 df3a18c4 df3a1874
[ 104.572195] fe20: c096b648 c08ff91c c096b648 c03f0218 df3a1800
df391400 df3ae010 0000118c
[ 104.580848] fe40: df3a1c10 c040c424 c0407c10 df3ae010 df3a1a10
c0407c34 c0407c10 df3a1a1c
[ 104.589500] fe60: df3a1a10 c03761b8 cdef0123 00000000 c08c7ab8
00000003 fee1dead ddcce000
[ 104.598151] fe80: 00000000 c0056e30 cdef0123 c0057008 de803964
00000001 00000101 00000000
[ 104.606803] fea0: ddccff04 c00b4824 dd8f6c80 de803968 ddccff54
00000000 00000000 c0d9fe80
[ 104.615455] fec0: ddccfed4 ddccff08 00000000 de8038c8 de803964
000748ff 00000000 de803964
[ 104.624107] fee0: 00000000 c00bddf0 00000020 00000000 00000000
c00b421c 0000000e c02c64c8
[ 104.632758] ff00: 00000000 00000000 00000000 00000000 ddccff10
ddccff10 ddccff18 ddccff18
[ 104.641408] ff20: 00000000 00000000 00000000 c00b55ec 7fffffff
00000000 00000000 00000000
[ 104.650061] ff40: ffffffff 7fffffff 00000001 de803870 de803870
de8038c8 c0890300 25ca25c9
[ 104.658713] ff60: df01a86c df01a7a8 de803870 c05ba4bc 00000000
de803870 de8038c8 c0103208
[ 104.667364] ff80: df01a86c 00000000 00000000 be9b5e44 00000002
00000000 be9b5e44 00000058
[ 104.676016] ffa0: c000db64 c000d9e0 00000002 00000000 fee1dead
28121969 4321fedc 00000003
[ 104.684667] ffc0: 00000002 00000000 be9b5e44 00000058 00000000
00000000 b6f8ef3c 00000000
[ 104.693319] ffe0: 00000058 be9b5cb4 b6eeff0d b6e7a276 20000030
fee1dead 00000000 00000000
[ 104.701992] [<c04c772c>] (rollback_registered_many+0xa4/0x204) from
[<c04c78b0>] (rollback_registered+0x24/0x38)
[ 104.712766] [<c04c78b0>] (rollback_registered+0x24/0x38) from
[<c04c9b34>] (unregister_netdevice_queue+0x68/0xa8)
[ 104.723626] [<c04c9b34>] (unregister_netdevice_queue+0x68/0xa8) from
[<c04c9b8c>] (unregister_netdev+0x18/0x20)
[ 104.734693] [<c04c9b8c>] (unregister_netdev+0x18/0x20) from
[<bf04494c>] (RtmpOSNetDevFree+0x20/0x2c [mt7601Usta])
[ 104.745979] [<bf04494c>] (RtmpOSNetDevFree+0x20/0x2c [mt7601Usta])
from [<bf053300>] (rtusb_disconnect+0xcc/0xf4 [mt7601Usta])
[ 104.758261] [<bf053300>] (rtusb_disconnect+0xcc/0xf4 [mt7601Usta])
from [<c03f5eec>] (usb_unbind_interface+0x60/0x160)
[ 104.769594] [<c03f5eec>] (usb_unbind_interface+0x60/0x160) from
[<c0377974>] (__device_release_driver+0x7c/0xc4)
[ 104.780364] [<c0377974>] (__device_release_driver+0x7c/0xc4) from
[<c03779d8>] (device_release_driver+0x1c/0x28)
[ 104.791132] [<c03779d8>] (device_release_driver+0x1c/0x28) from
[<c03773bc>] (bus_remove_device+0xdc/0xec)
[ 104.801349] [<c03773bc>] (bus_remove_device+0xdc/0xec) from
[<c0374f00>] (device_del+0x108/0x16c)
[ 104.810741] [<c0374f00>] (device_del+0x108/0x16c) from [<c03f4038>]
(usb_disable_device+0x84/0x190)
[ 104.820329] [<c03f4038>] (usb_disable_device+0x84/0x190) from
[<c03ebdf0>] (usb_disconnect+0x80/0x154)
[ 104.830182] [<c03ebdf0>] (usb_disconnect+0x80/0x154) from
[<c03ebddc>] (usb_disconnect+0x6c/0x154)
[ 104.839664] Code: ea000003 e3530001 e5c47285 0a000000 (e7f001f2)
[ 104.846114] --[ end trace ef9da05fb331bb68 ]--
Segmentation fault

Kernel 3.14.2-bone2

Will now halt
[ 501.272538] -----------[ cut here ]-----------
[ 501.277404] kernel BUG at net/core/dev.c:5556!
[ 501.282065] Internal error: Oops - BUG: 0 1 SMP ARM
[ 501.287454] Modules linked in: mt7601Usta(O) usb_f_acm u_serial
usb_f_ecm g_multi usb_f_mass_storage usb_f_rndis libcomposite u_ether
ti_am335x_adc kfifo_o
[ 501.307891] CPU: 0 PID: 1299 Comm: halt Tainted: G O 3.14.2-bone2 #1
[ 501.315470] task: dc1e8640 ti: dc2c6000 task.ti: dc2c6000
[ 501.321144] PC is at rollback_registered_many+0xb0/0x270
[ 501.326714] LR is at rollback_registered_many+0x2c/0x270
[ 501.332287] pc : [<c05e38a8>] lr : [<c05e3824>] psr: 20000013
[ 501.332287] sp : dc2c7cc0 ip : 00008040 fp : 00000000
[ 501.344329] : de3adc44 : 00200200 : 00100100
[ 501.349808] : 00000001 : dc2c7ca8 : dc2c7ce8 : dc459000
[ 501.356652] : 00000003 : dc2c7ce8 : 00000000 : 00000001
[ 501.363499] Flags: nzCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment user
[ 501.370983] Control: 10c5387d Table: 9e63c019 DAC: 00000015
[ 501.377009] Process halt (pid: 1299, stack limit = 0xdc2c6248)
[ 501.383126] Stack: (0xdc2c7cc0 to 0xdc2c8000)
[ 501.387699] 7cc0: dc2c7cc0 dc2c7cc0 dc2c7ce8 dc459000 00000000
c0ad6b68 de57a000 bf0fa850
[ 501.396279] 7ce0: 00000000 c05e3a8c dc459040 dc459040 dc2c7d00
c05e5c04 dc1e8640 dc459000
[ 501.404861] 7d00: e0dad000 c05e5c5c dc459000 bf0ce000 00000000
bf0dc898 dc2c7d24 00000000
[ 501.413441] 7d20: de57a000 dc459000 de5f8a20 de5f8a20 de57a000
de5f8a00 00000000 c04fff48
[ 501.422023] 7d40: c04ffee8 de5f8a20 bf0fa850 c0aedd70 de48ac00
de5f8a00 00000000 c046da7c
[ 501.430604] 7d60: dc1e8640 de5f8a54 de5f8a20 c046dae0 de5f8a44
de5f8a20 de15d430 c046d584
[ 501.439185] 7d80: de5f8a20 00000000 de57a068 c046b19c de57a000
00000000 00000000 c04fdf3c
[ 501.447765] 7da0: 00000000 de57a000 de57a09c 00000000 de57a068
de504600 00000000 c04f57f8
[ 501.456346] 7dc0: de523b40 de4b1000 de4b109c 00000002 de4b1068
de48d600 de4ce000 c04f57e4
[ 501.464927] 7de0: de48c9c0 de47a400 de47a49c 00000000 de47a468
dc2c7e24 de48d400 c04f57e4
[ 501.473508] 7e00: dc1e8640 de48ac00 de48acc4 de48ac74 c0bf2424
c0b15320 c0bf2424 c04f9c38
[ 501.482088] 7e20: de48ac00 de47a400 de01e010 00001204 de3ada10
c0514dec c0510178 de01e010
[ 501.490670] 7e40: de3adc10 c051019c c0510178 de3adc1c de3adc10
c046c41c cdef0123 00000000
[ 501.499251] 7e60: c0ab77a8 c0a824c8 00000003 fee1dead 00000000
c005cfe8 cdef0123 c005d240
[ 501.507832] 7e80: 00000101 00000000 00000000 0000000e dd80376c
00000001 00000101 00000000
[ 501.516412] 7ea0: dc2c7f04 c00e7b80 00015200 dd803770 00000000
00000000 00000000 c0a89700
[ 501.524994] 7ec0: dc2c7ec0 dc2c7f08 00000000 c0a7c300 dd80376c
000748ff 00000000 dd80376c
[ 501.533574] 7ee0: 00000000 c00f27dc 00000020 00000000 00000000
c00e7580 0000000e c00f01ec
[ 501.542155] 7f00: c0abf7d8 00000000 00000000 00000000 dc2c7f10
dc2c7f10 dc2c7f18 dc2c7f18
[ 501.550735] 7f20: c0abf7d8 00000000 00000000 c00e8928 7fffffff
00000000 00000000 00000000
[ 501.559317] 7f40: ffffffff 7fffffff 00000001 dd803690 dd803690
c0a7c300 c0a83444 c015286c
[ 501.567898] 7f60: 00000000 c00e7654 748fffff 00000000 00000000
dd803690 dd8036e8 c014150c
[ 501.576478] 7f80: c0a7c300 bd94362c 00000000 00000002 00000000
beaf3e44 00000058 c000dae4
[ 501.585058] 7fa0: dc2c6000 c000d960 00000002 00000000 fee1dead
28121969 4321fedc 00000003
[ 501.593639] 7fc0: 00000002 00000000 beaf3e44 00000058 00000000
00000000 b6f6af3c 00000000
[ 501.602219] 7fe0: 00000058 beaf3cb4 b6ecbf0d b6e56276 20000030
fee1dead 00000000 00000000
[ 501.610814] [<c05e38a8>] (rollback_registered_many) from
[<c05e3a8c>] (rollback_registered+0x24/0x38)
[ 501.620494] [<c05e3a8c>] (rollback_registered) from [<c05e5c04>]
(unregister_netdevice_queue+0x68/0xa8)
[ 501.630352] [<c05e5c04>] (unregister_netdevice_queue) from
[<c05e5c5c>] (unregister_netdev+0x18/0x20)
[ 501.640317] [<c05e5c5c>] (unregister_netdev) from [<bf0ce000>]
(RtmpOSNetDevFree+0x20/0x2c [mt7601Usta])
[ 501.650532] [<bf0ce000>] (RtmpOSNetDevFree [mt7601Usta]) from
[<bf0dc898>] (rtusb_disconnect+0xcc/0xf4 [mt7601Usta])
[ 501.661703] [<bf0dc898>] (rtusb_disconnect [mt7601Usta]) from
[<c04fff48>] (usb_unbind_interface+0x60/0x160)
[ 501.672026] [<c04fff48>] (usb_unbind_interface) from [<c046da7c>]
(__device_release_driver+0x7c/0xc4)
[ 501.681704] [<c046da7c>] (__device_release_driver) from [<c046dae0>]
(device_release_driver+0x1c/0x28)
[ 501.691471] [<c046dae0>] (device_release_driver) from [<c046d584>]
(bus_remove_device+0xdc/0xec)
[ 501.700691] [<c046d584>] (bus_remove_device) from [<c046b19c>]
(device_del+0x108/0x16c)
[ 501.709100] [<c046b19c>] (device_del) from [<c04fdf3c>]
(usb_disable_device+0x84/0x1a8)
[ 501.717502] [<c04fdf3c>] (usb_disable_device) from [<c04f57f8>]
(usb_disconnect+0x80/0x170)
[ 501.726268] [<c04f57f8>] (usb_disconnect) from [<c04f57e4>]
(usb_disconnect+0x6c/0x170)
[ 501.734668] Code: ea000003 e3530001 e5c47279 0a000000 (e7f001f2)
[ 501.741064] --[ end trace 4bd205cc7f74b30b ]--
Segmentation fault
