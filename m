Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:47843 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbYCZRbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 13:31:24 -0400
Received: by rn-out-0910.google.com with SMTP id v46so2431110rnb.15
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2008 10:31:22 -0700 (PDT)
Message-ID: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com> (sfid-20080326_173128_280926_47E6E231)
Date: Wed, 26 Mar 2008 13:31:22 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: problem with iwl4965 and kernel 2.6.24.4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've installed the compat-wireless-2008-03-25 source and I can get the
module to load, but the network card is still not recognized under
ifconfig/iwconfig.

or under lspci:
 06:00.0 Network controller: Intel Corporation Unknown device 4229 (rev 61)


dmesg output on loading the module shows a problem registering the device:

iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26k
iwl4965: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:06:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-4965-rs'
phy0: Failed to initialize wep
iwl4965: Failed to register network device (error -12)
ACPI: PCI interrupt for device 0000:06:00.0 disabled
iwl4965: probe of 0000:06:00.0 failed with error -12




As a side issue, I tried to grab the source from the repo but I am not
sure what I have to do to get that into a compilable state:

compat-wireless-2.6$ make
cat: /home/jgoulah/wdir/compat-wireless-2.6/compat-release: No such
file or directory
cat: /home/jgoulah/wdir/compat-wireless-2.6/compat-release: No such
file or directory
make -C /lib/modules/2.6.24.4-custom/build
M=/home/jgoulah/wdir/compat-wireless-2.6 modules
make[1]: Entering directory `/usr/src/linux-2.6.24.4'
scripts/Makefile.build:41:
/home/jgoulah/wdir/compat-wireless-2.6/drivers/misc/Makefile: No such
file or directory
make[3]: *** No rule to make target
`/home/jgoulah/wdir/compat-wireless-2.6/drivers/misc/Makefile'.  Stop.
make[2]: *** [/home/jgoulah/wdir/compat-wireless-2.6/drivers/misc] Error 2
make[1]: *** [_module_/home/jgoulah/wdir/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.24.4'
make: *** [modules] Error 2



Any help is appreciated, if you need more info just let me know.
