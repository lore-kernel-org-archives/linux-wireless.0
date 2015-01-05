Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33465 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbbAEVSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 16:18:44 -0500
Received: by mail-oi0-f53.google.com with SMTP id g201so49640920oib.12
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 13:18:43 -0800 (PST)
Message-ID: <54AAFFB1.8030109@lwfinger.net> (sfid-20150105_221847_547286_B2AC5188)
Date: Mon, 05 Jan 2015 15:18:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Erich Titl <erich.titl@think.ch>, linux-wireless@vger.kernel.org
Subject: Re: b43 driver and WEP
References: <54AA5438.9070902@think.ch>
In-Reply-To: <54AA5438.9070902@think.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2015 03:07 AM, Erich Titl wrote:
> Hello
>
> I am working on a WLAN client on an embedded system and I am facing a
> problem using WEP. I am using the b43 driver with a BCM43222 mini-pci
> card and kernel 3.10.55.
>
> The card works fine with WPA and without encryption. Using WEP results
> in a weird situation where dhcp requests can be sent across the wireless
> link, but a dhcp reply is never received.
>
> The only error I could come up with is
>
> AP# ip link set wlan0 up
> AP# iw event -f &
> AP# iw wlan0 connect scoobly keys 0:abcdefghijklm
> wlan0 (phy #0): scan started
> AP# wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442
> 2447 2452 2457 2462 2467 2472 2484, "scoobly"
> wlan0: new station f8:1a:67:56:42:96
>
> [  417.886167] b43 ssb0:0 wlan0: failed to set key 0
>
> wlan0 (phy #0): auth f8:1a:67:56:42:96 -> 00:1a:2b:5f:61:11 status: 0:
> Successful [frame: b0 00 40 01 00 1a 2b 5f 61 11 f8 1a 67 56 42 96 f8 1a
> 67 56 42 96 00 00 00 00 02 00 00 00]
> wlan0 (phy #0): assoc f8:1a:67:56:42:96 -> 00:1a:2b:5f:61:11 status: 0:
> Successful [frame: 10 00 40 01 00 1a 2b 5f 61 11 f8 1a 67 56 42 96 f8 1a
> 67 56 42 96 10 00 31 04 00 00 01 c0 01 08 82 84 8b 0c 12 96 18 24 32 04
> 30 48 60 6c dd 18 00 50 f2 02 01 01 85 00 03 a4 00 00 27 a4 00 00 42 43
> 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01
> 00 06 00 40 00]
> wlan0 (phy #0): connected to f8:1a:67:56:42:96
>
> AP# tcpdump -i wlan0 -s 1500 -w /tmp/foo &
> AP# tcpdump: WARNING: wlan0: no IPv4 address assigned
> tcpdump: listening on wlan0, link-type EN10MB (Ethernet), capture size
> 1500 bytes
>
> AP# dhcpcd wlan0
> dhcpcd[4335]: version 5.2.11 starting
> dhcpcd[4335]: wlan0: broadcasting for a lease
> dhcpcd[4335]: timed out
>
> AP# tcpdump -r /tmp/foo
> reading from file /tmp/foo, link-type EN10MB (Ethernet)
> 08:49:56.270834 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
> Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314
> 08:50:00.395859 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
> Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314
> 08:50:07.559542 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
> Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314
> 08:50:22.958262 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
> Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314
>
> AP# iw dev wlan0 link
> Connected to f8:1a:67:56:42:96 (on wlan0)
>          SSID: scoobly
>          freq: 2427
>          RX: 537892 bytes (7445 packets)
>          TX: 3639 bytes (21 packets)
>          signal: -76 dBm
>          tx bitrate: 1.0 MBit/s
>
>          bss flags:      short-preamble short-slot-time
>          dtim period:    0
>          beacon int:     100
>
> The dhcp request is received at the dhcp server and is being answered to.
>
> Any ideas?

Eric,

I have not run kernel 3.10 for a long time, but I first confirmed that WEP works 
for kernel 3.17.4 on a BCM4312 (14e4:4315 - no 43222 available). My WEP AP is a 
Linksys WRT54G V5 running standard firmware. On my system, the only bss flag is 
"short-slot-time", but that should not be important. Initially, I tested using 
NetworkManager to control the network; however, changing to manual network 
control and connecting with your commands also worked.

I then generated a 3.10.63 kernel, rebooted and retested. It also works.

One thing would be to try disabling hardware encryption using option 
"nohwcrypt=1". You might also check to determine what key slot your AP is 
expecting to use. My AP has only a single key setup. It calls it #1 while Linux 
is using #0, but that is expected.

Larry

