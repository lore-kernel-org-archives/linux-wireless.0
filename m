Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36108.mail.mud.yahoo.com ([66.163.179.222]:30769 "HELO
	web36108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752087Ab1BJDbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 22:31:31 -0500
Message-ID: <426364.35269.qm@web36108.mail.mud.yahoo.com>
Date: Wed, 9 Feb 2011 19:31:30 -0800 (PST)
From: Noel Milton Vega <nmvega@computingarchitects.com>
Reply-To: Noel Milton Vega <nmvega@ComputingArchitects.Com>
Subject: FWD: Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To (Original mailing list):
    wey-yi.w.guy@intel.com, (delivered)
    linux-wireless@vger.kernel.org, (bounced back from here).
    ilw@linux.intel.com (delivered)

Hello Developer Friends:

I'm writing because I'm having problems with the WiFi and Bluetooth interfaces
provided by the "Intel Centrino Advanced-N 6230AGN" card in my laptop. I am
running Fedora 14 Linux / 64 Bit, with the latest 2.6 kernel provided by their
repositories (2.6.35.10-74.fc14.x86_64).

Please CORRECT me if I am wrong, but as I understand it, the drivers for this
(and similar devices) are supposed to be these:

root# locate iwlwifi
/lib/modules/2.6.35.10-74.fc14.x86_64/kernel/drivers/net/wireless/iwlwifi/iwl3945.ko

/lib/modules/2.6.35.10-74.fc14.x86_64/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko

/lib/modules/2.6.35.10-74.fc14.x86_64/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko


But these kernel loadable modules do not seem to work. Let me show you why...

An "lspci -k" doesn't show any of these kernel modules bound to my 
WiFi/Bluetooth
card hardware (which, again, is a Intel Centrino Advanced-N 6230AGN device).
See  here....

root# lspci -k

   03:00.0 Ethernet controller: JMC250 PCI Express Gigabit Ethernet Controller 
(rev 05)
   Subsystem: CLEVO/KAPOK Computer Device 7100
   Kernel driver in use: jme  <--- GOOD for the Ethernet device
   Kernel modules: jme        <--- GOOD

   01:00.0 VGA compatible controller: nVidia Corporation Device 0e31 (rev a1)
   Subsystem: CLEVO/KAPOK Computer Device 7100
   Kernel driver in use: nvidia                <--- GOOD for the video 
controller.
   Kernel modules: nvidia, nouveau, nvidiafb   <--- GOOD

   04:00.0 Network controller: Intel Corporation Centrino Advanced-N 6230 (rev 
34)
   Subsystem: Intel Corporation Centrino Advanced-N 6230 AGN
   Kernel driver in use:   <---- missing / not bound.   NO GOOD
   Kernel modules:         <---- missing / not bound.   NO GOOD

This is true even after I manually do a "root# modeprobe iwlagn" (etc.)

So it looks like (1) either these driver are not working for this device and
needs to be fixed or *enhanced* to support this card; or (2) this is not the
driver for this Intel Centrino Advanced-N 6230AGNdevice, and one needs to
be written. So neither Wireless nor Bluetooth work because devices cannot be
accessed.

Many CLEVO made laptops will ship with this card (if they have not
already), and will need a working Linux device driver for it.

Btw... Here is my post about this missing driver to the Fedora and other 
forums...

   http://forums.fedoraforum.org/showthread.php?p=1442632#post1442632

Can someone help me out with this please? Thank you 

Thank you,
Noel Milton Vega
212-699-2660

