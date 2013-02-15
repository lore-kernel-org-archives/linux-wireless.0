Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53900 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3BOFAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 00:00:09 -0500
Received: by mail-wi0-f181.google.com with SMTP id hm6so683440wib.8
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 21:00:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4A04400646FF41AE84629E8D1443AA89@KGDOMAIN.local>
References: <loom.20130214T000819-590@post.gmane.org> <CAGRGNgU4akuP=iKqUqpNbztB7P6DECm=-ug6QKxtsJdvMd9iCg@mail.gmail.com>
 <4A04400646FF41AE84629E8D1443AA89@KGDOMAIN.local>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 15 Feb 2013 15:59:47 +1100
Message-ID: <CAGRGNgWBYOJeLnA64yT4Pp0JOd50UqnndA98Jmq1kRd25Fn-ZA@mail.gmail.com> (sfid-20130215_060016_230362_11832E0B)
Subject: Re: Writing application code using sd8686
To: "Kevin & Pauline Gordon" <kgordon@paradise.net.nz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
> (http://www.rescuerobot.org). I have been writing code in C# for a System on
> Module board using http://www.ghielectronics.com/catalog/product/128 and
> http://www.ghielectronics.com/catalog/product/379 . The supplier has been
> struggling with software problems
> http://www.tinyclr.com/forum/topic?id=10844&page=3#msg108916 so I thought I
> would experiment with Linux hence purchased an excellent board at
> http://www.isee.biz/products/processor-boards/igepv2-board . After writing a
> mass of C# code in NETMF (tinyclr) and regretting it, I am now enjoying
> configuring wifi on the IGEPV2 (poky to ubuntu) using the libertas module in
> Poky.

Sounds interesting.

The advice I'm going to give you assumes that the board on the robot
is running Linux. If it isn't then this is not really the right place
to be asking this question. If you're after .NET code to operate the
wireless module directly without the help of Linux or the standard
Linux wireless tools, you'll need to contact Marvell, the manufacturer
of the board, or write it yourself.

> I have setup eclipse on ubuntu and wish to start writing c/c++ code to
> experiment with linux wireless. The IGEPV2 contains a Marvell 88w8686B1.
>
> Is there a SDK or example code available on the net for the Marvell
> 88w8686B1. I have downloaded the driver package from Marvell which contains
> the source code for SD8686 (Marvell88w8686_d0acbab79fde.rar). I have no
> experience of programming in the Linux environment but have plenty of books
> to help.

I assume that you want to transmit data using TCP or UDP sockets over
a wireless link between the robot and some other device. I'm also
going to assume that some third device will be an access point and
both the robot and the other device will connect to it.

You need to do three things:
1. Ensure that the driver is installed and working
2. Establish a wireless link.
3. Obtain or set an IP address.
4. Determine the remote IP address.
5. Establish a socket connection between the two computers.

For 1, from what you've said above, it seems that this is already done.

For 2 and 3, the simplest way would be to install the network-manager
daemon and talk to it over d-bus, and there are modules for Mono /
.NET to communicate over d-bus. There may even be modules for Mono /
.NET to interface directly with network manager. Note that there are
other tools that perform the same functions, e.g. wicd or Connman and
you should be able to interface with them in a similar manner.

If that's not an option, you'll have to do it more manually. There may
be tools installed on the board to help you, or you could install
wpa_supplicant and configure it to maintain the wireless connection
for you. Note that wpa_supplicant can be controlled and configured
over d-bus. wpa_supplicant only manages the connection, and setting or
obtaining an IP address must be done separately. If you're using a
static IP address, you could use ifconfig, which should already be
installed, to set it. If you want a dynamic IP address and use DHCP,
you'll need to ensure that a DHCP client is installed and determine
how to operate it. You'll then have to figure out some way to run
these tools after wpa_supplicant connects to the wireless network.

4 and 5 are beyond the scope of the advice I can give you as I have no
experience with .NET, but once the wireless link is connected and IP
address set, everything works exactly the same as communicating over
any other IP network.

Oh, one last thing: this advice applies to practically any wireless
device on any system running Linux.

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
