Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.ust.hk ([143.89.13.11]:49696 "EHLO mx3.ust.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0A0KsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 05:48:23 -0500
Received: from sqmail.ust.hk (sqmail1.ust.hk [143.89.15.20])
	by mx3.ust.hk (8.13.8/8.13.8) with ESMTP id o0RAmIO7038215
	for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 18:48:20 +0800 (HKT)
Message-ID: <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
Date: Wed, 27 Jan 2010 18:48:20 +0800 (HKT)
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for      
     PowerPC architecture
From: "PAN Sunny S K" <sunnypan@ust.hk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
    <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
In-Reply-To: <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks Pavel, Xiao and especially Luis for their quick reply.
So as suggested, I'll firstly try to build the latest compat-wireless
driver with the 2.6.25 kernel. And update the kernel to 2.6.34 as the last
attempt which requires support from Freescale.

Let me briefly mention a little background and the problem I've
encountered when building the driver.

Our project is base on a Freescale MPC8377EWLAN reference design which
runs by a MPC8377 PowerQUICC II PowerPC processor. It uses LTIB to develop
and deploy BSP for this architecture and the Linux kernel version provided
is 2.6.25 (a slightly patched kernel to adapt the processor) The wireless
interface we're using is Wistron DNMA-83 (equivalent to Unex DNMA-83)
which uses Atheros AR9160 chipset.

To fully utilize the 802.11 a/b/g/n mode provided by the chipset (and the
proprietary driver came with the package has too many problems), we look
for the ath9k driver and would like to build it with the 2.6.25 kernel.

So what I did to build the driver is to provide the KLIB and KLIB_BUILD
with the path of 2.6.25 source and modified the CROSS_COMPILE variable in
the .config of the kernel to make sure it uses the MPC8377 toolchain to
compile the source. However, the following error occurred (With my latest
trial of the bleeding edge compat-wireless-2.6):

make -C /MyProject/ltib-mpc8377ewlan-20090922/rpm/BUILD/linux-2.6.25
M=/root/Desktop/compat-wireless-2009-12-11 modules
make[1]: Entering directory
`/MyProject/ltib-mpc8377ewlan-20090922/rpm/BUILD/linux-2.6.25'
  CC [M] 
/root/Desktop/compat-wireless-2009-12-11/drivers/misc/eeprom/eeprom_93cx6.o
cc1: error: unrecognized command line option "-mno-red-zone"
cc1: error: unrecognized command line option "-mcmodel=kernel"
cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
/root/Desktop/compat-wireless-2009-12-11/drivers/misc/eeprom/eeprom_93cx6.c:1:
error: -m64 not supported in this configuration
make[3]: ***
[/root/Desktop/compat-wireless-2009-12-11/drivers/misc/eeprom/eeprom_93cx6.o]
Error 1
make[2]: ***
[/root/Desktop/compat-wireless-2009-12-11/drivers/misc/eeprom] Error 2
make[1]: *** [_module_/root/Desktop/compat-wireless-2009-12-11] Error 2
make[1]: Leaving directory
`/MyProject/ltib-mpc8377ewlan-20090922/rpm/BUILD/linux-2.6.25'
make: *** [modules] Error 2


I'm a newbie in linux development especially for embedded linux, so please
forgive me if any question I asked are too stupid or wrong in concept.

Thanks again for generous help from all you guys.

Best regards,
Sunny


