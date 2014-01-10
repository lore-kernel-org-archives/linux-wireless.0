Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:62725 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaAJIsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 03:48:53 -0500
Received: by mail-qa0-f54.google.com with SMTP id j7so3888573qaq.13
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jan 2014 00:48:52 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 10 Jan 2014 09:48:52 +0100
Message-ID: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com> (sfid-20140110_094919_078774_BFC52CED)
Subject: mwifiex wowlan not working
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org, akarwar@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm experimenting with wowlan as described here:
http://www.spinics.net/lists/linux-wireless/msg104402.html

It's indeed very powerfu, I'm just fighting with a few minor things see below

these work nice:

wake-on ARP request for <ip addr>:
iw phy0 wowlan enable patterns ff:ff:ff:ff:ff:ff 20+08:06 46+<ip addr in hex>
sudo arping -c 3 <ip addr>

wake on multicast packet
iw phy0 wowlan enable patterns 33:33  <ipv4>
iw phy0 wowlan enable patterns 01:00:5e <ipv6>
sudo /etc/init.d/avahi-daemon restart

these fail:

iw phy0 wowlan enable magic-packet
etherwake -i wlan0 5C:F8:A1:15:1B:0B
wakeonlan 5C:F8:A1:15:1B:0B

wake-on RX packets with TCP destination port 22
iw phy0 wowlan enable patterns 44+16
<hit random keys in ssh session, established before sleep>

any hints on that

kind regards

andreas

---

wlan0     Link encap:Ethernet  HWaddr 5C:F8:A1:15:1B:0B
          inet addr:192.168.11.219  Bcast:192.168.11.255  Mask:255.255.255.0
          inet6 addr: fe80::5ef8:a1ff:fe15:1b0b/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:10 errors:0 dropped:0 overruns:0 frame:0
          TX packets:26 errors:8 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1478 (1.4 KiB)  TX bytes:6535 (6.3 KiB)

driver_version = mwifiex 1.0 (14.66.9.p96)
