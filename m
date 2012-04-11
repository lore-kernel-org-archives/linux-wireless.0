Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.visionsystems.de ([62.145.30.242]:43309 "EHLO
	mail.visionsystems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab2DKKlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 06:41:25 -0400
Message-ID: <4F855FC4.1080707@visionsystems.de> (sfid-20120411_124129_169049_CEC807A5)
Date: Wed, 11 Apr 2012 12:41:08 +0200
From: Yegor Yefremov <yegor_sub1@visionsystems.de>
Reply-To: yegor_sub1@visionsystems.de
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org, arik@wizery.com,
	Yegor Yefremov <yegorslists@googlemail.com>
Subject: Re: wl1271: communication fails with kernel 3.4-rc2 and firmware
 series 4
References: <4F855997.20603@visionsystems.de> <1334139944.10398.11.camel@cumari>
In-Reply-To: <1334139944.10398.11.camel@cumari>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.04.2012 12:25, schrieb Luciano Coelho:
> Hi Yegor,
>
> On Wed, 2012-04-11 at 12:14 +0200, Yegor Yefremov wrote:
>> continuing our yesterdays discussion on IRC I try to summarize my
>> results. 
>>
>> First of all I calibrated my WLAN card via ti-utils as described here
>> http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator using
>> calibrator plt calibrate. 
>>
>> Then I integrated this nvs file into kernel, so I have no longer these
>> nasty errors.
>>
>> Still I cannot ping anything. Here you can see the end of
>> wpa_supplicant's log:
>>
>> WPA: Installing PTK to the driver.
>> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=0x42a48 key_idx=0 set_tx=1 seq_len=6 key_len=32
>>    addr=5c:d9:98:f9:30:d9
>> EAPOL: External notification - portValid=1
>> State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
>> RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
>> WPA: Group Key - hexdump(len=32): [REMOVED]
>> WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
>> WPA: RSC - hexdump(len=6): b1 7c 0d 00 00 00
>> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=0x2a443 key_idx=1 set_tx=0 seq_len=6 key_len=32
>> WPA: Key negotiation completed with 5c:d9:98:f9:30:d9 [PTK=TKIP GTK=TKIP]
>> Cancelling authentication timeout
>> Removed BSSID 5c:d9:98:f9:30:d9 from blacklist
>> State: GROUP_HANDSHAKE -> COMPLETED
>> CTRL-EVENT-CONNECTED - Connection to 5c:d9:98:f9:30:d9 completed (reauth) [id=1
>> id_str=]
>> wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
>> netlink: Operstate: linkmode=-1, operstate=6
>> EAPOL: External notification - portValid=1
>> EAPOL: External notification - EAP success=1
>> EAPOL: SUPP_PAE entering state AUTHENTICATING
>> EAPOL: SUPP_BE entering state SUCCESS
>> EAP: EAP entering state DISABLED
>> EAPOL: SUPP_PAE entering state AUTHENTICATED
>> EAPOL: Supplicant port status: Authorized
>> EAPOL: SUPP_BE entering state IDLE
>> EAPOL authentication completed successfully
>> RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
>> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
>> EAPOL: startWhen --> 0
>> EAPOL: disable timer tick
>>
>> Any ideas? As i told before both 2.6.37 and 3.3-rc7 made no problems.
> Hard to say.  From these logs everything seems to be working fine.  What
> IP address are you using? Are you sure your routes are all set up
> correctly? Do you get any messages in the kernel logs, TX stuck
> watchdog, maybe?

As soon as I replace 3.4 with 2.6.37 pings go through.

# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:04:D9:80:55:02
          inet addr:192.168.1.239  Bcast:192.168.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:5 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:737 (737.0 B)  TX bytes:568 (568.0 B) 

# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 wlan0

#dmesg
wl12xx: firmware booted (Rev 6.3.5.0.98)
wlan0: authenticate with 5c:d9:98:f9:30:d9
wlan0: send auth to 5c:d9:98:f9:30:d9 (try 1/3)
wlan0: authenticated
wlan0: associate with 5c:d9:98:f9:30:d9 (try 1/3)
wlan0: RX AssocResp from 5c:d9:98:f9:30:d9 (capab=0x431 status=0 aid=2)
wlan0: associated

Yegor
