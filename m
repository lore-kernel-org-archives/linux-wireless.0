Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45798 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbcFPOIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 10:08:20 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: kbuild test robot <lkp@intel.com>
CC: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>,
	"arnagara@codeaurora.org" <arnagara@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kbuild-all@01.org" <kbuild-all@01.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: add support for controlling tx power to a station
Date: Thu, 16 Jun 2016 14:08:13 +0000
Message-ID: <87fusdw7jn.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_160831_306697_F64909C6)
References: <201606150220.30TL93eZ%fengguang.wu@intel.com>
In-Reply-To: <201606150220.30TL93eZ%fengguang.wu@intel.com> (kbuild test
	robot's message of "Wed, 15 Jun 2016 02:29:54 +0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> [auto build test ERROR on ath6kl/ath-next]
> [also build test ERROR on v4.7-rc3 next-20160614]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Ashok-Raj-Nagarajan/ath10k-add-support-for-controlling-tx-power-to-a-station/20160615-014225
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_sta_set_txpwr':
>>> drivers/net/wireless/ath/ath10k/mac.c:5836:13: error: 'struct ieee80211_sta' has no member named 'txpwr'
>      txpwr = sta->txpwr;
>                 ^~
>    drivers/net/wireless/ath/ath10k/mac.c: At top level:
>>> drivers/net/wireless/ath/ath10k/mac.c:7399:2: error: unknown field 'sta_set_txpwr' specified in initializer
>      .sta_set_txpwr   = ath10k_sta_set_txpwr,
>      ^
>>> drivers/net/wireless/ath/ath10k/mac.c:7399:21: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
>      .sta_set_txpwr   = ath10k_sta_set_txpwr,
>                         ^~~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/ath/ath10k/mac.c:7399:21: note: (near initialization for 'ath10k_ops.sta_pre_rcu_remove')
>    cc1: some warnings being treated as errors

These errors are expected as this depends on a mac80211 patch which is
not yet applied.

-- 
Kalle Valo