Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34842 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751750AbZIZBuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 21:50:12 -0400
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Re: ar9170 makes machine hang when shut down
Date: Sat, 26 Sep 2009 03:50:07 +0200
References: <200909242155.19485.malte.gell@gmx.de> <200909251132.18546.malte.gell@gmx.de> <4ABD2504.9010202@gmx.de>
In-Reply-To: <4ABD2504.9010202@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200909260350.07465.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Joerg Albert <jal2@gmx.de> wrote

Thanks to you and Luis for explanation.

> You are right. I had a look into the source rpm for the packets your url
>  pointed to. The ar9170 driver inside compat-wireless dates back to end of
>  February 2009, at that time the driver was called ar9170, it got the "usb"
>  prefix later.

Prefix? I guess it is more a suffix at the end, isn't it...?
 
> You might try arusb_lnx (the vendor driver) from the other package (no idea
>  how OpenSuSE handles two drivers for the same hardware), 

It seems it does not handle it at all... i was able to 1st load arusb_lnx but 
it did not work, maybe they reduced it just to a dummy thing? Ok, I'm surely 
wrong about that, at least arubs_lnx just did nothing. ar9170 only works.


>  but the best way
>  to get support from this list would be to compile a decent compat-wireless
>  by your own and report bugs etc. to the list. A lot of stuff changed since
>  February.

Yep, I tried before, but when i try to compile the latest compat-wireless I 
get this:

./scripts/driver-select ar9170

./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.27.29-0.1-k7/build 
M=/home/malte_gell/download/src/wifi/compat-wireless-2009-09-25 modules
make[1]: Entering directory `/usr/src/linux-2.6.27.29-0.1'
  LD      /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless/ath/built-in.o
  CC [M]  /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless/ath/main.o
In file included from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat.h:19,
                 from <command-line>:0:
/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:152: error: redefinition of 
‘struct tracepoint’
In file included from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat.h:19,
                 from <command-line>:0:
/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:182:1: warning: "DEFINE_TRACE" 
redefined
In file included from include/linux/module.h:19,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:26,
                 from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:10,
                 from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat.h:19,
                 from <command-line>:0:
include/linux/tracepoint.h:86:1: warning: this is the location of the previous 
definition
/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:186: error: redefinition of 
‘tracepoint_update_probe_range’
include/linux/tracepoint.h:100: error: previous definition of 
‘tracepoint_update_probe_range’ was here
make[4]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless/ath/main.o] Fehler 1
make[3]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless/ath] Fehler 2
make[2]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless] Fehler 2
make[1]: *** [_module_/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25] Fehler 2
make[1]: Leaving directory `/usr/src/linux-2.6.27.29-0.1'
make: *** [modules] Fehler 2


openSUSE 11.1 runs a 2.6.27 kernel, doesn't ar9170 need a 2.6.29 kernel? 
Somehow SUSE manages it in their packages, so I used the SUSE source rpm, but 
of course compat-wirless is more recent, but I can't compile it...

Thanx
Malte
