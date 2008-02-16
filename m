Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:51017 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYBPKpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 05:45:00 -0500
Received: from localhost (23.249.105.73) by aa012msr.fastwebnet.it (8.0.013.5)
        id 47AAE88C01529036 for linux-wireless@vger.kernel.org; Sat, 16 Feb 2008 11:39:43 +0100
Date: Sat, 16 Feb 2008 11:38:46 +0100
From: Fabio Venturi <f.venturi@tdnet.it>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Problem compiling ath5k
Message-ID: <20080216103846.GC9290@silverstar> (sfid-20080216_104524_633776_B3EAB4EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello to the list,
I'd like to try the ath5k kernel module for my Atheros AR2413 Wireless Card
so I downloaded the compat-wireless-2.6.tar.bz2 
I'm running a 2.6.24.2 kernel (the laste stable),
but the compile stage ends immediately:


//------ START MAKE ----------------
make -C /lib/modules/2.6.24.2-KaL/build M=/usr/src/modules/compat-wireless-2.6 modules
make[1]: Entering directory `/usr/src/linux-2.6.24'
  CC [M]  /usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.o
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:165:33: error: linux/pm_qos_params.h: No such file or directory
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c: In function 'ipw2100_up':
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:1704: error: implicit declaration of function 'pm_qos_update_requirement'
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:1704: error: 'PM_QOS_CPU_DMA_LATENCY' undeclared (first use in this function)
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:1704: error: (Each undeclared identifier is reported only once
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:1704: error: for each function it appears in.)
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c: In function 'ipw2100_down':
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:1859: error: 'PM_QOS_CPU_DMA_LATENCY' undeclared (first use in this function)
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:1860: error: 'PM_QOS_DEFAULT_VALUE' undeclared (first use in this function)
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c: In function 'ipw2100_init':
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:6558: error: implicit declaration of function 'pm_qos_add_requirement'
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:6558: error: 'PM_QOS_CPU_DMA_LATENCY' undeclared (first use in this function)
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:6559: error: 'PM_QOS_DEFAULT_VALUE' undeclared (first use in this function)
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c: In function 'ipw2100_exit':
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:6581: error: implicit declaration of function 'pm_qos_remove_requirement'
/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.c:6581: error: 'PM_QOS_CPU_DMA_LATENCY' undeclared (first use in this function)
make[3]: *** [/usr/src/modules/compat-wireless-2.6/drivers/net/wireless/ipw2100.o] Error 1
make[2]: *** [/usr/src/modules/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_module_/usr/src/modules/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.24'
make: *** [modules] Error 2

//------------ END MAKE ----------

I'm missing linux/pm_qos_params.h
Where can I get it?
The directory /usr/include is a symlink to /usr/src/linux/include

Thank you in advance for any advice.
Best regards,
Fabio
