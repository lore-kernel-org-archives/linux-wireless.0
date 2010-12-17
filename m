Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout022.mac.com ([17.148.16.97]:57733 "EHLO
	asmtpout022.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0LQLMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 06:12:48 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] (unknown [87.201.169.175])
 by asmtp022.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDK00KSGKH62P10@asmtp022.mac.com>
 for linux-wireless@vger.kernel.org; Fri, 17 Dec 2010 03:12:47 -0800 (PST)
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271 drivers
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <9B373863-A428-4A02-BFD2-DE5B5C914C48@mac.com>
Date: Fri, 17 Dec 2010 15:12:32 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <082B7C81-745C-4ABE-868D-EA3596138DD5@mac.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com>
 <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
 <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com>
 <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
 <98BC4735-664C-491E-80CE-356BE32FA2ED@mac.com>
 <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
 <C4B3622F-ADC4-481E-9340-1819C815184A@mac.com>
 <AANLkTikvk+AqKRr1VbKv9pSHicy7PAGu8GkdeZuvYwFh@mail.gmail.com>
 <397FC41E-7F1D-4AA8-9D09-6121BB0169E7@mac.com>
 <AANLkTimfNw7Lsp7vnLPt7SaC=SAg0ctMbunRBz4SybhD@mail.gmail.com>
 <9B373863-A428-4A02-BFD2-DE5B5C914C48@mac.com>
To: Arik Nemtsov <arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arik,
                Its working now. 

[    0.000000] wlan_mux_init: Configuring mux settings for wl1271 wlan module
[    2.143035] mmc1: mmc_rescan: trying to init card at 400000 Hz
[    2.292175] mmc1: card claims to support voltages below the defined range. These will be ignored.
[    2.337158] mmc1: queuing unknown CIS tuple 0x91 (3 bytes)
[    2.359710] mmc1: new SDIO card at address 0001
Starting udev
[    3.948883] udev: starting version 151
[    3.957519] udevd (550): /proc/550/oom_adj is deprecated, please use /proc/550/oom_score_adj instead.
[    5.156890] wl1271: loaded
[    5.159942] wl1271: initialized

# ifconfig -a
lo        Link encap:Local Loopback  
          LOOPBACK  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

wlan0     Link encap:Ethernet  HWaddr DE:AD:BE:EF:00:00  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

# ifconfig wlan0 up

# wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf
CTRL-EVENT-SCAN-RESULTS 
Trying to associate with 68:7f:74:1c:e4:7c (SSID='Olympus2' freq=2437 MHz)
Associated with 68:7f:74:1c:e4:7c
WPA: Key negotiation completed with 68:7f:74:1c:e4:7c [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 68:7f:74:1c:e4:7c completed (auth) [id=0 id_str=]


^Z[1] + Stopped                    wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf

# ifconfig -a
lo        Link encap:Local Loopback  
          LOOPBACK  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

wlan0     Link encap:Ethernet  HWaddr DE:AD:BE:EF:00:00  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:328 (328.0 b)  TX bytes:288 (288.0 b)


# ifconfig wlan0 inet 192.168.1.105 netmask 255.255.255.0

# ping 192.168.1.1

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=66.1 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=27.8 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=34.7 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=37.7 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=31.2 ms
^Z[2] + Stopped                    ping 192.168.1.1

# [  263.148956] cfg80211: Calling CRDA to update world regulatory domain


Best regards,

Elvis Dowson

