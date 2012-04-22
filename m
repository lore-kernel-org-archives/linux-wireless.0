Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42329 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2DVXBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 19:01:33 -0400
Received: by wibhq7 with SMTP id hq7so2310766wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 16:01:32 -0700 (PDT)
Message-ID: <4F948DC8.5050909@googlemail.com> (sfid-20120423_010207_727354_6953C70E)
Date: Mon, 23 Apr 2012 01:01:28 +0200
From: Michael Lampe <mlampe0@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Michael Lampe <mlampe0@googlemail.com>
Subject: compat-wireless 3.4 rcs and el6 kernels
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

3.3 started something nice -- compatibility with el6 kernels. This 
already resulted in an elrepo kmod.

3.4 rcs don't compile here anymore:

-----

/home/michael/compat-wireless-3.4-rc3-1> make
./compat/scripts/gen-compat-config.sh: line 51: KLIB_BUILD: command not 
found
grep: /Makefile: No such file or directory
./scripts/gen-compat-autoconf.sh 
/home/michael/compat-wireless-3.4-rc3-1/.config 
/home/michael/compat-wireless-3.4-rc3-1/config.mk > 
include/linux/compat_autoconf.h
make -C /lib/modules/2.6.32-220.13.1.el6.x86_64/build 
M=/home/michael/compat-wireless-3.4-rc3-1 modules
make[1]: Entering directory `/usr/src/kernels/2.6.32-220.13.1.el6.x86_64'
   CC [M]  /home/michael/compat-wireless-3.4-rc3-1/compat/main.o
In file included from 
/home/michael/compat-wireless-3.4-rc3-1/include/linux/compat-2.6.h:55,
                  from <command-line>:0:
/home/michael/compat-wireless-3.4-rc3-1/include/linux/compat-2.6.35.h:27: error: 
static declaration of ‘irq_set_affinity_hint’ follows non-static declaration
include/linux/interrupt.h:218: note: previous declaration of 
‘irq_set_affinity_hint’ was here
In file included from 
/home/michael/compat-wireless-3.4-rc3-1/include/linux/compat-2.6.h:61,
                  from <command-line>:0:
/home/michael/compat-wireless-3.4-rc3-1/include/linux/compat-3.1.h:11: 
error: redefinition of ‘__netdev_alloc_skb_ip_align’
include/linux/skbuff.h:1512: note: previous definition of 
‘__netdev_alloc_skb_ip_align’ was here
make[3]: *** [/home/michael/compat-wireless-3.4-rc3-1/compat/main.o] Error 1
make[2]: *** [/home/michael/compat-wireless-3.4-rc3-1/compat] Error 2
make[1]: *** [_module_/home/michael/compat-wireless-3.4-rc3-1] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.32-220.13.1.el6.x86_64'
make: *** [modules] Error 2

-----

Can we fix this?

Thanks,
   Michael
