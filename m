Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51498 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2DVVJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 17:09:45 -0400
Message-ID: <4F947391.4030100@hauke-m.de> (sfid-20120422_230949_436696_A34F8BF4)
Date: Sun, 22 Apr 2012 23:09:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Oleksandr Yeremko <yeremko@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: need help in compiling compat-wireless
References: <CAFE89JyAgkY4v7Hzcy1JJwuA5nCtd9n2+d95UCUPvFiOXrCnGw@mail.gmail.com>
In-Reply-To: <CAFE89JyAgkY4v7Hzcy1JJwuA5nCtd9n2+d95UCUPvFiOXrCnGw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2012 05:10 PM, Oleksandr Yeremko wrote:
> Dear Friends,
> 
> I have the error described below during my attempts to build the
> latest Linux wireless drivers.
> 
> Could you, please, be so kind and explain me how to solve the problem?
> 
> Thanks in advance,
> Oleksandr
> 
> 
> [root@hq compat-wireless-2012-04-15]# uname -r
> 2.6.32-220.7.1.el6.x86_64
> 
> [root@hq compat-wireless-2012-04-15]# ./scripts/driver-select intel
> Processing new driver-select request...
> Backing up makefile: Makefile.bk
> Backing up makefile: drivers/net/wireless/Makefile.bk
> Backup exists: Makefile.bk
> Backing up makefile: drivers/ssb/Makefile.bk
> Backing up makefile: drivers/bcma/Makefile.bk
> Backing up makefile: drivers/misc/eeprom/Makefile.bk
> Backup exists: Makefile.bk
> 
> [root@hq compat-wireless-2012-04-15]# make
> ./compat/scripts/gen-compat-config.sh: line 51: KLIB_BUILD: command not found
> grep: /Makefile: No such file or directory
> ./scripts/gen-compat-autoconf.sh
> /root/src/compat-wireless-2012-04-15/.config
> /root/src/compat-wireless-2012-04-15/config.mk >
> include/linux/compat_autoconf.h
> make -C /lib/modules/2.6.32-220.7.1.el6.x86_64/build
> M=/root/src/compat-wireless-2012-04-15 modules
> make[1]: Entering directory `/usr/src/kernels/2.6.32-220.7.1.el6.x86_64'
>   CC [M]  /root/src/compat-wireless-2012-04-15/compat/main.o
> In file included from
> /root/src/compat-wireless-2012-04-15/include/linux/compat-2.6.h:55,
>                  from <command-line>:0:
> /root/src/compat-wireless-2012-04-15/include/linux/compat-2.6.35.h:27:
> error: static declaration of ‘irq_set_affinity_hint’ follows
> non-static declaration
> include/linux/interrupt.h:218: note: previous declaration of
> ‘irq_set_affinity_hint’ was here
> In file included from
> /root/src/compat-wireless-2012-04-15/include/linux/compat-2.6.h:61,
>                  from <command-line>:0:
> /root/src/compat-wireless-2012-04-15/include/linux/compat-3.1.h:11:
> error: redefinition of ‘__netdev_alloc_skb_ip_align’
> include/linux/skbuff.h:1512: note: previous definition of
> ‘__netdev_alloc_skb_ip_align’ was here
> make[3]: *** [/root/src/compat-wireless-2012-04-15/compat/main.o] Error 1
> make[2]: *** [/root/src/compat-wireless-2012-04-15/compat] Error 2
> make[1]: *** [_module_/root/src/compat-wireless-2012-04-15] Error 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.32-220.7.1.el6.x86_64'
> make: *** [modules] Error 2

Hi Oleksandr,

With mainline kernel 2.6.32 I do not get these error messages.
2.6.32-220.7.1.el6.x86_64 looks like a RedHat kernel which is different
from mainline kernel. Someone has to provide some patches for
compat-wireless to make it work with RedHat kernel again.

Hauke
