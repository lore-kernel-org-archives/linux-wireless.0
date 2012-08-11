Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33477 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab2HKJ7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 05:59:53 -0400
Date: Sat, 11 Aug 2012 17:59:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [wireless-testing:master 68/100]
 drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct
 pointer types lacks a cast
Message-ID: <20120811095951.GA8534@localhost> (sfid-20120811_120045_096210_4E90CDCA)
References: <20120811084404.GA7755@localhost>
 <201208111149.47874.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201208111149.47874.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 11, 2012 at 11:49:47AM +0200, Christian Lamparter wrote:
> On Saturday 11 August 2012 10:44:04 Fengguang Wu wrote:
> > Hi Christian,
> > 
> > FYI, there are new compile warnings show up in
> 
> Thanks for telling me. Are these "normal" gcc's warnings
> for PPC? Because the usual C=2 CF=-D__CHECK_ENDIAN__
> doesn't show anything (on a x86 no cross-compile).

Yes, I don't use any special flags.

> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git master
> > head:   0eba6e668abe4e0760d9d5e20921cc6000a77a85
> > commit: 9bc63816be9bf504414d350e605a4b30f857907d [68/100] p54: parse output power table
> > config: powerpc-allmodconfig (attached as .config)
> > 
> > All error/warnings:
> > 
> > drivers/net/wireless/p54/eeprom.c: In function 'p54_get_maxpower':
> > drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > drivers/net/wireless/p54/eeprom.c:292:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > drivers/net/wireless/p54/eeprom.c:293:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > drivers/net/wireless/p54/eeprom.c:294:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> 
> interesting, rawpower is declared as u16.
> whereas le16_to_cpu returns a __u16. 
> (is that all, or is there something I don't see?)
> 
> Anyway, since you are currently the only person
> I know, would you mind telling me if either (or
> both?) of those patches has/have an effect?
> 
> patch 1: make rawpower __u16

Thanks for the quick fix! It works (build log follows).

Thanks,
Fengguang
---
wfg@bee ~/tip/obj-compiletest% make allmodconfig
/usr/bin/make -j40 -C source O=/home/wfg/tip/obj-compiletest ARCH=powerpc CROSS_COMPILE=/usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/powerpc64-linux- -j32 allmodconfig
make: Entering directory `/c/wfg/tip'
  HOSTCC  scripts/basic/fixdep
  GEN     /cc/wfg/tip-compiletest/Makefile
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.hash.c
  SHIPPED scripts/kconfig/zconf.lex.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --allmodconfig Kconfig
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
#
# configuration written to .config
#
make: Leaving directory `/c/wfg/tip'
wfg@bee ~/tip/obj-compiletest% make drivers/net/wireless/p54/
/usr/bin/make -j40 -C source O=/home/wfg/tip/obj-compiletest ARCH=powerpc CROSS_COMPILE=/usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/powerpc64-linux- -j32 drivers/net/wireless/p54/
make: Entering directory `/c/wfg/tip'
  GEN     /cc/wfg/tip-compiletest/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
  GEN     /cc/wfg/tip-compiletest/Makefile
  WRAP    arch/powerpc/include/generated/asm/rwsem.h
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  HOSTCC  scripts/dtc/checks.o
  HOSTCC  scripts/pnmtologo
  HOSTCC  scripts/conmakehash
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/bin2c
  HOSTCC  scripts/dtc/data.o
  HOSTCC  scripts/dtc/dtc-lexer.lex.o
  HOSTCC  scripts/dtc/dtc-parser.tab.o
  HOSTCC  scripts/dtc/dtc.o
  HOSTCC  scripts/dtc/flattree.o
  HOSTCC  scripts/dtc/fstree.o
  HOSTCC  scripts/dtc/livetree.o
  HOSTCC  scripts/genksyms/genksyms.o
  HOSTCC  scripts/dtc/srcpos.o
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  SHIPPED scripts/genksyms/lex.lex.c
  HOSTCC  scripts/dtc/treesource.o
  HOSTCC  scripts/selinux/genheaders/genheaders
  HOSTCC  scripts/dtc/util.o
  SHIPPED scripts/genksyms/parse.tab.h
  SHIPPED scripts/genksyms/keywords.hash.c
  HOSTCC  scripts/selinux/mdp/mdp
  SHIPPED scripts/genksyms/parse.tab.c
  HOSTCC  scripts/genksyms/lex.lex.o
  HOSTCC  scripts/genksyms/parse.tab.o
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/dtc/dtc
  HOSTLD  scripts/genksyms/genksyms
  HOSTLD  scripts/mod/modpost
  Using /c/wfg/tip as source for kernel
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/powerpc/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /c/wfg/tip/scripts/checksyscalls.sh
  LD      drivers/net/wireless/p54/built-in.o
  CC [M]  drivers/net/wireless/p54/eeprom.o
  CC [M]  drivers/net/wireless/p54/fwio.o
  CC [M]  drivers/net/wireless/p54/txrx.o
  CC [M]  drivers/net/wireless/p54/main.o
  CC [M]  drivers/net/wireless/p54/led.o
  CC [M]  drivers/net/wireless/p54/p54usb.o
  CC [M]  drivers/net/wireless/p54/p54pci.o
  CC [M]  drivers/net/wireless/p54/p54spi.o
  LD [M]  drivers/net/wireless/p54/p54common.o
make: Leaving directory `/c/wfg/tip'
wfg@bee ~/tip/obj-compiletest% ..
wfg@bee ~/tip% q pop
Removing patch patches/mutt-wfg-t420-1000-8534-5234451332105763812
Restoring drivers/net/wireless/p54/eeprom.c

No patches applied
wfg@bee ~/tip% cd -
~/tip/obj-compiletest
wfg@bee ~/tip/obj-compiletest% make drivers/net/wireless/p54/
/usr/bin/make -j40 -C source O=/home/wfg/tip/obj-compiletest ARCH=powerpc CROSS_COMPILE=/usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/powerpc64-linux- -j32 drivers/net/wireless/p54/
make: Entering directory `/c/wfg/tip'
  GEN     /cc/wfg/tip-compiletest/Makefile
  CHK     include/linux/version.h
  Using /c/wfg/tip as source for kernel
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CALL    /c/wfg/tip/scripts/checksyscalls.sh
  CC [M]  drivers/net/wireless/p54/eeprom.o
/c/wfg/tip/drivers/net/wireless/p54/eeprom.c: In function 'p54_get_maxpower':
/c/wfg/tip/drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
/c/wfg/tip/drivers/net/wireless/p54/eeprom.c:292:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
/c/wfg/tip/drivers/net/wireless/p54/eeprom.c:293:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
/c/wfg/tip/drivers/net/wireless/p54/eeprom.c:294:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  LD [M]  drivers/net/wireless/p54/p54common.o
make: Leaving directory `/c/wfg/tip'
wfg@bee ~/tip/obj-compiletest%
