Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36826 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754459AbcKQO0x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 09:26:53 -0500
Received: by mail-wm0-f49.google.com with SMTP id g23so314269438wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2016 06:26:52 -0800 (PST)
Subject: Re: [PATCH 3/5] nl80211: add support for gscan
To: Johannes Berg <johannes@sipsolutions.net>
References: <201611172006.xRJ9na1r%fengguang.wu@intel.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <014498fc-8f54-c07e-da5c-8dae0e577a7b@broadcom.com> (sfid-20161117_152818_249421_CA77E64F)
Date: Thu, 17 Nov 2016 13:40:42 +0100
MIME-Version: 1.0
In-Reply-To: <201611172006.xRJ9na1r%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-11-2016 13:10, kbuild test robot wrote:
> Hi Arend,
> 
> [auto build test ERROR on mac80211-next/master]
> [also build test ERROR on next-20161117]
> [cannot apply to v4.9-rc5]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Arend-van-Spriel/nl80211-add-support-for-g-scan/20161117-194818
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> config: i386-randconfig-x004-201646 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 

Shuffled the patches while rebasing. Not nice. Will fix it.

Regards,
Arend

> Note: the linux-review/Arend-van-Spriel/nl80211-add-support-for-g-scan/20161117-194818 HEAD 407f604bb543a049c99ae0f9974943f1c64ea880 builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    net/wireless/scan.c: In function '__cfg80211_stop_gscan':
>>> net/wireless/scan.c:358:2: error: implicit declaration of function 'nl80211_send_scan_event' [-Werror=implicit-function-declaration]
>      nl80211_send_scan_event(rdev, dev, NL80211_CMD_GSCAN_STOPPED);
>      ^~~~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> --
>    net/wireless/nl80211.c: In function 'nl80211_start_gscan':
>>> net/wireless/nl80211.c:12167:2: error: implicit declaration of function 'nl80211_send_scan_event' [-Werror=implicit-function-declaration]
>      nl80211_send_scan_event(rdev, dev,
>      ^~~~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/nl80211_send_scan_event +358 net/wireless/scan.c
> 
>    352		if (!driver_initiated) {
>    353			int err = rdev_stop_gscan(rdev, dev);
>    354			if (err)
>    355				return err;
>    356		}
>    357	
>  > 358		nl80211_send_scan_event(rdev, dev, NL80211_CMD_GSCAN_STOPPED);
>    359	
>    360		RCU_INIT_POINTER(rdev->gscan_req, NULL);
>    361		kfree_rcu(gscan_req, rcu_head);
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
