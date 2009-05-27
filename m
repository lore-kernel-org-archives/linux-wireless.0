Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46639 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752462AbZE0GJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 02:09:15 -0400
Message-ID: <4A1CD905.4090406@gmx.net>
Date: Wed, 27 May 2009 08:09:09 +0200
From: Barkle <barkle@gmx.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8185
References: <4A199FED.7000609@gmx.net>	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>	 <4A1B00E7.5070801@gmx.net>	 <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>	 <4A1B2186.3070107@gmx.net>	 <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com>	 <4A1C1766.3030004@gmx.net> <4A1C74C1.7060600@gmx.net> <3ace41890905261651l1cd3742bu5ac1af6f631798f3@mail.gmail.com>
In-Reply-To: <3ace41890905261651l1cd3742bu5ac1af6f631798f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung schrieb:
> On Wed, May 27, 2009 at 12:01 AM, Barkle <barkle@gmx.net> wrote:
>   
>> Barkle schrieb:
>>     
>>> Hin-Tak Leung schrieb:
>>>       
>>>> I am asking to a 2nd time - try compat-wireless.
>>>>         
>>> When I compile compat-wireless, I get an error
>>>
>>>       
>> After commenting out in the file "config.mk" the line
>> #CONFIG_MAC80211_LEDS=y
>>     
>
> Hmm, your kernel config did not seem to have LEDS_TRIGGER defined.
> That's a problem with non-distro custom-rolled kernel... For that
> matter, which bits of the kernel did you build as modules and which
> compiled in? I guess I need the output of these two commands:
>
>     lsmod
>     find /lib/modules/`uname -r`/updates
>   
Do you need the kernel config?

feta:~# lsmod
Module                  Size  Used by
af_packet              17180  2
loop                   14120  0
ecb                     2428  2
rtl8180                28668  0
mac80211              173848  1 rtl8180
eeprom_93cx6            1660  1 rtl8180
psmouse                41292  0
cfg80211               80660  2 rtl8180,mac80211
3c59x                  39972  0
mii                     4508  1 3c59x
ide_cd_mod             27808  0
cdrom                  33984  1 ide_cd_mod
unix                   24748  19
feta:~# find /lib/modules/`uname -r`/updates
/lib/modules/2.6.30-rc6-1/updates
/lib/modules/2.6.30-rc6-1/updates/drivers
/lib/modules/2.6.30-rc6-1/updates/drivers/misc
/lib/modules/2.6.30-rc6-1/updates/drivers/misc/eeprom
/lib/modules/2.6.30-rc6-1/updates/drivers/misc/eeprom/eeprom_93cx6.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net
/lib/modules/2.6.30-rc6-1/updates/drivers/net/b44.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/adm8211.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ath
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ath/ath.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ath/ath5k
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ath/ath9k
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ath/ath9k/ath9k.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/b43
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/b43/b43.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/b43legacy
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/b43legacy/b43legacy.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ipw2x00
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ipw2x00/ipw2100.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ipw2x00/ipw2200.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/ipw2x00/libipw.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/iwlwifi
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/iwlwifi/iwl3945.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/iwlwifi/iwlagn.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/iwlwifi/iwlcore.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/mac80211_hwsim.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/mwl8k.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/p54
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/p54/p54common.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/p54/p54pci.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rt2x00
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rt2x00/rt2400pci.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rt2x00/rt2500pci.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rt2x00/rt61pci.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rtl818x
/lib/modules/2.6.30-rc6-1/updates/drivers/net/wireless/rtl818x/rtl8180.ko
/lib/modules/2.6.30-rc6-1/updates/drivers/ssb
/lib/modules/2.6.30-rc6-1/updates/drivers/ssb/ssb.ko
/lib/modules/2.6.30-rc6-1/updates/net
/lib/modules/2.6.30-rc6-1/updates/net/mac80211
/lib/modules/2.6.30-rc6-1/updates/net/mac80211/mac80211.ko
/lib/modules/2.6.30-rc6-1/updates/net/wireless
/lib/modules/2.6.30-rc6-1/updates/net/wireless/cfg80211.ko
/lib/modules/2.6.30-rc6-1/updates/net/wireless/lib80211_crypt_ccmp.ko
/lib/modules/2.6.30-rc6-1/updates/net/wireless/lib80211_crypt_tkip.ko
/lib/modules/2.6.30-rc6-1/updates/net/wireless/lib80211_crypt_wep.ko


>> the code compiles without an error.
>> Then "make install", reboot and "wpa_supplicant -Dwext -iwlan0
>> -c/etc/wpa_supplicant/wpa_supplicant.conf -W -dd" => kernel freeze.
>>     
>
> Hmm, can you *not* run wpa_supplicant? This is about the 3rd time I
> asked - if you are not using encryption, you don't need
> wpa_supplicant. You should be doing just 'ifconfig wlan0 up', and
> 'ifconfig wlan0' and 'iwconfig wlan0' and see what they say. And do
> *not* do it in X - if there is any last minute crash message, it would
> be in the text console and you should be better doing these in
> run-level 3.
>   
**************************
from /etc/network/interfaces

iface wlan0 inet static
    address 192.168.43.129
    netmask 255.255.255.0

**************************

After "ifconfig wlan0 up" the system freeze
It's just every time the interface has to work, it's gonna freeze. It 
doesn't matter if I use wpa_supplicant or ifupdown (which invokes at 
last wpa_supplicant, so far as I know, on the debian system)

I can use " /etc/modprobe.d/rtl8185" to set the regulatory domain 
"options cfg80211 ieee80211_regdom=EU"
I can use "iwconfig wlan0 channel 6", that works (and some ather stuff).



***********************
feta:~# iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

feta:~# iwconfig wlan0 channel 6
feta:~# iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:""
          Mode:Managed  Frequency:2.437 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

***********************

feta:~# ifconfig wlan0
wlan0     Link encap:Ethernet  Hardware Adresse 00:0e:2e:e9:b5:fd
          BROADCAST MULTICAST  MTU:1500  Metrik:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          Kollisionen:0 Sendewarteschlangenlänge:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

***********************

