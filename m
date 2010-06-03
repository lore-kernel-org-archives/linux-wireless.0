Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60511 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab0FCPlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 11:41:24 -0400
Received: by vws11 with SMTP id 11so286590vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jun 2010 08:41:23 -0700 (PDT)
Subject: Re: RTL 8187b - naughty behaviour
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <q2k69e28c911004110635nac8100f6pe014361ed0a516a5@mail.gmail.com>
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
	 <4BB7660A.3030900@lwfinger.net>
	 <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>
	 <4BB773A9.2070703@lwfinger.net>
	 <n2n917a57cb1004031000h9910230ew50c6380788a64b1c@mail.gmail.com>
	 <q2k917a57cb1004100507s17249540xfb11a2e2f0a2dd76@mail.gmail.com>
	 <w2i69e28c911004101150h9db59aa1x2f9d12964f3c3fc1@mail.gmail.com>
	 <y2g917a57cb1004101240g8033e225n57bf68b6d37b5431@mail.gmail.com>
	 <q2k69e28c911004110635nac8100f6pe014361ed0a516a5@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-N1HQh1SAdadN14dQQFvM"
Date: Thu, 03 Jun 2010 12:40:54 -0300
Message-ID: <1275579654.1311.32.camel@casa>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N1HQh1SAdadN14dQQFvM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

You need to enable MMIO tracing support in your kernel config, and
> recompile your kernel (assuming it is not enabled already - distros
> usually disable the entire tracing framework by default). Then:
> -Mount debugfs to /debug. (Usually it is mounted by default, but some
> distros like to mount it @ /sys/kernel/debug instead - remount it to
> /debug.)
> -"echo mmiotrace > /debug/tracing/current_tracer"
> -"cat /debug/tracing/trace_pipe >  trace.txt &" - at this point, tracing begins.
> -Load r8187b and connect.
> -"echo "Driver loaded!" > /debug/tracing/trace_marker"
> -"echo nop


Ok here are some news: 

1) The rtl8187b problem is a know bug in Ubuntu since forever - bug
#215802 https://bugs.launchpad.net/ubuntu/+source/linux/+bug/215802

2) Tryied the Realtek driver found in: 
http://ubuntuforums.org/showthread.php?t=1446894 
(rtl8187B_linux_26.1056.1112.2009.release.tar.gz )

- as seno said here on the list in 14-05-2010 17:20:02

It installs a module called r8187b, witch I managed to use ONCE, after
it installed, then after it disconnected it would not connect again, and
after I rebooted there was no more wi-fi interface (!!!) ifconfig and
iwconfig confirm that my wi-fi card (wlan0) is nowhere to be found

5) Rate seems weird on this card. If I define the rate with 
"iwconfig wlan0 rate 11M" it gives the best download speed, even if I
rase this to 24M or 54M I get at least a 40% difference, same if I lower
the rate. 
Maybe what Hin-Tak Leung (2010-04-03) said about the Minstrel algorithm?
Could we try to install both Minstrel and older algorithms side by side
and make a comparison? from what I read here: 

http://wireless.kernel.org/en/developers/Documentation/mac80211/RateControl/minstrel
"Further, it means that the 1 Mbps rate (which typically has a high
probability of successful transmission) will not be used in preference
to the 11 Mbps rate." 

But my rate is always a defaulted 1Mb/s on bootup. I put it to 11M
manually and the connection improves dramatically 

4) Ran the mmiotrace on the rtl8187 driver, it all seems gibberish to
me ;) 

one while it was at 1m from the router giving me top speed (same as
Win7): trace1.txt:
 
VERSION 20070824
PCIDEV 0000 10390671 0 d0000000 0 0 0 0 0 0 8000000 0 0 0 0 0 0
agpgart-sis
PCIDEV 0008 10390003 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0010 10390968 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0015 10395513 10 1f0 3f6 170 376 1081 0 0 8 0 8 0 10 0 0 pata_sis
PCIDEV 0018 10397001 14 d8404000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 0019 10397001 15 d8405000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 001b 10397002 16 d8406000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ehci_hcd
PCIDEV 0020 10390191 13 d8407000 1001 0 0 0 0 0 80 80 0 0 0 0 0 sis190
PCIDEV 0028 10391183 11 10c9 10bd 10c1 10b9 10a1 0 0 8 4 8 4 10 0 0
sata_sis
PCIDEV 0030 1039000a 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0038 1039000a 19 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0078 10397502 12 d8400000 0 0 0 0 0 0 4000 0 0 0 0 0 0 HDA Intel
PCIDEV 00f8 10390004 1a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0100 10396351 10 c0000008 d8000000 9001 0 0 0 2 10000000 20000 80
0 0 0 0 
PCIDEV 0300 197b2382 10 d8100000 0 0 0 0 0 d8500000 100 0 0 0 0 0 10000
sdhci-pci
PCIDEV 0302 197b2381 10 d8100400 0 0 0 0 0 0 100 0 0 0 0 0 0 
PCIDEV 0303 197b2383 10 d8100800 0 0 0 0 0 0 100 0 0 0 0 0 0 jmb38x_ms

** then when it was about 10m - failed to connect (Windows 7 connects
normally) trace2.txt 

VERSION 20070824
PCIDEV 0000 10390671 0 d0000000 0 0 0 0 0 0 8000000 0 0 0 0 0 0
agpgart-sis
PCIDEV 0008 10390003 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0010 10390968 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0015 10395513 10 1f0 3f6 170 376 1081 0 0 8 0 8 0 10 0 0 pata_sis
PCIDEV 0018 10397001 14 d8404000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 0019 10397001 15 d8405000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 001b 10397002 16 d8406000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ehci_hcd
PCIDEV 0020 10390191 13 d8407000 1001 0 0 0 0 0 80 80 0 0 0 0 0 sis190
PCIDEV 0028 10391183 11 10c9 10bd 10c1 10b9 10a1 0 0 8 4 8 4 10 0 0
sata_sis
PCIDEV 0030 1039000a 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0038 1039000a 19 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0078 10397502 12 d8400000 0 0 0 0 0 0 4000 0 0 0 0 0 0 HDA Intel
PCIDEV 00f8 10390004 1a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0100 10396351 10 c0000008 d8000000 9001 0 0 0 2 10000000 20000 80
0 0 0 0 
PCIDEV 0300 197b2382 10 d8100000 0 0 0 0 0 d8500000 100 0 0 0 0 0 10000
sdhci-pci
PCIDEV 0302 197b2381 10 d8100400 0 0 0 0 0 0 100 0 0 0 0 0 0 
PCIDEV 0303 197b2383 10 d8100800 0 0 0 0 0 0 100 0 0 0 0 0 0 jmb38x_ms

*** All the steps asked by Gábor were done. 

Thanks all you guys.

Rogerio 

--=-N1HQh1SAdadN14dQQFvM
Content-Disposition: attachment; filename="trace2.txt"
Content-Type: text/plain; name="trace2.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

VERSION 20070824
PCIDEV 0000 10390671 0 d0000000 0 0 0 0 0 0 8000000 0 0 0 0 0 0 agpgart-sis
PCIDEV 0008 10390003 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0010 10390968 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0015 10395513 10 1f0 3f6 170 376 1081 0 0 8 0 8 0 10 0 0 pata_sis
PCIDEV 0018 10397001 14 d8404000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 0019 10397001 15 d8405000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 001b 10397002 16 d8406000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ehci_hcd
PCIDEV 0020 10390191 13 d8407000 1001 0 0 0 0 0 80 80 0 0 0 0 0 sis190
PCIDEV 0028 10391183 11 10c9 10bd 10c1 10b9 10a1 0 0 8 4 8 4 10 0 0 sata_sis
PCIDEV 0030 1039000a 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0038 1039000a 19 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0078 10397502 12 d8400000 0 0 0 0 0 0 4000 0 0 0 0 0 0 HDA Intel
PCIDEV 00f8 10390004 1a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0100 10396351 10 c0000008 d8000000 9001 0 0 0 2 10000000 20000 80 0 0 0 0 
PCIDEV 0300 197b2382 10 d8100000 0 0 0 0 0 d8500000 100 0 0 0 0 0 10000 sdhci-pci
PCIDEV 0302 197b2381 10 d8100400 0 0 0 0 0 0 100 0 0 0 0 0 0 
PCIDEV 0303 197b2383 10 d8100800 0 0 0 0 0 0 100 0 0 0 0 0 0 jmb38x_ms

--=-N1HQh1SAdadN14dQQFvM
Content-Disposition: attachment; filename="trace1.txt"
Content-Type: text/plain; name="trace1.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

VERSION 20070824
PCIDEV 0000 10390671 0 d0000000 0 0 0 0 0 0 8000000 0 0 0 0 0 0 agpgart-sis
PCIDEV 0008 10390003 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0010 10390968 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
PCIDEV 0015 10395513 10 1f0 3f6 170 376 1081 0 0 8 0 8 0 10 0 0 pata_sis
PCIDEV 0018 10397001 14 d8404000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 0019 10397001 15 d8405000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ohci_hcd
PCIDEV 001b 10397002 16 d8406000 0 0 0 0 0 0 1000 0 0 0 0 0 0 ehci_hcd
PCIDEV 0020 10390191 13 d8407000 1001 0 0 0 0 0 80 80 0 0 0 0 0 sis190
PCIDEV 0028 10391183 11 10c9 10bd 10c1 10b9 10a1 0 0 8 4 8 4 10 0 0 sata_sis
PCIDEV 0030 1039000a 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0038 1039000a 19 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0078 10397502 12 d8400000 0 0 0 0 0 0 4000 0 0 0 0 0 0 HDA Intel
PCIDEV 00f8 10390004 1a 0 0 0 0 0 0 0 0 0 0 0 0 0 0 pcieport
PCIDEV 0100 10396351 10 c0000008 d8000000 9001 0 0 0 2 10000000 20000 80 0 0 0 0 
PCIDEV 0300 197b2382 10 d8100000 0 0 0 0 0 d8500000 100 0 0 0 0 0 10000 sdhci-pci
PCIDEV 0302 197b2381 10 d8100400 0 0 0 0 0 0 100 0 0 0 0 0 0 
PCIDEV 0303 197b2383 10 d8100800 0 0 0 0 0 0 100 0 0 0 0 0 0 jmb38x_ms

--=-N1HQh1SAdadN14dQQFvM--

