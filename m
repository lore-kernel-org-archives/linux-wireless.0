Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753283AbcKIKqT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 05:46:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 09 Nov 2016 16:16:18 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: c_traja@qti.qualcomm.com, kbuild-all@01.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] ath10k: Add support to update btcoex priority value
 via nl80211
In-Reply-To: <201611090753.f8QniYub%fengguang.wu@intel.com>
References: <201611090753.f8QniYub%fengguang.wu@intel.com>
Message-ID: <0ca51f681fad7bc3129a3929646adc7a@codeaurora.org> (sfid-20161109_114708_150051_7D8A6AEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-11-09 05:19, kbuild test robot wrote:
> Hi Tamizh,
> 
> [auto build test ERROR on ath6kl/ath-next]
> [cannot apply to v4.9-rc4 next-20161108]
> [if your patch is applied to the wrong git tree, please drop us a note
> to help improve the system]
> 
> url:
> https://github.com/0day-ci/linux/commits/c_traja-qti-qualcomm-com/ath10k-Add-support-for-BTCOEX-feature/20161109-043718
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git 
> ath-next
> config: xtensa-allmodconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget
> https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross
> -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa
> 
> All error/warnings (new ones prefixed by >>):
> 
>>> drivers/net/wireless/ath/ath10k/mac.c:7508:35: warning: 'struct 
>>> cfg80211_btcoex_priority' declared inside parameter list
>     ath10k_mac_get_btcoex_prio(struct cfg80211_btcoex_priority 
> *btcoex_priority)
>                                       ^
>>> drivers/net/wireless/ath/ath10k/mac.c:7508:35: warning: its scope is 
>>> only this definition or declaration, which is probably not what you 
>>> want
>    drivers/net/wireless/ath/ath10k/mac.c: In function
> 'ath10k_mac_get_btcoex_prio':
>>> drivers/net/wireless/ath/ath10k/mac.c:7512:21: error: dereferencing 
>>> pointer to incomplete type
>      if (btcoex_priority->wlan_be_preferred)
>                         ^
>    drivers/net/wireless/ath/ath10k/mac.c:7513:18: error:
> 'WIPHY_WLAN_BE_PREFERRED' undeclared (first use in this function)
>       btcoex_prio |= WIPHY_WLAN_BE_PREFERRED;
>                      ^
>    drivers/net/wireless/ath/ath10k/mac.c:7513:18: note: each
> undeclared identifier is reported only once for each function it
> appears in
>    drivers/net/wireless/ath/ath10k/mac.c:7515:21: error: dereferencing
> pointer to incomplete type
>      if (btcoex_priority->wlan_bk_preferred)
>                         ^
>    drivers/net/wireless/ath/ath10k/mac.c:7516:18: error:
> 'WIPHY_WLAN_BK_PREFERRED' undeclared (first use in this function)
>       btcoex_prio |= WIPHY_WLAN_BK_PREFERRED;
>                      ^
>    drivers/net/wireless/ath/ath10k/mac.c:7518:21: error: dereferencing
> pointer to incomplete type
>      if (btcoex_priority->wlan_vi_preferred)
>                         ^
>    drivers/net/wireless/ath/ath10k/mac.c:7519:18: error:
> 'WIPHY_WLAN_VI_PREFERRED' undeclared (first use in this function)
>       btcoex_prio |= WIPHY_WLAN_VI_PREFERRED;
>                      ^
>    drivers/net/wireless/ath/ath10k/mac.c:7521:21: error: dereferencing
> pointer to incomplete type
>      if (btcoex_priority->wlan_vo_preferred)
>                         ^
>    drivers/net/wireless/ath/ath10k/mac.c:7522:18: error:
> 'WIPHY_WLAN_VO_PREFERRED' undeclared (first use in this function)
>       btcoex_prio |= WIPHY_WLAN_VO_PREFERRED;
>                      ^
>    drivers/net/wireless/ath/ath10k/mac.c:7524:21: error: dereferencing
> pointer to incomplete type
>      if (btcoex_priority->wlan_beacon_preferred)
>                         ^
>    drivers/net/wireless/ath/ath10k/mac.c:7525:18: error:
> 'WIPHY_WLAN_BEACON_PREFERRED' undeclared (first use in this function)
>       btcoex_prio |= WIPHY_WLAN_BEACON_PREFERRED;
>                      ^
>    drivers/net/wireless/ath/ath10k/mac.c:7527:21: error: dereferencing
> pointer to incomplete type
>      if (btcoex_priority->wlan_mgmt_preferred)
>                         ^
>    drivers/net/wireless/ath/ath10k/mac.c:7528:18: error:
> 'WIPHY_WLAN_MGMT_PREFERRED' undeclared (first use in this function)
>       btcoex_prio |= WIPHY_WLAN_MGMT_PREFERRED;
>                      ^
>    drivers/net/wireless/ath/ath10k/mac.c: At top level:
>    drivers/net/wireless/ath/ath10k/mac.c:7534:11: warning: 'struct
> cfg80211_btcoex_priority' declared inside parameter list
>        struct cfg80211_btcoex_priority *btcoex_priority)
>               ^
>    drivers/net/wireless/ath/ath10k/mac.c: In function
> 'ath10k_mac_op_set_btcoex_priority':
>>> drivers/net/wireless/ath/ath10k/mac.c:7553:16: warning: passing 
>>> argument 1 of 'ath10k_mac_get_btcoex_prio' from incompatible pointer 
>>> type
>      btcoex_prio = ath10k_mac_get_btcoex_prio(btcoex_priority);
>                    ^
>    drivers/net/wireless/ath/ath10k/mac.c:7508:1: note: expected
> 'struct cfg80211_btcoex_priority *' but argument is of type 'struct
> cfg80211_btcoex_priority *'
>     ath10k_mac_get_btcoex_prio(struct cfg80211_btcoex_priority 
> *btcoex_priority)
>     ^
>    drivers/net/wireless/ath/ath10k/mac.c: At top level:
>    drivers/net/wireless/ath/ath10k/mac.c:7611:2: error: unknown field
> 'set_btcoex' specified in initializer
>      .set_btcoex                     = ath10k_mac_op_set_btcoex,
>      ^
>    drivers/net/wireless/ath/ath10k/mac.c:7611:2: warning:
> initialization from incompatible pointer type
>    drivers/net/wireless/ath/ath10k/mac.c:7611:2: warning: (near
> initialization for 'ath10k_ops.reconfig_complete')
>    drivers/net/wireless/ath/ath10k/mac.c:7612:2: error: unknown field
> 'set_btcoex_priority' specified in initializer
>      .set_btcoex_priority  = ath10k_mac_op_set_btcoex_priority,
>      ^
>    drivers/net/wireless/ath/ath10k/mac.c:7612:2: warning:
> initialization from incompatible pointer type
>    drivers/net/wireless/ath/ath10k/mac.c:7612:2: warning: (near
> initialization for 'ath10k_ops.ipv6_addr_change')
>    drivers/net/wireless/ath/ath10k/mac.c: In function 
> 'ath10k_mac_register':
>    drivers/net/wireless/ath/ath10k/mac.c:8203:16: error: 'struct
> wiphy' has no member named 'btcoex_support_flags'
>       ar->hw->wiphy->btcoex_support_flags =
>                    ^
>    drivers/net/wireless/ath/ath10k/mac.c:8204:4: error:
> 'WIPHY_WLAN_BE_PREFERRED' undeclared (first use in this function)
>        WIPHY_WLAN_BE_PREFERRED |
>        ^
>    drivers/net/wireless/ath/ath10k/mac.c:8205:4: error:
> 'WIPHY_WLAN_BK_PREFERRED' undeclared (first use in this function)
>        WIPHY_WLAN_BK_PREFERRED |
>        ^
>    drivers/net/wireless/ath/ath10k/mac.c:8206:4: error:
> 'WIPHY_WLAN_VI_PREFERRED' undeclared (first use in this function)
>        WIPHY_WLAN_VI_PREFERRED |
>        ^
>    drivers/net/wireless/ath/ath10k/mac.c:8207:4: error:
> 'WIPHY_WLAN_VO_PREFERRED' undeclared (first use in this function)
>        WIPHY_WLAN_VO_PREFERRED |
>        ^
>    drivers/net/wireless/ath/ath10k/mac.c:8208:4: error:
> 'WIPHY_WLAN_BEACON_PREFERRED' undeclared (first use in this function)
>        WIPHY_WLAN_BEACON_PREFERRED |
>        ^
>    drivers/net/wireless/ath/ath10k/mac.c:8209:4: error:
> 'WIPHY_WLAN_MGMT_PREFERRED' undeclared (first use in this function)
>        WIPHY_WLAN_MGMT_PREFERRED;
>        ^
>    drivers/net/wireless/ath/ath10k/mac.c:8211:20: error: 'struct
> wiphy' has no member named 'btcoex_support_flags'
>           ar->hw->wiphy->btcoex_support_flags);
>                        ^
> 
This patch has dependency of "cfg80211: mac80211: BTCOEX feature 
support" patchset.

> vim +7512 drivers/net/wireless/ath/ath10k/mac.c
> 
>   7502		mutex_unlock(&ar->conf_mutex);
>   7503
>   7504		return ret;
>   7505	}
>   7506
>   7507	u32
>> 7508	ath10k_mac_get_btcoex_prio(struct cfg80211_btcoex_priority 
>> *btcoex_priority)
>   7509	{
>   7510		u32 btcoex_prio = 0;
>   7511
>> 7512		if (btcoex_priority->wlan_be_preferred)
>   7513			btcoex_prio |= WIPHY_WLAN_BE_PREFERRED;
>   7514
>   7515		if (btcoex_priority->wlan_bk_preferred)
>   7516			btcoex_prio |= WIPHY_WLAN_BK_PREFERRED;
>   7517
>   7518		if (btcoex_priority->wlan_vi_preferred)
>   7519			btcoex_prio |= WIPHY_WLAN_VI_PREFERRED;
>   7520
>   7521		if (btcoex_priority->wlan_vo_preferred)
>   7522			btcoex_prio |= WIPHY_WLAN_VO_PREFERRED;
>   7523
>   7524		if (btcoex_priority->wlan_beacon_preferred)
>   7525			btcoex_prio |= WIPHY_WLAN_BEACON_PREFERRED;
>   7526
>   7527		if (btcoex_priority->wlan_mgmt_preferred)
>> 7528			btcoex_prio |= WIPHY_WLAN_MGMT_PREFERRED;
>   7529
>   7530		return btcoex_prio;
>   7531	}
>   7532
>   7533	static int ath10k_mac_op_set_btcoex_priority(struct ieee80211_hw 
> *hw,
>   7534				struct cfg80211_btcoex_priority *btcoex_priority)
>   7535	{
>   7536		u32 btcoex_prio;
>   7537		struct ath10k *ar = hw->priv;
>   7538		int ret;
>   7539
>   7540		if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags))) {
>   7541			ret = -EINVAL;
>   7542			goto exit;
>   7543		}
>   7544
>   7545		mutex_lock(&ar->conf_mutex);
>   7546
>   7547		if (ar->state != ATH10K_STATE_ON &&
>   7548		    ar->state != ATH10K_STATE_RESTARTED) {
>   7549			ret = -ENETDOWN;
>   7550			goto exit;
>   7551		}
>   7552
>> 7553		btcoex_prio = ath10k_mac_get_btcoex_prio(btcoex_priority);
>   7554
>   7555		if (btcoex_prio > 0x3f)
>   7556			return -E2BIG;
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology 
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel 
> Corporation
