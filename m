Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:9707 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753762AbcKIUuZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 15:50:25 -0500
Date: Wed, 9 Nov 2016 21:50:23 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: c_traja@qti.qualcomm.com
cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        tamizhchelvam@codeaurora.org,
        Tamizh chelvam <c_traja@qti.qualcomm.com>, kbuild-all@01.org
Subject: Re: [PATCH 2/4] ath10k: Add support to update btcoex priority value
 via nl80211
In-Reply-To: <201611090629.9JO64IrN%fengguang.wu@intel.com>
Message-ID: <alpine.DEB.2.20.1611092149120.2206@hadrien> (sfid-20161109_215029_068882_D28A188B)
References: <201611090629.9JO64IrN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems possible that one might like to release the mutex lock before the
return on line 7556.

julia



On Wed, 9 Nov 2016, kbuild test robot wrote:

> Hi Tamizh,
>
> [auto build test WARNING on ath6kl/ath-next]
> [cannot apply to v4.9-rc4 next-20161108]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/c_traja-qti-qualcomm-com/ath10k-Add-support-for-BTCOEX-feature/20161109-043718
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
> :::::: branch date: 2 hours ago
> :::::: commit date: 2 hours ago
>
> >> drivers/net/wireless/ath/ath10k/mac.c:7556:2-8: preceding lock on line 7545
>
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 2fc922b27f111b9e8089a3e94a17ee827e769c55
> vim +7556 drivers/net/wireless/ath/ath10k/mac.c
>
> 2fc922b2 Tamizh chelvam 2016-11-08  7539
> 2fc922b2 Tamizh chelvam 2016-11-08  7540  	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags))) {
> 2fc922b2 Tamizh chelvam 2016-11-08  7541  		ret = -EINVAL;
> 2fc922b2 Tamizh chelvam 2016-11-08  7542  		goto exit;
> 2fc922b2 Tamizh chelvam 2016-11-08  7543  	}
> 2fc922b2 Tamizh chelvam 2016-11-08  7544
> 2fc922b2 Tamizh chelvam 2016-11-08 @7545  	mutex_lock(&ar->conf_mutex);
> 2fc922b2 Tamizh chelvam 2016-11-08  7546
> 2fc922b2 Tamizh chelvam 2016-11-08  7547  	if (ar->state != ATH10K_STATE_ON &&
> 2fc922b2 Tamizh chelvam 2016-11-08  7548  	    ar->state != ATH10K_STATE_RESTARTED) {
> 2fc922b2 Tamizh chelvam 2016-11-08  7549  		ret = -ENETDOWN;
> 2fc922b2 Tamizh chelvam 2016-11-08  7550  		goto exit;
> 2fc922b2 Tamizh chelvam 2016-11-08  7551  	}
> 2fc922b2 Tamizh chelvam 2016-11-08  7552
> 2fc922b2 Tamizh chelvam 2016-11-08  7553  	btcoex_prio = ath10k_mac_get_btcoex_prio(btcoex_priority);
> 2fc922b2 Tamizh chelvam 2016-11-08  7554
> 2fc922b2 Tamizh chelvam 2016-11-08  7555  	if (btcoex_prio > 0x3f)
> 2fc922b2 Tamizh chelvam 2016-11-08 @7556  		return -E2BIG;
> 2fc922b2 Tamizh chelvam 2016-11-08  7557
> 2fc922b2 Tamizh chelvam 2016-11-08  7558  	ret = ath10k_wmi_set_coex_param(ar, btcoex_prio);
> 2fc922b2 Tamizh chelvam 2016-11-08  7559
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
