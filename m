Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.clear.net.nz ([203.97.37.64]:44391 "EHLO
	smtp4.clear.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3BOWTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 17:19:09 -0500
Received: from mxin2-orange.clear.net.nz
 (lb2-srcnat.clear.net.nz [203.97.32.237])
 by smtp4.clear.net.nz (CLEAR Net Mail)
 with ESMTP id <0MIA006O87YR2Y10@smtp4.clear.net.nz> for
 linux-wireless@vger.kernel.org; Sat, 16 Feb 2013 11:04:05 +1300 (NZDT)
Date: Sat, 16 Feb 2013 11:03:26 +1300
From: Kevin & Pauline Gordon <kgordon@paradise.net.nz>
Subject: RE: Writing application code using sd8686
In-reply-to: <CAGRGNgUnSuALDpZME=YrSDwTJQew+kdUHRrZskJBob8HHGcqVQ@mail.gmail.com>
To: 'Julian Calaby' <julian.calaby@gmail.com>
Cc: 'linux-wireless' <linux-wireless@vger.kernel.org>
Message-id: <E09AA5D37894474C897FDF8284D04380@KGDOMAIN.local> (sfid-20130215_231931_014864_54228384)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <loom.20130214T000819-590@post.gmane.org>
 <CAGRGNgU4akuP=iKqUqpNbztB7P6DECm=-ug6QKxtsJdvMd9iCg@mail.gmail.com>
 <4A04400646FF41AE84629E8D1443AA89@KGDOMAIN.local>
 <CAGRGNgWBYOJeLnA64yT4Pp0JOd50UqnndA98Jmq1kRd25Fn-ZA@mail.gmail.com>
 <A91BB000EAB44D40A1C1EF25B3CD8761@KGDOMAIN.local>
 <CAGRGNgUnSuALDpZME=YrSDwTJQew+kdUHRrZskJBob8HHGcqVQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many thanks for your comments Julian. Configuring files is fine if one is
not out and about. Today with free Wifi or for demo purposes gaining access
as a guest to local systems one needs an api (library) to:
Configure,
Open,
Enable Dhcp,
Scan,
Join
to automatically join local wifi access point on the fly.
If anyone has some thoughts on this, I am keen to hear (especially re
Libertas).
Regards,
Kevin Gordon.


-----Original Message-----
From: Julian Calaby [mailto:julian.calaby@gmail.com] 
Sent: Friday, 15 February 2013 10:27 p.m.
To: Kevin & Pauline Gordon
Cc: linux-wireless
Subject: Re: Writing application code using sd8686

Hi Kevin,

On Fri, Feb 15, 2013 at 5:26 PM, Kevin & Pauline Gordon
<kgordon@paradise.net.nz> wrote:
> Hi Julian,
> Thank you for your reply. Please refer to my answers below.
>
> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Friday, 15 February 2013 6:00 p.m.
> To: Kevin & Pauline Gordon
> Cc: linux-wireless
> Subject: Re: Writing application code using sd8686
>
> Hi Kevin,
>
> Firstly, please CC linux-wireless or reply to all. I don't support or
> assist people off-list. Also, don't top post. Quote the relevant parts
> of the email you're replying to, then respond to them underneath. This
> helps people to quickly read the entire discussion.
>
> On Fri, Feb 15, 2013 at 2:55 PM, Kevin & Pauline Gordon
> <kgordon@paradise.net.nz> wrote:
>> Hi Julian,
>>
>> My main interest is wireless control of a robot
>> (http://www.rescuerobot.org). I have been writing code in C# for a System
> on
>> Module board using http://www.ghielectronics.com/catalog/product/128 and
>> http://www.ghielectronics.com/catalog/product/379 . The supplier has been
>> struggling with software problems
>> http://www.tinyclr.com/forum/topic?id=10844&page=3#msg108916 so I thought
> I
>> would experiment with Linux hence purchased an excellent board at
>> http://www.isee.biz/products/processor-boards/igepv2-board . After
writing
> a
>> mass of C# code in NETMF (tinyclr) and regretting it, I am now enjoying
>> configuring wifi on the IGEPV2 (poky to ubuntu) using the libertas module
> in
>> Poky.
>
> "Sounds interesting.
>
> The advice I'm going to give you assumes that the board on the robot
> is running Linux. If it isn't then this is not really the right place
> to be asking this question."
>
> I am using Poky and Ubuntu which are both Linux.

Good.

> " If you're after .NET code to operate the
> wireless module directly without the help of Linux or the standard
> Linux wireless tools, you'll need to contact Marvell, the manufacturer
> of the board, or write it yourself."
>
> I have setup eclipse for C/C++ on Linux (Poky and Ubuntu):

Sorry, I misunderstood, I assumed you were writing your application in C#.

>> I have setup eclipse on ubuntu and wish to start writing c/c++ code to
>> experiment with linux wireless. The IGEPV2 contains a Marvell 88w8686B1.
>>
>> Is there a SDK or example code available on the net for the Marvell
>> 88w8686B1. I have downloaded the driver package from Marvell which
> contains
>> the source code for SD8686 (Marvell88w8686_d0acbab79fde.rar). I have no
>> experience of programming in the Linux environment but have plenty of
> books
>> to help.
>
> "I assume that you want to transmit data using TCP or UDP sockets over
> a wireless link between the robot and some other device. I'm also
> going to assume that some third device will be an access point and
> both the robot and the other device will connect to it."
>
> I will use TCP sockets over a wireless link. The third device will be an
> access point.

Good.

> "You need to do three things:
> 1. Ensure that the driver is installed and working
> 2. Establish a wireless link.
> 3. Obtain or set an IP address.
> 4. Determine the remote IP address.
> 5. Establish a socket connection between the two computers."
>
> "For 1, from what you've said above, it seems that this is already done."
>
> Done.
>
> "For 2 and 3, the simplest way would be to install the network-manager
> daemon and talk to it over d-bus, and there are modules for Mono /
> .NET to communicate over d-bus. There may even be modules for Mono /
> .NET to interface directly with network manager. Note that there are
> other tools that perform the same functions, e.g. wicd or Connman and
> you should be able to interface with them in a similar manner."
>
> I will not be using Mono.
>
> "If that's not an option, you'll have to do it more manually. There may
> be tools installed on the board to help you, or you could install
> wpa_supplicant and configure it to maintain the wireless connection
> for you. Note that wpa_supplicant can be controlled and configured
> over d-bus. wpa_supplicant only manages the connection, and setting or
> obtaining an IP address must be done separately. If you're using a
> static IP address, you could use ifconfig, which should already be
> installed, to set it. If you want a dynamic IP address and use DHCP,
> you'll need to ensure that a DHCP client is installed and determine
> how to operate it. You'll then have to figure out some way to run
> these tools after wpa_supplicant connects to the wireless network."
>
> Today in Poky (embedded Linux) I have configured wpa_supplicant.conf and
> interfaces files. I am able to use ssh in Ubuntu to command Poky (via
wired)
> and use Tera Term in Windows (via wifi) to command Poky. The IGEPV2 board
> (6.5cm x 9cm) has Poky installed with the libertas module. It also can
have
> a DVI screen, usb mouse and usb keyboard plugged in.

Ok, that sounds good, you should be ready to go.

> "4 and 5 are beyond the scope of the advice I can give you as I have no
> experience with .NET, but once the wireless link is connected and IP
> address set, everything works exactly the same as communicating over
> any other IP network."
>
> I will not be using .NET. I need help with getting started with Linux
C/C++.
>
> "Oh, one last thing: this advice applies to practically any wireless
> device on any system running Linux."
>
> I do wish to write C/C++ code for TCP sockets. There will be much data
> feeding back from the robot which the user of the PC will consider before
> using the graphical interface to send command data back to the robot.

You should be just using the socket library to do this. I understand
it's rather simple.

> Also I wish to use the libertas "library" to initiate a connection and IP
> address. Is this possible?

"libertas" is not a library, it's the driver for the wireless card.

If you want to communicate between two computers, the wireless link
is, from an application's perspective, exactly like any other network
connection, so you use the socket library.

If you want to control the _wireless_ connection, i.e. tell the sd8686
card to connect to a different access point, you'll need to do
something different. You will need to, at the very least, use
wpa_supplicant or network manager or something else you can interface
with to manage the actual wireless connection, then, depending on what
you use, you may need to do something else to configure the network
interface with an IP address.

Hope that helps.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

