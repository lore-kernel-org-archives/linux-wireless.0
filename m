Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59667 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2BWCRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 21:17:13 -0500
Received: by iacb35 with SMTP id b35so857946iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 18:17:13 -0800 (PST)
Message-ID: <4F45A1A6.1040500@lwfinger.net> (sfid-20120223_031717_256492_23013F11)
Date: Wed, 22 Feb 2012 20:17:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: htl10@users.sourceforge.net, Attila Fazekas <turul64@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
References: <4F457BCD.5020200@lwfinger.net> <1329957888.76143.YahooMailClassic@web29502.mail.ird.yahoo.com> <CAGRGNgXOjKZQqF_JrAA0hyqcsn8TZWHd9OysqOMrE5_JrmnRjA@mail.gmail.com>
In-Reply-To: <CAGRGNgXOjKZQqF_JrAA0hyqcsn8TZWHd9OysqOMrE5_JrmnRjA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2012 06:59 PM, Julian Calaby wrote:
> Hi,
>
> On Thu, Feb 23, 2012 at 11:44, Hin-Tak Leung
> <htl10@users.sourceforge.net>  wrote:
>> --- On Wed, 22/2/12, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>> I fixed and tested your patch. With it, I certainly see the
>>> beacons and I was
>>> able to use NetworkManager to connect once. However, I was
>>> never able to ping
>>> from either end of the network to the other.
>>
>> Do you need something manual set-up like "ifconfig wlan1 192.168.0.1" for one box and "ifconfig wlan1 192.168.0.2" for the other box in the IP layer to work? I haven't quite got my head around this one - how network manager agrees for each for go into a private tcp/ip network, given there are three(?) private ranges to use, and setting up host names, and what ip adresses to assign... and since there is no dns for a network of two, it would have to ping by ip address?
>
> If it's anything like how it works on Ubuntu, when you start an Ad-Hoc
> network with NetworkManager, it chooses an IP range based on some
> internal logic (usually in the 10.0.0.0/8 private network) sets it's
> IP to something sensible then starts a DHCP server for everyone else
> on the network, so everyone should get a valid IP.

Actually, I was assigning the IP for both ends and not using DHCP. My test 
network was a trivial one that was not connected to the outside world - only two 
isolated computers that should have been talking to each other. I expected a 
wireless NULL cable.

I could see the iwconfig from each end being part of the cell and each end had 
an IP address, but no ping data flowed between them.

Larry



