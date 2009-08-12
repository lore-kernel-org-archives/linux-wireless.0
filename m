Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:9813 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbZHLK6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 06:58:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id BF110507B4
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 12:46:44 +0200 (CEST)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
	by localhost (kso.tls-tautenburg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2EZYhdZ7qKtm for <linux-wireless@vger.kernel.org>;
	Wed, 12 Aug 2009 12:46:40 +0200 (CEST)
Received: from [194.94.209.48] (unknown [194.94.209.48])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by kso.tls-tautenburg.de (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 12:46:40 +0200 (CEST)
Message-ID: <4A829D90.2080208@tls-tautenburg.de>
Date: Wed, 12 Aug 2009 12:46:40 +0200
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compile error: compat-wireless-2009-08-12
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to compile the latest compat-wireless package on an Ubuntu 8.10
64bit system running linux kernel 2.6.27-12 I get the following error

stecklum@extragalactix:~/System/src/compat-wireless-2009-08-12$ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.27-12-mygeneric/build 
M=/home/stecklum/System/src/compat-wireless-2009-08-12 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
...
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/main.c: 
In function ‘b43_request_firmware’:
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/main.c:2103: 
warning: format not a string literal and no format arguments
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/tables.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/phy_common.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/phy_g.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/phy_a.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/sysfs.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/xmit.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/lo.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/wa.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/dma.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pio.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/rfkill.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/leds.o
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.o
In file included from 
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:30:
include/pcmcia/cistpl.h:610:1: warning: "pcmcia_parse_tuple" redefined
In file included from 
/home/stecklum/System/src/compat-wireless-2009-08-12/include/net/compat.h:19,
                  from <command-line>:0:
/home/stecklum/System/src/compat-wireless-2009-08-12/include/net/compat-2.6.28.h:32:1: 
warning: this is the location of the previous definition
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91:41: 
error: macro "pcmcia_parse_tuple" requires 3 arguments, but only 2 given
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c: 
In function ‘b43_pcmcia_probe’:
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91: 
error: ‘pcmcia_parse_tuple’ undeclared (first use in this function)
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91: 
error: (Each undeclared identifier is reported only once
/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.c:91: 
error: for each function it appears in.)
make[4]: *** 
[/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43/pcmcia.o] 
Error 1
make[3]: *** 
[/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless/b43] 
Error 2
make[2]: *** 
[/home/stecklum/System/src/compat-wireless-2009-08-12/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/stecklum/System/src/compat-wireless-2009-08-12] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
make: *** [modules] Error 2

Regards,

	Bringfried



