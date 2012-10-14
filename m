Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56476 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab2JNM1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 08:27:50 -0400
Message-ID: <507AAFB8.1090906@hauke-m.de> (sfid-20121014_142753_787017_62BB2244)
Date: Sun, 14 Oct 2012 14:27:36 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Kevin Wilson <wkevils@gmail.com>
CC: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Rami Rosen <roszenrami@gmail.com>,
	=?ISO-8859-1?Q?=22Mikko_V=2E_Viin?= =?ISO-8859-1?Q?am=E4ki=22?=
	<Mikko.Viinamaki@students.turkuamk.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: OpenFWWF for b43
References: <0C7D424D957547489E16A29D0D15433494C29E7FE8@AMKMS11.ad.turkuamk.fi> <CAKoUArnsntysudq3CRric4gb3eUOLq2f9ppkUGxbqWhSZp7yhg@mail.gmail.com> <5070944B.4010205@lwfinger.net> <20121007113348.42ba05fa@milhouse> <CAGXs5wXz7f8=Dz4BTmbLAmRXC4Cos2w9yGpJ9cmNKsq+_Qh2Pg@mail.gmail.com>
In-Reply-To: <CAGXs5wXz7f8=Dz4BTmbLAmRXC4Cos2w9yGpJ9cmNKsq+_Qh2Pg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

On 10/13/2012 10:46 PM, Kevin Wilson wrote:
> Hi,
> It could be that I am missing something.
> I tried building the firmware as explained here.
> Under  b43_v4.6 one firmware (extension fw) file
> is created, named: ucode5.fw.

Isn't version 5.2 the latest open firmware for these broadcom devices?
Why are you using version 4.6?

> I have LinkSys WRTG54GL with backfire (10.03.x).

You could also build your own OpenWrt image and select the open firmware
in menuconfig. Then you do not have to do it yourself. I do not know if
this option is available in backfire, but it should work in trunk.

> I am using b43 driver.
> 
> I ran:
> insmod b43.ko
> and got:
> b43-phy0: Broadcom 5352 WLAN found (core revision 9)
> phy0: Selected rate control algorithm 'minstrel'
> Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]
> 
> which seems OK.
> 
> Now I copied ucode5.fw to:
> /lib/firmware/b43 on the device.
> 
> I run:ucode5.fw
> hostapd /etc/hostapd.
> 
> I get this message in the kernel log:
> 
> b43 ssb0:3: firmware: requesting b43/ucode5.fw
> b43 ssb0:3: firmware: requesting b43/pcm5.fw
> b43 ssb0:3: firmware: requesting b43/b0g0initvals5.fw
> b43 ssb0:3: firmware: requesting b43-open/ucode5.fw
> b43-phy0 ERROR: Firmware file "b43/b0g0initvals5.fw" not found
> b43-phy0 ERROR: Firmware file "b43-open/ucode5.fw" not found
> b43-phy0 ERROR: You must go to
> http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and
> download the correct firmware for this driver version. Please
> carefully read all instructions on this website.
> 
> 
> 
> Now, I noticed two things:
> 1) it asks also for other firmware files. Isn't the  ucode5.fw
> file the only one needed ?

You also need the initivals (b0g0bsinitvals5.fw and b0g0initvals5.fw) in
addition to the firmware itself (ucode5.fw).

> 2) It also looks for "b43-open" folder, not only for "b43".

OpenWrt takes b43 from compat-wireless, so OpenWrt 10.03.1 contains b43
from round about a year ago and not from kernel version 2.6.32.27. This
version searches in b43-open for the open source firmware and not in b43.

> Could it be that the driver I am using is not updated and
> does not support this OpenFWWF firmware ?
> (backfire has 2.6.32.27 kernel).
> 
> Or should there be some additional firmware from somewhere else ?
> 
> rgs,
> Kevin
> 
> 
> On Sun, Oct 7, 2012 at 11:33 AM, Michael Büsch <m@bues.ch> wrote:
>> On Sat, 06 Oct 2012 15:27:55 -0500
>> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>>> That repo was converted from HTTP to GIT form some time ago. The correct request is
>>>
>>> git clone git://git.bu3sch.de/git/b43-tools.git
>>>
>>> It appears, however, the git.bu3sch.de is down.
>>
>> The bu3sch.de domain is no longer registered (by me). All services are available
>> under bues.ch now.
>>
>> git clone git://git.bues.ch/git/b43-tools.git
>>
>> --
>> Greetings, Michael.
>>
>> PGP encryption is encouraged / 908D8B0E
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

