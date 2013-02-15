Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.clear.net.nz ([203.97.33.64]:35036 "EHLO
	smtp3.clear.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120Ab3BOGma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 01:42:30 -0500
Received: from mxin2-orange.clear.net.nz
 (lb2-srcnat.clear.net.nz [203.97.32.237])
 by smtp3.clear.net.nz (CLEAR Net Mail)
 with ESMTP id <0MI9003JE0KGE030@smtp3.clear.net.nz> for
 linux-wireless@vger.kernel.org; Fri, 15 Feb 2013 19:26:46 +1300 (NZDT)
Date: Fri, 15 Feb 2013 19:26:12 +1300
From: Kevin & Pauline Gordon <kgordon@paradise.net.nz>
Subject: RE: Writing application code using sd8686
In-reply-to: <CAGRGNgWBYOJeLnA64yT4Pp0JOd50UqnndA98Jmq1kRd25Fn-ZA@mail.gmail.com>
To: 'Julian Calaby' <julian.calaby@gmail.com>
Cc: 'linux-wireless' <linux-wireless@vger.kernel.org>
Message-id: <A91BB000EAB44D40A1C1EF25B3CD8761@KGDOMAIN.local> (sfid-20130215_074234_925844_BF17D386)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <loom.20130214T000819-590@post.gmane.org>
 <CAGRGNgU4akuP=iKqUqpNbztB7P6DECm=-ug6QKxtsJdvMd9iCg@mail.gmail.com>
 <4A04400646FF41AE84629E8D1443AA89@KGDOMAIN.local>
 <CAGRGNgWBYOJeLnA64yT4Pp0JOd50UqnndA98Jmq1kRd25Fn-ZA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,
Thank you for your reply. Please refer to my answers below.

-----Original Message-----
From: Julian Calaby [mailto:julian.calaby@gmail.com] 
Sent: Friday, 15 February 2013 6:00 p.m.
To: Kevin & Pauline Gordon
Cc: linux-wireless
Subject: Re: Writing application code using sd8686

Hi Kevin,

Firstly, please CC linux-wireless or reply to all. I don't support or
assist people off-list. Also, don't top post. Quote the relevant parts
of the email you're replying to, then respond to them underneath. This
helps people to quickly read the entire discussion.

On Fri, Feb 15, 2013 at 2:55 PM, Kevin & Pauline Gordon
<kgordon@paradise.net.nz> wrote:
> Hi Julian,
>
> My main interest is wireless control of a robot
> (http://www.rescuerobot.org). I have been writing code in C# for a System
on
> Module board using http://www.ghielectronics.com/catalog/product/128 and
> http://www.ghielectronics.com/catalog/product/379 . The supplier has been
> struggling with software problems
> http://www.tinyclr.com/forum/topic?id=10844&page=3#msg108916 so I thought
I
> would experiment with Linux hence purchased an excellent board at
> http://www.isee.biz/products/processor-boards/igepv2-board . After writing
a
> mass of C# code in NETMF (tinyclr) and regretting it, I am now enjoying
> configuring wifi on the IGEPV2 (poky to ubuntu) using the libertas module
in
> Poky.

"Sounds interesting.

The advice I'm going to give you assumes that the board on the robot
is running Linux. If it isn't then this is not really the right place
to be asking this question."

I am using Poky and Ubuntu which are both Linux.

" If you're after .NET code to operate the
wireless module directly without the help of Linux or the standard
Linux wireless tools, you'll need to contact Marvell, the manufacturer
of the board, or write it yourself."

I have setup eclipse for C/C++ on Linux (Poky and Ubuntu):

> I have setup eclipse on ubuntu and wish to start writing c/c++ code to
> experiment with linux wireless. The IGEPV2 contains a Marvell 88w8686B1.
>
> Is there a SDK or example code available on the net for the Marvell
> 88w8686B1. I have downloaded the driver package from Marvell which
contains
> the source code for SD8686 (Marvell88w8686_d0acbab79fde.rar). I have no
> experience of programming in the Linux environment but have plenty of
books
> to help.

"I assume that you want to transmit data using TCP or UDP sockets over
a wireless link between the robot and some other device. I'm also
going to assume that some third device will be an access point and
both the robot and the other device will connect to it."

I will use TCP sockets over a wireless link. The third device will be an
access point.

"You need to do three things:
1. Ensure that the driver is installed and working
2. Establish a wireless link.
3. Obtain or set an IP address.
4. Determine the remote IP address.
5. Establish a socket connection between the two computers."

"For 1, from what you've said above, it seems that this is already done." 

Done.

"For 2 and 3, the simplest way would be to install the network-manager
daemon and talk to it over d-bus, and there are modules for Mono /
.NET to communicate over d-bus. There may even be modules for Mono /
.NET to interface directly with network manager. Note that there are
other tools that perform the same functions, e.g. wicd or Connman and
you should be able to interface with them in a similar manner."

I will not be using Mono.

"If that's not an option, you'll have to do it more manually. There may
be tools installed on the board to help you, or you could install
wpa_supplicant and configure it to maintain the wireless connection
for you. Note that wpa_supplicant can be controlled and configured
over d-bus. wpa_supplicant only manages the connection, and setting or
obtaining an IP address must be done separately. If you're using a
static IP address, you could use ifconfig, which should already be
installed, to set it. If you want a dynamic IP address and use DHCP,
you'll need to ensure that a DHCP client is installed and determine
how to operate it. You'll then have to figure out some way to run
these tools after wpa_supplicant connects to the wireless network."

Today in Poky (embedded Linux) I have configured wpa_supplicant.conf and
interfaces files. I am able to use ssh in Ubuntu to command Poky (via wired)
and use Tera Term in Windows (via wifi) to command Poky. The IGEPV2 board
(6.5cm x 9cm) has Poky installed with the libertas module. It also can have
a DVI screen, usb mouse and usb keyboard plugged in.

"4 and 5 are beyond the scope of the advice I can give you as I have no
experience with .NET, but once the wireless link is connected and IP
address set, everything works exactly the same as communicating over
any other IP network."

I will not be using .NET. I need help with getting started with Linux C/C++.

"Oh, one last thing: this advice applies to practically any wireless
device on any system running Linux."

I do wish to write C/C++ code for TCP sockets. There will be much data
feeding back from the robot which the user of the PC will consider before
using the graphical interface to send command data back to the robot.

Also I wish to use the libertas "library" to initiate a connection and IP
address. Is this possible?

> I would much appreciate your advice.
>
> Regards,
> Kevin Gordon
>
>
> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Thursday, 14 February 2013 5:36 p.m.
> To: Kevin Gordon
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: Writing application code using sd8686
>
> Hi Kevin,
>
> On Thu, Feb 14, 2013 at 10:13 AM, Kevin Gordon <kgordon@paradise.net.nz>
> wrote:
>> Is it possible to write C/C++ code to use sd8686.bin driver? Is there a
> SDK or
>> header/source files available? I would much appreciate your advice.
>
> What exactly are you trying to do here?
>
> sd8686.bin is the firmware image for Marvell 8686 wireless cards, not
> a driver as such.
>
> If you're after a driver to use those cards under Linux, you need to
> ensure that your kernel the "libertas" driver available.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/


Is there any example code in C/C++?

Many thanks everyone.

Kevin Gordon

