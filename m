Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934279AbeFMJ4I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 05:56:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: Niklas Cassel <niklas.cassel@linaro.org>, kbuild-all@01.org,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
References: <20180612113907.15043-2-niklas.cassel@linaro.org>
        <201806122228.8vAQXcD6%fengguang.wu@intel.com>
Date: Wed, 13 Jun 2018 12:56:02 +0300
In-Reply-To: <201806122228.8vAQXcD6%fengguang.wu@intel.com> (kbuild test
        robot's message of "Tue, 12 Jun 2018 22:50:37 +0800")
Message-ID: <87h8m7au31.fsf@kamboji.qca.qualcomm.com> (sfid-20180613_115625_603495_7CD67EB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on ath6kl/ath-next]
> [also build test WARNING on next-20180612]
> [cannot apply to v4.17]
> [if your patch is applied to the wrong git tree, please drop us a note
> to help improve the system]
>
> url:
> https://github.com/0day-ci/linux/commits/Niklas-Cassel/ath10k-do-not-mix-spaces-and-tabs-in-Kconfig/20180612-194241
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> drivers/net/wireless/ath/ath10k/snoc.c:823:5: sparse: symbol
>>> 'ath10k_snoc_get_ce_id_from_irq' was not declared. Should it be
>>> static?
>>> drivers/net/wireless/ath/ath10k/snoc.c:871:6: sparse: symbol
>>> 'ath10k_snoc_init_napi' was not declared. Should it be static?
>
> Please review and possibly fold the followup patch.

There's already a patch pending to fix these:

ath10k: make some functions static

https://patchwork.kernel.org/patch/10440159/

-- 
Kalle Valo
