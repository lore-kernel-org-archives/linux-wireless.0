Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:53889 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab3HAQwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 12:52:46 -0400
Message-ID: <51FA8ECD.7070401@lenbrook.com> (sfid-20130801_185249_719440_8046B31F)
Date: Thu, 01 Aug 2013 12:37:33 -0400
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: cross compile backports?
References: <1375338204-2021-8-git-send-email-sujith@msujith.org> <1375370826-1387-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1375370826-1387-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've been cross compiling compat-wireless and now I'm trying backports.  
It looks like conf.c and zconf.tab.c are being compiled as arm and then 
the build process is trying to run conf on my x86 host.  Results using 
the below make parameters I was using for compat-wireless......

Generating local configuration database from kernel ... done.
gcc -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 
-fomit-frame-pointer   -c -o conf.o conf.c
gcc -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 
-fomit-frame-pointer   -c -o zconf.tab.o zconf.tab.c
gcc   conf.o zconf.tab.o   -o conf
./kconf/conf: ./kconf/conf: cannot execute binary file

There must be a way to build conf as x86 and the actual drivers as arm 
without butchering the makefile? I've been cross compiling 
compat-wireless with....

make    prefix=%{_prefix}
CROSS_COMPILE=/opt/freescale/usr/local/gcc-4.6.2-glibc-2.13-linaro-multilib-2011.12/fsl-linaro-toolchain/bin/arm-none-linux-gnueabi- 
\
     ARCH=arm \
     KLIB=/media/hdd1/ltibs/n100/rootfs/lib/modules/%{kversion} \
     KLIB_BUILD=/media/hdd1/ltibs/n100/rpm/BUILD/linux

Jon
