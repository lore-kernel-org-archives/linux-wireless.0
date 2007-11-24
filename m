Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62089 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbXKXEn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 23:43:27 -0500
Subject: Re: Belin FD7010 v7
From: Pavel Roskin <proski@gnu.org>
To: Vadim Peretokin <vperetokin@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6995ca080711230736n54330d30s96831a664d46df1c@mail.gmail.com>
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	 <1195781993.11966.27.camel@dv>
	 <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
	 <1195784707.11966.38.camel@dv>
	 <6995ca080711230736n54330d30s96831a664d46df1c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 23:43:25 -0500
Message-Id: <1195879405.7449.62.camel@dv> (sfid-20071124_044336_845375_78AEACDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-11-23 at 10:36 -0500, Vadim Peretokin wrote:
> That didn't quite work. iwconfig and ifconfig couldn't see the card,
> but lswh -C network showed my card.

You probably mean lshw.  I've never heard of it, but it looks like a
useful program.

>  It said "* - network UNCLAIMED",
> but it didn't say any logical adresses.

It means there is no driver using the card.  It you load either rtl8180
or ndiswrapper, it won't be unclaimed.

>  I tried a host of adresses
> with "sudo ifconfig <adress> up", but nothing would work.

You need to have a network interface first.  If the driver doesn't
create the interface, then it's not working with your card.  Use dmesg
to see kernel message for possible explanations.

Once you have the interface (let's say it's wlan0), use "ifconfig wlan0
up" to bring it up, "iwlist wlan0 scan" to see access points around you,
iwconfig to configure the wireless parameters, possible wpa_supplicant
for WPA authentication.  Once the driver report association, use
ifconfig or dhclient to configure it.  I'm sure there is more detailed
documentation somewhere.

> I had a friend help me do some hacks involving telling the driver the
> adress of my card, and then iwconfig saw it - but for some reason Wicd
> couldn't see it (I'll try again when I get back home and install
> Network Manager again.). I have a log of what we did to get it
> "working", if it's any help.

wicd is another interesting program I've never heard before.  Perhaps
you should ask in a list for wicd users, just make sure to provide with
sufficient details.

Anyway, wicd should not be required to connect to an AP.

> And yes, the card does work if you install the net8185.inf driver in
> ndiswrapper and then use the -a command to link the card to the
> driver. I was just hoping that the card would work out of the box :)

Well, not everything is working out of box, but we are getting there.

-- 
Regards,
Pavel Roskin
