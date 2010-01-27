Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13626 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab0A0WCd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 17:02:33 -0500
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for      
 PowerPC architecture
From: Pavel Roskin <proski@gnu.org>
To: PAN Sunny S K <sunnypan@ust.hk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
	 <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
	 <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
Content-Type: text/plain
Date: Wed, 27 Jan 2010 17:02:21 -0500
Message-Id: <1264629741.19648.25.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-01-27 at 18:48 +0800, PAN Sunny S K wrote:

> So what I did to build the driver is to provide the KLIB and KLIB_BUILD
> with the path of 2.6.25 source and modified the CROSS_COMPILE variable in
> the .config of the kernel to make sure it uses the MPC8377 toolchain to
> compile the source. However, the following error occurred (With my latest
> trial of the bleeding edge compat-wireless-2.6):
> 
> make -C /MyProject/ltib-mpc8377ewlan-20090922/rpm/BUILD/linux-2.6.25
> M=/root/Desktop/compat-wireless-2009-12-11 modules
> make[1]: Entering directory
> `/MyProject/ltib-mpc8377ewlan-20090922/rpm/BUILD/linux-2.6.25'
>   CC [M] 
> /root/Desktop/compat-wireless-2009-12-11/drivers/misc/eeprom/eeprom_93cx6.o
> cc1: error: unrecognized command line option "-mno-red-zone"
> cc1: error: unrecognized command line option "-mcmodel=kernel"
> cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
> /root/Desktop/compat-wireless-2009-12-11/drivers/misc/eeprom/eeprom_93cx6.c:1:
> error: -m64 not supported in this configuration

It looks like the compiler just cannot compile the kernel code.
-maccumulate-outgoing-args is only used on the x86 architecture, so I
assume the build system is picking up x86 makefiles while using a
PowerPC compiler.

I think ARCH should be specified on the make command line in addition to
other arguments:

make ARCH=powerpc

-- 
Regards,
Pavel Roskin
