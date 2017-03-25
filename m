Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:47222 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751306AbdCYHZI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Mar 2017 03:25:08 -0400
To: Christian Lamparter <chunkeey@googlemail.com>
References: <3243718.FYinmXYgr7@debian64>
 <4960795b-028f-27b1-8bdf-6c9fb2242f5f@dd-wrt.com>
 <3143301.IOZImBPhRt@debian64>
Cc: ath10k@lists.infradead.org,
        ath10k-devel <ath10k-devel@qca.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "linux-wireless (linux-wireless@vger.kernel.org)"
        <linux-wireless@vger.kernel.org>, hannu.nyman@iki.fi,
        Adrian Chadd <adrian@freebsd.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <20d2aa5c-c0a6-f14b-9694-4e4384299d25@dd-wrt.com> (sfid-20170325_082517_929826_ED1EF208)
Date: Sat, 25 Mar 2017 08:24:59 +0100
MIME-Version: 1.0
In-Reply-To: <3143301.IOZImBPhRt@debian64>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: QCA9984 bmi identification failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 24.03.2017 um 16:01 schrieb Christian Lamparter:
> On Friday, March 24, 2017 11:09:03 AM CET Sebastian Gottschall wrote:
>> i have a r7800 running. consider to use the board.bin file which is
>> stored in flash memory of the r7800.
> Well, this is a bit beside the point. But what makes you think that
> what is stored in the flash memory of R7800 is the "board.bin"?
i dont know how to answer this question without getting rude. i'm 
developing dd-wrt which is a alternate firmware like lede/openwrt for 
many hundrets of different routers.this is my job since more than 10 years.
so my primary job is reverse engineering all the vendor stuff they wont 
tell you in a easy way but on the other hands vendors do also share such 
informations with me if i kindly ask them
the board.bin has a specific file format this can be easily detected. 
the flash memory contains 2 board.bin files, for each of the both cards.
since the mtd partition where this all is stored is named art there is 
also another indicator. you may not know it, but the name of the 
qca/atheros calibration software is "art".

> I know that Netgear provided a myriad of different board data files
> with in there GPL drop:
you can ignore them. use the files stored in flash memory. this board 
data is the calibration data which is different for each device you buy. 
its precalibrated and stored in flash memory.
a normal wifi card has a own eeprom on it which stores this data. but on 
embedded devices the routers own flash memory is used for storing this data.
this case is mainly ignored by drivers like ath10k, so patches are 
required right now until ath10k does officially support these conditions
> Here's a link:
> <https://github.com/paul-chambers/netgear-r7800/tree/master/git_home/madwifi-11n.git/halphy_tools/host/eepromUtil/release_qca9984/hw1>
i know the gpl tree
> So, does the data in your flash matches any of those files 1:1 or not?
nope. these files are just default files shipped with the driver by qca
> (Note: From what I know, it's the caldata that's in the flash.
> caldata ≈ cal+board. But I'm asking why ath10k's bmi identification
> isn't working for those chips right now. And judging from your logs,
> you are using probably a similar WA to the
> 936-ath10k_skip_otp_check.patch out of necessity as well.)
the board.bin is the caldata and configuration set for the card.
the skip otp check patch is required in any way since the cards has no 
on board eeprom
if bmi identification fails, the api 1 board-2.bin file is loaded as 
alternate variant and this is exactly the data which is stored in flash 
memory.
>> there are 2 stored for both cards. you need to patch ath10k to use
>> different board.bin files for each card.
> Exactly. Why do you (or anyone for that matter) need to patch ath10k?
> The driver is supposed to support the QCA9984 out of the box, right?
it is supposed, but thats not the case. ath10k mainly supports cards 
with own on board eeprom.
embedded routers can be very specific and nonstandard, so customizations 
are required sometimes.
you may not like it, but i know this device very well and also others. 
consider how the skip otp patch was created.
its a workaround which is only required for routers.
> And I know, that the bmi identification is supposed to work, as
> somebody posted the following log:
> <http://lists.infradead.org/pipermail/lede-dev/2016-December/004987.html>
>
> [  379.392210] ath10k_pci 0002:01:00.0: boot upload otp to 0x1234 len 9000 for board id
> [  379.399945] ath10k_pci 0002:01:00.0: bmi fast download address 0x1234 buffer 0xe1676038 length 9000
> [  379.408977] ath10k_pci 0002:01:00.0: bmi lz stream start address 0x1234
> [  379.415603] ath10k_pci 0002:01:00.0: bmi lz data buffer 0xe1676038 length 9000
> [  379.451626] ath10k_pci 0002:01:00.0: bmi lz stream start address 0x0
> [  379.457985] ath10k_pci 0002:01:00.0: bmi execute address 0x1234 param 0x10
> [  380.857006] ath10k_pci 0002:01:00.0: bmi execute result 0x400
> [  380.862749] ath10k_pci 0002:01:00.0: boot get otp board id result 0x00000400 board_id 1 chip_id 0
> [  380.871603] ath10k_pci 0002:01:00.0: boot using board name 'bus=pci,bmi-chip-id=0,bmi-board-id=1'
> [  380.880468] ath10k_pci 0002:01:00.0: board name
> [  380.884999] ath10k_pci 0002:01:00.0: 00000000: 62 75 73 3d 70 63 69 2c 62 6d 69 2d 63 68 69 70  bus=pci,bmi-chip
> [  380.895159] ath10k_pci 0002:01:00.0: 00000010: 2d 69 64 3d 30 2c 62 6d 69 2d 62 6f 61 72 64 2d  -id=0,bmi-board-
> [  380.905317] ath10k_pci 0002:01:00.0: 00000020: 69 64 3d 31                                      id=1
> [  380.914436] ath10k_pci 0002:01:00.0: boot found match for name 'bus=pci,bmi-chip-id=0,bmi-board-id=1'
> [  380.923640] ath10k_pci 0002:01:00.0: boot found board data for 'bus=pci,bmi-chip-id=0,bmi-board-id=1'
> [  380.932845] ath10k_pci 0002:01:00.0: using board api 2
> ...
>
> The board name for the QCA9984 is supposed to look like
> "'bus=pci,bmi-chip-id=0,bmi-board-id=1'"
>
> and not like (from your log):
sure. you can load wrong board data into your card this may result in 
the following situation a 5 ghz card is shown as 2.4 ghz card and vice 
versa or even dualband also if the card is not supporting this. this may 
not be the case on the r7800 but i know another device where this is the 
bevaviour. power calibration set is wrong in any way so output power may 
be lower as expected.
and the resulting operation state will not work in best way. lede does 
not support this device in correct way.
wrong board data can also destroy the hardware. this may not happen 
fast, but using wrong power calibration data may destroy the phy over 
time by overheating

take a look on your router. especially on mtd3
mtd3: 00140000 00020000 "art"

dump this partition and take a look inside and take a guess what you 
will find. offset 0x1000 is first board data. offset 0x5000 is second 
board data
this is common for almost all wireless routers on the market. i dont 
know a single router with a qca or atheros chipset on the market which 
does not have stored the board data in flash memory


>> bus=pci,vendor=168c,device=0046,subsystem-vendor=168c,subsystem-device=cafe
>> from ath10k/QCA9984/hw1.0/board-2.bin
>> the failed to fetch board data error is normal.
> I don't think it is. I think it's a regression.
ahm no. you dont know what you're dealing with.
>
> Thanks,
> Christian
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
