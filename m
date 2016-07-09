Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33560 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbcGIRF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 13:05:29 -0400
Subject: Re: [v1] ErrHandling:Make IS_ERR_VALUE_U32 as generic API to avoid
 IS_ERR_VALUE abuses.
To: kbuild test robot <lkp@intel.com>
References: <201607100030.7r0gSKVZ%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, zajec5@gmail.com, viresh.kumar@linaro.org,
	akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: arvind Yadav <arvind.yadav.cs@gmail.com>
Message-ID: <57812ED2.8030300@gmail.com> (sfid-20160709_190551_860422_EAA570ED)
Date: Sat, 9 Jul 2016 22:35:22 +0530
MIME-Version: 1.0
In-Reply-To: <201607100030.7r0gSKVZ%fengguang.wu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I have summited one more version-2 patch. Please test on that. please 
share your result with us.

Thanks,
Arvind yadav

On Saturday 09 July 2016 10:08 PM, kbuild test robot wrote:
> Hi,
>
> [auto build test WARNING on v4.7-rc6]
> [also build test WARNING on next-20160708]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Arvind-Yadav/ErrHandling-Make-IS_ERR_VALUE_U32-as-generic-API-to-avoid-IS_ERR_VALUE-abuses/20160709-235356
> config: x86_64-rhel (attached as .config)
> compiler: gcc-4.9 (Debian 4.9.3-14) 4.9.3
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
>
> All warnings (new ones prefixed by >>):
>
>     In file included from include/uapi/linux/stddef.h:1:0,
>                      from include/linux/stddef.h:4,
>                      from include/uapi/linux/posix_types.h:4,
>                      from include/uapi/linux/types.h:13,
>                      from include/linux/types.h:5,
>                      from include/linux/mod_devicetable.h:11,
>                      from include/linux/pci.h:20,
>                      from include/linux/bcma/bcma.h:4,
>                      from drivers/bcma/bcma_private.h:8,
>                      from drivers/bcma/scan.c:9:
>     drivers/bcma/scan.c: In function 'bcma_get_next_core':
>     include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                                         ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>>> drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
>       if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
>                       ^
>>> include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                           ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>>> drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
>       if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
>                       ^
>     include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                                         ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:365:19: note: in expansion of macro 'IS_ERR_VALUE_U32'
>        if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
>                        ^
>>> include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                           ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:365:19: note: in expansion of macro 'IS_ERR_VALUE_U32'
>        if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
>                        ^
>     include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                                         ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:380:8: note: in expansion of macro 'IS_ERR_VALUE_U32'
>         if (IS_ERR_VALUE_U32(tmp)) {
>             ^
>>> include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                           ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:380:8: note: in expansion of macro 'IS_ERR_VALUE_U32'
>         if (IS_ERR_VALUE_U32(tmp)) {
>             ^
>     include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                                         ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:397:8: note: in expansion of macro 'IS_ERR_VALUE_U32'
>         if (IS_ERR_VALUE_U32(tmp)) {
>             ^
>>> include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                           ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:397:8: note: in expansion of macro 'IS_ERR_VALUE_U32'
>         if (IS_ERR_VALUE_U32(tmp)) {
>             ^
>     include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                                         ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:415:8: note: in expansion of macro 'IS_ERR_VALUE_U32'
>         if (IS_ERR_VALUE_U32(tmp)) {
>             ^
>>> include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
>                                           ^
>     include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
>      # define unlikely(x) __builtin_expect(!!(x), 0)
>                                               ^
>     drivers/bcma/scan.c:415:8: note: in expansion of macro 'IS_ERR_VALUE_U32'
>         if (IS_ERR_VALUE_U32(tmp)) {
>             ^
>
> vim +/IS_ERR_VALUE_U32 +361 drivers/bcma/scan.c
>
> 517f43e5 Hauke Mehrtens 2011-07-23  345  	    )) {
> 517f43e5 Hauke Mehrtens 2011-07-23  346  		bcma_erom_skip_component(bus, eromptr);
> 517f43e5 Hauke Mehrtens 2011-07-23  347  		return -ENODEV;
> 517f43e5 Hauke Mehrtens 2011-07-23  348  	}
> 517f43e5 Hauke Mehrtens 2011-07-23  349
> 8369ae33 Rafał Miłecki  2011-05-09  350  	/* get & parse master ports */
> 8369ae33 Rafał Miłecki  2011-05-09  351  	for (i = 0; i < ports[0]; i++) {
> 4e0d8cc1 Dan Carpenter  2011-08-23  352  		s32 mst_port_d = bcma_erom_get_mst_port(bus, eromptr);
> 982eee67 Hauke Mehrtens 2011-07-23  353  		if (mst_port_d < 0)
> 982eee67 Hauke Mehrtens 2011-07-23  354  			return -EILSEQ;
> 8369ae33 Rafał Miłecki  2011-05-09  355  	}
> 8369ae33 Rafał Miłecki  2011-05-09  356
> e167d9fb Hauke Mehrtens 2012-03-15  357  	/* First Slave Address Descriptor should be port 0:
> e167d9fb Hauke Mehrtens 2012-03-15  358  	 * the main register space for the core
> e167d9fb Hauke Mehrtens 2012-03-15  359  	 */
> e167d9fb Hauke Mehrtens 2012-03-15  360  	tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
> aaa2ced1 Hauke Mehrtens 2013-09-07 @361  	if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
> e167d9fb Hauke Mehrtens 2012-03-15  362  		/* Try again to see if it is a bridge */
> e167d9fb Hauke Mehrtens 2012-03-15  363  		tmp = bcma_erom_get_addr_desc(bus, eromptr,
> e167d9fb Hauke Mehrtens 2012-03-15  364  					      SCAN_ADDR_TYPE_BRIDGE, 0);
> aaa2ced1 Hauke Mehrtens 2013-09-07  365  		if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
> e167d9fb Hauke Mehrtens 2012-03-15  366  			return -EILSEQ;
> e167d9fb Hauke Mehrtens 2012-03-15  367  		} else {
> 3d9d8af3 Rafał Miłecki  2012-07-05  368  			bcma_info(bus, "Bridge found\n");
> e167d9fb Hauke Mehrtens 2012-03-15  369  			return -ENXIO;
>
> :::::: The code at line 361 was first introduced by commit
> :::::: aaa2ced15ad8dca8048666c9f70736424d696a6b bcma: fix error code handling on 64 Bit systems
>
> :::::: TO: Hauke Mehrtens <hauke@hauke-m.de>
> :::::: CC: John W. Linville <linville@tuxdriver.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

