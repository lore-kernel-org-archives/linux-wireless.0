Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:24988 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaBJIid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 03:38:33 -0500
Message-ID: <52F88FEA.3000102@huawei.com> (sfid-20140210_093836_899113_452FFDB7)
Date: Mon, 10 Feb 2014 16:38:02 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <zhousiyi@huawei.com>
Subject: Re: Get multiple ip addresses by dhcp for wireless card
References: <52F84DFD.4030602@huawei.com> <52F87608.808@candelatech.com>
In-Reply-To: <52F87608.808@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014/2/10 14:47, Ben Greear wrote:
> On 02/09/2014 07:56 PM, Zhao Hongjiang wrote:
>> Hello,
>>
>> Is it possible for one station to get multiple ip addresses from AP/Wireless
>> router by dhcp? I had tried to add one or more virtual interface for
>> phy0 (wlan0, wlan1, wlan2,etc), but only wlan0 can get ip address from AP.
>> the following is the steps:
>>
>> /bin/wpa_supplicant -ddd -iwlan0 -Dnl80211 -c/wifi/wpa_supplicant.conf -B
>> /bin/wpa_cli -i wlan0 -p /wlan0
>>> add_network
>>> set_network 0 ssid "APabc"
>>> set_network 0 psk "1111111"
>>> enable_network 0
>>
>> iw wlan0 interface add wlan1 type station 4addr on
>> ip link set wlan1 up
>> dhcpcd -ABKL wlan0 #works, can get ip
>> dhcpcd -ABKL wlan1 #cannot work
> 
> Virtual stations work just fine for me, though I don't use that '4addr' thing.
> ...maybe sniff your wlan1 and see if it is sending
> out proper DHCP requests (and they are being received by the AP)?
> 
> You have to create a new supplicant config for each virtual station,
> or run a unique supplicant instance for each station.

I try to follow the instruction which you give and do the following command, but wlan1 
cannot associate with AP.

1. root@local# /bin/wpa_supplicant -ddd -iwlan0 -Dnl80211 -c/wifi/wpa_supplicant.conf -B
2. root@local# iw wlan0 interface add wlan1 type station
3. root@local# /bin/wpa_supplicant -ddd -iwlan1 -Dnl80211 -c/wifi/wpa_supplicant_wlan1.conf -B

wpa_supplicant_wlan1.conf file contains folliwng lines:

ctrl_interface=wlan1
driver_param=use_multi_chan_concurrent=1
update_config=1
config_methods=physical_display virtual_push_button keypad

After this step, when using ifconfig, "ifconfig wlan1" gave a unusual hwaddr, is it a issue?
ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:13:0B:D2:2D:B1  
          inet6 addr: fe80::213:bff:fed2:2db1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

ifconfig wlan1
wlan1     Link encap:Ethernet  HWaddr 02:00:00:00:00:00  
          inet6 addr: fe80::ff:fe00:0/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
	  
4. root@local# /system/bin/wpa_cli -i wlan0 -p /wlan0
   >add_network
   >set_network 2 ssid "APabc" 
   >set_network 2 psk "11111111" 
   >enable_network 2

   wlan0 can associate with ap.

5. root@local# /bin/wpa_cli -i wlan1 -p /wlan1
   > add_network
   > set_network 0 ssid "APabc" 
   > set_network 0 psk "11111111" 
   > enable_network 0

   it will give the following result:
   <3>CTRL-EVENT-STATE-CHANGE id=-1 state=3 BSSID=00:00:00:00:00:00 SSID=
   <3>CTRL-EVENT-SCAN-RESULTS 
   <3>Trying to associate with 78:f5:fd:77:e5:a4 (SSID='APabc' freq=2462 MHz)
   <3>CTRL-EVENT-STATE-CHANGE id=-1 state=5 BSSID=00:00:00:00:00:00 SSID=
   <3>CTRL-EVENT-ASSOC-REJECT status_code=1

   so wlan1 cannot associate with ap.

   further help is appreciated, thanks.
> 
> To do any useful traffic, between stations, you will have to be careful
> about setting up routing rules and use special binding commands for your
> traffic types.
> 
> Thanks,
> Ben
> 


