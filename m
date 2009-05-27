Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750949AbZE0Tf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 15:35:29 -0400
Message-ID: <4A1D95F8.7050003@gmx.net>
Date: Wed, 27 May 2009 21:35:20 +0200
From: Barkle <barkle@gmx.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8185
References: <4A199FED.7000609@gmx.net>	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>	 <4A1B00E7.5070801@gmx.net>	 <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>	 <4A1B2186.3070107@gmx.net>	 <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com>	 <4A1C1766.3030004@gmx.net> <4A1C74C1.7060600@gmx.net>	 <3ace41890905261651l1cd3742bu5ac1af6f631798f3@mail.gmail.com>	 <4A1CD905.4090406@gmx.net> <3ace41890905270121r4d724c73h2187b7a89931f46e@mail.gmail.com>
In-Reply-To: <3ace41890905270121r4d724c73h2187b7a89931f46e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung schrieb:
> On Wed, May 27, 2009 at 7:09 AM, Barkle <barkle@gmx.net> wrote:
>
>   
>> After "ifconfig wlan0 up" the system freeze
>> It's just every time the interface has to work, it's gonna freeze. It
>> doesn't matter if I use wpa_supplicant or ifupdown (which invokes at last
>> wpa_supplicant, so far as I know, on the debian system)
>>     
>
> Hmm, try to disable any devices on the pci bus which you don't use
> with setpci <id> command=0 before anything els

Have a look at lspci

*********************
feta:~# lspci
00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and 
Memory Controller Hub (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82815 Chipset 
Graphics Controller (CGC) (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801AA PCI Bridge (rev 02)
00:1f.0 ISA bridge: Intel Corporation 82801AA ISA Bridge (LPC) (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801AA IDE Controller (rev 02)
00:1f.2 USB Controller: Intel Corporation 82801AA USB Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801AA SMBus Controller (rev 02)
01:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185 
IEEE 802.11a/b/g Wireless LAN Controller (rev 20)
01:09.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] 
(rev 74)
*********************

Wich device do you mean?

I disabled
feta:~# setpci -d 8086:2413 command=0 [the SMBus]
feta:~# setpci -d 8086:2412 command=0 [the USB]
feta:~# setpci -d 8086:2410 command=0 [the ISA bridge]
feta:~# setpci -d 8086:1132 command=0 [the VGA]
feta:~# ifconfig wlan0 up

=> freeze


