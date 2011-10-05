Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42763 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1JFFKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 01:10:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RBgDd-0002c5-RP
	for linux-wireless@vger.kernel.org; Thu, 06 Oct 2011 07:10:06 +0200
Received: from 121.241.106.73.static-delhi.vsnl.net.in ([121.241.106.73.static-delhi.vsnl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 07:10:05 +0200
Received: from mail.manishverma by 121.241.106.73.static-delhi.vsnl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 07:10:05 +0200
To: linux-wireless@vger.kernel.org
From: Manish Verma <mail.manishverma@gmail.com>
Subject: hostapd with Ralink3060,  SSID not visible to STA
Date: Wed, 5 Oct 2011 10:47:01 +0000 (UTC)
Message-ID: <loom.20111005T122216-407@post.gmane.org> (sfid-20111006_071012_155066_D045BE25)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm not able to see the SSID configured on my x86 PC using hostapd-0.7.3 with a 
DWA-525 (Dlink N-150) wifi adapter.
This card has a Ralink's 3060 chipset that is using rt2800pci drivers.

Although hostapd is able to configure the card in AP mode but its SSID is not 
visible to other STAs to connect.


I'm using FC15 shipped kernel 2.6.28.6-26.rc1.fc15.i686

Has someone got this configuration working? Any pointers to the solution are 
welcome.

Best regards,
Manish

Logs:-

#ifconfig wlan0
shows that some packets are transmitted but none received. (byte count never 
increases further)
{{{
[root@localhost ~]# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 14:D6:4D:4B:C9:A6
          inet6 addr: fe80::16d6:4dff:fe4b:c9a6/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:30 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:2880 (2.8 KiB)

}}}

hostapd console messages are as follows:
{{{

[root@localhost hostapd]# ./hostapd -ddd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=10 (from group name 'wheel')
nl80211: Add own interface ifindex 3
nl80211: New interface mon.wlan0 created: ifindex=7
nl80211: Add own interface ifindex 7
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=13 freq=2472 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=13 freq=2472 MHz max_tx_power=20 dBm
RATE[0] rate=10 flags=0x1
RATE[1] rate=20 flags=0x1
RATE[2] rate=55 flags=0x1
RATE[3] rate=110 flags=0x1
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Completing interface initialization
Mode: IEEE 802.11g  Channel: 11  Frequency: 2462 MHz
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0 set_tx=1 
seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1 set_tx=0 
seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2 set_tx=0 
seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3 set_tx=0 
seq_len=0 key_len=0
Using interface wlan0 with hwaddr 14:d6:4d:4b:c9:a6 and ssid 'Test'
nl80211: Set beacon (beacon_set=0)
wlan0: Setup of interface done.
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
}}}

hostapd.conf
{{{

ctrl_interface=/var/run/hostapd
ctrl_interface_group=wheel

# Some usable default settings...
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0

# Uncomment these for base WPA & WPA2 support with a pre-shared key
#wpa=2
#wpa_key_mgmt=WPA-PSK
#wpa_pairwise=TKIP
#rsn_pairwise=CCMP

# DO NOT FORGET TO SET A WPA PASSPHRASE!!
#wpa_passphrase=YourPassPhrase

# Most modern wireless drivers in the kernel need driver=nl80211
driver=nl80211

# Customize these for your local configuration...
interface=wlan0
hw_mode=g
channel=11
ssid=Test
}}}

