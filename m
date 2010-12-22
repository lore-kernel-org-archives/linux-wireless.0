Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout028.mac.com ([17.148.16.103]:62987 "EHLO
	asmtpout028.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0LVQKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 11:10:12 -0500
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp028.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDU00G5V7KCJ940@asmtp028.mac.com>
 for linux-wireless@vger.kernel.org; Wed, 22 Dec 2010 08:09:53 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
Date: Wed, 22 Dec 2010 20:09:35 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
To: "Kahn, Gery" <geryk@ti.com>, Oz Krakowski <ozk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
         I set the following values in my .bashrc file
#
# Environment setup for u-boot and linux kernel
#

export ARCH=arm
export CROSS_COMPILE=arm-angstrom-linux-gnueabi-
export CROSSCOMPILER=armv7a
export CROSSTOOLCHAIN=${OVEROTOP}/tmp/sysroots/x86_64-linux/usr/${CROSSCOMPILER}
export KERNEL_DIR="/tool/patches/android-rowboat-2.6.32-kernel-patchwork"
export UIMAGE_DIR="${KERNEL_DIR}/arch/arm/boot"
export KLIB="${KERNEL_DIR}"
export KLIB_BUILD="${KERNEL_DIR}"

I selected the wl12xx driver

$ cd /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork
$ ./scripts/driver-select wl12xx

then I try to build it, but it gives me the following error:

$ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /tool/patches/android-rowboat-2.6.32-kernel-patchwork M=/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork modules
make[1]: Entering directory `/tool/patches/android-rowboat-2.6.32-kernel-patchwork'
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/main.o
In file included from /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/include/linux/compat-2.6.h:28,
                 from <command-line>:0:
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/include/linux/compat-2.6.33.h:56:1: warning: "NETDEV_POST_INIT" redefined
In file included from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:653,
                 from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:27,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/include/linux/compat-2.6.29.h:5,
                 from /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/linux/notifier.h:204:1: warning: this is the location of the previous definition
In file included from /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/include/linux/compat-2.6.h:28,
                 from <command-line>:0:
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/include/linux/compat-2.6.33.h:58: error: redefinition of ‘netdev_alloc_skb_ip_align’
include/linux/skbuff.h:1487: error: previous definition of ‘netdev_alloc_skb_ip_align’ was here
make[3]: *** [/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/main.o] Error 1
make[2]: *** [/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat] Error 2
make[1]: *** [_module_/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork] Error 2
make[1]: Leaving directory `/tool/patches/android-rowboat-2.6.32-kernel-patchwork'
make: *** [modules] Error 2


Best regards,

Elvis