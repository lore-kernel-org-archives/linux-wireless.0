Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from christianpatriot.us ([68.213.142.108]:55864 "EHLO
	panda1.christianpatriot.us" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbZARXFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 18:05:39 -0500
Received: from [192.168.0.4] (panda4.christianpatriot.us [192.168.0.4])
	by panda1.christianpatriot.us (8.14.2/8.14.2) with ESMTP id n0IN5c5H006236
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 18:05:38 -0500
Subject: Failed Build of modules for 2.6.27.9-159
From: Paul Hickey <paul@christianpatriot.us>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Jan 2009 18:04:14 -0500
Message-Id: <1232319854.4596.1.camel@localhost.localdomain> (sfid-20090119_000544_593667_F4639496)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath9k is part of (my) Fedora 10 and loaded in kernel
2.6.27-9.159.fc10.x86_64. mac80211 is loaded when Ath9k is loaded and
loads cfg80211. mac80211 can be loaded without loading Ath9k (you still
get cfg80211) but one of them gives a never ending log entry of
=46orceXPAon:0

I have a valid .config file
I have the kernel headers and development files as well.

[root@panda4 compat-wireless-2009-01-18]# make
make -C /lib/modules/2.6.27.9-159.fc10.x86_64/build
M=3D/home/paul/Download/compat-wireless-2009-01-18 modules
make[1]: Entering directory `/usr/src/kernels/2.6.27.9-159.fc10.x86_64'

Message from syslogd@panda4 at Jan 18 15:50:48 ...
kernel:Disabling IRQ #16
  CC
[M]  /home/paul/Download/compat-wireless-2009-01-18/net/wireless/compat=
=2Eo
/home/paul/Download/compat-wireless-2009-01-18/net/wireless/compat.c:18=
:
error: redefinition of =E2=80=98pci_ioremap_bar=E2=80=99
include/linux/pci.h:1127: error: previous definition of
=E2=80=98pci_ioremap_bar=E2=80=99 was here
make[3]: ***
[/home/paul/Download/compat-wireless-2009-01-18/net/wireless/compat.o]
Error 1
make[2]: ***
[/home/paul/Download/compat-wireless-2009-01-18/net/wireless] Error 2
make[1]: *** [_module_/home/paul/Download/compat-wireless-2009-01-18]
Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27.9-159.fc10.x86_64'
make: *** [modules] Error 2

I tried both the wireless-testing download and the compat-wireless with
the same results.

Any suggestions?

Thanks


Paul Hickey
Christian Patriot

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
