Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.211.193]:43375 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZHMCDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 22:03:13 -0400
Received: by ywh31 with SMTP id 31so641394ywh.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 19:03:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A829D90.2080208@tls-tautenburg.de>
References: <4A829D90.2080208@tls-tautenburg.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Aug 2009 19:02:54 -0700
Message-ID: <43e72e890908121902g11b136e8y3f1cd30e6c607c08@mail.gmail.com>
Subject: Re: compile error: compat-wireless-2009-08-12
To: Bringfried Stecklum <stecklum@tls-tautenburg.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 3:46 AM, Bringfried
Stecklum<stecklum@tls-tautenburg.de> wrote:
> When trying to compile the latest compat-wireless package on an Ubuntu 8.10
> 64bit system running linux kernel 2.6.27-12 I get the following error
>
> stecklum@extragalactix:~/System/src/compat-wireless-2009-08-12$ make
> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> make -C /lib/modules/2.6.27-12-mygeneric/build
> M=/home/stecklum/System/src/compat-wireless-2009-08-12 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
> ...
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/main.c:
> In function ‘b43_request_firmware’:
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/main.c:2103:
> warning: format not a string literal and no format arguments
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/tables.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/phy_common.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/phy_g.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/phy_a.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/sysfs.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/xmit.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/lo.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/wa.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/dma.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pio.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/rfkill.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/leds.o
>  CC [M]
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.o
> In file included from
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:30:
> include/pcmcia/cistpl.h:610:1: warning: "pcmcia_parse_tuple" redefined
> In file included from
> /home/stecklum/System/src/compat-wireless-2009-08-12/include/net/compat.h:19,
>                 from <command-line>:0:
> /home/stecklum/System/src/compat-wireless-2009-08-12/include/net/compat-2.6.28.h:32:1:
> warning: this is the location of the previous definition
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91:41:
> error: macro "pcmcia_parse_tuple" requires 3 arguments, but only 2 given
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:
> In function ‘b43_pcmcia_probe’:
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91:
> error: ‘pcmcia_parse_tuple’ undeclared (first use in this function)
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91:
> error: (Each undeclared identifier is reported only once
> /home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91:
> error: for each function it appears in.)
> make[4]: ***
> [/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.o]
> Error 1
> make[3]: ***
> [/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43]
> Error 2
> make[2]: ***
> [/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless]
> Error 2
> make[1]: *** [_module_/home/stecklum/System/src/compat-wireless-2009-08-12]
> Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
> make: *** [modules] Error 2

Try today's release.

  Luis
