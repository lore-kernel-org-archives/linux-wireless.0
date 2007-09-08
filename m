Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:58472 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXIHS2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 14:28:03 -0400
Received: by wa-out-1112.google.com with SMTP id v27so959061wah
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 11:28:02 -0700 (PDT)
Message-ID: <6b8cef970709081128w7500e012q30719cab0c7b3834@mail.gmail.com>
Date: Sat, 8 Sep 2007 14:28:02 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709081939.10253.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <200709081918.45514.IvDoorn@gmail.com>
	 <6b8cef970709081016q1179de26sa49b3a3403283f21@mail.gmail.com>
	 <200709081939.10253.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that rc80211_simple is being built-in. I don't know why
mac80211 can't find it, and I have no idea where to go from here.

rob@rob-desktop:~/Source/wireless-dev$ grep -R "rc80211_simple" *
net/mac80211/Makefile:obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
net/mac80211/.built-in.o.cmd:cmd_net/mac80211/built-in.o :=  ld -m
elf_i386 -m elf_i386  -r -o net/mac80211/built-in.o
net/mac80211/mac80211.o net/mac80211/rc80211_simple.o
Binary file net/mac80211/rc80211_simple.o matches
net/mac80211/.rc80211_simple.o.cmd:cmd_net/mac80211/rc80211_simple.o
:= gcc -m32 -Wp,-MD,net/mac80211/.rc80211_simple.o.d  -nostdinc
-isystem /usr/lib/gcc/i486-linux-gnu/4.1.2/include -D__KERNEL__
-Iinclude  -include include/linux/autoconf.h -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -O2 -pipe -msoft-float
-mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2
-march=i686 -mtune=pentium4 -ffreestanding -maccumulate-outgoing-args
 -Iinclude/asm-i386/mach-default -fomit-frame-pointer
-fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign
 -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(rc80211_simple)"
-D"KBUILD_MODNAME=KBUILD_STR(rc80211_simple)" -c -o
net/mac80211/.tmp_rc80211_simple.o net/mac80211/rc80211_simple.c
net/mac80211/.rc80211_simple.o.cmd:deps_net/mac80211/rc80211_simple.o := \
net/mac80211/.rc80211_simple.o.cmd:  net/mac80211/rc80211_simple.c \
net/mac80211/.rc80211_simple.o.cmd:net/mac80211/rc80211_simple.o:
$(deps_net/mac80211/rc80211_simple.o)
net/mac80211/.rc80211_simple.o.cmd:$(deps_net/mac80211/rc80211_simple.o):
Binary file net/mac80211/built-in.o matches
Binary file net/built-in.o matches
Binary file vmlinux matches
Binary file vmlinux.o matches
