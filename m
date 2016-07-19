Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33804 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcGSF4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 01:56:10 -0400
Received: by mail-lf0-f65.google.com with SMTP id l69so437946lfg.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 22:56:09 -0700 (PDT)
Subject: Re: [ath6kl:pending 14/24] drivers/mtd/devices/bcm47xxsflash.c:299:2:
 error: implicit declaration of function 'ioremap_cache'
To: kbuild test robot <fengguang.wu@intel.com>,
	Brian Norris <computersforpeace@gmail.com>
References: <201607190916.c8xDOxpA%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
	Kalle Valo <kvalo@adurom.com>, linux-mtd@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <b1bcfe6c-6875-b01b-7d10-ea8d1e00adfc@gmail.com> (sfid-20160719_075614_900553_92B23CE0)
Date: Tue, 19 Jul 2016 07:56:06 +0200
MIME-Version: 1.0
In-Reply-To: <201607190916.c8xDOxpA%fengguang.wu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending reply with proper To/Cc.

On 07/19/2016 03:14 AM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git pending
> head:   7a1b79bd39dda1f12b9f6708583250f40354c981
> commit: 57d8f7dd2132df3ac21044e93a8ecdc9744b4459 [14/24] bcma: allow enabling serial flash support on non-MIPS SoCs
> config: cris-allmodconfig (attached as .config)
> compiler: cris-linux-gcc (GCC) 4.6.3
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 57d8f7dd2132df3ac21044e93a8ecdc9744b4459
>         # save the attached .config to linux build tree
>         make.cross ARCH=cris
>
> All error/warnings (new ones prefixed by >>):
>
>    drivers/mtd/devices/bcm47xxsflash.c: In function 'bcm47xxsflash_bcma_probe':
>>> drivers/mtd/devices/bcm47xxsflash.c:299:2: error: implicit declaration of function 'ioremap_cache' [-Werror=implicit-function-declaration]
>>> drivers/mtd/devices/bcm47xxsflash.c:299:15: warning: assignment makes pointer from integer without a cast [enabled by default]
>    cc1: some warnings being treated as errors

Oh, great :( With commit:
5651d6aaf489 ("mtd: bcm47xxsflash: use ioremap_cache() instead of KSEG0ADDR()")
we believed to make this driver compilable on all architectures. It seems that
ioremap_cache is available only on arm, arm64, ia64, mips, sh, x86 and xtensa.

I noticed that kernel/memremap.c implements ioremap_cache on its own for archs
that don't provide it. There is a comment in this file:
/* temporary while we convert existing ioremap_cache users to memremap */

Should we use memremap? I don't understand this function well, it seems I could
call it with with MEMREMAP_WB flag (and trigger ioremap_cache call), but is it a
correct thing to do?

Or should we simply make some symbol (CONFIG_MTD_BCM47XXSFLASH?) depend on
ARM || MIPS?


> vim +/ioremap_cache +299 drivers/mtd/devices/bcm47xxsflash.c
>
> 5fe42d5bf Rafał Miłecki 2012-09-17  283
> 5651d6aaf Brian Norris  2016-02-26  284  	b47s = devm_kzalloc(dev, sizeof(*b47s), GFP_KERNEL);
> d2b1bd142 Libo Chen     2013-05-30  285  	if (!b47s)
> d2b1bd142 Libo Chen     2013-05-30  286  		return -ENOMEM;
> a2f74a7da Rafał Miłecki 2013-01-06  287  	sflash->priv = b47s;
> a2f74a7da Rafał Miłecki 2013-01-06  288
> 5651d6aaf Brian Norris  2016-02-26  289  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 5651d6aaf Brian Norris  2016-02-26  290  	if (!res) {
> 5651d6aaf Brian Norris  2016-02-26  291  		dev_err(dev, "invalid resource\n");
> 5651d6aaf Brian Norris  2016-02-26  292  		return -EINVAL;
> 5651d6aaf Brian Norris  2016-02-26  293  	}
> 5651d6aaf Brian Norris  2016-02-26  294  	if (!devm_request_mem_region(dev, res->start, resource_size(res),
> 5651d6aaf Brian Norris  2016-02-26  295  				     res->name)) {
> 5651d6aaf Brian Norris  2016-02-26  296  		dev_err(dev, "can't request region for resource %pR\n", res);
> 5651d6aaf Brian Norris  2016-02-26  297  		return -EBUSY;
> 5651d6aaf Brian Norris  2016-02-26  298  	}
> 5651d6aaf Brian Norris  2016-02-26 @299  	b47s->window = ioremap_cache(res->start, resource_size(res));
> 5651d6aaf Brian Norris  2016-02-26  300  	if (!b47s->window) {
> 5651d6aaf Brian Norris  2016-02-26  301  		dev_err(dev, "ioremap failed for resource %pR\n", res);
> 5651d6aaf Brian Norris  2016-02-26  302  		return -ENOMEM;
> 5651d6aaf Brian Norris  2016-02-26  303  	}
> 5651d6aaf Brian Norris  2016-02-26  304
> 41c81536e Rafał Miłecki 2013-03-06  305  	b47s->bcma_cc = container_of(sflash, struct bcma_drv_cc, sflash);
> 265dfbd9a Rafał Miłecki 2013-03-24  306  	b47s->cc_read = bcm47xxsflash_bcma_cc_read;
> 265dfbd9a Rafał Miłecki 2013-03-24  307  	b47s->cc_write = bcm47xxsflash_bcma_cc_write;
>
> :::::: The code at line 299 was first introduced by commit
> :::::: 5651d6aaf489d1db48c253cf884b40214e91c2c5 mtd: bcm47xxsflash: use ioremap_cache() instead of KSEG0ADDR()
>
> :::::: TO: Brian Norris <computersforpeace@gmail.com>
> :::::: CC: Brian Norris <computersforpeace@gmail.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
