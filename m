Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:2824 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYDEKsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 06:48:10 -0400
Received: from egdell.wetwork.net ([204.17.34.178])
 by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01MT922V1UTY8YM7QJ@Opus1.COM> for
 linux-wireless@vger.kernel.org; Sat, 05 Apr 2008 03:48:07 -0700 (MST)
Date: Sat, 05 Apr 2008 03:48:07 -0700
From: gavron@wetwork.net
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
In-reply-to: <1207364787.2115.16.camel@dv>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-id: <47F758E7.3050306@wetwork.net> (sfid-20080405_114814_744953_188811F0)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <200804041612.18840.mb@bu3sch.de> <1207364787.2115.16.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had a case of total disassociation last night, and it is unusual.  NM 
was unable to reconnect (so we go to bash).
A scan revealed no APs but after a module reload they are back...
What further testing or other diagnostics can I run should this happen 
again to rest?
Thanks
E

[root@egdell ~]# iwlist wlan0 scan
wlan0     No scan results

[root@egdell ~]# rmmod b43
[root@egdell ~]# modprobe b43
[root@egdell ~]# iwlist wlan0 scan
wlan0     Scan completed :
          Cell 01 - Address: 00:16:01:B9:F9:3F
                    ESSID:"wetwork"
                    Mode:Master
                    Frequency:2.437 GHz (Channel 6)
                    Channel:6
                    Quality=71/100  Signal level=-64 dBm  Noise 
level=-69 dBm
                    Encryption key:on
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=00000266671a2b44
          Cell 02 - Address: 00:16:01:B9:FE:8F
                    ESSID:"wetwork"
                    Mode:Master
                    Frequency:2.437 GHz (Channel 6)
                    Channel:6
                    Quality=98/100  Signal level=-36 dBm  Noise 
level=-69 dBm
                    Encryption key:on
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=000002cd08cbc1ce
          Cell 03 - Address: 00:16:01:B9:F5:1F
                    ESSID:"wetwork"
                    Mode:Master
                    Frequency:2.437 GHz (Channel 6)
                    Channel:6
                    Quality=61/100  Signal level=-74 dBm  Noise 
level=-69 dBm
                    Encryption key:on
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=0000021011e7a0e7

[root@egdell ~]#


Pavel Roskin wrote:
> On Fri, 2008-04-04 at 16:12 +0200, Michael Buesch wrote:
>   
>> Hi b43 users,
>>
>> Please be so kind to run lots of regression tests on the following
>> patch. This patch is supposed to make the LO calibration a _lot_ more
>> lightweight and avoid a long MAC-disable period every 120 seconds.
>>
>> We need a lot of regression testing with this patch on lots of different
>> devices to make sure we don't introduce regressions.
>>
>> I tested this on a 4306 and a 4318 card. So far it seems to work great
>> on these cards.
>>     
>
> Tested on this:
>
> b43-phy0: Broadcom 4306 WLAN found
> b43-phy0 debug: Found PHY: Analog 2, Type 2, Revision 2
> b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> phy0: Selected rate control algorithm 'pid'
> Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
>
> It's actually Fedora development kernel 2.6.25-0.195.rc8.git1.fc9.i686
> with patched compat-wireless installed.
>
> It's working better than I could possibly expect.  The range is on the
> par with another laptop with ipw3945 running Linux or Windows XP.  It's
> working through 4 walls and 30 meters on top of that.  I understand that
> there are many random factors involved, but my impression is very
> positive.  Basically, it's good enough to go outside with the laptop
> without having an AP installed near a window.  I haven't seen any
> significant interruptions in the connection.
>
> Unfortunately, I hit that nasty circular lock dependency bug (already
> discussed in another thread) when I killed wpa_supplicant to try another
> AP.  The CPU utilization went to 100%, but the driver kept working.
>
> Another unrelated bug (sorry, testing often finds unrelated bugs) is
> that scanning with specific ESSID was returning non-matching APs.  I
> mean "iwlist wlan0 scan my_essid", which would still report many
> different ESSIDs.  It's inconvenient when the driver can sense 22 APs at
> once :)
>
> I'll try to get 4318 tested over the weekend.
>
>   
