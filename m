Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11.bullet.mail.ird.yahoo.com ([77.238.189.64]:36342 "HELO
	nm11.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751313Ab2GYRTm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 13:19:42 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com>
Message-ID: <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> (sfid-20120725_191946_771567_5E2D20DF)
Date: Wed, 25 Jul 2012 18:19:40 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After uninstall (make uninstall), it's back to normal.

The syslog says:
Jul 25 19:14:55 HTPC kernel: [10126.298298] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Jul 25 19:14:55 HTPC NetworkManager[1260]:    SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0)
Jul 25 19:14:55 HTPC NetworkManager[1260]:    SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0): no ifupdown configuration found.
Jul 25 19:14:55 HTPC kernel: [10126.692251] device wlan0 entered promiscuous mode
Jul 25 19:14:55 HTPC kernel: [10126.693037] br0: port 2(wlan0) entering forwarding state
Jul 25 19:14:55 HTPC kernel: [10126.693073] br0: port 2(wlan0) entering forwarding state
Jul 25 19:14:57 HTPC avahi-daemon[1256]: Joining mDNS multicast group on interface wlan0.IPv6 with address fe80::e291:53ff:fe6f:55e7.
Jul 25 19:14:57 HTPC avahi-daemon[1256]: New relevant interface wlan0.IPv6 for mDNS.
Jul 25 19:14:57 HTPC avahi-daemon[1256]: Registering new address record for fe80::e291:53ff:fe6f:55e7 on wlan0.*.
Jul 25 19:15:06 HTPC kernel: [10137.351494] wlan0: no IPv6 routers present
Jul 25 19:15:11 HTPC kernel: [10141.717652] br0: port 2(wlan0) entering forwarding state

Jul 25 19:15:39 HTPC dhcrelay: Discarding packet received on wlan0 interface that has no IPv4 address assigned.

kernel log says:
Jul 25 19:17:30 HTPC kernel: [10281.037865] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Jul 25 19:17:30 HTPC kernel: [10281.390776] device wlan0 entered promiscuous mode
Jul 25 19:17:30 HTPC kernel: [10281.391433] br0: port 2(wlan0) entering forwarding state
Jul 25 19:17:30 HTPC kernel: [10281.391465] br0: port 2(wlan0) entering forwarding state

Jul 25 19:17:41 HTPC kernel: [10292.174075] wlan0: no IPv6 routers present
Jul 25 19:17:45 HTPC kernel: [10296.404288] br0: port 2(wlan0) entering forwarding state

and hostapd says:
Using interface wlan0 with hwaddr e0:91:53:6f:55:e7 and ssid 'Sweet Home 2'
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=12):
     53 77 65 65 74 20 48 6f 6d 65 20 32               Sweet Home 2    
PSK (ASCII passphrase) - hexdump_ascii(len=24): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=4 alg=2 addr=(nil) key_idx=1 set_tx=1 seq_len=0 key_len=32
nl80211: Set beacon (beacon_set=0)
wlan0: Setup of interface done.
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb

Does anyone have a suggestion? Am not sure if the complain about IPv6 is important here. ...

Merci
XabiX
