Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:47440 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038AbXJRRND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 13:13:03 -0400
Received: by py-out-1112.google.com with SMTP id u77so439153pyb
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2007 10:13:02 -0700 (PDT)
Message-ID: <bbbeeccd0710181013g6607423bobb31ca1e817f33c5@mail.gmail.com> (sfid-20071018_181311_275798_E64A70E4)
Date: Thu, 18 Oct 2007 11:13:00 -0600
From: "Wade Berrier" <wberrier@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: realtek 8185
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710171938.48414.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <bbbeeccd0710160658p7f127bb9if2239287bee33d6c@mail.gmail.com>
	 <bbbeeccd0710162220u3b276506s68457b4220bec8ae@mail.gmail.com>
	 <bbbeeccd0710171552x37986f68m906a603e793c7996@mail.gmail.com>
	 <200710171938.48414.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

I'm also copying the linux wireless list...

On 10/17/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Wednesday 17 October 2007 18:52:28 Wade Berrier wrote:
> > Another thing I'm noticing is that I can't connect to an 802.11b open
> > network with a hidden essid.
> >
> For those, you should specify the channel, and bssid in one iwconfig command,
> and then ssid in another command. Everything needs to be specified for hidden
> networks. Never tried connecting to hidden networks with network manager so I
> dunno if that's suppose to work.

I've been able to connect to this hidden network via network manager.
>From a users experience, I enter in the essid from the "Connect to
other wireless network" dialog, and it connects.  I'm not sure how
networkmanager makes the connection between the essid and the ap.

I did get it working from using your suggested method though:

moby:/etc # iwlist wlan0 scanning
wlan0     Scan completed :
          Cell 02 - Address: 00:02:2D:2E:64:FE
                    ESSID:""
                    Mode:Master
                    Channel:4
                    Frequency:2.427 GHz
                    Signal level=52/65
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Extra:tsf=000002ae8691fbab

iwconfig wlan0 ap 00:02:2D:2E:64:FE channel 4
iwconfig wlan0 essid onenet

moby:/home/wberrier # iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11g  ESSID:"onenet"
          Mode:Managed  Frequency:2.427 GHz  Access Point: 00:02:2D:2E:64:FE
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:off
          Link Signal level=42/65
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

wlan0 dhclient

Internet Systems Consortium DHCP Client V3.0.6
Copyright 2004-2007 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

wmaster0: unknown hardware address type 801
wmaster0: unknown hardware address type 801
Listening on LPF/wlan0/00:c0:a8:f4:7e:00
Sending on   LPF/wlan0/00:c0:a8:f4:7e:00
Sending on   Socket/fallback
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPACK from 151.155.11.254
bound to 151.155.10.138 -- renewal in 10908 seconds.

moby:/home/wberrier # ping www.google.com
PING www.l.google.com (72.14.235.104) 56(84) bytes of data.
64 bytes from tw-in-f104.google.com (72.14.235.104): icmp_seq=1
ttl=242 time=174 ms


NetworkManager uses wpa_supplicant, even for connecting to networks
without encryption, but I'm not sure why it's not working in this
case.  It actually never sets the essid.

Thanks for your driver and the help,

Wade
