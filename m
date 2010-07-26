Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39766 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0GZHkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 03:40:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OdII8-0004K3-RO
	for linux-wireless@vger.kernel.org; Mon, 26 Jul 2010 09:40:05 +0200
Received: from 24.164-31.dialup.alkar.net ([217.24.164.31])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 09:40:04 +0200
Received: from vo.on3z by 24.164-31.dialup.alkar.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 09:40:04 +0200
To: linux-wireless@vger.kernel.org
From: Vladimir Linevich <vo.on3z@gmail.com>
Subject: Re: ath5k phy0: unsupported jumbo
Date: Mon, 26 Jul 2010 07:06:27 +0000 (UTC)
Message-ID: <loom.20100726T090249-29@post.gmane.org>
References: <20100123105111.GA24790@progeny.tock> <fe54d8c01001230418u3de7f4ccuc4fbfdecc7c76ebf@mail.gmail.com>  <20100123134005.GA11322@progeny.tock> <b6c5339f1001231032r155b380av93563a6febeeae2b@mail.gmail.com> <43e72e891001251025s1e3fa358v31527d1b5f7e3436@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've found that this bug is a result of poor hardware ASPM support.
It is a hardware bug that is worked around in windows driver by
disabling PCIE ASPM L0S.
There's a solution - turn ASPM L0S off for this device.
---
1. Download enable-aspm
kernel org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm

2. Get your root complex:
$ lspci -tv 
0000:00 
... 
+-1c.2-[0000:03]----00.0 Atheros Communications Inc. AR5001 Wireless Network 
Adapter 
...

00:1c.2 
3. Get your endpoint: 
$ lspci 
... 
03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network 
Adapter (rev 01) 
...
= 03:00.0 

4. Now you neet to edit your enable-aspm

﻿# You just need to modify these three values: 

ROOT_COMPLEX="00:1c.2" 
ENDPOINT="03:00.0" 

ASPM_SETTING=2 

5. Now executing: 
vo-one@acerone:~$ sudo bash enable-aspm 
[sudo] password for vo-one: 
Root complex: 
00:1c.2 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 3 (rev 
02) 
0x50 : 0x43 --> 0x42 ... [SUCCESS]] 
L1 only 

Endpoint: 
03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network 
Adapter (rev 01) 
0x70 : 0x4B --> 0x4A ... [SUCCESS]] 
L1 only 

6. Making the script executed at system startup:
sudo chmod +x enable-aspm
sudo cp enable-aspm /usr/bin
sudo cat "enable-aspm" > /etc/rc.conf

hope that helps 

