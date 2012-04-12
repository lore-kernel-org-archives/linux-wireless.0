Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58358 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab2DLLw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 07:52:57 -0400
Received: by yenl12 with SMTP id l12so972610yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 04:52:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F855FC4.1080707@visionsystems.de>
References: <4F855997.20603@visionsystems.de> <1334139944.10398.11.camel@cumari>
 <4F855FC4.1080707@visionsystems.de>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Thu, 12 Apr 2012 13:52:36 +0200
Message-ID: <CAGm1_ktjuRbq_8Dep4JNfGaQqUuadbBoxLhr9RtqT4KgNDysvA@mail.gmail.com> (sfid-20120412_135303_079625_E57770F6)
Subject: Re: wl1271: communication fails with kernel 3.4-rc2 and firmware
 series 4
To: yegor_sub1@visionsystems.de
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	arik@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2012 at 12:41 PM, Yegor Yefremov
<yegor_sub1@visionsystems.de> wrote:
> Am 11.04.2012 12:25, schrieb Luciano Coelho:
>> Hi Yegor,
>>
>> On Wed, 2012-04-11 at 12:14 +0200, Yegor Yefremov wrote:
>>> continuing our yesterdays discussion on IRC I try to summarize my
>>> results.
>>>
>>> First of all I calibrated my WLAN card via ti-utils as described here
>>> http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator using
>>> calibrator plt calibrate.
>>>
>>> Then I integrated this nvs file into kernel, so I have no longer these
>>> nasty errors.
>>>
>>> Still I cannot ping anything. Here you can see the end of
>>> wpa_supplicant's log:
>>>
>>> WPA: Installing PTK to the driver.
>>> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=0x42a48 key_idx=0 set_tx=1 seq_len=6 key_len=32
>>>    addr=5c:d9:98:f9:30:d9
>>> EAPOL: External notification - portValid=1
>>> State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
>>> RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
>>> WPA: Group Key - hexdump(len=32): [REMOVED]
>>> WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
>>> WPA: RSC - hexdump(len=6): b1 7c 0d 00 00 00
>>> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=0x2a443 key_idx=1 set_tx=0 seq_len=6 key_len=32
>>> WPA: Key negotiation completed with 5c:d9:98:f9:30:d9 [PTK=TKIP GTK=TKIP]
>>> Cancelling authentication timeout
>>> Removed BSSID 5c:d9:98:f9:30:d9 from blacklist
>>> State: GROUP_HANDSHAKE -> COMPLETED
>>> CTRL-EVENT-CONNECTED - Connection to 5c:d9:98:f9:30:d9 completed (reauth) [id=1
>>> id_str=]
>>> wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
>>> netlink: Operstate: linkmode=-1, operstate=6
>>> EAPOL: External notification - portValid=1
>>> EAPOL: External notification - EAP success=1
>>> EAPOL: SUPP_PAE entering state AUTHENTICATING
>>> EAPOL: SUPP_BE entering state SUCCESS
>>> EAP: EAP entering state DISABLED
>>> EAPOL: SUPP_PAE entering state AUTHENTICATED
>>> EAPOL: Supplicant port status: Authorized
>>> EAPOL: SUPP_BE entering state IDLE
>>> EAPOL authentication completed successfully
>>> RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
>>> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
>>> EAPOL: startWhen --> 0
>>> EAPOL: disable timer tick
>>>
>>> Any ideas? As i told before both 2.6.37 and 3.3-rc7 made no problems.
>> Hard to say.  From these logs everything seems to be working fine.  What
>> IP address are you using? Are you sure your routes are all set up
>> correctly? Do you get any messages in the kernel logs, TX stuck
>> watchdog, maybe?
>
> As soon as I replace 3.4 with 2.6.37 pings go through.
>
> # ifconfig wlan0
> wlan0     Link encap:Ethernet  HWaddr 00:04:D9:80:55:02
>          inet addr:192.168.1.239  Bcast:192.168.1.255  Mask:255.255.255.0
>          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>          RX packets:5 errors:0 dropped:0 overruns:0 frame:0
>          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
>          collisions:0 txqueuelen:1000
>          RX bytes:737 (737.0 B)  TX bytes:568 (568.0 B)
>
> # route -n
> Kernel IP routing table
> Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
> 192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 wlan0
>
> #dmesg
> wl12xx: firmware booted (Rev 6.3.5.0.98)
> wlan0: authenticate with 5c:d9:98:f9:30:d9
> wlan0: send auth to 5c:d9:98:f9:30:d9 (try 1/3)
> wlan0: authenticated
> wlan0: associate with 5c:d9:98:f9:30:d9 (try 1/3)
> wlan0: RX AssocResp from 5c:d9:98:f9:30:d9 (capab=0x431 status=0 aid=2)
> wlan0: associated

I made debugging on Pandaboard:

Jan  1 00:09:55 buildroot user.info kernel:
dynamic_debug:ddebug_exec_queries: processed 1 queries, with 225
matches, 0 errs
Jan  1 00:10:28 buildroot user.debug kernel: wl12xx: mac80211 start
Jan  1 00:10:28 buildroot user.debug kernel: wl12xx: mac80211 add
interface type 2 mac de:ad:be:ef:00:00
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: MBOX ptrs: 0x4cf80 0x4cfc0
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: MBOX ptrs: 0x4cf80 0x4cfc0
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: available tx blocks: 99
Jan  1 00:10:29 buildroot user.info kernel: wl12xx: firmware booted
(Rev 6.3.5.0.98)
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: 11a is supported
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 bss info
changed 0xe
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 conf tx 0
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 conf tx 1
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 conf tx 2
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 conf tx 3
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 bss info
changed 0x2000
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 bss info
changed 0x4000
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 config
ch 1 psm off power 20 idle changed 0xffffffff
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: flushing tx buffer: 0 0
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211 config
ch 1 psm off power 20 idle changed 0x10
Jan  1 00:10:29 buildroot user.debug kernel: wl12xx: mac80211
configure filter changed 0 total 80000000
Jan  1 00:10:43 buildroot user.debug kernel: wl12xx: mac80211 hw scan
Jan  1 00:10:43 buildroot user.debug kernel: wl12xx: rx skb
0xef28c500: 214 B  seq 2896 hlid 0
Jan  1 00:10:43 buildroot user.debug kernel: wl12xx: rx skb
0xef28ca40: 142 B  seq 871 hlid 0
Jan  1 00:10:43 buildroot user.debug kernel: wl12xx: rx skb
0xef28c980: 214 B  seq 2897 hlid 0
Jan  1 00:10:43 buildroot user.debug kernel: wl12xx: rx skb
0xef28cc80: 281 B  seq 2364 hlid 0
Jan  1 00:10:43 buildroot user.debug kernel: wl12xx: rx skb
0xef28cb00: 142 B  seq 872 hlid 0
Jan  1 00:10:43 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2e00: 148 B beacon seq 1545 hlid 0
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: EVENT on mbox 0
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: MBOX DUMP:
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx:    vector: 0x400
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx:    mask: 0x3893bfe
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: vector: 0x400
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: status: 0x87
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: EVENT on mbox 1
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: MBOX DUMP:
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx:    vector: 0x400
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx:    mask: 0x3893bfe
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: vector: 0x400
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: status: 0x9f
Jan  1 00:10:44 buildroot user.debug kernel: wl12xx: mac80211 hw scan
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: EVENT on mbox 0
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: MBOX DUMP:
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx:    vector: 0x400
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx:    mask: 0x3893bfe
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: vector: 0x400
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: status: 0x87
Jan  1 00:10:45 buildroot user.debug kernel: wlan0: authenticate with
5c:d9:98:f9:30:d9
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 bss info
changed 0x4000
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 config
ch 1 psm off power 20 in use changed 0x100
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: EVENT on mbox 1
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: MBOX DUMP:
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx:    vector: 0x80000000
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx:    mask: 0x3893bfe
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: vector: 0x80000000
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 config
ch 1 psm off power 20 in use changed 0x40
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 bss info
changed 0xa0
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 sta 0 state=0->1
Jan  1 00:10:45 buildroot user.debug kernel: wlan0: send auth to
5c:d9:98:f9:30:d9 (try 1/3)
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: queue skb hlid 1 q 3 len 30
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx_allocate:
size: 46, blocks: 2, id: 0
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx_fill_hdr: pad:
2 hlid: 1 tx_attr: 0x824 len: 12 life: 2000 mem: 2
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2a40: 30 B  seq 0 hlid 1
Jan  1 00:10:45 buildroot user.debug kernel: wlan0: authenticated
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 sta 0 state=1->2
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx_complete
received, packets: 1
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx status id 0
skb 0xee7c2c80 failures 0 rate 0x15 status 0x0
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 config
ch 1 psm off power 20 in use changed 0x40
Jan  1 00:10:45 buildroot user.debug kernel: wlan0: associate with
5c:d9:98:f9:30:d9 (try 1/3)
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: queue skb hlid 1 q 3 len 73
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx_allocate:
size: 89, blocks: 2, id: 0
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx_fill_hdr: pad:
3 hlid: 1 tx_attr: 0xc24 len: 23 life: 2000 mem: 2
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx_complete
received, packets: 1
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: tx status id 0
skb 0xef28c680 failures 0 rate 0x15 status 0x0
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: rx skb
0xee7b99c0: 69 B  seq 1 hlid 1
Jan  1 00:10:45 buildroot user.debug kernel: wlan0: RX AssocResp from
5c:d9:98:f9:30:d9 (capab=0x431 status=0 aid=1)
Jan  1 00:10:45 buildroot user.debug kernel: wlan0: associated
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 sta 0 state=2->3
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 conf tx 0
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 conf tx 1
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 conf tx 2
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 conf tx 3
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: mac80211 bss info
changed 0x304d
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: rx skb
0xee7b9300: 131 B  seq 4 hlid 1
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: rx skb
0xee7b9240: 148 B beacon seq 1568 hlid 1
Jan  1 00:10:45 buildroot user.debug kernel: cfg80211: Pending
regulatory request, waiting for it to be processed...
Jan  1 00:10:45 buildroot user.debug kernel: wl12xx: rx skb
0xee7b9300: 220 B beacon seq 171 hlid 1
.............................................................................
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: rx skb
0xee7b6740: 220 B beacon seq 1920 hlid 1
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: queue skb hlid 1
q 0 len 153
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx_allocate:
size: 169, blocks: 2, id: 0
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx_fill_hdr: pad:
3 hlid: 1 tx_attr: 0xc24 len: 43 life: 2000 mem: 2
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx_complete
received, packets: 1
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx status id 0
skb 0xee7b6740 failures 0 rate 0x15 status 0x0
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: rx skb
0xee7b6740: 217 B  seq 5 hlid 1
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: rx skb
0xee7b6200: 247 B beacon seq 2387 hlid 1
.........................................................
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: rx skb
0xee7b39c0: 247 B beacon seq 2390 hlid 1
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: queue skb hlid 1
q 0 len 131
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx_allocate:
size: 147, blocks: 2, id: 0
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx_fill_hdr: pad:
1 hlid: 1 tx_attr: 0x424 len: 37 life: 2000 mem: 2
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx_complete
received, packets: 1
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: tx status id 0
skb 0xee7b39c0 failures 0 rate 0x13 status 0x0
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: mac80211 set key
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: mac80211 set key
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: mac80211 sta 0 state=3->4
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: mac80211 config
ch 1 psm on power 20 in use changed 0x10
Jan  1 00:10:46 buildroot user.debug kernel: wl12xx: rx skb
0xee7b3480: 148 B beacon seq 1577 hlid 1
..........................................................................................................
Jan  1 00:10:51 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2800: 220 B beacon seq 229 hlid 1
Jan  1 00:10:51 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2680: 118 B  seq 67 hlid 1
Jan  1 00:10:51 buildroot user.debug kernel: wl12xx: rx skb
0xee7c25c0: 118 B  seq 69 hlid 1
Jan  1 00:10:51 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2500: 118 B  seq 70 hlid 1
Jan  1 00:10:51 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2440: 247 B beacon seq 2442 hlid 1
..........................................................................................................
Jan  1 00:10:53 buildroot user.debug kernel: wl12xx: rx skb
0xee7b08c0: 247 B beacon seq 2464 hlid 1
Jan  1 00:10:53 buildroot user.debug kernel: wl12xx: queue skb hlid 1 q 0 len 60
Jan  1 00:10:53 buildroot user.debug kernel: wl12xx: tx_allocate:
size: 80, blocks: 2, id: 0
Jan  1 00:10:53 buildroot user.debug kernel: wl12xx: tx_fill_hdr: pad:
0 hlid: 1 tx_attr: 0x24 len: 20 life: 2000 mem: 2
Jan  1 00:10:53 buildroot user.debug kernel: wl12xx: tx_complete
received, packets: 1
Jan  1 00:10:53 buildroot user.debug kernel: wl12xx: tx status id 0
skb 0xee7b0680 failures 0 rate 0x10 status 0x4
Jan  1 00:10:53 buildroot user.debug kernel: wl12xx: rx skb
0xee7b0380: 148 B beacon seq 1676 hlid 1
...................................................................................
Jan  1 00:10:54 buildroot user.debug kernel: wl12xx: rx skb
0xee7b6a40: 247 B beacon seq 2474 hlid 1
Jan  1 00:10:54 buildroot user.debug kernel: wl12xx: queue skb hlid 1 q 0 len 60
Jan  1 00:10:54 buildroot user.debug kernel: wl12xx: tx_allocate:
size: 80, blocks: 2, id: 0
Jan  1 00:10:54 buildroot user.debug kernel: wl12xx: tx_fill_hdr: pad:
0 hlid: 1 tx_attr: 0x24 len: 20 life: 2000 mem: 2
Jan  1 00:10:54 buildroot user.debug kernel: wl12xx: tx_complete
received, packets: 1
Jan  1 00:10:54 buildroot user.debug kernel: wl12xx: tx status id 0
skb 0xee7b6b00 failures 0 rate 0x10 status 0x4
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: rx skb
0xee7b6ec0: 148 B beacon seq 1689 hlid 1
...................................................................
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: rx skb
0xee7c28c0: 247 B beacon seq 2483 hlid 1
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: rx skb
0xef28c2c0: 148 B beacon seq 1701 hlid 1
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2bc0: 220 B beacon seq 271 hlid 1
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2a40: 220 B beacon seq 2017 hlid 1
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: queue skb hlid 1 q 0 len 60
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: tx_allocate:
size: 80, blocks: 2, id: 0
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: tx_fill_hdr: pad:
0 hlid: 1 tx_attr: 0x24 len: 20 life: 2000 mem: 2
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: tx_complete
received, packets: 1
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: tx status id 0
skb 0xee7c2c80 failures 0 rate 0x10 status 0x4
Jan  1 00:10:55 buildroot user.debug kernel: wl12xx: rx skb
0xee7b9540: 247 B beacon seq 2484 hlid 1
Jan  1 00:10:56 buildroot user.debug kernel: wl12xx: rx skb
0xee7b99c0: 148 B beacon seq 1703 hlid 1
....................................................................
Jan  1 00:11:01 buildroot user.debug kernel: wl12xx: rx skb
0xee7b0a40: 148 B beacon seq 1768 hlid 1
Jan  1 00:11:01 buildroot user.debug kernel: wl12xx: rx skb
0xee7b0980: 220 B beacon seq 321 hlid 1
Jan  1 00:11:01 buildroot user.debug kernel: wl12xx: rx skb
0xee7b08c0: 118 B  seq 75 hlid 1
Jan  1 00:11:01 buildroot user.debug kernel: wl12xx: rx skb
0xee7b0680: 118 B  seq 76 hlid 1
Jan  1 00:11:01 buildroot user.debug kernel: wl12xx: rx skb
0xef28c140: 118 B  seq 77 hlid 1
Jan  1 00:11:01 buildroot user.debug kernel: wl12xx: rx skb
0xee7b05c0: 118 B  seq 78 hlid 1
Jan  1 00:11:01 buildroot user.debug kernel: wl12xx: rx skb
0xee7b0500: 247 B beacon seq 2539 hlid 1
....................................
Jan  1 00:11:23 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2d40: 220 B beacon seq 540 hlid 1
Jan  1 00:11:23 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2d40: 118 B  seq 91 hlid 1
Jan  1 00:11:23 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2d40: 148 B beacon seq 2058 hlid 1
Jan  1 00:11:23 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2d40: 247 B beacon seq 2759 hlid 1
Jan  1 00:11:23 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2d40: 118 B  seq 93 hlid 1
Jan  1 00:11:23 buildroot user.debug kernel: wl12xx: rx skb
0xee7c2d40: 118 B  seq 94 hlid 1

Do you see something strange?

Yegor
