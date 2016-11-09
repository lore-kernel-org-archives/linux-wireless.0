Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932214AbcKIKpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 05:45:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 09 Nov 2016 16:15:16 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: c_traja@qti.qualcomm.com, kbuild-all@01.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] ath10k: Add support to enable or disable btcoex via
 nl80211
In-Reply-To: <201611090758.VuakpqyK%fengguang.wu@intel.com>
References: <201611090758.VuakpqyK%fengguang.wu@intel.com>
Message-ID: <66e8e99f749485f8e0dc6ea0d07dd777@codeaurora.org> (sfid-20161109_114544_949785_B99B06D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-11-09 04:50, kbuild test robot wrote:
> Hi Tamizh,
> 
> [auto build test WARNING on ath6kl/ath-next]
> [also build test WARNING on v4.9-rc4 next-20161108]
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
> All warnings (new ones prefixed by >>):
> 
>    drivers/net/wireless/ath/ath10k/mac.c:7548:2: error: unknown field
> 'set_btcoex' specified in initializer
>      .set_btcoex                     = ath10k_mac_op_set_btcoex,
>      ^
>>> drivers/net/wireless/ath/ath10k/mac.c:7548:2: warning: initialization 
>>> from incompatible pointer type
>    drivers/net/wireless/ath/ath10k/mac.c:7548:2: warning: (near
> initialization for 'ath10k_ops.reconfig_complete')

This patch has dependency of "cfg80211: mac80211: BTCOEX feature 
support" patchset.
> 
> vim +7548 drivers/net/wireless/ath/ath10k/mac.c
> 
>   7532		.reconfig_complete		= ath10k_reconfig_complete,
>   7533		.get_survey			= ath10k_get_survey,
>   7534		.set_bitrate_mask		= ath10k_mac_op_set_bitrate_mask,
>   7535		.sta_rc_update			= ath10k_sta_rc_update,
>   7536		.get_tsf			= ath10k_get_tsf,
>   7537		.set_tsf			= ath10k_set_tsf,
>   7538		.ampdu_action			= ath10k_ampdu_action,
>   7539		.get_et_sset_count		= ath10k_debug_get_et_sset_count,
>   7540		.get_et_stats			= ath10k_debug_get_et_stats,
>   7541		.get_et_strings			= ath10k_debug_get_et_strings,
>   7542		.add_chanctx			= ath10k_mac_op_add_chanctx,
>   7543		.remove_chanctx			= ath10k_mac_op_remove_chanctx,
>   7544		.change_chanctx			= ath10k_mac_op_change_chanctx,
>   7545		.assign_vif_chanctx		= ath10k_mac_op_assign_vif_chanctx,
>   7546		.unassign_vif_chanctx		= ath10k_mac_op_unassign_vif_chanctx,
>   7547		.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
>> 7548		.set_btcoex                     = ath10k_mac_op_set_btcoex,
>   7549
>   7550		CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
>   7551
>   7552	#ifdef CONFIG_PM
>   7553		.suspend			= ath10k_wow_op_suspend,
>   7554		.resume				= ath10k_wow_op_resume,
>   7555	#endif
>   7556	#ifdef CONFIG_MAC80211_DEBUGFS
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology 
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel 
> Corporation
