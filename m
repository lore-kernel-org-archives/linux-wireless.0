Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:57522 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057Ab0AVTVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 14:21:20 -0500
Message-ID: <4B59FAAD.6060804@redfish-solutions.com>
Date: Fri, 22 Jan 2010 11:21:17 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Building compat-wireless from 2.6.27
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to build compat-wireless's snapshot from git on compat-wireless-2.6-mcgrof last night, on linux 2.6.27.42 and getting:

...
make -j5 -C /home/philipp/alix/build_i586/compat-wireless-2010-01-21 \
		HOSTCC=gcc CC=/home/philipp/alix/build_i586/staging_dir/bin/i586-linux-uclibc-gcc ARCH=i386 \
		KLIB_BUILD=/home/philipp/alix/build_i586/linux-2.6.27.42-astlinux \
		MODPROBE='true' PWD=/home/philipp/alix/build_i586/compat-wireless-2010-01-21 \
		CONFIG_IPW2100= CONFIG_IPW2200= CONFIG_LIBERTAS= CONFIG_B44= CONFIG_B43= CONFIG_B43LEGACY= \
		modules
make[1]: Entering directory `/home/philipp/alix/build_i586/compat-wireless-2010-01-21'
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
make -C /home/philipp/alix/build_i586/linux-2.6.27.42-astlinux M=/home/philipp/alix/build_i586/compat-wireless-2010-01-21 modules
make[2]: Entering directory `/home/philipp/alix/build_i586/linux-2.6.27.42-astlinux'
scripts/Makefile.build:41: /home/philipp/alix/build_i586/compat-wireless-2010-01-21/compat/Makefile: No such file or directory
make[4]: *** No rule to make target `/home/philipp/alix/build_i586/compat-wireless-2010-01-21/compat/Makefile'.  Stop.
make[3]: *** [/home/philipp/alix/build_i586/compat-wireless-2010-01-21/compat] Error 2
make[3]: *** Waiting for unfinished jobs....
scripts/Makefile.build:41: /home/philipp/alix/build_i586/compat-wireless-2010-01-21/drivers/bluetooth/Makefile: No such file or directory
make[4]: *** No rule to make target `/home/philipp/alix/build_i586/compat-wireless-2010-01-21/drivers/bluetooth/Makefile'.  Stop.
make[3]: *** [/home/philipp/alix/build_i586/compat-wireless-2010-01-21/drivers/bluetooth] Error 2
make[2]: *** [_module_/home/philipp/alix/build_i586/compat-wireless-2010-01-21] Error 2
make[2]: Leaving directory `/home/philipp/alix/build_i586/linux-2.6.27.42-astlinux'
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/home/philipp/alix/build_i586/compat-wireless-2010-01-21'
make: *** [/home/philipp/alix/build_i586/compat-wireless-2010-01-21/net/wireless/lib80211.ko] Error 2
% 

as a diagnostic, I've patched my makefile to $(info ...) out the following:

CONFIG_PCI=y
CONFIG_USB=y
CONFIG_PCMCIA=
CONFIG_SSB=
CONFIG_LIBERTAS=
CONFIG_ATH5K=m
CONFIG_ATH9K=m
CONFIG_IPW2100=
CONFIG_IPW2200=
CONFIG_IWLWIFI=m
CONFIG_B43=
CONFIG_B43LEGACY=
CONFIG_B44=


How should I be building compat-wireless?  This worked until about early December.

-Philip


