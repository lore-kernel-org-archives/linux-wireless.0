Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:60449 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751813AbdC0Lz3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 07:55:29 -0400
To: Christian Lamparter <chunkeey@googlemail.com>
References: <3243718.FYinmXYgr7@debian64> <3143301.IOZImBPhRt@debian64>
 <20d2aa5c-c0a6-f14b-9694-4e4384299d25@dd-wrt.com>
 <1843566.sGKvOoxMzK@debian64>
Cc: ath10k@lists.infradead.org,
        ath10k-devel <ath10k-devel@qca.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "linux-wireless (linux-wireless@vger.kernel.org)"
        <linux-wireless@vger.kernel.org>, hannu.nyman@iki.fi,
        Adrian Chadd <adrian@freebsd.org>,
        "K.Mani" <sailormani@gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <c4add4e6-a6ba-bc17-0543-01292d4371e4@dd-wrt.com> (sfid-20170327_135640_193617_2E4ED571)
Date: Mon, 27 Mar 2017 13:33:54 +0200
MIME-Version: 1.0
In-Reply-To: <1843566.sGKvOoxMzK@debian64>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: QCA9984 bmi identification failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>
>>> On Friday, March 24, 2017 11:09:03 AM CET Sebastian Gottschall wrote:
>>> i have a r7800 running. consider to use the board.bin file which is
>>> stored in flash memory of the r7800.
>>> there are 2 stored for both cards. you need to patch ath10k to use
>>> different board.bin files for each card.
>>> this is a log from a working r7800 running dd-wrt. the failed to fetch
>>> board data error is normal. it will use api1 board files then which i
>>> provide on fs based on the board data stored in flash memory
> What makes you think that what you do with the data in the flash is
> the "board.bin"? Do you have any documentation to back up your statement?
> I know that you have been reporting about the QCA99x0. there even
> is a patch with your "reported-by" tag:
> "ath10k: fix calibration init sequence of qca99x0".
> <http://lists.infradead.org/pipermail/ath10k/2016-March/007173.html>
this question has been already answered. take it as a fact or find it 
out by yourself. i dont know how to prove you that the firmware format 
is identical without simply showing you the hexdump which you can do by 
yourself
use the correct data, insert it to the driver using hotplug. thats it.
the mail you are refering to is not related to the source of the 
calibration data
>
> Clearly, you must have read it. So you know that:
> "[...] whereas calibration file is used by ar9888 and qca99x0 that contains
> both board data and caldata. [...]"
and? the mail is about a fix in a structure but says nothing about the 
content of a board.bin file
>
> which is what I said in the response as well. we both knew that
> (from the beginning). If you want you can go on about it:
> Please do. However, you should provide some data to back up your
> claims and statements (logs, links to code or patches are fine I think).
> Furthermore, let's keep the discussion civil and not go off on a
> tangent and start a pissing contest. And finally, let's not forget
> that the discussion is about the "QCA9984 bmi identification failure".
ahm. sorry. we stop here.
you asked a question. i was kind enough to answer it. i do not claim 
anything and i dont have you proof anything. i have my working firmware 
using the correct data on multiple devices
its up to you if you believe me or not.
>>> the failed to fetch board data error is normal.
> Why do you need to patch the ath10k driver? And why is it, that even
> you have patched it, ath10k is still producing an error message? And
> why is it normal(save?) to ignore it?
i patched it. but i also found out that you may use the hotplug event of 
the driver  to load it per card.
in addition i talked with nbd from lede about the caldata problem on the 
r7800 and he is aware of it and told me it will be fixed soon
>
>>> I know that Netgear provided a myriad of different board data files
>>> with in there GPL drop:
>> you can ignore them. use the files stored in flash memory. this board
>> data is the calibration data which is different for each device you buy.
>> its precalibrated and stored in flash memory.
> If this was the case, then why does the ath10k-firmware and codeaurora.org
> provide the board files in the firmware repositories?
its a default set and "again" not related to embedded devices. and second
please ask qca if you want to know why something is done by qca
> <https://github.com/kvalo/ath10k-firmware/tree/master/QCA9984/hw1.0>
> <https://source.codeaurora.org/quic/qsdk/oss/firmware/ath10k-firmware/plain/ath10k/QCA9984/hw1.0/>
>   
> Also, why does ath10k insist on requesting the board-2.bin files, even after
> it has loaded the calibration file which is supposed to contain both
> (for the QCA9984 and others)?
its chipset specific. the file is different for each chipset and also 
the content.
but board-2.bin doesnt matter here. this is api 2. the routers are only 
using api 1 files which are named board.bin which are stored in the 
flash memory.
the board-2.bin can contain multiple board datas for different card 
configurations like 2.4 and 5 ghz or both. the board.bin is a single 
calibration data file for a chipset
it also stores the mac address for your card. without using the correct 
file your card wont get the correct mac address. lede does patch the 
board.bin on some devices to correct this
> Would it be easier just to request "one file" and not two different files
> with the same content?
its not the same content. the flash contains 2 files which are 
different. one is made for 2.4 ghz 9984 and the second is done for the 5 
ghz 9984
>
> Note: I know that LEDE currently puts the data from the flash
> into the cal-pci-0000:01:00.0.bin and creates a symlink to "board.bin".
> <https://git.lede-project.org/?p=source.git;a=blob;f=package/firmware/ath10k-firmware/Makefile;h=febf7d26794bd8c5b34bd6703e88cf8070e213a1;hb=HEAD#l323>
> I expect to see something similar in DD-WRT. If not, please tell us about your
> method.
similar method, yes but different implementation. result is the same. 
you just need the correct data extracted from the "art" partitition 
offset 0x1000 and offset 0x5000 (consider to use the correct filesize)
and then recreate the links to point to the correct data.
>
>> a normal wifi card has a own eeprom on it which stores this data. but on
>> embedded devices the routers own flash memory is used for storing this data.
>> this case is mainly ignored by drivers like ath10k, so patches are
>> required right now until ath10k does officially support these conditions
> The QCA9984 support was added by this patch back in August 2016:
> "ath10k: enable support for QCA9984"
> https://patchwork.kernel.org/patch/8890981/
this is chipset support. i was talking about firmware loading methods
>
> At this point, I think ath10k should support the QCA9984 in the R7800
> "out of the box" without any need for special or custom patches.
> LEDE's compat-wireless is dated 2017-01-31.
its possible by using the firmware hotplug event and the way you 
described with symbolic links
>> the board.bin is the caldata and configuration set for the card.
>> the skip otp check patch is required in any way since the cards has no
>> on board eeprom
>> if bmi identification fails, the api 1 board-2.bin file is loaded as
>> alternate variant and this is exactly the data which is stored in flash
>> memory.
> Two points:
>
> - skip_otp is mentioned in a patch from 2014 (long before
> the QCA9984) <https://patchwork.kernel.org/patch/5252351/>
> The commit log says: "It is useful for initial calibration."
> This does sound like this feature is used for "product development"
> if it is used for something else (QCA6174, QCA9377?),
> the description:
> | MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
> should be upgraded.
this patch has been made a long time ago by me and i provided the info 
to lede and they made a own variant.
some cards like yours do not have a otp. so the result of the otp 
calibration needs to be ignored.
the reason is that your card has no own eeprom stored per chipset which 
is normal for minipci express cards with such chipsets.
it contains the calibration data, mac address, chipset configuration. etc.
on the r7800 like on most other routers its stored in the routers own 
flash memory. i told this already.
so the otp calibration will fail. if the result is ignored the 
calibration data will be loaded from file and all is fine
>
> Note: skip_otp doesn't skip over the BMI identification.
> Instead it just instructs the code to ignore the result from it.
> So setting skip_otp will not help here, since bmi_execute is
> returing -ETIMEDOUT.
> <http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath10k/core.c#L742>
>
> - board api 1 was not intended to be used for QCA99X0+.
> In fact, the patch:"ath10k: add board 2 API support".
> <https://patchwork.kernel.org/patch/7334851/> which added it
> lists the 99X0 (predecessor of the 9984?) as a target (altought
> the ath10k-firmware repository still has the old file).
> The board api 1 was just left as a fallback.
it must be used. its the only available format on this router. the 
original qca driver which is used by netgear (they do not use ath10k) 
does not know anything about bmi / api 2

>
>> sure. you can load wrong board data into your card this may result in
>> the following situation a 5 ghz card is shown as 2.4 ghz card and vice
>> versa or even dualband also if the card is not supporting this. this may
>> not be the case on the r7800 but i know another device where this is the
>> bevaviour. power calibration set is wrong in any way so output power may
>> be lower as expected.
>> and the resulting operation state will not work in best way. lede does
>> not support this device in correct way.
>> wrong board data can also destroy the hardware. this may not happen
>> fast, but using wrong power calibration data may destroy the phy over
>> time by overheating
>>
>> take a look on your router. especially on mtd3
>> mtd3: 00140000 00020000 "art"
>>
>> dump this partition and take a look inside and take a guess what you
>> will find. offset 0x1000 is first board data. offset 0x5000 is second
>> board data
>> this is common for almost all wireless routers on the market. i dont
>> know a single router with a qca or atheros chipset on the market which
>> does not have stored the board data in flash memory
> Well, "almost all wireless routers on the martket" does it include older ath9k too?
yes also ath9k uses calibration data from flash memory. its stored in 
platform data and provided by the kernel implementation for the device
> If so, then there's the Aerohive HiveAP 121.
> <https://github.com/riptidewave93/LEDE-HiveAP-121>. It has an AR934x SoC
> and the internal WMAC is storing its calibration data in the SoC's OTP area.
> The device is supported by ath9k. The device does have a wifi-cal/art
> partition but it was empty.
need to take a look into a flash memory dump so see if i find the 
calibration data. the partition you see is created by lede as 
preconfigured layout.
it doesnt mean that the offsets are correct. and the kernel doesnt need 
the partition to read data from flash memory. look into the lede 
sourcecode at the various mach-.....c files to see how its handled
> There are simply too many devices, to keep track of each one and
> each is a little bit different.
most store the data in the last flash sector. not much difference for 
many vendors
>
>>>> bus=pci,vendor=168c,device=0046,subsystem-vendor=168c,subsystem-device=cafe
>>>> from ath10k/QCA9984/hw1.0/board-2.bin
>>>> the failed to fetch board data error is normal.
>>> I don't think it is. I think it's a regression.
>> ahm no. you dont know what you're dealing with.
> I reported that Hannu Nyman has an issue with the QCA9984 in his Netgear R7800.
> The BMI Identification isn't working as expected... I asked on the ML what's
> going on and if they could take a look. Let's see if anyone has a good idea or
> suggestion. I know that people are able to get the correct bmi identification
> too (see 5G_success_log.txt from Mani), but it is not working for everyone.
>
> Thanks,
> Christian


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
