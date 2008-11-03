Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:9689 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbYKCEHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 23:07:25 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2362003rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 20:07:24 -0800 (PST)
Message-ID: <43075fc60811022007o74803868l8d6d223e18f26ce2@mail.gmail.com> (sfid-20081103_050731_341163_8B6A5799)
Date: Sun, 2 Nov 2008 23:07:24 -0500
From: "Iordan Iordanov" <iiordanov@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath9k driver runs out of TX descriptors
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43075fc60811021914v39a98f8dxc52fdbfd20f2a81d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43075fc60811012033t6fdcd1c4h2c4868659afa9ec5@mail.gmail.com>
	 <43e72e890811021227m30231c2ega9ab1c3f0eac71d6@mail.gmail.com>
	 <43075fc60811021914v39a98f8dxc52fdbfd20f2a81d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> Usually, all the logs are awfully quiet for a while, and sometimes it
> unstalls, and continues to copy, or it reports "No ProbeResp" and
> disconnects and tries to reconnect. I haven't been able to transfer
> more than 130MB without a stall, although once I establish a working
> connection and I don't load it heavily, I am able to browse the
> Internet and do small tasks without instigating a stall.

Actually, I got some syslog output last time the connection stalled,
so I am including it here:

Nov  2 22:21:17 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 5 -> 6
Nov  2 22:21:17 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:22:50 pancake NetworkManager: <debug> [1225682570.965431]
periodic_update(): Roamed from BSSID xx:xx:xx:xx:xx:xx
(wirelessnetwork) to (none) ((none))
Nov  2 22:22:56 pancake NetworkManager: <debug> [1225682576.969473]
periodic_update(): Roamed from BSSID (none) ((none)) to
xx:xx:xx:xx:xx:xx (wirelessnetwork)
Nov  2 22:43:45 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:45 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:46 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:46 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:47 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:47 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:48 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:48 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:49 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:49 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:50 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:50 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:51 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:51 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:52 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 6
Nov  2 22:43:52 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 6 -> 7
Nov  2 22:43:53 pancake kernel: [74338.355791] wlan3: deauthenticated
Nov  2 22:43:53 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 0
Nov  2 22:43:53 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 22:43:54 pancake kernel: [74339.353181] wlan3: direct probe to
AP xx:xx:xx:xx:xx:xx try 1
Nov  2 22:43:54 pancake kernel: [74339.356905] wlan3 direct probe responded
Nov  2 22:43:54 pancake kernel: [74339.356919] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 22:43:54 pancake kernel: [74339.359757] wlan3: authenticated
Nov  2 22:43:54 pancake kernel: [74339.359769] wlan3: associate with
AP xx:xx:xx:xx:xx:xx
Nov  2 22:43:54 pancake kernel: [74339.364025] wlan3: RX ReassocResp
from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
Nov  2 22:43:54 pancake kernel: [74339.364036] wlan3: associated
Nov  2 22:43:54 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 4
Nov  2 22:43:56 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 4 -> 5
Nov  2 22:44:04 pancake kernel: [74348.925408] wlan3: deauthenticated
Nov  2 22:44:04 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 5 -> 0
Nov  2 22:44:04 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 22:44:05 pancake kernel: [74349.925508] wlan3: direct probe to
AP xx:xx:xx:xx:xx:xx try 1
Nov  2 22:44:05 pancake kernel: [74349.929232] wlan3 direct probe responded
Nov  2 22:44:05 pancake kernel: [74349.929246] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 22:44:05 pancake kernel: [74349.931465] wlan3: authenticated
Nov  2 22:44:05 pancake kernel: [74349.931474] wlan3: associate with
AP xx:xx:xx:xx:xx:xx
Nov  2 22:44:05 pancake kernel: [74349.935733] wlan3: RX ReassocResp
from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
Nov  2 22:44:05 pancake kernel: [74349.935745] wlan3: associated
Nov  2 22:44:05 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 4
Nov  2 22:44:07 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 4 -> 5
Nov  2 22:44:08 pancake NetworkManager: <info>  (wlan3): device state
change: 8 -> 3
Nov  2 22:44:08 pancake NetworkManager: <info>  (wlan3): deactivating
device (reason: 11).
Nov  2 22:44:09 pancake NetworkManager: <info>  wlan3: canceled DHCP
transaction, dhcp client pid 9265
Nov  2 22:44:09 pancake kernel: [74353.600555] wlan3: disassociating
by local choice (reason=3)
Nov  2 22:44:09 pancake NetworkManager: <WARN>  check_one_route():
(wlan3) error -34 returned from rtnl_route_del(): Sucess
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation (wlan3)
starting connection 'Auto wirelessnetwork'
Nov  2 22:44:09 pancake NetworkManager: <info>  (wlan3): device state
change: 3 -> 4
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) scheduled...
Nov  2 22:44:09 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 5 -> 0
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) started...
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) scheduled...
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) complete.
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) starting...
Nov  2 22:44:09 pancake NetworkManager: <info>  (wlan3): device state
change: 4 -> 5
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation
(wlan3/wireless): connection 'Auto wirelessnetwork' has security, and
secrets exist.  No new secrets needed.
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: added 'ssid'
value 'wirelessnetwork'
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: added
'scan_ssid' value '1'
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: added
'key_mgmt' value 'WPA-PSK'
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: added 'psk'
value '<omitted>'
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: added 'proto'
value 'WPA RSN'
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: added
'pairwise' value 'TKIP CCMP'
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: added 'group'
value 'WEP40 WEP104 TKIP CCMP'
Nov  2 22:44:09 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) complete.
Nov  2 22:44:09 pancake avahi-daemon[4829]: Withdrawing address record
for 192.168.2.198 on wlan3.
Nov  2 22:44:09 pancake avahi-daemon[4829]: Leaving mDNS multicast
group on interface wlan3.IPv4 with address 192.168.2.198.
Nov  2 22:44:09 pancake avahi-daemon[4829]: Interface wlan3.IPv4 no
longer relevant for mDNS.
Nov  2 22:44:09 pancake NetworkManager: <info>  Config: set interface
ap_scan to 1
Nov  2 22:44:09 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 22:44:10 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 3
Nov  2 22:44:12 pancake kernel: [74356.691258] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 22:44:12 pancake kernel: [74356.693551] wlan3: authenticated
Nov  2 22:44:12 pancake kernel: [74356.693569] wlan3: associate with
AP xx:xx:xx:xx:xx:xx
Nov  2 22:44:12 pancake kernel: [74356.697979] wlan3: RX AssocResp
from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
Nov  2 22:44:12 pancake kernel: [74356.697994] wlan3: associated
Nov  2 22:44:12 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 3 -> 4
Nov  2 22:44:20 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 4 -> 0
Nov  2 22:44:20 pancake kernel: [74364.625485] wlan3: deauthenticated
Nov  2 22:44:20 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 22:44:21 pancake kernel: [74365.628139] wlan3: direct probe to
AP xx:xx:xx:xx:xx:xx try 1
Nov  2 22:44:21 pancake kernel: [74365.631888] wlan3 direct probe responded
Nov  2 22:44:21 pancake kernel: [74365.631904] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 22:44:21 pancake kernel: [74365.635039] wlan3: authenticated
Nov  2 22:44:21 pancake kernel: [74365.635051] wlan3: associate with
AP xx:xx:xx:xx:xx:xx
Nov  2 22:44:21 pancake kernel: [74365.639412] wlan3: RX ReassocResp
from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
Nov  2 22:44:21 pancake kernel: [74365.639429] wlan3: associated
Nov  2 22:44:21 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 4

I believe that at the end of this output it unstalled for a while and
copied some more.

I hope this helps,
Iordan

-- 
The conscious mind has only one thread of execution.
