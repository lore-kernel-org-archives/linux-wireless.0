Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:9186 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759327AbXJRG6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 02:58:46 -0400
Date: Thu, 18 Oct 2007 08:57:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Clark <Stephen.Clark@seclark.us>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Message-ID: <20071018065746.GB5063@kernel.dk> (sfid-20071018_075849_746268_8188E6D1)
References: <20071017135452.GJ5043@kernel.dk> <200710171708.48654.ismail@pardus.org.tr> <20071017141111.GM5043@kernel.dk> <1192630733.10567.37.camel@localhost.localdomain> <20071017142246.GQ5043@kernel.dk> <1192634183.11584.0.camel@localhost.localdomain> <20071017163519.GC15552@kernel.dk> <47166B5F.1010804@seclark.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <47166B5F.1010804@seclark.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17 2007, Stephen Clark wrote:
> Jens Axboe wrote:
>
>> On Wed, Oct 17 2007, Dan Williams wrote:
>> =20
>>> On Wed, 2007-10-17 at 16:22 +0200, Jens Axboe wrote:
>>>   =20
>>>> On Wed, Oct 17 2007, Dan Williams wrote:
>>>>     =20
>>>>> On Wed, 2007-10-17 at 16:11 +0200, Jens Axboe wrote:
>>>>>       =20
>>>>>> On Wed, Oct 17 2007, Ismail D=F6nmez wrote:
>>>>>>         =20
>>>>>>> Wednesday 17 October 2007 Tarihinde 16:54:53 yazm????t??:
>>>>>>>           =20
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Seeing that iwl3945 is now merged, I decided to switch my x60 =
to use
>>>>>>>> that instead of ipw3945. That would leave me with zero kernel
>>>>>>>> dependencies.
>>>>>>>>
>>>>>>>> Unfortunately it doesn't work. Loading the module reveals the=20
>>>>>>>> device:
>>>>>>>>
>>>>>>>> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection d=
river=20
>>>>>>>> for
>>>>>>>> Linux, 1.1.17ks
>>>>>>>> iwl3945: Copyright(c) 2003-2007 Intel Corporation
>>>>>>>> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> =
IRQ 21
>>>>>>>> PCI: Setting latency timer of device 0000:03:00.0 to 64
>>>>>>>> iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connectio=
n
>>>>>>>> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
>>>>>>>> phy0: Selected rate control algorithm 'iwl-3945-rs'
>>>>>>>>
>>>>>>>> # iwconfig wlan0
>>>>>>>> wlan0     IEEE 802.11g  ESSID:"xxxxxxxxxxxxxx"
>>>>>>>>          Mode:Managed  Channel:0  Access Point: Not-Associated
>>>>>>>>          Tx-Power=3D0 dBm
>>>>>>>>          Retry min limit:7   RTS thr:off   Fragment thr=3D2346=
 B
>>>>>>>>          Encryption key:XXXX-XXXX-XX
>>>>>>>>          Link Quality:0  Signal level:0  Noise level:0
>>>>>>>>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid fra=
g:0
>>>>>>>>          Tx excessive retries:0  Invalid misc:0   Missed beaco=
n:0
>>>>>>>>
>>>>>>>> and iwconfig sees it, essid/enc settings are fine, but I don't=
 get a
>>>>>>>> link.
>>>>>>>>             =20
>>>>>>> Same issue here, try iwlist wlan0 scan first and then it should=
 work.
>>>>>>>           =20
>>>>>> Huh indeed, now it links fine! Thanks for the hint. Would be nic=
e to
>>>>>> have fixed, though :-)
>>>>>>         =20
>>>>> Odd, doesn't the driver need to do a scan _anyway_ to find the ri=
ght
>>>>> BSSID to associate with if the cached scan results are more than =
a few
>>>>> seconds old?  Can you run '/sbin/iwevent' before trying a fresh
>>>>> association, try to associate, ensure that it has failed, and rep=
ort=20
>>>>> the
>>>>> output?
>>>>>
>>>>> If you don't get something like:
>>>>>
>>>>> 10:17:05.117937   eth1     Scan request completed
>>>>>
>>>>> shown there, then there's likely a bug in the driver because it's=
=20
>>>>> either
>>>>> (a) not scanning before trying to associate, or (b) not sending o=
ut=20
>>>>> scan
>>>>> completion events after it's done a scan.
>>>>>       =20
>>>> Indeed, there is now Scan request completed before I run the iwlis=
t
>>>> scan. iwevent output:
>>>>     =20
>>> Hmm, the output below doesn't show the scan request completed, righ=
t?
>>>
>>>   =20
>>>> Waiting for Wireless Events from interfaces...
>>>> 16:20:27.453588   wlan0    Set Mode:Managed
>>>> 16:20:27.462104   wlan0    Set Encryption key:off
>>>> 16:20:27.463940   wlan0    Set Encryption key:****-****-**   Secur=
ity=20
>>>> mode:open
>>>> 16:20:27.466535   wlan0    Set ESSID:"kjellbergaxboe"
>>>>
>>>> waiting, nothing else happens. Then run iwlist scan from another
>>>> terminal.
>>>>
>>>> 16:20:53.892549   wlan0    Scan request completed
>>>>     =20
>>> So you only get this when you manually scan right after setting the=
 ssid
>>> and key?
>>>   =20
>>
>> If you look at the time stamp, I ran the iwlist scan about 26 second=
s
>> after loading the module. When the module is loaded, the networking
>> script sets the essid and encryption key.
>>
>> So yes, I only get that 'Scan request completed' line after running
>> iwlist scan manually.
>>
>> =20
> Don't know whether this is related, but I was having all kinds of tro=
uble=20
> getting associated,
> iwlist eth1 scan would report no scan results, I then switched to loa=
ding=20
> the kernel module with
> the option that tells  iwl3945 to do software scanning and it works=20
> everytime now.

Which option is that?

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
