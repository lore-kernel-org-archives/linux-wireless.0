Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYC0Q1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 12:27:51 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
Date: Thu, 27 Mar 2008 09:27:49 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040BC0B8@orsmsx416.amr.corp.intel.com> (sfid-20080327_162756_009042_5A07C311)
In-Reply-To: <183c1cc10803270741r66896d88q15614af05a4142e6@mail.gmail.com>
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com> <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com> <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com> <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com> <183c1cc10803262027k4c40386v767b2f9c79945deb@mail.gmail.com> <183c1cc10803270741r66896d88q15614af05a4142e6@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John Goulah" <jgoulah@gmail.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 27, 2008 7:41 AM, John Goulah  wrote:

>>  It appears I am still having some issues here with associating. 
>>  Could this be on the driver end of things?  It doesn't happen with
>> another  box (other drivers) 
>> 
>>  I can disassociate:
>>  $ sudo iwconfig wlan0 ap off
>>  $ iwconfig
>> 
>> wlan0     IEEE 802.11  ESSID:"goulahnet"
>>           Mode:Managed  Frequency:2.412 GHz  Access Point:
>> Not-Associated           Tx-Power=14 dBm 
>> 
>>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>>           Link Quality:0  Signal level:0  Noise level:0
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>> 
>> 
>> 
>>  What I was doing before is showing Invalid:
>> 
>> 
>>  $ sudo iwconfig wlan0 ap any  (same for auto here)  $ iwconfig
>> 
>> wlan0     IEEE 802.11  ESSID:"goulahnet"
>>           Mode:Managed  Frequency:2.412 GHz  Access Point: Invalid  
>> Tx-Power=14 dBm 
>> 
>>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>>           Link Quality:0  Signal level:0  Noise level:0
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>> 
>> 
>> 
>> 
>>  It does seem a bit random, and I did have it working there for a
>>  while, but it looked like if issue ctrl-C to wpa_supplicant  it got
>>  into this state, or a reboot.
>> 
>>  Anything I can try here?
>> 
>> 
>> 
> 
> 
> Quick followup, one thing I've found is that I can scan as root and
> see my access point in the list:
> 
>          Cell 09 - Address: 00:15:E9:FA:E2:DB
>                    ESSID:"goulahnet"
>                    Mode:Master
>                    Frequency:2.462 GHz (Channel 11)                  
>                    Channel:11 Quality=84/100  Signal level=-50 dBm
> Noise level=-127 dBm
>                    Encryption key:on
>                    IE: WPA Version 1
>                        Group Cipher : CCMP
>                        Pairwise Ciphers (1) : CCMP
>                        Authentication Suites (1) : PSK
>                    IE: IEEE 802.11i/WPA2 Version 1
>                        Group Cipher : CCMP
>                        Pairwise Ciphers (1) : CCMP
>                        Authentication Suites (1) : PSK
>                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
>                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24
> Mb/s; 36 Mb/s
>                              48 Mb/s; 54 Mb/s
>                    Extra:tsf=00000208dd78c752
> 
> 
> 
> 
> One time, that even got me associated.  But after removing the module
> and trying again to be sure, I'm still showing "Invalid"
> 
> This seems a bit odd to me-  Ideas are appreciated, I'm happy to
> debug where appropriate - 

The driver and wpa_supplicant is able to provide more debugging
information. Could you please capture debugging from both and submit a
bug to http://www.intellinuxwireless.org/bugzilla/?

wpa_supplicant debugging is obtained by running it with -ddt option
driver debugging is obtained by loading driver with debugging enabled
(modprobe iwl4965 debug=0x43fff)

If possible, please annotate logs to indicate what you did at the time.

Thanks!

Reinette
