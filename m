Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60332 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2DQR7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 13:59:17 -0400
Received: by bkcik5 with SMTP id ik5so4803020bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 10:59:16 -0700 (PDT)
From: Dominik Feser <dominik.feser@googlemail.com>
Content-Type: text/plain; charset=iso-8859-1
Subject: wlan0 not present
Date: Tue, 17 Apr 2012 19:59:13 +0200
Message-Id: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> (sfid-20120417_195921_721980_A794EF8E)
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1257)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
Maybe someone can help me. I have compiled and installed compat-wireless-3.4-rc1-2 and it seems to load correctly. The thing I am missing is the wlan0 device.

# lspci -kvm
Device:	02:00.0
Class:	Network controller
Vendor:	Intel Corporation
Device:	Centrino Advanced-N 6205
SVendor:	Intel Corporation
SDevice:	Centrino Advanced-N 6205 AGN
Rev:	34
Module:	iwlwifi

# dmesg | grep iwlwifi
iwlwifi 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlwifi 0000:02:00.0: setting latency timer to 64
iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:02:00.0: pci_resource_base = f23e0000
iwlwifi 0000:02:00.0: HW Revision ID = 0x34
iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
iwlwifi 0000:02:00.0: edf81e1c
iwlwifi 0000:02:00.0: c9933e1c
iwlwifi 0000:02:00.0: c9933de8
iwlwifi 0000:02:00.0: PCI INT A disabled

# lsmod | grep iwl
iwlwifi               179689  0 
mac80211              231218  1 iwlwifi
compat_firmware_class     5816  1 iwlwifi
cfg80211              161549  2 iwlwifi,mac80211
compat                 28095  4 iwlwifi,mac80211,compat_firmware_class,cfg80211
led_class               2525  2 iwlwifi,compat

# uname -a
Linux xenserver 2.6.32.12-0.7.1 #6 SMP Mon Apr 16 19:31:06 EDT 2012 i686 i686 i386 GNU/Linux

For some reason there is no wlan0 when I run ifconfig -a and when I try to get it up I get:

# ifconfig wlan0 up
wlan0: unbekannte Schnittstelle: Kein passendes Gerät gefunden

In proc:

# cat /proc/net/wireless 
Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22

Nothing...

Maybe some thoughts?

Cheers,
Dominik