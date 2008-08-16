Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:62106 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbYHPVPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 17:15:21 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1041307yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 Aug 2008 14:15:20 -0700 (PDT)
Message-ID: <606ccac00808161415t5623583ibccc86d7340644b0@mail.gmail.com> (sfid-20080816_231536_114823_ED8C92F4)
Date: Sat, 16 Aug 2008 17:15:20 -0400
From: "Fred Reimer" <srnetguru@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Lockup on load of ath5k.ko
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just downloaded the latest ath5k tarball and compiled and installed
it.  My computer locks up when I load the ath5k module.  Here's the
output of lspci:

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI
Express Root Port (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 5 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface
Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6
port SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller
(rev 02)
01:00.0 VGA compatible controller: nVidia Corporation Unknown device
06e4 (rev a1)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E
Gigabit Ethernet Controller (rev 12)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 03)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 03)
05:00.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet
Pro 100 (rev 05)
05:01.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet
Pro 100 (rev 05)
05:02.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213
Multiprotocol MAC/baseband processor (rev 01)
05:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70)

It's the second to the last entry, for the Atheros wireless controller,
that of issue.  If I include this module in
the /etc/modprobe.d/blacklist the computer boots fine.  I don't know how
to get any more debug info out of the system, but if you can suggest
something I'd be more than glad to try.

I'm running Fedora 9 x86_64 with a kernel I compiled myself.  The kernel
doesn't have any special options, I just had to compile it to get my
nvidia driver working.

Linux localhost.localdomain 2.6.25.14-108.fwr1.fc9.x86_64 #1 SMP Wed Aug
13 09:20:29 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux


Thanks,


Fred Reimer


-- 
Fred Reimer, CISSP, CCNP, CQS-VPN, CQS-ISS
Senior Network Engineer
Coleman Technologies, Inc.

--
Fred Reimer, CISSP, CCNP, CQS-VPN, CQS-ISS
Senior Network Engineer
Coleman Technologies, Inc.
