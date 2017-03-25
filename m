Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33903 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751474AbdCYSVM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Mar 2017 14:21:12 -0400
Received: by mail-wm0-f65.google.com with SMTP id u132so3762136wmg.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Mar 2017 11:21:05 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: ath10k@lists.infradead.org,
        ath10k-devel <ath10k-devel@qca.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "linux-wireless (linux-wireless@vger.kernel.org)"
        <linux-wireless@vger.kernel.org>, hannu.nyman@iki.fi,
        Adrian Chadd <adrian@freebsd.org>,
        "K.Mani" <sailormani@gmail.com>
Subject: Re: QCA9984 bmi identification failure
Date: Sat, 25 Mar 2017 19:21:02 +0100
Message-ID: <1843566.sGKvOoxMzK@debian64> (sfid-20170325_192126_821442_BDC7F6D6)
In-Reply-To: <20d2aa5c-c0a6-f14b-9694-4e4384299d25@dd-wrt.com>
References: <3243718.FYinmXYgr7@debian64> <3143301.IOZImBPhRt@debian64> <20d2aa5c-c0a6-f14b-9694-4e4384299d25@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart135502668.1dcBANbLSa"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart135502668.1dcBANbLSa
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

On Saturday, March 25, 2017 8:24:59 AM CET Sebastian Gottschall wrote:
> Am 24.03.2017 um 16:01 schrieb Christian Lamparter:
> > On Friday, March 24, 2017 11:09:03 AM CET Sebastian Gottschall wrote:
> >> i have a r7800 running. consider to use the board.bin file which is
> >> stored in flash memory of the r7800.
> > Well, this is a bit beside the point. But what makes you think that
> > what is stored in the flash memory of R7800 is the "board.bin"?
> i dont know how to answer this question without getting rude.=20
> i'm developing dd-wrt which is a alternate firmware like lede/openwrt for=
=20
> many hundrets of different routers.this is my job since more than 10 year=
s.
> [...]

Well. What you're posting to the ML, is entirely your own decision.
But let's focus again on:

> > On Friday, March 24, 2017 11:09:03 AM CET Sebastian Gottschall wrote:
> > i have a r7800 running. consider to use the board.bin file which is=20
> > stored in flash memory of the r7800.
> > there are 2 stored for both cards. you need to patch ath10k to use=20
> > different board.bin files for each card.
> > this is a log from a working r7800 running dd-wrt. the failed to fetch=
=20
> > board data error is normal. it will use api1 board files then which i=20
> > provide on fs based on the board data stored in flash memory

What makes you think that what you do with the data in the flash is
the "board.bin"? Do you have any documentation to back up your statement?
I know that you have been reporting about the QCA99x0. there even
is a patch with your "reported-by" tag:=20
"ath10k: fix calibration init sequence of qca99x0".
<http://lists.infradead.org/pipermail/ath10k/2016-March/007173.html>

Clearly, you must have read it. So you know that:
"[...] whereas calibration file is used by ar9888 and qca99x0 that contains
both board data and caldata. [...]"

which is what I said in the response as well. we both knew that
(from the beginning). If you want you can go on about it:
Please do. However, you should provide some data to back up your
claims and statements (logs, links to code or patches are fine I think).
=46urthermore, let's keep the discussion civil and not go off on a
tangent and start a pissing contest. And finally, let's not forget
that the discussion is about the "QCA9984 bmi identification failure".

which seems to be also affecting your unit, since you wrote about the same=
=20
issue in your first mail:
> > On Friday, March 24, 2017 11:09:03 AM CET Sebastian Gottschall wrote:
> > you need to patch ath10k to use different board.bin files for each card.

and

> > the failed to fetch board data error is normal.=20

Why do you need to patch the ath10k driver? And why is it, that even
you have patched it, ath10k is still producing an error message? And
why is it normal(save?) to ignore it?

> > I know that Netgear provided a myriad of different board data files
> > with in there GPL drop:
> you can ignore them. use the files stored in flash memory. this board=20
> data is the calibration data which is different for each device you buy.=
=20
> its precalibrated and stored in flash memory.
If this was the case, then why does the ath10k-firmware and codeaurora.org
provide the board files in the firmware repositories?
<https://github.com/kvalo/ath10k-firmware/tree/master/QCA9984/hw1.0>
<https://source.codeaurora.org/quic/qsdk/oss/firmware/ath10k-firmware/plain=
/ath10k/QCA9984/hw1.0/>
=20
Also, why does ath10k insist on requesting the board-2.bin files, even after
it has loaded the calibration file which is supposed to contain both=20
(for the QCA9984 and others)?
Would it be easier just to request "one file" and not two different files
with the same content?=20

Note: I know that LEDE currently puts the data from the flash
into the cal-pci-0000:01:00.0.bin and creates a symlink to "board.bin".
<https://git.lede-project.org/?p=3Dsource.git;a=3Dblob;f=3Dpackage/firmware=
/ath10k-firmware/Makefile;h=3Dfebf7d26794bd8c5b34bd6703e88cf8070e213a1;hb=
=3DHEAD#l323>
I expect to see something similar in DD-WRT. If not, please tell us about y=
our
method.

> a normal wifi card has a own eeprom on it which stores this data. but on=
=20
> embedded devices the routers own flash memory is used for storing this da=
ta.
> this case is mainly ignored by drivers like ath10k, so patches are=20
> required right now until ath10k does officially support these conditions
The QCA9984 support was added by this patch back in August 2016: =20
"ath10k: enable support for QCA9984"
https://patchwork.kernel.org/patch/8890981/

At this point, I think ath10k should support the QCA9984 in the R7800
"out of the box" without any need for special or custom patches.
LEDE's compat-wireless is dated 2017-01-31.
> > Here's a link:
> > <https://github.com/paul-chambers/netgear-r7800/tree/master/git_home/ma=
dwifi-11n.git/halphy_tools/host/eepromUtil/release_qca9984/hw1>
> i know the gpl tree
> > So, does the data in your flash matches any of those files 1:1 or not?
> nope. these files are just default files shipped with the driver by qca
> > (Note: From what I know, it's the caldata that's in the flash.
> > caldata =E2=89=88 cal+board. But I'm asking why ath10k's bmi identifica=
tion
> > isn't working for those chips right now. And judging from your logs,
> > you are using probably a similar WA to the
> > 936-ath10k_skip_otp_check.patch out of necessity as well.)
> the board.bin is the caldata and configuration set for the card.
> the skip otp check patch is required in any way since the cards has no=20
> on board eeprom
> if bmi identification fails, the api 1 board-2.bin file is loaded as=20
> alternate variant and this is exactly the data which is stored in flash=20
> memory.
Two points:

=2D skip_otp is mentioned in a patch from 2014 (long before
the QCA9984) <https://patchwork.kernel.org/patch/5252351/>
The commit log says: "It is useful for initial calibration."
This does sound like this feature is used for "product development"
if it is used for something else (QCA6174, QCA9377?),=20
the description:=20
| MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode"=
);
should be upgraded.

Note: skip_otp doesn't skip over the BMI identification.
Instead it just instructs the code to ignore the result from it.
So setting skip_otp will not help here, since bmi_execute is=20
returing -ETIMEDOUT.
<http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath10k/core.=
c#L742>

=2D board api 1 was not intended to be used for QCA99X0+.
In fact, the patch:"ath10k: add board 2 API support".
<https://patchwork.kernel.org/patch/7334851/> which added it
lists the 99X0 (predecessor of the 9984?) as a target (altought
the ath10k-firmware repository still has the old file).
The board api 1 was just left as a fallback.

> >> there are 2 stored for both cards. you need to patch ath10k to use
> >> different board.bin files for each card.
> > Exactly. Why do you (or anyone for that matter) need to patch ath10k?
> > The driver is supposed to support the QCA9984 out of the box, right?
> it is supposed, but thats not the case. ath10k mainly supports cards=20
> with own on board eeprom.
> embedded routers can be very specific and nonstandard, so customizations=
=20
> are required sometimes.
> you may not like it, but i know this device very well and also others.=20
> consider how the skip otp patch was created.
> its a workaround which is only required for routers.
> > And I know, that the bmi identification is supposed to work, as
> > somebody posted the following log:
> > <http://lists.infradead.org/pipermail/lede-dev/2016-December/004987.htm=
l>
> >
> > [  379.392210] ath10k_pci 0002:01:00.0: boot upload otp to 0x1234 len 9=
000 for board id
> > [  379.399945] ath10k_pci 0002:01:00.0: bmi fast download address 0x123=
4 buffer 0xe1676038 length 9000
> > [  379.408977] ath10k_pci 0002:01:00.0: bmi lz stream start address 0x1=
234
> > [  379.415603] ath10k_pci 0002:01:00.0: bmi lz data buffer 0xe1676038 l=
ength 9000
> > [  379.451626] ath10k_pci 0002:01:00.0: bmi lz stream start address 0x0
> > [  379.457985] ath10k_pci 0002:01:00.0: bmi execute address 0x1234 para=
m 0x10
> > [  380.857006] ath10k_pci 0002:01:00.0: bmi execute result 0x400
> > [  380.862749] ath10k_pci 0002:01:00.0: boot get otp board id result 0x=
00000400 board_id 1 chip_id 0
> > [  380.871603] ath10k_pci 0002:01:00.0: boot using board name 'bus=3Dpc=
i,bmi-chip-id=3D0,bmi-board-id=3D1'
> > [  380.880468] ath10k_pci 0002:01:00.0: board name
> > [  380.884999] ath10k_pci 0002:01:00.0: 00000000: 62 75 73 3d 70 63 69 =
2c 62 6d 69 2d 63 68 69 70  bus=3Dpci,bmi-chip
> > [  380.895159] ath10k_pci 0002:01:00.0: 00000010: 2d 69 64 3d 30 2c 62 =
6d 69 2d 62 6f 61 72 64 2d  -id=3D0,bmi-board-
> > [  380.905317] ath10k_pci 0002:01:00.0: 00000020: 69 64 3d 31          =
                            id=3D1
> > [  380.914436] ath10k_pci 0002:01:00.0: boot found match for name 'bus=
=3Dpci,bmi-chip-id=3D0,bmi-board-id=3D1'
> > [  380.923640] ath10k_pci 0002:01:00.0: boot found board data for 'bus=
=3Dpci,bmi-chip-id=3D0,bmi-board-id=3D1'
> > [  380.932845] ath10k_pci 0002:01:00.0: using board api 2
> > ...
> >
> > The board name for the QCA9984 is supposed to look like
> > "'bus=3Dpci,bmi-chip-id=3D0,bmi-board-id=3D1'"
> >
> > and not like (from your log):
> sure. you can load wrong board data into your card this may result in=20
> the following situation a 5 ghz card is shown as 2.4 ghz card and vice=20
> versa or even dualband also if the card is not supporting this. this may=
=20
> not be the case on the r7800 but i know another device where this is the=
=20
> bevaviour. power calibration set is wrong in any way so output power may=
=20
> be lower as expected.
> and the resulting operation state will not work in best way. lede does=20
> not support this device in correct way.
> wrong board data can also destroy the hardware. this may not happen=20
> fast, but using wrong power calibration data may destroy the phy over=20
> time by overheating
>=20
> take a look on your router. especially on mtd3
> mtd3: 00140000 00020000 "art"
>=20
> dump this partition and take a look inside and take a guess what you=20
> will find. offset 0x1000 is first board data. offset 0x5000 is second=20
> board data
> this is common for almost all wireless routers on the market. i dont=20
> know a single router with a qca or atheros chipset on the market which=20
> does not have stored the board data in flash memory
Well, "almost all wireless routers on the martket" does it include older at=
h9k too?
If so, then there's the Aerohive HiveAP 121.
<https://github.com/riptidewave93/LEDE-HiveAP-121>. It has an AR934x SoC
and the internal WMAC is storing its calibration data in the SoC's OTP area.
The device is supported by ath9k. The device does have a wifi-cal/art
partition but it was empty.

There are simply too many devices, to keep track of each one and
each is a little bit different.

> >> bus=3Dpci,vendor=3D168c,device=3D0046,subsystem-vendor=3D168c,subsyste=
m-device=3Dcafe
> >> from ath10k/QCA9984/hw1.0/board-2.bin
> >> the failed to fetch board data error is normal.
> > I don't think it is. I think it's a regression.
> ahm no. you dont know what you're dealing with.
I reported that Hannu Nyman has an issue with the QCA9984 in his Netgear R7=
800.
The BMI Identification isn't working as expected... I asked on the ML what'=
s=20
going on and if they could take a look. Let's see if anyone has a good idea=
 or
suggestion. I know that people are able to get the correct bmi identificati=
on
too (see 5G_success_log.txt from Mani), but it is not working for everyone.

Thanks,
Christian
--nextPart135502668.1dcBANbLSa
Content-Disposition: attachment; filename="5G_succes_log.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="5G_succes_log.txt"

root@OpenWrt:/# dmesg
[  318.872990] Loading modules backported from Linux version wt-2016-10-03-1-g6fcb1a6
[  318.881313] Backport generated by backports.git backports-20160324-9-g0e38f5c
[  338.693224] ath10k_pci 0001:01:00.0: pci probe 168c:0046 168c:cafe
[  338.693299] PCI: enabling device 0001:01:00.0 (0140 -> 0142)
[  338.698968] ath10k_pci 0001:01:00.0: failed to set dma mask to 32-bit: -5
[  338.705745] ath10k_pci 0001:01:00.0: failed to claim device: -5
[  338.711857] ath10k_pci: probe of 0001:01:00.0 failed with error -5
[  504.407294] ath10k_pci 0001:01:00.0: pci probe 168c:0046 168c:cafe
[  504.407385] ath10k_pci 0001:01:00.0: boot pci_mem 0xe1400000
[  504.407620] ath10k_pci 0001:01:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
[  504.415723] ath10k_pci 0001:01:00.0: boot qca99x0 chip reset
[  504.415730] ath10k_pci 0001:01:00.0: boot cold reset
[  504.468595] ath10k_pci 0001:01:00.0: boot cold reset complete
[  504.468602] ath10k_pci 0001:01:00.0: boot waiting target to initialise
[  504.468610] ath10k_pci 0001:01:00.0: boot target indicator 2
[  504.468619] ath10k_pci 0001:01:00.0: boot target initialised
[  504.468624] ath10k_pci 0001:01:00.0: boot qca99x0 chip reset complete (cold)
[  504.468639] ath10k_pci 0001:01:00.0: boot hif power up
[  504.468647] ath10k_pci 0001:01:00.0: boot qca99x0 chip reset
[  504.468652] ath10k_pci 0001:01:00.0: boot cold reset
[  504.528598] ath10k_pci 0001:01:00.0: boot cold reset complete
[  504.528605] ath10k_pci 0001:01:00.0: boot waiting target to initialise
[  504.528613] ath10k_pci 0001:01:00.0: boot target indicator 2
[  504.528621] ath10k_pci 0001:01:00.0: boot target initialised
[  504.528627] ath10k_pci 0001:01:00.0: boot qca99x0 chip reset complete (cold)
[  504.528646] ath10k_pci 0001:01:00.0: boot init ce src ring id 0 entries 16 base_addr dbf67000
[  504.528664] ath10k_pci 0001:01:00.0: boot ce dest ring id 1 entries 512 base_addr dbf46000
[  504.528680] ath10k_pci 0001:01:00.0: boot ce dest ring id 2 entries 128 base_addr dbf68000
[  504.528699] ath10k_pci 0001:01:00.0: boot init ce src ring id 3 entries 32 base_addr dbf69000
[  504.528728] ath10k_pci 0001:01:00.0: boot init ce src ring id 4 entries 8192 base_addr db9e0000
[  504.528745] ath10k_pci 0001:01:00.0: boot ce dest ring id 5 entries 512 base_addr db9d0000
[  504.528763] ath10k_pci 0001:01:00.0: boot init ce src ring id 7 entries 2 base_addr db9fe000
[  504.528779] ath10k_pci 0001:01:00.0: boot ce dest ring id 7 entries 2 base_addr db9fd000
[  504.528795] ath10k_pci 0001:01:00.0: boot ce dest ring id 8 entries 128 base_addr db9fc000
[  504.539895] ath10k_pci 0001:01:00.0: bmi get target info
[  504.539962] ath10k_pci 0001:01:00.0: Hardware name qca9984/qca9994 hw1.0 version 0x1000000
[  624.858680] ath10k_pci 0001:01:00.0: trying fw api 5
[  624.859231] ath10k_pci 0001:01:00.0: found fw version 10.4-3.3-00092
[  624.859239] ath10k_pci 0001:01:00.0: found fw timestamp 1475058219
[  624.859245] ath10k_pci 0001:01:00.0: found otp image ie (9000 B)
[  624.859251] ath10k_pci 0001:01:00.0: found fw image ie (374947 B)
[  624.859257] ath10k_pci 0001:01:00.0: found firmware features ie (2 B)
[  624.859262] ath10k_pci 0001:01:00.0: Enabling feature bit: 3
[  624.859268] ath10k_pci 0001:01:00.0: Enabling feature bit: 12
[  624.859273] ath10k_pci 0001:01:00.0: Enabling feature bit: 13
[  624.859278] ath10k_pci 0001:01:00.0: Enabling feature bit: 14
[  624.859283] ath10k_pci 0001:01:00.0: features
[  624.859290] ath10k_pci 0001:01:00.0: 00000000: 08 70 00 00                                      .p..
[  624.859296] ath10k_pci 0001:01:00.0: found fw ie wmi op version 6
[  624.859301] ath10k_pci 0001:01:00.0: found fw ie htt op version 4
[  624.859307] ath10k_pci 0001:01:00.0: found fw code swap image ie (225340 B)
[  624.859313] ath10k_pci 0001:01:00.0: using fw api 5
[  624.859322] ath10k_pci 0001:01:00.0: qca9984/qca9994 hw1.0 target 0x01000000 chip_id 0x00000000 sub 168c:cafe
[  624.869235] ath10k_pci 0001:01:00.0: kconfig debug 1 debugfs 0 tracing 0 dfs 0 testmode 1
[  624.878638] ath10k_pci 0001:01:00.0: firmware ver 10.4-3.3-00092 api 5 features no-p2p,mfp,peer-flow-ctrl,btcoex-param crc32 3fc32024
[  624.890622] ath10k_pci 0001:01:00.0: boot did not find a pre calibration file, try DT next: -2
[  624.890628] ath10k_pci 0001:01:00.0: unable to load pre cal data from DT: -2
[  624.890633] ath10k_pci 0001:01:00.0: could not load pre cal data: -2
[  624.890640] ath10k_pci 0001:01:00.0: boot upload otp to 0x1234 len 9000 for board id
[  624.890647] ath10k_pci 0001:01:00.0: bmi fast download address 0x1234 buffer 0xe12f2038 length 9000
[  624.890652] ath10k_pci 0001:01:00.0: bmi lz stream start address 0x1234
[  624.890678] ath10k_pci 0001:01:00.0: bmi lz data buffer 0xe12f2038 length 9000
[  624.919493] ath10k_pci 0001:01:00.0: bmi lz stream start address 0x0
[  624.919729] ath10k_pci 0001:01:00.0: bmi execute address 0x1234 param 0x10
[  626.311613] ath10k_pci 0001:01:00.0: bmi execute result 0x400
[  626.311620] ath10k_pci 0001:01:00.0: boot get otp board id result 0x00000400 board_id 1 chip_id 0
[  626.311627] ath10k_pci 0001:01:00.0: boot using board name 'bus=pci,bmi-chip-id=0,bmi-board-id=1'
[  626.311702] ath10k_pci 0001:01:00.0: board name
[  626.311709] ath10k_pci 0001:01:00.0: 00000000: 62 75 73 3d 70 63 69 2c 62 6d 69 2d 63 68 69 70  bus=pci,bmi-chip
[  626.311715] ath10k_pci 0001:01:00.0: 00000010: 2d 69 64 3d 30 2c 62 6d 69 2d 62 6f 61 72 64 2d  -id=0,bmi-board-
[  626.311721] ath10k_pci 0001:01:00.0: 00000020: 69 64 3d 31                                      id=1
[  626.311727] ath10k_pci 0001:01:00.0: boot found match for name 'bus=pci,bmi-chip-id=0,bmi-board-id=1'
[  626.311732] ath10k_pci 0001:01:00.0: boot found board data for 'bus=pci,bmi-chip-id=0,bmi-board-id=1'
[  626.311738] ath10k_pci 0001:01:00.0: using board api 2
[  626.311770] ath10k_pci 0001:01:00.0: board_file api 2 bmi_id 0:1 crc32 e8ae406f
[  626.319206] ath10k_pci 0001:01:00.0: bmi start
[  626.319213] ath10k_pci 0001:01:00.0: bmi write address 0x400800 length 4
[  626.319232] ath10k_pci 0001:01:00.0: bmi read address 0x400810 length 4
[  626.319326] ath10k_pci 0001:01:00.0: bmi write address 0x400810 length 4
[  626.319340] ath10k_pci 0001:01:00.0: bmi write address 0x400844 length 4
[  626.319402] ath10k_pci 0001:01:00.0: bmi write address 0x400904 length 4
[  626.319447] ath10k_pci 0001:01:00.0: bmi write address 0x4008bc length 4
[  626.319493] ath10k_pci 0001:01:00.0: boot did not find a pre calibration file, try DT next: -2
[  626.319498] ath10k_pci 0001:01:00.0: unable to load pre cal data from DT: -2
[  626.319504] ath10k_pci 0001:01:00.0: failed to load pre cal data: -2
[  626.319509] ath10k_pci 0001:01:00.0: pre cal download procedure failed, try cal file: -2
[  626.319514] ath10k_pci 0001:01:00.0: boot did not find a calibration file, try DT next: -2
[  626.319520] ath10k_pci 0001:01:00.0: boot did not find DT entry, try target EEPROM next: -2
[  626.319526] ath10k_pci 0001:01:00.0: boot did not find target EEPROM entry, try OTP next: -95
[  626.319531] ath10k_pci 0001:01:00.0: bmi read address 0x4008ac length 4
[  626.319581] ath10k_pci 0001:01:00.0: boot push board extended data addr 0x0
[  626.319586] ath10k_pci 0001:01:00.0: bmi read address 0x400854 length 4
[  626.319657] ath10k_pci 0001:01:00.0: bmi write address 0xc0000 length 12064
[  626.338831] ath10k_pci 0001:01:00.0: bmi write address 0x400858 length 4
[  626.339021] ath10k_pci 0001:01:00.0: boot upload otp to 0x1234 len 9000
[  626.339028] ath10k_pci 0001:01:00.0: bmi fast download address 0x1234 buffer 0xe12f2038 length 9000
[  626.339033] ath10k_pci 0001:01:00.0: bmi lz stream start address 0x1234
[  626.339067] ath10k_pci 0001:01:00.0: bmi lz data buffer 0xe12f2038 length 9000
[  626.367884] ath10k_pci 0001:01:00.0: bmi lz stream start address 0x0
[  626.368121] ath10k_pci 0001:01:00.0: bmi execute address 0x1234 param 0x700
[  627.769087] ath10k_pci 0001:01:00.0: bmi execute result 0x0
[  627.769094] ath10k_pci 0001:01:00.0: boot otp execute result 0
[  627.769101] ath10k_pci 0001:01:00.0: boot using calibration mode otp
[  627.769106] ath10k_pci 0001:01:00.0: boot found firmware code swap binary
[  627.769112] ath10k_pci 0001:01:00.0: bmi write address 0x422108 length 208
[  627.769134] ath10k_pci 0001:01:00.0: boot uploading firmware image e12f4368 len 374947
[  627.769140] ath10k_pci 0001:01:00.0: bmi fast download address 0x1234 buffer 0xe12f4368 length 374947
[  627.769146] ath10k_pci 0001:01:00.0: bmi lz stream start address 0x1234
[  627.769478] ath10k_pci 0001:01:00.0: bmi lz data buffer 0xe12f4368 length 374944
[  628.960394] ath10k_pci 0001:01:00.0: bmi lz data buffer 0xdf9d7e74 length 4
[  628.961008] ath10k_pci 0001:01:00.0: bmi lz stream start address 0x0
[  628.961055] ath10k_pci 0001:01:00.0: bmi write address 0x400814 length 4
[  628.961094] ath10k_pci 0001:01:00.0: pci hif get default pipe
[  628.961099] ath10k_pci 0001:01:00.0: pci hif map service
[  628.961105] ath10k_pci 0001:01:00.0: bmi done
[  628.961140] ath10k_pci 0001:01:00.0: htt tx max num pending tx 2500
[  628.961232] ath10k_pci 0001:01:00.0: htt rx ring size 2048 fill_level 1023
[  628.961238] ath10k_pci 0001:01:00.0: boot hif start
[  628.966867] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 20
[  628.966876] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 00 0c 00 00 00 00 00 01 00 02 00 00 07 16 00  ................
[  628.966883] ath10k_pci 0001:01:00.0: pci rx: 00000010: 01 00 00 00                                      ....
[  628.966964] ath10k_pci 0001:01:00.0: Target ready! transmit resources: 2 size:1792
[  628.966970] ath10k_pci 0001:01:00.0: pci hif map service
[  628.966978] ath10k_pci 0001:01:00.0: boot htc service 'Control' ul pipe 0 dl pipe 1 eid 0 ready
[  628.966984] ath10k_pci 0001:01:00.0: boot htc service 'Control' eid 0 TX flow control disabled
[  628.966990] ath10k_pci 0001:01:00.0: boot htc service HTT Data does not allocate target credits
[  628.966996] ath10k_pci 0001:01:00.0: ath10k_htc_build_tx_ctrl_skb: skb dc103800
[  628.967004] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b55464c len 16 n_items 1
[  628.967011] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 00 01 08 00 84 00 42 42 02 00 00 03 08 00 00 00  ......BB........
[  628.967037] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 0 skb dc103800
[  628.967099] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 20
[  628.967107] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 00 0c 00 00 01 00 00 03 00 00 03 00 01 d0 07  ................
[  628.967113] ath10k_pci 0001:01:00.0: pci rx: 00000010: 00 00 00 00                                      ....
[  628.967184] ath10k_pci 0001:01:00.0: HTC Service HTT Data connect response: status: 0x0, assigned ep: 0x1
[  628.967190] ath10k_pci 0001:01:00.0: pci hif map service
[  628.967197] ath10k_pci 0001:01:00.0: boot htc service 'HTT Data' ul pipe 4 dl pipe 5 eid 1 ready
[  628.967203] ath10k_pci 0001:01:00.0: boot htc service 'HTT Data' eid 1 TX flow control disabled
[  628.967210] ath10k_pci 0001:01:00.0: ath10k_htc_build_tx_ctrl_skb: skb dc256800
[  628.967217] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b5c7acc len 16 n_items 1
[  628.967223] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 00 01 08 00 31 01 01 20 02 00 00 01 00 02 00 00  ....1.. ........
[  628.967247] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 0 skb dc256800
[  628.967310] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 20
[  628.967317] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 00 0c 00 00 02 00 00 03 00 00 01 00 02 b4 06  ................
[  628.967323] ath10k_pci 0001:01:00.0: pci rx: 00000010: 00 00 00 00                                      ....
[  628.967394] ath10k_pci 0001:01:00.0: HTC Service WMI connect response: status: 0x0, assigned ep: 0x2
[  628.967400] ath10k_pci 0001:01:00.0: pci hif map service
[  628.967406] ath10k_pci 0001:01:00.0: boot htc service 'WMI' ul pipe 3 dl pipe 2 eid 2 ready
[  628.967412] ath10k_pci 0001:01:00.0: ath10k_htc_build_tx_ctrl_skb: skb db618800
[  628.967418] ath10k_pci 0001:01:00.0: HTC is using TX credit flow control
[  628.967425] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b65b4cc len 20 n_items 1
[  628.967431] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 00 01 0c 00 a3 02 a0 00 05 00 00 00 00 00 00 00  ................
[  628.967437] ath10k_pci 0001:01:00.0: pci tx data: 00000010: 00 00 00 00                                      ....
[  628.967458] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 0 skb db618800
[  628.967523] ath10k_pci 0001:01:00.0: pci rx ce pipe 2 len 284
[  628.967529] ath10k_pci 0001:01:00.0: pci rx: 00000000: 02 00 14 01 00 03 00 00 00 80 00 00 00 00 00 01  ................
[  628.967535] ath10k_pci 0001:01:00.0: pci rx: 00000010: 5c 00 00 00 03 00 00 00 01 00 00 00 05 00 00 00  \...............
[  628.967541] ath10k_pci 0001:01:00.0: pci rx: 00000020: 08 00 00 00 07 00 00 00 07 00 00 00 09 00 00 00  ................
[  628.967547] ath10k_pci 0001:01:00.0: pci rx: 00000030: 04 00 00 00 01 00 00 00 0e 00 00 00 08 00 00 00  ................
[  628.967553] ath10k_pci 0001:01:00.0: pci rx: 00000040: 0d 00 00 00 03 00 00 00 0e 00 00 00 0c 00 00 00  ................
[  628.967558] ath10k_pci 0001:01:00.0: pci rx: 00000050: 0f 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
[  628.967564] ath10k_pci 0001:01:00.0: pci rx: 00000060: 04 00 00 00 5b 18 00 00 f2 79 9b 33 aa ff 00 00  ....[....y.3....
[  628.967570] ath10k_pci 0001:01:00.0: pci rx: 00000070: 3f 00 00 00 3f 00 00 00 00 00 00 00 3f 00 00 00  ?...?.......?...
[  628.967575] ath10k_pci 0001:01:00.0: pci rx: 00000080: 07 00 00 00 c0 0b 00 00 01 90 7f 00 08 09 00 00  ................
[  628.967581] ath10k_pci 0001:01:00.0: pci rx: 00000090: ac 0a 00 00 30 13 00 00 d4 17 00 00 00 00 00 00  ....0...........
[  628.967587] ath10k_pci 0001:01:00.0: pci rx: 000000a0: 00 00 00 00 00 00 00 00 07 00 00 00 01 00 00 00  ................
[  628.967592] ath10k_pci 0001:01:00.0: pci rx: 000000b0: a8 08 00 00 02 00 00 00 00 00 00 00 02 00 00 00  ................
[  628.967598] ath10k_pci 0001:01:00.0: pci rx: 000000c0: 00 01 00 00 0c 00 00 00 01 00 00 00 03 00 00 00  ................
[  628.967604] ath10k_pci 0001:01:00.0: pci rx: 000000d0: 00 04 00 00 0c 00 00 00 01 00 00 00 04 00 00 00  ................
[  628.967609] ath10k_pci 0001:01:00.0: pci rx: 000000e0: 00 10 00 00 0c 00 00 00 01 00 00 00 06 00 00 00  ................
[  628.967615] ath10k_pci 0001:01:00.0: pci rx: 000000f0: 00 0c 00 00 00 00 00 00 23 00 00 00 07 00 00 00  ........#.......
[  628.967621] ath10k_pci 0001:01:00.0: pci rx: 00000100: 00 30 00 00 00 00 00 00 01 00 00 00 05 00 00 00  .0..............
[  628.967627] ath10k_pci 0001:01:00.0: pci rx: 00000110: bc 07 00 00 02 00 00 00 00 00 00 00              ............
[  628.967633] ath10k_pci 0001:01:00.0: htc rx completion ep 2 skb dbaf2a40
[  628.967640] ath10k_pci 0001:01:00.0: testmode event wmi cmd_id 32768 skb dbaf2a40 skb->len 272
[  628.967646] ath10k_pci 0001:01:00.0: 00000000: 00 00 00 01 5c 00 00 00 03 00 00 00 01 00 00 00  ....\...........
[  628.967651] ath10k_pci 0001:01:00.0: 00000010: 05 00 00 00 08 00 00 00 07 00 00 00 07 00 00 00  ................
[  628.967657] ath10k_pci 0001:01:00.0: 00000020: 09 00 00 00 04 00 00 00 01 00 00 00 0e 00 00 00  ................
[  628.967662] ath10k_pci 0001:01:00.0: 00000030: 08 00 00 00 0d 00 00 00 03 00 00 00 0e 00 00 00  ................
[  628.967668] ath10k_pci 0001:01:00.0: 00000040: 0c 00 00 00 0f 00 00 00 02 00 00 00 00 00 00 00  ................
[  628.967673] ath10k_pci 0001:01:00.0: 00000050: 00 00 00 00 04 00 00 00 5b 18 00 00 f2 79 9b 33  ........[....y.3
[  628.967679] ath10k_pci 0001:01:00.0: 00000060: aa ff 00 00 3f 00 00 00 3f 00 00 00 00 00 00 00  ....?...?.......
[  628.967685] ath10k_pci 0001:01:00.0: 00000070: 3f 00 00 00 07 00 00 00 c0 0b 00 00 01 90 7f 00  ?...............
[  628.967690] ath10k_pci 0001:01:00.0: 00000080: 08 09 00 00 ac 0a 00 00 30 13 00 00 d4 17 00 00  ........0.......
[  628.967696] ath10k_pci 0001:01:00.0: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 07 00 00 00  ................
[  628.967701] ath10k_pci 0001:01:00.0: 000000a0: 01 00 00 00 a8 08 00 00 02 00 00 00 00 00 00 00  ................
[  628.967707] ath10k_pci 0001:01:00.0: 000000b0: 02 00 00 00 00 01 00 00 0c 00 00 00 01 00 00 00  ................
[  628.967712] ath10k_pci 0001:01:00.0: 000000c0: 03 00 00 00 00 04 00 00 0c 00 00 00 01 00 00 00  ................
[  628.967718] ath10k_pci 0001:01:00.0: 000000d0: 04 00 00 00 00 10 00 00 0c 00 00 00 01 00 00 00  ................
[  628.967723] ath10k_pci 0001:01:00.0: 000000e0: 06 00 00 00 00 0c 00 00 00 00 00 00 23 00 00 00  ............#...
[  628.967729] ath10k_pci 0001:01:00.0: 000000f0: 07 00 00 00 00 30 00 00 00 00 00 00 01 00 00 00  .....0..........
[  628.967734] ath10k_pci 0001:01:00.0: 00000100: 05 00 00 00 bc 07 00 00 02 00 00 00 00 00 00 00  ................
[  628.967966] ath10k_pci 0001:01:00.0: wmi svc: 00000000: 08 00 00 00 07 00 00 00 07 00 00 00 09 00 00 00  ................
[  628.967974] ath10k_pci 0001:01:00.0: wmi svc: 00000010: 04 00 00 00 01 00 00 00 0e 00 00 00 08 00 00 00  ................
[  628.967981] ath10k_pci 0001:01:00.0: wmi svc: 00000020: 0d 00 00 00 03 00 00 00 0e 00 00 00 0c 00 00 00  ................
[  628.967988] ath10k_pci 0001:01:00.0: wmi svc: 00000030: 0f 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
[  628.967996] ath10k_pci 0001:01:00.0: wmi mem_req_id 1 num_units 0 num_unit_info 2 unit size 2216 actual units 529
[  628.968385] ath10k_pci 0001:01:00.0: wmi mem_req_id 2 num_units 1 num_unit_info 12 unit size 256 actual units 52
[  628.968397] ath10k_pci 0001:01:00.0: wmi mem_req_id 3 num_units 1 num_unit_info 12 unit size 1024 actual units 52
[  628.968418] ath10k_pci 0001:01:00.0: wmi mem_req_id 4 num_units 1 num_unit_info 12 unit size 4096 actual units 52
[  628.968474] ath10k_pci 0001:01:00.0: wmi mem_req_id 6 num_units 35 num_unit_info 0 unit size 3072 actual units 35
[  628.968508] ath10k_pci 0001:01:00.0: wmi mem_req_id 7 num_units 1 num_unit_info 0 unit size 12288 actual units 1
[  628.968519] ath10k_pci 0001:01:00.0: wmi mem_req_id 5 num_units 0 num_unit_info 2 unit size 1980 actual units 529
[  628.968778] ath10k_pci 0001:01:00.0: wmi event service ready min_tx_power 0x0000003f max_tx_power 0x0000003f ht_cap 0x0000185b vht_cap 0x337
[  628.968793] ath10k_pci 0001:01:00.0: firmware 10.4-3.3-00092 booted
[  628.968801] ath10k_pci 0001:01:00.0: wmi ext resource config host type 1 firmware feature bitmap 00000010
[  628.968809] ath10k_pci 0001:01:00.0: htc ep 2 consumed 1 credits (total 1)
[  628.968816] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b6ce940 len 20 n_items 1
[  628.968823] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 02 01 0c 00 71 00 00 65 8d 90 00 00 01 00 00 00  ....q..e........
[  628.968829] ath10k_pci 0001:01:00.0: pci tx data: 00000010: 10 00 00 00                                      ....
[  628.968838] ath10k_pci 0001:01:00.0: wmi chunk 0 len 1172264 requested, addr 0x1b000000
[  628.968856] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 2 skb dbaf2a40
[  628.968924] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 16
[  628.968931] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 02 08 00 08 04 00 00 01 04 00 01 02 01 b4 06  ................
[  628.968938] ath10k_pci 0001:01:00.0: htc ep 2 got 1 credits (total 2)
[  628.968965] ath10k_pci 0001:01:00.0: wmi chunk 1 len 13312 requested, addr 0x1b6d0000
[  628.968971] ath10k_pci 0001:01:00.0: wmi chunk 2 len 53248 requested, addr 0x1b6e0000
[  628.968977] ath10k_pci 0001:01:00.0: wmi chunk 3 len 212992 requested, addr 0x1b700000
[  628.968983] ath10k_pci 0001:01:00.0: wmi chunk 4 len 107520 requested, addr 0x1b740000
[  628.968989] ath10k_pci 0001:01:00.0: wmi chunk 5 len 12288 requested, addr 0x1b6d4000
[  628.968995] ath10k_pci 0001:01:00.0: wmi chunk 6 len 1047420 requested, addr 0x1b200000
[  628.969000] ath10k_pci 0001:01:00.0: wmi init 10.4
[  628.969006] ath10k_pci 0001:01:00.0: htc ep 2 consumed 1 credits (total 1)
[  628.969013] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b6cea80 len 280 n_items 1
[  628.969019] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 02 01 10 01 55 01 e5 4a 00 a0 00 00 10 00 00 00  ....U..J........
[  628.969026] ath10k_pci 0001:01:00.0: pci tx data: 00000010: 10 02 00 00 33 00 00 00 00 00 00 00 00 00 00 00  ....3...........
[  628.969031] ath10k_pci 0001:01:00.0: pci tx data: 00000020: 02 00 00 00 66 00 00 00 20 00 00 00 0f 00 00 00  ....f... .......
[  628.969037] ath10k_pci 0001:01:00.0: pci tx data: 00000030: 0f 00 00 00 64 00 00 00 64 00 00 00 64 00 00 00  ....d...d...d...
[  628.969043] ath10k_pci 0001:01:00.0: pci tx data: 00000040: 28 00 00 00 01 00 00 00 04 00 00 00 03 00 00 00  (...............
[  628.969049] ath10k_pci 0001:01:00.0: pci tx data: 00000050: 03 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00  ................
[  628.969055] ath10k_pci 0001:01:00.0: pci tx data: 00000060: 00 00 00 00 00 04 00 00 20 00 00 00 00 00 00 00  ........ .......
[  628.969060] ath10k_pci 0001:01:00.0: pci tx data: 00000070: 00 00 00 00 01 00 00 00 00 00 00 00 03 00 00 00  ................
[  628.969066] ath10k_pci 0001:01:00.0: pci tx data: 00000080: c4 09 00 00 02 00 00 00 10 00 00 00 00 00 00 00  ................
[  628.969072] ath10k_pci 0001:01:00.0: pci tx data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  628.969078] ath10k_pci 0001:01:00.0: pci tx data: 000000a0: 01 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00  ................
[  628.969084] ath10k_pci 0001:01:00.0: pci tx data: 000000b0: 00 00 00 00 07 00 00 00 01 00 00 00 00 00 00 1b  ................
[  628.969089] ath10k_pci 0001:01:00.0: pci tx data: 000000c0: 28 e3 11 00 02 00 00 00 00 00 6d 1b 00 34 00 00  (.........m..4..
[  628.969095] ath10k_pci 0001:01:00.0: pci tx data: 000000d0: 03 00 00 00 00 00 6e 1b 00 d0 00 00 04 00 00 00  ......n.........
[  628.969101] ath10k_pci 0001:01:00.0: pci tx data: 000000e0: 00 00 70 1b 00 40 03 00 06 00 00 00 00 00 74 1b  ..p..@........t.
[  628.969107] ath10k_pci 0001:01:00.0: pci tx data: 000000f0: 00 a4 01 00 07 00 00 00 00 40 6d 1b 00 30 00 00  .........@m..0..
[  628.969112] ath10k_pci 0001:01:00.0: pci tx data: 00000100: 05 00 00 00 00 00 20 1b 7c fb 0f 00 00 00 00 00  ...... .|.......
[  628.969118] ath10k_pci 0001:01:00.0: pci tx data: 00000110: 00 00 00 00 00 00 00 00                          ........
[  628.969147] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 2 skb db622740
[  629.040937] ath10k_pci 0001:01:00.0: pci rx ce pipe 5 len 28
[  629.040946] ath10k_pci 0001:01:00.0: pci rx: 00000000: 01 00 14 00 00 05 00 00 0f 00 00 00 64 14 00 00  ............d...
[  629.040953] ath10k_pci 0001:01:00.0: pci rx: 00000010: 5a 14 00 00 02 00 00 00 09 00 00 00              Z...........
[  629.040959] ath10k_pci 0001:01:00.0: htt rx, msg_type: 0xF
[  629.040966] ath10k_pci 0001:01:00.0: htt chan change freq 5220 phymode 11ac-vht40
[  629.042327] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 16
[  629.042335] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 02 08 00 08 07 00 00 01 04 00 01 02 01 b4 06  ................
[  629.042343] ath10k_pci 0001:01:00.0: htc ep 2 got 1 credits (total 2)
[  629.042355] ath10k_pci 0001:01:00.0: pci rx ce pipe 2 len 40
[  629.042362] ath10k_pci 0001:01:00.0: pci rx: 00000000: 02 00 20 00 00 06 00 00 01 80 00 00 00 00 00 01  .. .............
[  629.042368] ath10k_pci 0001:01:00.0: pci rx: 00000010: 03 00 00 00 00 00 79 55 a0 14 00 00 00 00 00 00  ......yU........
[  629.042374] ath10k_pci 0001:01:00.0: pci rx: 00000020: 00 00 00 00 00 00 00 00                          ........
[  629.042380] ath10k_pci 0001:01:00.0: htc rx completion ep 2 skb dbaf2980
[  629.042387] ath10k_pci 0001:01:00.0: testmode event wmi cmd_id 32769 skb dbaf2980 skb->len 28
[  629.042393] ath10k_pci 0001:01:00.0: 00000000: 00 00 00 01 03 00 00 00 00 00 79 55 a0 14 00 00  ..........yU....
[  629.042399] ath10k_pci 0001:01:00.0: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00              ............
[  629.042407] ath10k_pci 0001:01:00.0: wmi event ready sw_version 16777216 abi_version 3 mac_addr 00:00:79:55:a0:14 status 0
[  629.042435] ath10k_pci 0001:01:00.0: WMI vdev create: id 0 type 2 subtype 0 macaddr 00:00:79:55:a0:14
[  629.042442] ath10k_pci 0001:01:00.0: htc ep 2 consumed 1 credits (total 1)
[  629.042449] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7e8940 len 32 n_items 1
[  629.042455] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 02 01 18 00 51 02 28 b5 13 90 00 00 00 00 00 00  ....Q.(.........
[  629.042461] ath10k_pci 0001:01:00.0: pci tx data: 00000010: 02 00 00 00 00 00 00 00 00 00 79 55 a0 14 00 00  ..........yU....
[  629.042468] ath10k_pci 0001:01:00.0: WMI vdev delete id 0
[  629.042483] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 2 skb db622740
[  629.042495] ath10k_pci 0001:01:00.0: htc ep 2 consumed 1 credits (total 0)
[  629.042502] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7e8a80 len 16 n_items 1
[  629.042508] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 02 01 08 00 08 03 56 70 14 90 00 00 00 00 00 00  ......Vp........
[  629.042515] ath10k_pci 0001:01:00.0: wmi echo value 0x0ba991e9
[  629.042530] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 2 skb db628540
[  629.042714] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 16
[  629.042722] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 02 08 00 08 08 00 00 01 04 00 01 02 01 b4 06  ................
[  629.042730] ath10k_pci 0001:01:00.0: htc ep 2 got 1 credits (total 1)
[  629.042753] ath10k_pci 0001:01:00.0: htc ep 2 consumed 1 credits (total 0)
[  629.042760] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7e8bc0 len 16 n_items 1
[  629.042767] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 02 01 08 00 26 04 45 0a 05 90 00 00 e9 91 a9 0b  ....&.E.........
[  629.042787] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 16
[  629.042793] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 02 08 00 08 09 00 00 01 04 00 00 02 01 00 00  ................
[  629.042803] ath10k_pci 0001:01:00.0: htc ep 2 got 1 credits (total 1)
[  629.042821] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 16
[  629.042827] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 02 08 00 08 0b 00 00 01 04 00 00 02 01 00 00  ................
[  629.042833] ath10k_pci 0001:01:00.0: htc ep 2 got 1 credits (total 2)
[  629.042843] ath10k_pci 0001:01:00.0: pci rx ce pipe 2 len 16
[  629.042849] ath10k_pci 0001:01:00.0: pci rx: 00000000: 02 00 08 00 00 0a 00 00 01 90 00 00 e9 91 a9 0b  ................
[  629.042855] ath10k_pci 0001:01:00.0: htc rx completion ep 2 skb dbaf28c0
[  629.042862] ath10k_pci 0001:01:00.0: testmode event wmi cmd_id 36865 skb dbaf28c0 skb->len 4
[  629.042868] ath10k_pci 0001:01:00.0: 00000000: e9 91 a9 0b                                      ....
[  629.042874] ath10k_pci 0001:01:00.0: wmi event echo value 0x0ba991e9
[  629.042886] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 2 skb db622740
[  629.042900] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7ed500 len 12 n_items 1
[  629.042906] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 01 01 04 00 9d 00 25 69 00 6f f1 c5              ......%i.o..
[  629.042957] ath10k_pci 0001:01:00.0: pci rx ce pipe 5 len 12
[  629.042965] ath10k_pci 0001:01:00.0: pci rx: 00000000: 01 00 04 00 00 0c 00 00 00 02 02 00              ............
[  629.042972] ath10k_pci 0001:01:00.0: htt rx, msg_type: 0x0
[  629.042991] ath10k_pci 0001:01:00.0: htt target version 2.2
[  629.042998] ath10k_pci 0001:01:00.0: htt frag desc bank cmd
[  629.043005] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7ed640 len 56 n_items 1
[  629.043012] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 01 01 30 00 ea 01 19 a1 06 08 01 40 00 00 ac 1b  ..0........@....
[  629.043018] ath10k_pci 0001:01:00.0: pci tx data: 00000010: 08 d4 9f 84 0b 2c c3 48 02 81 d2 06 00 00 c3 09  .....,.H........
[  629.043025] ath10k_pci 0001:01:00.0: pci tx data: 00000020: 05 d1 cc 81 c0 b2 08 05 dd d4 54 0e 00 40 a2 1b  ..........T..@..
[  629.043031] ath10k_pci 0001:01:00.0: pci tx data: 00000030: 10 02 08 00 01 00 c2 40                          .......@
[  629.043039] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7ed780 len 48 n_items 1
[  629.043045] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 01 01 28 00 59 02 87 12 02 01 a5 8c 00 f0 af 1b  ..(.Y...........
[  629.043051] ath10k_pci 0001:01:00.0: pci tx data: 00000010: 00 c0 a2 1b 00 08 80 07 ff ff ff 03 3b 00 4b 00  ............;.K.
[  629.043057] ath10k_pci 0001:01:00.0: pci tx data: 00000020: 15 00 1f 00 03 00 14 00 06 00 0a 00 01 00 02 00  ................
[  629.043063] ath10k_pci 0001:01:00.0: htt h2t aggr cfg msg amsdu 3 ampdu 64
[  629.043070] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7ed8c0 len 11 n_items 1
[  629.043076] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 01 01 03 00 09 03 18 b2 05 40 03                 .........@.
[  629.043084] ath10k_pci 0001:01:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 cal otp max-sta 512 raw 0 hwcrypto 1
[  629.052477] ath10k_pci 0001:01:00.0: htc ep 2 consumed 1 credits (total 1)
[  629.052493] ath10k_pci 0001:01:00.0: pci rx ce pipe 5 len 16
[  629.052500] ath10k_pci 0001:01:00.0: pci rx: 00000000: 01 00 08 00 00 0d 00 00 15 00 00 00 00 00 00 00  ................
[  629.052506] ath10k_pci 0001:01:00.0: htt rx, msg_type: 0x15
[  629.052520] ath10k_pci 0001:01:00.0: pci tx item 0 paddr 0x1b7eda00 len 16 n_items 1
[  629.052535] ath10k_pci 0001:01:00.0: pci tx data: 00000000: 02 01 08 00 51 05 a0 40 55 90 00 00 01 00 00 00  ....Q..@U.......
[  629.052561] ath10k_pci 0001:01:00.0: ath10k_htc_notify_tx_completion: ep 2 skb db6283c0
[  629.052706] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 16
[  629.052714] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 02 08 00 08 0e 00 00 01 04 00 00 02 01 00 00  ................
[  629.052722] ath10k_pci 0001:01:00.0: htc ep 2 got 1 credits (total 2)
[  629.052730] ath10k_pci 0001:01:00.0: pci rx ce pipe 1 len 12
[  629.052737] ath10k_pci 0001:01:00.0: pci rx: 00000000: 00 00 04 00 00 0f 00 00 06 00 00 00              ............
[  629.052743] ath10k_pci 0001:01:00.0: boot suspend complete
[  629.052764] ath10k_pci 0001:01:00.0: boot hif stop
[  629.052812] ath10k_pci 0001:01:00.0: boot qca99x0 chip reset
[  629.052817] ath10k_pci 0001:01:00.0: boot cold reset
[  629.108598] ath10k_pci 0001:01:00.0: boot cold reset complete
[  629.108605] ath10k_pci 0001:01:00.0: boot waiting target to initialise
[  629.108613] ath10k_pci 0001:01:00.0: boot target indicator 2
[  629.108622] ath10k_pci 0001:01:00.0: boot target initialised
[  629.108628] ath10k_pci 0001:01:00.0: boot qca99x0 chip reset complete (cold)
[  629.110054] ath10k_pci 0001:01:00.0: boot hif power down
[  629.110063] ath: EEPROM regdomain: 0x0
[  629.110067] ath: EEPROM indicates default country code should be used
[  629.110071] ath: doing EEPROM country->regdmn map search
[  629.110076] ath: country maps to regdmn code: 0x3a
[  629.110080] ath: Country alpha2 being used: US
[  629.110084] ath: Regpair used: 0x3a

============================================================

root@OpenWrt:/# iw list
Wiphy phy1
        max # scan SSIDs: 16
        max scan IEs length: 199 bytes
        Retry short limit: 7
        Retry long limit: 4
        Coverage class: 0 (up to 0m)
        Device supports AP-side u-APSD.
        Available Antennas: TX 0xf RX 0xf
        Configured Antennas: TX 0xf RX 0xf
        Supported interface modes:
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * mesh point
        Band 2:
                Capabilities: 0x19ef
                        RX LDPC
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        TX STBC
                        RX STBC 1-stream
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT TX/RX MCS rate indexes supported: 0-31
                VHT Capabilities (0x339b79f6):
                        Max MPDU length: 11454
                        Supported Channel Width: 160 MHz
                        RX LDPC
                        short GI (80 MHz)
                        short GI (160/80+80 MHz)
                        TX STBC
                        SU Beamformer
                        SU Beamformee
                        MU Beamformer
                        MU Beamformee
                        RX antenna pattern consistency
                        TX antenna pattern consistency
                VHT RX MCS set:
                        1 streams: MCS 0-9
                        2 streams: MCS 0-9
                        3 streams: MCS 0-9
                        4 streams: MCS 0-9
                        5 streams: not supported
                        6 streams: not supported
                        7 streams: not supported
                        8 streams: not supported
                VHT RX highest supported: 0 Mbps
                VHT TX MCS set:
                        1 streams: MCS 0-9
                        2 streams: MCS 0-9
                        3 streams: MCS 0-9
                        4 streams: MCS 0-9
                        5 streams: not supported
                        6 streams: not supported
                        7 streams: not supported
                        8 streams: not supported
                VHT TX highest supported: 0 Mbps
                Frequencies:
                        * 5180 MHz [36] (23.0 dBm)
                        * 5200 MHz [40] (23.0 dBm)
                        * 5220 MHz [44] (23.0 dBm)
                        * 5240 MHz [48] (23.0 dBm)
                        * 5260 MHz [52] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5280 MHz [56] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5300 MHz [60] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5320 MHz [64] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5500 MHz [100] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5520 MHz [104] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5540 MHz [108] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5560 MHz [112] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5580 MHz [116] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5600 MHz [120] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5620 MHz [124] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5640 MHz [128] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5660 MHz [132] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5680 MHz [136] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5700 MHz [140] (23.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5720 MHz [144] (23.0 dBm) (radar detection)
                          DFS state: usable (for 201 sec)
                          DFS CAC time: 60000 ms
                        * 5745 MHz [149] (30.0 dBm)
                        * 5765 MHz [153] (30.0 dBm)
                        * 5785 MHz [157] (30.0 dBm)
                        * 5805 MHz [161] (30.0 dBm)
                        * 5825 MHz [165] (30.0 dBm)
        valid interface combinations:
                 * #{ managed } <= 1, #{ AP, mesh point } <= 16,
                   total <= 16, #channels <= 1, STA/AP BI must match
        HT Capability overrides:
                 * MCS: ff ff ff ff ff ff ff ff ff ff
                 * maximum A-MSDU length
                 * supported channel width
                 * short GI for 40 MHz
                 * max A-MPDU length exponent
                 * min MPDU start spacing
root@OpenWrt:/# 
CTRL-A Z for help | 115200 8N1 | NOR | Minicom 2.7 | VT102 | Offline | ttyUSB0                                                                


--nextPart135502668.1dcBANbLSa--
