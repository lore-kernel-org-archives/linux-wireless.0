Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pikachu.3ti.be ([188.40.111.73]:38621 "EHLO pikachu.3ti.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422652Ab3BGXJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 18:09:09 -0500
Received: from localhost (localhost [127.0.0.1])
	by pikachu.3ti.be (Postfix) with ESMTP id 15C54211E2
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2013 00:01:50 +0100 (CET)
Received: from pikachu.3ti.be ([127.0.0.1])
	by localhost (pikachu.3ti.be [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ppf7bkA0Swx3 for <linux-wireless@vger.kernel.org>;
	Fri,  8 Feb 2013 00:01:49 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by pikachu.3ti.be (Postfix) with ESMTP id 77F45211E2
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2013 00:01:49 +0100 (CET)
Date: Fri, 8 Feb 2013 00:01:49 +0100 (CET)
From: Dag Wieers <dag@wieers.com>
To: linux-wireless@vger.kernel.org
Subject: BCM4321 (b43) on AppleTV (1st gen)
Message-ID: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be> (sfid-20130208_000913_987109_6C51FE3E)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For the OpenELEC project I am looking into getting better performance out 
of the b43 driver on the AppleTV (1st gen) device . The website reports 
the driver can do 802.11n (albeit on 2.4Ghz only), however using kernel 
3.7.5 (and earlier) I cannot get more than 3 MB/sec out of it (usually 
much less).

Here's the information of the device from the PCI bus:
----
02:00.0 Network controller: Broadcom Corporation BCM4321 802.11a/b/g/n (rev 05)
         Subsystem: Apple Inc. Device 008c
         Physical Slot: 1
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at 22100000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
         Capabilities: [58] Vendor Specific Information: Len=78 <?>
         Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
         Capabilities: [d0] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [13c] Virtual Channel
         Capabilities: [160] Device Serial Number 4a-7a-12-ff-ff-27-00-23
         Capabilities: [16c] Power Budgeting <?>
         Kernel driver in use: b43-pci-bridge
         Kernel modules: wl
----

And the output of iwconfig:
----
wlan0     IEEE 802.11bg  ESSID:"zelfbestuur"
           Mode:Managed  Frequency:2.462 GHz  Access Point: 74:44:01:8D:90:5E
           Bit Rate=54 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=63/70  Signal level=-47 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:33  Invalid misc:1987   Missed beacon:0
----

The device's bit rate never exceeds 54 MB/s while other wireless devices 
have iwconfig report e.g. IEEE 802.11abgn on the same netwerk:
----
wlan0     IEEE 802.11abgn  ESSID:"zelfbestuur"
           Mode:Managed  Frequency:2.462 GHz  Access Point: 74:44:01:8D:90:5E
           Bit Rate=130 Mb/s   Tx-Power=15 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=55/70  Signal level=-55 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:4867638  Invalid misc:22386   Missed beacon:0

03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)
         Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
         Flags: bus master, fast devsel, latency 0, IRQ 45
         Memory at f1400000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [c8] Power Management version 3
         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Capabilities: [e0] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Device Serial Number 8c-70-5a-ff-ff-c3-f2-64
         Kernel driver in use: iwlwifi
         Kernel modules: iwlwifi
----

Is there anything I can do to troubleshoot ? Are there any module 
parameters that could help ?

I have to mention that the device's interrupt is shared with the nvidia 
driver.
----
  16:    6374726   IO-APIC-fasteoi   b43, nvidia
----

And that the kernel has been compiled using:
----
CONFIG_B43=m
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_DEBUG=y
----

If the above can be trimmed down for this type of device I'd like to hear 
that as well (e.g. I am not sure if we need PIO or LEDS in this case).

PS I am also interested in any power management capabilities the 
device has and that we could enable when the device is idle, since the 
system lacks proper power management capabilities by itself 
(suspend/hibernate) and seems to have a limited ACPI implementation.

Thanks in advance for any insights,
-- 
-- dag wieers, dag@wieers.com, http://dag.wieers.com/
-- dagit linux solutions, info@dagit.net, http://dagit.net/

[Any errors in spelling, tact or fact are transmission errors]
