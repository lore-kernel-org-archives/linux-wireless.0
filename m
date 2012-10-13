Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:63167 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2JMUqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 16:46:11 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so2645553lag.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2012 13:46:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121007113348.42ba05fa@milhouse>
References: <0C7D424D957547489E16A29D0D15433494C29E7FE8@AMKMS11.ad.turkuamk.fi>
	<CAKoUArnsntysudq3CRric4gb3eUOLq2f9ppkUGxbqWhSZp7yhg@mail.gmail.com>
	<5070944B.4010205@lwfinger.net>
	<20121007113348.42ba05fa@milhouse>
Date: Sat, 13 Oct 2012 22:46:09 +0200
Message-ID: <CAGXs5wXz7f8=Dz4BTmbLAmRXC4Cos2w9yGpJ9cmNKsq+_Qh2Pg@mail.gmail.com> (sfid-20121013_224619_600768_D98E5D9E)
Subject: Re: OpenFWWF for b43
From: Kevin Wilson <wkevils@gmail.com>
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Rami Rosen <roszenrami@gmail.com>,
	=?ISO-8859-1?Q?Mikko_V=2E_Viinam=E4ki?=
	<Mikko.Viinamaki@students.turkuamk.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
It could be that I am missing something.
I tried building the firmware as explained here.
Under  b43_v4.6 one firmware (extension fw) file
is created, named: ucode5.fw.

I have LinkSys WRTG54GL with backfire (10.03.x).
I am using b43 driver.

I ran:
insmod b43.ko
and got:
b43-phy0: Broadcom 5352 WLAN found (core revision 9)
phy0: Selected rate control algorithm 'minstrel'
Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]

which seems OK.

Now I copied ucode5.fw to:
/lib/firmware/b43 on the device.

I run:
hostapd /etc/hostapd.

I get this message in the kernel log:

b43 ssb0:3: firmware: requesting b43/ucode5.fw
b43 ssb0:3: firmware: requesting b43/pcm5.fw
b43 ssb0:3: firmware: requesting b43/b0g0initvals5.fw
b43 ssb0:3: firmware: requesting b43-open/ucode5.fw
b43-phy0 ERROR: Firmware file "b43/b0g0initvals5.fw" not found
b43-phy0 ERROR: Firmware file "b43-open/ucode5.fw" not found
b43-phy0 ERROR: You must go to
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and
download the correct firmware for this driver version. Please
carefully read all instructions on this website.



Now, I noticed two things:
1) it asks also for other firmware files. Isn't the  ucode5.fw
file the only one needed ?
2) It also looks for "b43-open" folder, not only for "b43".

Could it be that the driver I am using is not updated and
does not support this OpenFWWF firmware ?
(backfire has 2.6.32.27 kernel).

Or should there be some additional firmware from somewhere else ?

rgs,
Kevin


On Sun, Oct 7, 2012 at 11:33 AM, Michael Büsch <m@bues.ch> wrote:
> On Sat, 06 Oct 2012 15:27:55 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> That repo was converted from HTTP to GIT form some time ago. The correct request is
>>
>> git clone git://git.bu3sch.de/git/b43-tools.git
>>
>> It appears, however, the git.bu3sch.de is down.
>
> The bu3sch.de domain is no longer registered (by me). All services are available
> under bues.ch now.
>
> git clone git://git.bues.ch/git/b43-tools.git
>
> --
> Greetings, Michael.
>
> PGP encryption is encouraged / 908D8B0E
