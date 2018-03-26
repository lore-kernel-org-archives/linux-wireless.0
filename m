Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:36733 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbeCZJPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 05:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <201803252111.2HMcV5IS%fengguang.wu@intel.com>
References: <20180324041027.6498-1-quytelda@tamalin.org> <201803252111.2HMcV5IS%fengguang.wu@intel.com>
From: Quytelda Kahja <quytelda@tamalin.org>
Date: Mon, 26 Mar 2018 02:15:19 -0700
Message-ID: <CAFLvi237jR_tTQMXBNqCO=NQFOEFiJQkDBMxb_AxgBEqQDYQEw@mail.gmail.com> (sfid-20180326_111538_838332_4A0C2EED)
Subject: Re: [PATCH 1/3] ieee80211: Replace bit shifts with the BIT() macro
 for WLAN_CAPABILITY_*.
To: kbuild test robot <lkp@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: kbuild-all@01.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a problem with the rtl8723bs driver in staging; it's source
tree has a custom IEEE80211 header which imports 'linux/ieee80211.h',
but redefines many of the #define's from the original header.
Functionally, they are the same, but I will submit a patch in reply to
this email which removes the duplicate #defines from
drivers/staging/rtl8723bs/include/ieee80211.h.  It looks like there's
also some #defines there that shadow enum members in
'linux/ieee80211.h', but I will address that in separate patch(es)
when I have a chance.

Thank you,
Quytelda Kahja

On Sun, Mar 25, 2018 at 7:05 AM, kbuild test robot <lkp@intel.com> wrote:
> Hi Quytelda,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on mac80211-next/master]
> [also build test WARNING on v4.16-rc6 next-20180323]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Quytelda-Kahja/ieee80211-Replace-bit-shifts-with-the-BIT-macro-for-WLAN_CAPABILITY_/20180325-211645
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> config: i386-randconfig-s1-03251817 (attached as .config)
> compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All warnings (new ones prefixed by >>):
>
>    In file included from drivers/staging/rtl8723bs/include/drv_types.h:33:0,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>>> drivers/staging/rtl8723bs/include/ieee80211.h:444:0: warning: "WLAN_CAPABILITY_IBSS" redefined
>     #define WLAN_CAPABILITY_IBSS (1<<1)
>
>    In file included from include/net/cfg80211.h:23:0,
>                     from drivers/staging/rtl8723bs/include/osdep_service_linux.h:50,
>                     from drivers/staging/rtl8723bs/include/osdep_service.h:23,
>                     from drivers/staging/rtl8723bs/include/drv_types.h:29,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>    include/linux/ieee80211.h:1593:0: note: this is the location of the previous definition
>     #define WLAN_CAPABILITY_IBSS  BIT(1)
>
>    In file included from drivers/staging/rtl8723bs/include/drv_types.h:33:0,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>>> drivers/staging/rtl8723bs/include/ieee80211.h:445:0: warning: "WLAN_CAPABILITY_CF_POLLABLE" redefined
>     #define WLAN_CAPABILITY_CF_POLLABLE (1<<2)
>
>    In file included from include/net/cfg80211.h:23:0,
>                     from drivers/staging/rtl8723bs/include/osdep_service_linux.h:50,
>                     from drivers/staging/rtl8723bs/include/osdep_service.h:23,
>                     from drivers/staging/rtl8723bs/include/drv_types.h:29,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>    include/linux/ieee80211.h:1603:0: note: this is the location of the previous definition
>     #define WLAN_CAPABILITY_CF_POLLABLE BIT(2)
>
>    In file included from drivers/staging/rtl8723bs/include/drv_types.h:33:0,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>>> drivers/staging/rtl8723bs/include/ieee80211.h:446:0: warning: "WLAN_CAPABILITY_CF_POLL_REQUEST" redefined
>     #define WLAN_CAPABILITY_CF_POLL_REQUEST (1<<3)
>
>    In file included from include/net/cfg80211.h:23:0,
>                     from drivers/staging/rtl8723bs/include/osdep_service_linux.h:50,
>                     from drivers/staging/rtl8723bs/include/osdep_service.h:23,
>                     from drivers/staging/rtl8723bs/include/drv_types.h:29,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>    include/linux/ieee80211.h:1604:0: note: this is the location of the previous definition
>     #define WLAN_CAPABILITY_CF_POLL_REQUEST BIT(3)
>
>    In file included from drivers/staging/rtl8723bs/include/drv_types.h:33:0,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>>> drivers/staging/rtl8723bs/include/ieee80211.h:447:0: warning: "WLAN_CAPABILITY_PRIVACY" redefined
>     #define WLAN_CAPABILITY_PRIVACY (1<<4)
>
>    In file included from include/net/cfg80211.h:23:0,
>                     from drivers/staging/rtl8723bs/include/osdep_service_linux.h:50,
>                     from drivers/staging/rtl8723bs/include/osdep_service.h:23,
>                     from drivers/staging/rtl8723bs/include/drv_types.h:29,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>    include/linux/ieee80211.h:1605:0: note: this is the location of the previous definition
>     #define WLAN_CAPABILITY_PRIVACY  BIT(4)
>
>    In file included from drivers/staging/rtl8723bs/include/drv_types.h:33:0,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>>> drivers/staging/rtl8723bs/include/ieee80211.h:448:0: warning: "WLAN_CAPABILITY_SHORT_PREAMBLE" redefined
>     #define WLAN_CAPABILITY_SHORT_PREAMBLE (1<<5)
>
>    In file included from include/net/cfg80211.h:23:0,
>                     from drivers/staging/rtl8723bs/include/osdep_service_linux.h:50,
>                     from drivers/staging/rtl8723bs/include/osdep_service.h:23,
>                     from drivers/staging/rtl8723bs/include/drv_types.h:29,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>    include/linux/ieee80211.h:1606:0: note: this is the location of the previous definition
>     #define WLAN_CAPABILITY_SHORT_PREAMBLE BIT(5)
>
>    In file included from drivers/staging/rtl8723bs/include/drv_types.h:33:0,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>>> drivers/staging/rtl8723bs/include/ieee80211.h:449:0: warning: "WLAN_CAPABILITY_PBCC" redefined
>     #define WLAN_CAPABILITY_PBCC (1<<6)
>
>    In file included from include/net/cfg80211.h:23:0,
>                     from drivers/staging/rtl8723bs/include/osdep_service_linux.h:50,
>                     from drivers/staging/rtl8723bs/include/osdep_service.h:23,
>                     from drivers/staging/rtl8723bs/include/drv_types.h:29,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>    include/linux/ieee80211.h:1607:0: note: this is the location of the previous definition
>     #define WLAN_CAPABILITY_PBCC  BIT(6)
>
>    In file included from drivers/staging/rtl8723bs/include/drv_types.h:33:0,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>>> drivers/staging/rtl8723bs/include/ieee80211.h:450:0: warning: "WLAN_CAPABILITY_CHANNEL_AGILITY" redefined
>     #define WLAN_CAPABILITY_CHANNEL_AGILITY (1<<7)
>
>    In file included from include/net/cfg80211.h:23:0,
>                     from drivers/staging/rtl8723bs/include/osdep_service_linux.h:50,
>                     from drivers/staging/rtl8723bs/include/osdep_service.h:23,
>                     from drivers/staging/rtl8723bs/include/drv_types.h:29,
>                     from drivers/staging/rtl8723bs/hal/rtl8723b_dm.c:20:
>    include/linux/ieee80211.h:1608:0: note: this is the location of the previous definition
>     #define WLAN_CAPABILITY_CHANNEL_AGILITY BIT(7)
>
>
> vim +/WLAN_CAPABILITY_IBSS +444 drivers/staging/rtl8723bs/include/ieee80211.h
>
> 554c0a3a Hans de Goede 2017-03-29  442
> 554c0a3a Hans de Goede 2017-03-29  443  #define WLAN_CAPABILITY_BSS (1<<0)
> 554c0a3a Hans de Goede 2017-03-29 @444  #define WLAN_CAPABILITY_IBSS (1<<1)
> 554c0a3a Hans de Goede 2017-03-29 @445  #define WLAN_CAPABILITY_CF_POLLABLE (1<<2)
> 554c0a3a Hans de Goede 2017-03-29 @446  #define WLAN_CAPABILITY_CF_POLL_REQUEST (1<<3)
> 554c0a3a Hans de Goede 2017-03-29 @447  #define WLAN_CAPABILITY_PRIVACY (1<<4)
> 554c0a3a Hans de Goede 2017-03-29 @448  #define WLAN_CAPABILITY_SHORT_PREAMBLE (1<<5)
> 554c0a3a Hans de Goede 2017-03-29 @449  #define WLAN_CAPABILITY_PBCC (1<<6)
> 554c0a3a Hans de Goede 2017-03-29 @450  #define WLAN_CAPABILITY_CHANNEL_AGILITY (1<<7)
> 554c0a3a Hans de Goede 2017-03-29  451  #define WLAN_CAPABILITY_SHORT_SLOT (1<<10)
> 554c0a3a Hans de Goede 2017-03-29  452
>
> :::::: The code at line 444 was first introduced by commit
> :::::: 554c0a3abf216c991c5ebddcdb2c08689ecd290b staging: Add rtl8723bs sdio wifi driver
>
> :::::: TO: Hans de Goede <hdegoede@redhat.com>
> :::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
