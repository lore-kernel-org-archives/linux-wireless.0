Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3592 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3ARIi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 03:38:26 -0500
Date: Fri, 18 Jan 2013 16:38:25 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [wireless-next:master 52/89] drivers/bcma/driver_mips.c:297:4:
 error: implicit declaration of function 'bcma_core_irq'
Message-ID: <50f90a01.gkgVoH9EfWvuZEYP%fengguang.wu@intel.com> (sfid-20130118_093832_165576_8A466474)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   660b9caaad380758c756a7e60397e33dab44fe3f
commit: e3f05a42faac627d8704c76c1927e09b22443b7b [52/89] bcma: mips: explicit assign IRQ numbers
config: make ARCH=mips allmodconfig

Note: the wireless-next/master HEAD 660b9ca builds fine.
      It only hurts bisectibility.

All error/warnings:

   In file included from include/linux/bcma/bcma.h:7:0,
                    from drivers/bcma/bcma_private.h:8,
                    from drivers/bcma/driver_mips.c:13:
   include/linux/bcma/bcma_driver_chipcommon.h:582:19: error: field 'gpio' has incomplete type
   In file included from include/linux/bcma/bcma.h:11:0,
                    from drivers/bcma/bcma_private.h:8,
                    from drivers/bcma/driver_mips.c:13:
   include/linux/ssb/ssb.h:440:19: error: field 'gpio' has incomplete type
   drivers/bcma/driver_mips.c: In function 'bcma_core_mips_init':
>> drivers/bcma/driver_mips.c:297:4: error: implicit declaration of function 'bcma_core_irq' [-Werror=implicit-function-declaration]
   cc1: some warnings being treated as errors

vim +/bcma_core_irq +297 drivers/bcma/driver_mips.c

   291			bcma_core_mips_set_irq_name(bus, 4, BCMA_CORE_USB20_HOST, 0);
   292			bcma_core_mips_set_irq_name(bus, 0, BCMA_CORE_4706_CHIPCOMMON,
   293						    0);
   294			break;
   295		default:
   296			list_for_each_entry(core, &bus->cores, list) {
 > 297				core->irq = bcma_core_irq(core);
   298			}
   299			bcma_err(bus,
   300				 "Unknown device (0x%x) found, can not configure IRQs\n",

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
