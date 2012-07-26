Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm10.bullet.mail.ird.yahoo.com ([77.238.189.39]:45071 "HELO
	nm10.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751720Ab2GZLBp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 07:01:45 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net>
Message-ID: <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> (sfid-20120726_130151_432754_E70D2B44)
Date: Thu, 26 Jul 2012 12:01:43 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <501121B5.4010305@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cool let's get this sorted then.

Here is the output now with the 3.4.6 kernel. If you prefer me to try with the 3.5, I can.

thanks

uname -r
3.4.6-custom

ifconfig 

br0       Link encap:Ethernet  HWaddr 80:ee:73:31:54:b2  
          inet addr:192.168.0.40  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::82ee:73ff:fe31:54b2/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:426 errors:0 dropped:0 overruns:0 frame:0
          TX packets:548 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:30369 (30.3 KB)  TX bytes:79172 (79.1 KB)

eth0      Link encap:Ethernet  HWaddr 80:ee:73:31:54:b2  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:510 errors:0 dropped:4 overruns:0 frame:0
          TX packets:546 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:54044 (54.0 KB)  TX bytes:79000 (79.0 KB)
          Interrupt:45 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:968 errors:0 dropped:0 overruns:0 frame:0
          TX packets:968 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:72060 (72.0 KB)  TX bytes:72060 (72.0 KB)

iwconfig 
br0       no wireless extensions.

wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.437 GHz  Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:on
          
lo        no wireless extensions.

eth0      no wireless extensions.

sudo modinfo rtl8192ce
filename:       /lib/modules/3.4.6-custom/kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
firmware:       rtlwifi/rtl8192cfwU_B.bin
firmware:       rtlwifi/rtl8192cfwU.bin
firmware:       rtlwifi/rtl8192cfw.bin
description:    Realtek 8192C/8188C 802.11n PCI wireless
license:        GPL
author:         Larry Finger    <Larry.Finger@lwfinger.net>
author:         Realtek WlanFAE <wlanfae@realtek.com>
author:         lizhaoming      <chaoming_li@realsil.com.cn>
srcversion:     AE758D5E662358264A4DB35
alias:          pci:v000010ECd00008176sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008177sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008178sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008191sv*sd*bc*sc*i*
depends:        rtlwifi,rtl8192c-common,mac80211
intree:         Y
vermagic:       3.4.6-custom SMP mod_unload modversions 686 
parm:           swenc:Set to 1 for software crypto (default 0)
parm:           ips:Set to 0 to not use link power save (default 1)

parm:           swlps:Set to 1 to use SW control power save (default 0)

parm:           fwlps:Set to 1 to use FW control power save (default 1)

parm:           debug:Set debug level (0-5) (default 0) (int)



sudo hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf

nl80211: Register Action command failed: ret=-114 (Operation already in progress)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Interface wlan0 is in bridge br0
nl80211: Add own interface ifindex 3
nl80211: Add own interface ifindex 4
Failed to create interface mon.wlan0: -23 (Too many open files in system)
Try to remove and re-create mon.wlan0
nl80211: Remove interface ifindex=5
nl80211: New interface mon.wlan0 created: ifindex=6
nl80211: Add own interface ifindex 6
Could not set interface mon.wlan0 flags: Success
nl80211: Remove interface ifindex=6
nl80211: Failed to set interface wlan0 into AP mode
nl80211 driver initialization failed.
ELOOP: remaining socket: sock=4 eloop_data=0x8423900 user_data=0x8423eb0 handler=0x807c5e0
ELOOP: remaining socket: sock=6 eloop_data=0x8425cb8 user_data=(nil) handler=0x8086770

