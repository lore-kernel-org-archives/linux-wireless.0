Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:52235 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab2CJOQ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 09:16:56 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1S6N6M-00065z-8u
	for linux-wireless@vger.kernel.org; Sat, 10 Mar 2012 15:16:54 +0100
Received: from localhost ([::1]:46471 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1S6N6M-0004cj-8J
	for linux-wireless@vger.kernel.org; Sat, 10 Mar 2012 15:16:54 +0100
Received: from [195.4.92.12] (port=55612 helo=2.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1S6N3m-0003D6-8o
	for linux-wireless@vger.kernel.org; Sat, 10 Mar 2012 15:14:14 +0100
Received: from [2002:4fde:d9d:2:5054:ff:feb8:40bd] (port=51069 helo=mail.maya.org)
	by 2.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1S6N3l-0004LY-T6
	for linux-wireless@vger.kernel.org; Sat, 10 Mar 2012 15:14:14 +0100
Message-ID: <4F5B61A7.6010904@01019freenet.de> (sfid-20120310_151659_575717_ED9AEC4A)
Date: Sat, 10 Mar 2012 15:13:59 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Oskar Stenman <oskar@cetex.se>
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k timeouts with the current Mainline
References: <4F12F5DD.3030904@gmail.com> <4F5B27DB.8090508@cetex.se>
In-Reply-To: <4F5B27DB.8090508@cetex.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oskar Stenman wrote:
> I'm having a similar or the same problem, it's been nagging me for at
> least 1.5years.
> 
> If I'm able to connect I get frequent dropouts from any wireless network
> I'm connected to. It gets sluggish and after a little while disconnects,
> and once it has disconnected it just keeps reconnecting and failing.
> sometimes a reboot helps, but most of the time it wont help anymore than
> a couple of seconds to a minute. It's also impossible to connect to my
> wireless hotspot on my Xperia Mini Pro and it seems ad-hoc networks are
> also impossible.
> 
> I'm running ubuntu 11.10 with latest patches applied as of today. Since
> i've not seen anything being solved during this time i doubt anyone has
> been trying to, or has been able to solve the problem recently.

I'm running exactly the same chip (according lspci) without any problem.
But I'm using slightly different environment:

1. 64 bit
2. kernel 3.1 (some time ago, I run 3.0, too, but cannot remember
   having any problems related ar9285).
3. no network manager - just plain wpa_supplicant.
4. wpa_supplicant 0.7.3


If you like to, you could just check, if the problem is network manager
related. Try to stop it and run wpa_supplicant manually as root like
this (ensure, that no other wpa_supplicant process is running at the
same time):

wpa_supplicant -t -c /etc/wpa_supplicant/wpa_supplicant.conf -Dnl80211
-i wlan0

-c is the config file. -i is the device name.

sample config file for WPA2 PSK would be:

network={
        ssid="your network name"
        # scan_ssid=1
        key_mgmt=WPA-PSK
        psk="your psk"
        proto=WPA2
}

If you see a line like this:
WPA: Key negotiation completed with xx:xx:xx:xx:xx:xx [PTK=CCMP GTK=CCMP]
you can go to another terminal and start dhclient or dhcpcd like this:

dhcpcd wlan0 (or whatever your device name is)


If this is all running fine, you most probably face a network manager
problem.


Hope that helps,
regards,
Andreas
