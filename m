Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Gamera.Varna.Net ([217.145.80.8]:51508 "EHLO Gamera.varna.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbeIIRWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 13:22:37 -0400
Received: from [192.168.110.102] (ip4-nat-95-82-135-157.cust.nbox.cz [95.82.135.157] (may be forged))
        (authenticated bits=0)
        by Gamera.varna.net (8.15.2/8.15.2) with ESMTPSA id w89CWvoW018699
        (version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-wireless@vger.kernel.org>; Sun, 9 Sep 2018 15:32:59 +0300
Subject: Testing simulated Wi-Fi with hostap
References: <050031f7-7699-9eac-7c9b-e26315cd0870@varna.net>
To: linux-wireless@vger.kernel.org
From: Pavlin Georgiev <pavlin@varna.net>
Message-ID: <1304eeb8-67e4-485e-754e-4001d16ee88d@varna.net> (sfid-20180909_143348_640028_E74000FC)
Date: Sun, 9 Sep 2018 14:32:56 +0200
MIME-Version: 1.0
In-Reply-To: <050031f7-7699-9eac-7c9b-e26315cd0870@varna.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am a software tester who decided to experiment with hostap.
I am not a C++ programmer, but I have general understanding of that 
language.
My Linux distro is Fedora 27.


My goal is to test network connections with various authentication methods
between a simulated Wi-Fi access point and a station.
I would like to test on a physical/virtual machine without Wi-Fi adapter.
One testing machine contains both - the access point and the station.


What I did so far?
I read the documentation...

     https://wireless.wiki.kernel.org/en/users/documentation/hostapd
     http://w1.fi/hostapd/
     https://wireless.wiki.kernel.org/en/users/drivers/mac80211_hwsim


I installed hostap:
yum install hostapd



I loaded the module:
modprobe mac80211_hwsim



I check network devices:

# nmcli device
DEVICE      TYPE      STATE         CONNECTION
virbr0      bridge    connected     virbr0
enp7s0      ethernet  connected     enp7s0
vnet0       tun       connected     vnet0
wlan0       wifi      disconnected  --
wlan1       wifi      disconnected  --
lo          loopback  unmanaged     --
virbr0-nic  tun       unmanaged     --
hwsim0      unknown   unmanaged     --



When I follow the steps from the 
https://wireless.wiki.kernel.org/en/users/drivers/mac80211_hwsim#simple_example[simple 
example] from the documentation
then I receive message:

Configuration file: hostapd.conf
nl80211: Could not configure driver mode
nl80211: deinit ifname=wlan0 disabled_11b_rates=0
nl80211 driver initialization failed.
wlan0: interface state UNINITIALIZED->DISABLED
wlan0: AP-DISABLED
hostapd_free_hapd_data: Interface wlan0 wasn't started


When I try to load module nl80211 manually
then I see:
modprobe: FATAL: Module nl80211 not found in directory 
/lib/modules/4.13.16-302.fc27.x86_64

I try another configuration taken from gitweb:
http://w1.fi/cgit/hostap/tree/tests/hwsim


When I load hostapd with configuration "bss-1.conf"
then I receive message:

Configuration file: bss-1.conf
Could not read interface wlan3 flags: No such device
nl80211: Driver does not support authentication/association or connect 
commands
nl80211: deinit ifname=wlan3 disabled_11b_rates=0
Could not read interface wlan3 flags: No such device
nl80211 driver initialization failed.
wlan3: interface state UNINITIALIZED->DISABLED
wlan3: AP-DISABLED
hostapd_free_hapd_data: Interface wlan3 wasn't started


When I replace interface wlan3 with wlan0
  and I run hostapd with configuration "bss-1.conf"
then I receive message:

Configuration file: bss-1.conf
nl80211: Could not configure driver mode
nl80211: deinit ifname=wlan0 disabled_11b_rates=0
nl80211 driver initialization failed.
wlan0: interface state UNINITIALIZED->DISABLED
wlan0: AP-DISABLED
hostapd_free_hapd_data: Interface wlan0 wasn't started


Questions
1. Why does hostapd fail to start?
2. Which of the interfaces wlan0 and wlan1 should be the AP?
3. What configuration should be taken as example for simulated AP and 
station?
4. How to troubleshoot the initial loading of hostapd?


Details
kernel-4.13.16-302.fc27.x86_64
hostapd-2.6-9.fc27.x86_64


Thank you in advance for any advice.
Pavlin
