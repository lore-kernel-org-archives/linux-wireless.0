Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41295 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbbKYBXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 20:23:50 -0500
Message-ID: <56550D40.3090603@codeaurora.org> (sfid-20151125_022419_423837_D51E07AC)
Date: Tue, 24 Nov 2015 17:22:08 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: kbuild test robot <lkp@intel.com>, Peter Oh <poh@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, kbuild-all@01.org,
	ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ath10k: update WMI 10.x service map
References: <201511250520.vewzfdmy%fengguang.wu@intel.com>
In-Reply-To: <201511250520.vewzfdmy%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I believe the robot report is false.
Am I right?

Thanks,
Peter
On 11/24/2015 01:19 PM, kbuild test robot wrote:
> Hi Peter,
>
> [auto build test WARNING on net-next/master]
> [also build test WARNING on v4.4-rc2 next-20151124]
>
> url:
> https://github.com/0day-ci/linux/commits/Peter-Oh/ath10k-introduce-Mesh-su
> pport-in-native-WiFi-mode-for-QCA988X/20151125-014059
> config: m68k-allmodconfig (attached as .config)
> reproduce:
>          wget
> https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/
> make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          make.cross ARCH=m68k
>
> All warnings (new ones prefixed by >>):
>
>     In file included from include/linux/bitops.h:36:0,
>                      from include/linux/kernel.h:10,
>                      from include/asm-generic/bug.h:13,
>                      from arch/m68k/include/asm/bug.h:28,
>                      from include/linux/bug.h:4,
>                      from include/net/mac80211.h:18,
>                      from drivers/net/wireless/ath/ath10k/mac.h:21,
>                      from drivers/net/wireless/ath/ath10k/mac.c:18:
>     drivers/net/wireless/ath/ath10k/wmi.h: In function 'wmi_10x_svc_map':
>     drivers/net/wireless/ath/ath10k/wmi.h:457:9: error: 'WMI_SERVICE_MESH'
> undeclared (first use in this function)
>              WMI_SERVICE_MESH, len);
>              ^
>     arch/m68k/include/asm/bitops.h:63:50: note: in definition of macro
> 'set_bit'
>      #define set_bit(nr, vaddr) (__builtin_constant_p(nr) ? \
>                                                       ^
>>> drivers/net/wireless/ath/ath10k/wmi.h:398:4: note: in expansion of
> macro '__set_bit'
>         __set_bit(y, out); \
>         ^
>>> drivers/net/wireless/ath/ath10k/wmi.h:456:2: note: in expansion of
> macro 'SVCMAP'
>       SVCMAP(WMI_10X_SERVICE_MESH,
>       ^
>     drivers/net/wireless/ath/ath10k/wmi.h:457:9: note: each undeclared
> identifier is reported only once for each function it appears in
>              WMI_SERVICE_MESH, len);
>              ^
>     arch/m68k/include/asm/bitops.h:63:50: note: in definition of macro
> 'set_bit'
>      #define set_bit(nr, vaddr) (__builtin_constant_p(nr) ? \
>                                                       ^
>>> drivers/net/wireless/ath/ath10k/wmi.h:398:4: note: in expansion of
> macro '__set_bit'
>         __set_bit(y, out); \
>         ^
>>> drivers/net/wireless/ath/ath10k/wmi.h:456:2: note: in expansion of
> macro 'SVCMAP'
>       SVCMAP(WMI_10X_SERVICE_MESH,
>       ^
>     drivers/net/wireless/ath/ath10k/wmi.h:459:9: error:
> 'WMI_SERVICE_EXT_RES_CFG_SUPPORT' undeclared (first use in this function)
>              WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
>              ^
>     arch/m68k/include/asm/bitops.h:63:50: note: in definition of macro
> 'set_bit'
>      #define set_bit(nr, vaddr) (__builtin_constant_p(nr) ? \
>                                                       ^
>>> drivers/net/wireless/ath/ath10k/wmi.h:398:4: note: in expansion of
> macro '__set_bit'
>         __set_bit(y, out); \
>         ^
>     drivers/net/wireless/ath/ath10k/wmi.h:458:2: note: in expansion of
> macro 'SVCMAP'
>       SVCMAP(WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
>       ^
>
> vim +/__set_bit +398 drivers/net/wireless/ath/ath10k/wmi.h
>
> 37b9f933 Michal Kazior 2014-11-27  392
> __le32_to_cpu((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
> cff990ce Michal Kazior 2014-08-04  393
> BIT((svc_id)%(sizeof(u32))))
> cff990ce Michal Kazior 2014-08-04  394
> 37b9f933 Michal Kazior 2014-11-27  395  #define SVCMAP(x, y, len) \
> cff990ce Michal Kazior 2014-08-04  396  	do { \
> 37b9f933 Michal Kazior 2014-11-27  397  		if
> (WMI_SERVICE_IS_ENABLED((in), (x), (len))) \
> cff990ce Michal Kazior 2014-08-04 @398
> __set_bit(y, out); \
> cff990ce Michal Kazior 2014-08-04  399  	} while (0)
> cff990ce Michal Kazior 2014-08-04  400
> 37b9f933 Michal Kazior 2014-11-27  401  static inline void
> wmi_10x_svc_map(const __le32 *in, unsigned long *out,
> 37b9f933 Michal Kazior 2014-11-27  402
> size_t len)
> cff990ce Michal Kazior 2014-08-04  403  {
> cff990ce Michal Kazior 2014-08-04  404
> SVCMAP(WMI_10X_SERVICE_BEACON_OFFLOAD,
> 37b9f933 Michal Kazior 2014-11-27  405
> WMI_SERVICE_BEACON_OFFLOAD, len);
> cff990ce Michal Kazior 2014-08-04  406
> SVCMAP(WMI_10X_SERVICE_SCAN_OFFLOAD,
> 37b9f933 Michal Kazior 2014-11-27  407
> WMI_SERVICE_SCAN_OFFLOAD, len);
> cff990ce Michal Kazior 2014-08-04  408
> SVCMAP(WMI_10X_SERVICE_ROAM_OFFLOAD,
> 37b9f933 Michal Kazior 2014-11-27  409
> WMI_SERVICE_ROAM_OFFLOAD, len);
> cff990ce Michal Kazior 2014-08-04  410
> SVCMAP(WMI_10X_SERVICE_BCN_MISS_OFFLOAD,
> 37b9f933 Michal Kazior 2014-11-27  411
> WMI_SERVICE_BCN_MISS_OFFLOAD, len);
> cff990ce Michal Kazior 2014-08-04  412
> SVCMAP(WMI_10X_SERVICE_STA_PWRSAVE,
> 37b9f933 Michal Kazior 2014-11-27  413
> WMI_SERVICE_STA_PWRSAVE, len);
> cff990ce Michal Kazior 2014-08-04  414
> SVCMAP(WMI_10X_SERVICE_STA_ADVANCED_PWRSAVE,
> 37b9f933 Michal Kazior 2014-11-27  415
> WMI_SERVICE_STA_ADVANCED_PWRSAVE, len);
> cff990ce Michal Kazior 2014-08-04  416
> SVCMAP(WMI_10X_SERVICE_AP_UAPSD,
> 37b9f933 Michal Kazior 2014-11-27  417
> WMI_SERVICE_AP_UAPSD, len);
> cff990ce Michal Kazior 2014-08-04  418
> SVCMAP(WMI_10X_SERVICE_AP_DFS,
> 37b9f933 Michal Kazior 2014-11-27  419  	       WMI_SERVICE_AP_DFS,
> len);
> cff990ce Michal Kazior 2014-08-04  420
> SVCMAP(WMI_10X_SERVICE_11AC,
> 37b9f933 Michal Kazior 2014-11-27  421  	       WMI_SERVICE_11AC,
> len);
> cff990ce Michal Kazior 2014-08-04  422
> SVCMAP(WMI_10X_SERVICE_BLOCKACK,
> 37b9f933 Michal Kazior 2014-11-27  423
> WMI_SERVICE_BLOCKACK, len);
> cff990ce Michal Kazior 2014-08-04  424
> SVCMAP(WMI_10X_SERVICE_PHYERR,
> 37b9f933 Michal Kazior 2014-11-27  425  	       WMI_SERVICE_PHYERR,
> len);
> cff990ce Michal Kazior 2014-08-04  426
> SVCMAP(WMI_10X_SERVICE_BCN_FILTER,
> 37b9f933 Michal Kazior 2014-11-27  427
> WMI_SERVICE_BCN_FILTER, len);
> cff990ce Michal Kazior 2014-08-04  428
> SVCMAP(WMI_10X_SERVICE_RTT,
> 37b9f933 Michal Kazior 2014-11-27  429  	       WMI_SERVICE_RTT,
> len);
> cff990ce Michal Kazior 2014-08-04  430
> SVCMAP(WMI_10X_SERVICE_RATECTRL,
> 37b9f933 Michal Kazior 2014-11-27  431
> WMI_SERVICE_RATECTRL, len);
> cff990ce Michal Kazior 2014-08-04  432
> SVCMAP(WMI_10X_SERVICE_WOW,
> 37b9f933 Michal Kazior 2014-11-27  433  	       WMI_SERVICE_WOW,
> len);
> cff990ce Michal Kazior 2014-08-04  434
> SVCMAP(WMI_10X_SERVICE_RATECTRL_CACHE,
> 37b9f933 Michal Kazior 2014-11-27  435
> WMI_SERVICE_RATECTRL_CACHE, len);
> cff990ce Michal Kazior 2014-08-04  436
> SVCMAP(WMI_10X_SERVICE_IRAM_TIDS,
> 37b9f933 Michal Kazior 2014-11-27  437
> WMI_SERVICE_IRAM_TIDS, len);
> cff990ce Michal Kazior 2014-08-04  438
> SVCMAP(WMI_10X_SERVICE_BURST,
> 37b9f933 Michal Kazior 2014-11-27  439  	       WMI_SERVICE_BURST,
> len);
> cff990ce Michal Kazior 2014-08-04  440
> SVCMAP(WMI_10X_SERVICE_SMART_ANTENNA_SW_SUPPORT,
> 37b9f933 Michal Kazior 2014-11-27  441
> WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT, len);
> cff990ce Michal Kazior 2014-08-04  442
> SVCMAP(WMI_10X_SERVICE_FORCE_FW_HANG,
> 37b9f933 Michal Kazior 2014-11-27  443
> WMI_SERVICE_FORCE_FW_HANG, len);
> cff990ce Michal Kazior 2014-08-04  444
> SVCMAP(WMI_10X_SERVICE_SMART_ANTENNA_HW_SUPPORT,
> 37b9f933 Michal Kazior 2014-11-27  445
> WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT, len);
> 52c22a63 Yanbo Li      2015-04-15  446
> SVCMAP(WMI_10X_SERVICE_ATF,
> 52c22a63 Yanbo Li      2015-04-15  447  	       WMI_SERVICE_ATF,
> len);
> de0c789b Yanbo Li      2015-04-15  448
> SVCMAP(WMI_10X_SERVICE_COEX_GPIO,
> de0c789b Yanbo Li      2015-04-15  449
> WMI_SERVICE_COEX_GPIO, len);
> 96a31b26 Peter Oh      2015-11-24  450
> SVCMAP(WMI_10X_SERVICE_AUX_SPECTRAL_INTF,
> 96a31b26 Peter Oh      2015-11-24  451
> WMI_SERVICE_AUX_SPECTRAL_INTF, len);
> 96a31b26 Peter Oh      2015-11-24  452
> SVCMAP(WMI_10X_SERVICE_AUX_CHAN_LOAD_INTF,
> 96a31b26 Peter Oh      2015-11-24  453
> WMI_SERVICE_AUX_CHAN_LOAD_INTF, len);
> 96a31b26 Peter Oh      2015-11-24  454
> SVCMAP(WMI_10X_SERVICE_BSS_CHANNEL_INFO_64,
> 96a31b26 Peter Oh      2015-11-24  455
> WMI_SERVICE_BSS_CHANNEL_INFO_64, len);
> 96a31b26 Peter Oh      2015-11-24 @456
> SVCMAP(WMI_10X_SERVICE_MESH,
> 96a31b26 Peter Oh      2015-11-24 @457  	       WMI_SERVICE_MESH,
> len);
> 96a31b26 Peter Oh      2015-11-24  458
> SVCMAP(WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
> 96a31b26 Peter Oh      2015-11-24  459
> WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
> 5e3dd157 Kalle Valo    2013-06-12  460  }
>
> :::::: The code at line 398 was first introduced by commit
> :::::: cff990ce7ddd6a43f86757867399a8a64aa29af9 ath10k: fix wmi service
> bitmap debug
>
> :::::: TO: Michal Kazior <michal.kazior@tieto.com>
> :::::: CC: Kalle Valo <kvalo@qca.qualcomm.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation

