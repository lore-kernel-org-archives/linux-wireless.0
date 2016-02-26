Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbcBZHRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 02:17:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>, kbuild-all@01.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: Re: [PATCH] mac80211_hwsim: Set global RRM capability
References: <201602251751.QT2WO50c%fengguang.wu@intel.com>
Date: Fri, 26 Feb 2016 09:17:15 +0200
In-Reply-To: <201602251751.QT2WO50c%fengguang.wu@intel.com> (kbuild test
	robot's message of "Thu, 25 Feb 2016 18:01:41 +0800")
Message-ID: <87y4a8lz44.fsf@purkki.adurom.net> (sfid-20160226_081724_038232_35D5DD0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi David,
>
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on v4.5-rc5 next-20160224]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Emmanuel-Grumbach/mac80211_hwsim-Set-global-RRM-capability/20160225-172733
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: sparc64-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=sparc64 
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/mac80211_hwsim.c: In function 'mac80211_hwsim_new_radio':
>>> drivers/net/wireless/mac80211_hwsim.c:2462:35: error: 'NL80211_EXT_FEATURE_RRM' undeclared (first use in this function)
>      wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_RRM);
>                                       ^
>    drivers/net/wireless/mac80211_hwsim.c:2462:35: note: each undeclared identifier is reported only once for each function it appears in

I think this build failure is because mac80211_hwsim is an exception to
other wireless drivers and is applied via mac80211-next. Should we add
an entry for mac80211_hwsim to MAINTAINERS with the correct git tree? I
think kbuild test robot follows MAINTAINERS file nowdays (or at least I
understood that's the plan).

-- 
Kalle Valo
