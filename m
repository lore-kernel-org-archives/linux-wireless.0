Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailin.taunusstein.net ([193.138.96.2]:59849 "EHLO
	mailin.taunusstein.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZHAIY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:24:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailin.taunusstein.net (Postfix) with ESMTP id 0BB4047A07
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2009 10:16:17 +0200 (CEST)
Received: from mailin.taunusstein.net ([127.0.0.1])
	by localhost (mail.taunusstein.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nfNylSymsRYd for <linux-wireless@vger.kernel.org>;
	Sat,  1 Aug 2009 10:16:11 +0200 (CEST)
Received: from [192.168.1.45] (u5-2.dsl.vianetworks.de [194.231.189.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "hostmaster@taunusstein.net", Issuer "taunusstein.net Root CA" (verified OK))
	by mailin.taunusstein.net (Postfix) with ESMTPS
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2009 10:16:11 +0200 (CEST)
Message-ID: <4A73F9CB.8000606@taunusstein.net>
Date: Sat, 01 Aug 2009 10:16:11 +0200
From: Christian Felsing <hostmaster@taunusstein.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Multiple BSSID problem with hostapd
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I ran into problems configuring multiple BSSID in hostapd, because
hostapd is running in an error. My intention is to set up one public
ssid and one private ssid. I think it is a configuration problem, but
neither Google nor http://linuxwireless.org/ gives a hint.

I did following steps:

debian:~# iw reg set DE
debian:~# ip link set wlan0 addr 00:15:6d:84:0e:00

...works so far

config file /etc/hostapd/hostapd.conf contains following content:

interface=wlan0
bridge=br0
driver=nl80211
ieee80211n=1
ht_capab=[SHORT-GI-40][DSSS_CCK-40][HT40-][HT40+][HT20]
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=cftest
country_code=DE
ieee80211d=1
hw_mode=g
channel=1
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
auth_algs=3
ignore_broadcast_ssid=0
wme_enabled=1
wme_ac_bk_cwmin=4
wme_ac_bk_cwmax=10
wme_ac_bk_aifs=7
wme_ac_bk_txop_limit=0
wme_ac_bk_acm=0
wme_ac_be_aifs=3
wme_ac_be_cwmin=4
wme_ac_be_cwmax=10
wme_ac_be_txop_limit=0
wme_ac_be_acm=0
wme_ac_vi_aifs=2
wme_ac_vi_cwmin=3
wme_ac_vi_cwmax=4
wme_ac_vi_txop_limit=94
wme_ac_vi_acm=0
wme_ac_vo_aifs=2
wme_ac_vo_cwmin=2
wme_ac_vo_cwmax=3
wme_ac_vo_txop_limit=47
wme_ac_vo_acm=0
eapol_key_index_workaround=0
eap_server=0
own_ip_addr=127.0.0.1
bss=wlan0_0
ssid=taunusstein.net

after starting hostapd with that config following happens:

debian:~# hostapd -ddd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 166465272
BSS count 2, BSSID mask ff:ff:ff:ff:ff:fe (1 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
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
HT40: control channel: 1  secondary channel: 5
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x6
RATE[2] rate=55 flags=0x6
RATE[3] rate=110 flags=0x6
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Passive scanning not supported
Flushing old station entries
Deauthenticate all stations
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
Using interface wlan0 with hwaddr 00:15:6d:84:0e:00 and ssid 'cftest'
Failed to add BSS (BSSID=00:15:6d:84:0e:01)
wlan0: Unable to setup interface.
Failed to remove interface.


if I remove lines
 bss=wlan0_0
 ssid=taunusstein.net

then hostapd starts and I get at least an unencrypted WLAN and I got
following interfaces:

debian:/usr/src# ifconfig
mon.wlan0 Link encap:UNSPEC  HWaddr
00-15-6D-84-0E-51-77-6C-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr 00:15:6d:84:0e:00
          inet6 addr: fe80::215:6dff:fe84:e00/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:100 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:9171 (8.9 KiB)

debian:/usr/src# iwconfig
wlan0     IEEE 802.11abgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=20
dBm
          Retry  long limit:7   RTS thr=2347 B   Fragment thr=2346 B
          Power Management:on

mon.wlan0  IEEE 802.11abgn  Mode:Monitor  Frequency:2.412 GHz
Tx-Power=20 dBm
          Retry  long limit:7   RTS thr=2347 B   Fragment thr=2346 B
          Power Management:on

(non relevant interfaces stripped from output)

Clients are able to join network.

My platform:

* Alix 2D3
* Ubiquity SR-71A (driver ath9k from compat-wireless-2009-07-31)
* Debian Lenny
* Kernel 2.6.30.4
* compat-wireless-2009-07-31
* 2009.04.17-regulatory.bin
* crda-1.1.0
* hostapd-0.6.9
* iw-0.9.15

As long as no additional bss is configured, everything works well
including WPA/WPA2 and 802.11n but channels 12/13 - but at this time I
don't care about that missing channels.

Christian

