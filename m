Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.redpill-linpro.com ([87.238.49.234]:59856 "EHLO
	zimbra.redpill-linpro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1KCXwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 19:52:54 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.redpill-linpro.com (Postfix) with ESMTP id 6CC8A1048056
	for <linux-wireless@vger.kernel.org>; Fri,  4 Nov 2011 00:45:59 +0100 (CET)
Received: from zimbra.redpill-linpro.com ([127.0.0.1])
	by localhost (zimbra.redpill-linpro.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Owi+6AvQTSC1 for <linux-wireless@vger.kernel.org>;
	Fri,  4 Nov 2011 00:45:58 +0100 (CET)
Received: from zimbra.redpill-linpro.com (claudius.linpro.no [87.238.49.234])
	by zimbra.redpill-linpro.com (Postfix) with ESMTP id D39221048055
	for <linux-wireless@vger.kernel.org>; Fri,  4 Nov 2011 00:45:58 +0100 (CET)
Date: Fri, 04 Nov 2011 00:45:58 +0100 (CET)
From: Ingvar Hagelund <ingvar@redpill-linpro.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] net:rfkill: add a gpio setup function into GPIO rfkill
Message-ID: <30f8016d-2707-429b-8b78-6e6dee5cc8f2@claudius.linpro.no> (sfid-20111104_005259_022235_8F58E737)
In-Reply-To: <bebe7f8a-897c-4096-9aaf-e3f63151bbfc@claudius.linpro.no>
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reference: Email from Sangwook Lee, 2011-09-29 to this list and to lkml, with this subject, see http://article.gmane.org/gmane.linux.kernel/1197024/

Now, when I compile compat-wireless-2011-11-03 on my G3 iBook (ppc32) against linux-3.1.0 (Fedora based kernel package 3.1.0-7.fc16.ppc), I get the following errors, so it seems that Lee's patch was not merged (yet), though those structs 'gpio_runtime_setup' and 'gpio_runtime_close' are used in the rfkill-gpio module:

  CC [M]  /home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.o
/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.c: In function 'rfkill_gpio_probe':
/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.c:104:11: error: 'struct rfkill_gpio_platform_data' has no member named 'gpio_runtime_setup'
/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.c:105:14: error: 'struct rfkill_gpio_platform_data' has no member named 'gpio_runtime_setup'
/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.c: In function 'rfkill_gpio_remove':
/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.c:195:11: error: 'struct rfkill_gpio_platform_data' has no member named 'gpio_runtime_close'
/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.c:196:8: error: 'struct rfkill_gpio_platform_data' has no member named 'gpio_runtime_close'
make[3]: *** [/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill/rfkill-gpio.o] Error 1
make[2]: *** [/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03/net/rfkill] Error 2
make[1]: *** [_module_/home/ingvar/src/compat-wireless-latest/compat-wireless-2011-11-03] Error 2
make[1]: Leaving directory `/usr/src/kernels/3.1.0-7.fc16.ppc'
make: *** [modules] Error 2

Adding Lee's patch (or even only the headers) seems to work.

Just fyi.

Ingvar
