Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:33183 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762140AbYBTVmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 16:42:32 -0500
Received: from hoboi3bl4.telenet-ops.be (unknown [195.130.137.79])
	by yergi.telenet-ops.be (Postfix) with ESMTP id F10A75C97DE
	for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2008 22:42:32 +0100 (CET)
Message-ID: <47AFAD34.5030301@yahoo.co.uk> (sfid-20080220_214239_028169_D7EC119A)
Date: Mon, 11 Feb 2008 03:04:36 +0100
From: Ivo Couckuyt <iv0co@yahoo.co.uk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb	adapter
References: <47AF79DA.10204@yahoo.co.uk> <20080220200926.GA3825@tuxdriver.com>
In-Reply-To: <20080220200926.GA3825@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


John W. Linville wrote:
> On Sun, Feb 10, 2008 at 11:25:30PM +0100, Ivo Couckuyt wrote:
> This is the Internet, nothing is ever lost... :-)
>
> FWIW, your old patch was against the prism54usb driver.  I retargeted
> against p54usb and just posted it to this list.  I'll send it upstream
> with the next round of fixes.
>
> John
>   
Great, thanks

> Please switch to a VT (e.g. VT 1, usually by pressing ctrl-alt-f1) and
> associate by hand (e.g. iwconfig wlan0 essid "your ssid") and take a
> picture of the oops that comes out.
k, i configured my ap as plain text and turned off xorg.
In the first console I did:
ifconfig wlan0 up
iwconfig wlan0 essid ilm
dmesg shows several of this lines... which is normal scanning  i believe:
...
HW CONFIG: channel=8 freq=2447 phymode=2
HW CONFIG: channel=9 freq=2452 phymode=2
HW CONFIG: channel=10 freq=2457 phymode=2
HW CONFIG: channel=11 freq=2462 phymode=2
HW CONFIG: channel=1 freq=2412 phymode=2
...
iwconfig -> Not-associated

wlan0     IEEE 802.11g  ESSID:"ilm" 
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated  
          Tx-Power=27 dBm  
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B  
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

but nothing, so i do
iwlist wlan0 scanning
which 99.99% of the time returns nothing, and very occasional one 
accesspoint that isn't mine.

configuring wpa_supplicant for plain text and starting it in the 
foreground gives me:
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 5 value 0x1 - ioctl[SIOCGIFADDR]: Cannot assign 
requested address
ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
ioctl[SIOCGIFADDR]: Cannot assign requested address
ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
ioctl[SIOCGIFADDR]: Cannot assign requested address
ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
ioctl[SIOCGIFADDR]: Cannot assign requested address
ioctl[SIOCGIFADDR]: Cannot assign requested address
ioctl[SIOCGIFADDR]: Cannot assign requested address
ioctl[SIOCGIFADDR]: Cannot assign requested address
ioctl[SIOCGIFADDR]: Cannot assign requested address
ioctl[SIOCGIFADDR]: Cannot assign requested address


Which i think isn't really relevant to the problem, in any case 
wpa_supplicant doesnt work.
The strange thing is i don't get any oops anymore, that only happeneded 
with wpa_supplicant AND wpa enabled

Using the good old islsm driver i can configure it all manually without 
problems:
ifconfig eth1 up
iwlist eth1 scanning -> returns about 5 ap, including mine
iwconfig eth1 essid ilm
iwconfig -> shows associated
dhcpcd eth1 -> in business

so apparantly the p54usb/cpwua054 combination doesn't find the ap in the 
first place.
I vaguely remember some thread on the islsm mailing list about those 
unknown frame messages that may be related to the empty scan results, to 
be exact:
...
phy0: unknown frame RXed (0x20)
phy0: unknown frame RXed (0x30)
phy0: unknown frame RXed (0x30)
phy0: unknown frame RXed (0x20)
phy0: unknown frame RXed (0x20)
phy0: unknown frame RXed (0x20)
...

Next step is probably enabling debug in the p54usb driver i think, if 
possible. Any suggestions for tests i can do ?

kind regards,
Ivo Couckuyt
