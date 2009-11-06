Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:61846 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZKFS1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:27:12 -0500
Received: by ewy28 with SMTP id 28so1433311ewy.18
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 10:27:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911061822.17121.mb@bu3sch.de>
References: <ba4215e10911060819y1175e003g695281fe084e07ab@mail.gmail.com>
	 <200911061822.17121.mb@bu3sch.de>
Date: Fri, 6 Nov 2009 19:27:17 +0100
Message-ID: <ba4215e10911061027t413d2c34g8ad66a7982f7c43c@mail.gmail.com>
Subject: Re: b43: firmware loading problem and sleeping BUG
From: Martin Fuzzey <mfuzzey@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 6:22 PM, Michael Buesch <mb@bu3sch.de> wrote:
> These logs look weird. Is that the full log from "dmesg" command?
Yes - I've just stripped the timestamps

> I guess the pcmcia_access_configuration_register() is doing nonatomic vmalloc stuff.
>
Indeed looks like its iounmap() that eventually gets called from there.

> I think this is easy to fix, because we can replace the spinlock by a mutex, as
> the b43 driver (which is the only user of the code) always allows sleeping now.
> I'll send a patch for testing soon.
>
Great - happy to test it.

>> b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
>> b43-phy0 ERROR: Initial Values Firmware file-format error.
>> b43-phy0 ERROR: You must go to
>>
>> Any ideas why the versions don't match?
>
> These are two different version numbers. One for the broadcom driver
> and one for the firmware.
>
Ok so I do have the correct firmware.

I seem to be having very non deterministic behaviour regarding
the firmware loading.

Sometimes I get the behaviour above (which I trace to the first test
in b43_write_initvals().

And sometimes I get this behaviour:

pcmcia driver load:
[  102.850000] ssb: Sonics Silicon Backplane found on PCMCIA device pcmcia0.0

[  102.880000] b43-phy0: Broadcom 4318 WLAN found (core revision 9)

[  102.990000] b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7

[  103.010000] b43-phy0 debug: Found Radio: Manuf 0x17F, Version
0x2050, Revision 8

[  105.610000] phy0: Selected rate control algorithm 'minstrel'

[  105.650000] Broadcom 43xx driver loaded [ Features: M, Firmware-ID: FW13 ]


First ifconfig wlan0 up (note it's trying to use the open firmware -
which I don't have):
[  108.770000] b43 ssb0:0: firmware: requesting b43/ucode5.fw

[  108.910000] b43 ssb0:0: firmware: requesting b43/pcm5.fw

[  109.170000] b43 ssb0:0: firmware: requesting b43-open/ucode5.fw

[  109.330000] b43 ssb0:0: firmware: requesting b43-open/pcm5.fw

[  109.520000] b43 ssb0:0: firmware: requesting b43-open/b0g0initvals5.fw

[  109.690000] b43-phy0 ERROR: Firmware file "b43/pcm5.fw" format error.

[  109.760000] b43-phy0 ERROR: Firmware file
"b43-open/b0g0initvals5.fw" not found

[  109.960000] b43-phy0 ERROR: You must go to
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and
download the correct firmware for this driver version. Please
carefully read all instructions on this website.


Second ifconfig wlan0 up (no reboot):
[  157.730000] b43 ssb0:0: firmware: requesting b43/ucode5.fw

[  157.860000] b43 ssb0:0: firmware: requesting b43/pcm5.fw

[  158.040000] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw

[  158.310000] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw

[  158.940000] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)

[  159.010000] b43-phy0 debug: Chip initialized

[  159.030000] b43-phy0 debug: PIO initialized

[  159.040000] b43-phy0 debug: QoS enabled

[  159.070000] b43-phy0 debug: Wireless interface started

[  159.130000] b43-phy0 debug: Adding Interface type 2


Yay - and iwlist scanning works (haven't tried associating yet)

And sometimes even after mutiple ups it gives up and the microcode
doesn't reply...

So any suggestions on figuring out what is going on?
>
> Thanks for testing. The ssb-pcmcia code is not tested a lot, so
> I'm not surprised that there are bugs.
>
You're welcome

Cheers,

Martin
