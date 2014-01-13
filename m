Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f47.google.com ([209.85.128.47]:65137 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaAMM6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 07:58:48 -0500
Received: by mail-qe0-f47.google.com with SMTP id 5so6787882qeb.6
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 04:58:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF59510D9F010D4@SC-VEXCH1.marvell.com>
References: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF59510D9F010D4@SC-VEXCH1.marvell.com>
Date: Mon, 13 Jan 2014 13:58:47 +0100
Message-ID: <CALtMJECByCXZ3ToiToNiZUwTAkj0dzd6PtTMPCBjgTRJsKUkJA@mail.gmail.com> (sfid-20140113_135852_162380_2E6A5B0C)
Subject: Re: mwifiex wowlan not working
From: Andreas Fenkart <afenkart@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sven Neumann <neumann@teufel.de>
Content-Type: multipart/mixed; boundary=047d7b6d80aaf2847e04efd9a2a0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--047d7b6d80aaf2847e04efd9a2a0
Content-Type: text/plain; charset=UTF-8

Hi Amitkumar,

2014/1/10 Amitkumar Karwar <akarwar@marvell.com>:
>> these fail:
>>
>> iw phy0 wowlan enable magic-packet
>> etherwake -i wlan0 5C:F8:A1:15:1B:0B
>> wakeonlan 5C:F8:A1:15:1B:0B
>>
>
> It works for magic-packet, only if the packet contains device's(Marvell) MAC address and received through wireless interface.

The module is from Murata, will magic packet wakeup work with those?
http://hwaddress.com/?q=5C%3AF8%3AA1%3A15%3A1B%3A0B

> Are you generating magic packet on different device connected wirelessly?
> Is 5C:F8:A1:15:1B:0B MAC of Marvell device?
>
>> wake-on RX packets with TCP destination port 22
>> iw phy0 wowlan enable patterns 44+16
>> <hit random keys in ssh session, established before sleep>
>
> This could be a setup issue. Connection might have lost.
> Can you please confirm using TCPDUMP,sniffer etc. if TCP packets are actually transmitted by remote device?

I attached two pcap files. I'm using a router with openwrt flashed to it.

[magic packet]
I issue the command on the router, and check on the target that the
packet arrives:

router# etherwake -i wlan1 5C:F8:A1:15:1B:0B
target# tcpdump  -i wlan0  -w magic-packet.pcap

After seeing that magic packet arrive, I send the target
to sleep and send the magic-packet again

[ssh-packet-while sleep]
I open up an ssh session from host via router to the the target.
I sniff on the router for outgoing packets to target

host# ssh root@target
target# iw phy0 wowlan enable patterns 44+16
target# echo mem > /sys/power/state
router# tcpdump -i wlan1 dst 192.168.11.219 -w ssh-pkt-while-sleeping.pcap


>
> Regards,
> Amitkumar Karwar

/Andreas

--047d7b6d80aaf2847e04efd9a2a0
Content-Type: application/vnd.tcpdump.pcap;
	name="ssh-pkt-while-sleeping.pcap"
Content-Disposition: attachment; filename="ssh-pkt-while-sleeping.pcap"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqdq1d3i0

obLD1AACAAQAAAAAAAAAAAAA//8AAAABUtPewQAI1osAAAByAAAAclz4oRUbCzyp9CGKlAgARRAA
ZI8+QABABhIkwKgL9sCoC9u/1AAWsR74qAtx3I6AGACEkDUAAAEBCAoIbQYmAANTCx9F7q2OFiVI
4cf9LXyMo8R/N8NELBA8HfOvhWRUoYyCnqDteN+hNqE6LHzMfYD9BVLT3sEADBV1AAAAcgAAAHJc
+KEVGws8qfQhipQIAEUQAGSPP0AAQAYSI8CoC/bAqAvbv9QAFrEe+NgLcdyOgBgAhFatAAABAQgK
CG0GWwADUwvKaDIajffPw7qniGlsw3W9Rga2oPjdj/7KgTNc3xKpe9kYMuyfAFKVmL1JgKVYwYdS
097BAA3swQAAAKIAAACiXPihFRsLPKn0IYqUCABFEACUj0BAAEAGEfLAqAv2wKgL27/UABaxHvio
C3HcjoAYAIS9NwAAAQEICghtBnoAA1MLH0XurY4WJUjhx/0tfIyjxH83w0QsEDwd86+FZFShjIKe
oO1436E2oTosfMx9gP0FymgyGo33z8O6p4hpbMN1vUYGtqD43Y/+yoEzXN8SqXvZGDLsnwBSlZi9
SYClWMGHUtPewgAI69YAAACiAAAAolz4oRUbCzyp9CGKlAgARRAAlI9BQABABhHxwKgL9sCoC9u/
1AAWsR74qAtx3I6AGACEvI8AAAEBCAoIbQciAANTCx9F7q2OFiVI4cf9LXyMo8R/N8NELBA8HfOv
hWRUoYyCnqDteN+hNqE6LHzMfYD9BcpoMhqN98/DuqeIaWzDdb1GBrag+N2P/sqBM1zfEql72Rgy
7J8AUpWYvUmApVjBh1LT3sMADj0nAAAAogAAAKJc+KEVGws8qfQhipQIAEUQAJSPQkAAQAYR8MCo
C/bAqAvbv9QAFrEe+KgLcdyOgBgAhLs+AAABAQgKCG0IcwADUwsfRe6tjhYlSOHH/S18jKPEfzfD
RCwQPB3zr4VkVKGMgp6g7XjfoTahOix8zH2A/QXKaDIajffPw7qniGlsw3W9Rga2oPjdj/7KgTNc
3xKpe9kYMuyfAFKVmL1JgKVYwYdS097GAAmIRAAAAKIAAACiXPihFRsLPKn0IYqUCABFEACUj0NA
AEAGEe/AqAv2wKgL27/UABaxHvioC3HcjoAYAIS4nQAAAQEICghtCxQAA1MLH0XurY4WJUjhx/0t
fIyjxH83w0QsEDwd86+FZFShjIKeoO1436E2oTosfMx9gP0FymgyGo33z8O6p4hpbMN1vUYGtqD4
3Y/+yoEzXN8SqXvZGDLsnwBSlZi9SYClWMGHUtPezAAAQaYAAACiAAAAolz4oRUbCzyp9CGKlAgA
RRAAlI9EQABABhHuwKgL9sCoC9u/1AAWsR74qAtx3I6AGACEs1kAAAEBCAoIbRBYAANTCx9F7q2O
FiVI4cf9LXyMo8R/N8NELBA8HfOvhWRUoYyCnqDteN+hNqE6LHzMfYD9BcpoMhqN98/DuqeIaWzD
db1GBrag+N2P/sqBM1zfEql72Rgy7J8AUpWYvUmApVjBhw==
--047d7b6d80aaf2847e04efd9a2a0
Content-Type: application/vnd.tcpdump.pcap; name="magic-packet.pcap"
Content-Disposition: attachment; filename="magic-packet.pcap"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqdqfyvq1

1MOyoQIABAAAAAAAAAAAAP//AAABAAAAa6ySURFdBAB0AAAAdAAAAFz4oRUbC2RwArXYZAhC////
////XPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsL
XPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLbaySUTM4CAB0AAAAdAAA
AFz4oRUbC2RwArXYZAhC////////XPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsL
XPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPih
FRsLb6ySUZuzAgB0AAAAdAAAAFz4oRUbC2RwArXYZAhC////////XPihFRsLXPihFRsLXPihFRsL
XPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPihFRsLXPih
FRsLXPihFRsLXPihFRsLXPihFRsL
--047d7b6d80aaf2847e04efd9a2a0--
