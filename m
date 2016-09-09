Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65061 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbcIIM1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:27:39 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: kbuild test robot <lkp@intel.com>
CC: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH] ath10k: advertize hardware packet loss mechanism
Date: Fri, 9 Sep 2016 12:27:29 +0000
Message-ID: <871t0tqmvj.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_142742_835064_4BB8B102)
References: <201609061655.E4ZdBCGt%fengguang.wu@intel.com>
In-Reply-To: <201609061655.E4ZdBCGt%fengguang.wu@intel.com> (kbuild test
        robot's message of "Tue, 6 Sep 2016 16:18:28 +0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi Rajkumar,
>
> [auto build test ERROR on ath6kl/ath-next]
> [also build test ERROR on v4.8-rc5 next-20160906]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
> [Suggest to use git(>=3D2.9.0) format-patch --base=3D<commit> (or --base=
=3Dauto for convenience) to record what (public, well-known) commit your pa=
tch series was built on]
> [Check https://git-scm.com/docs/git-format-patch for more information]
>
> url:    https://github.com/0day-ci/linux/commits/Rajkumar-Manoharan/ath10=
k-advertize-hardware-packet-loss-mechanism/20160906-151148
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath=
-next
> config: i386-randconfig-x008-201636 (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Di386=20
>
> All error/warnings (new ones prefixed by >>):
>
>    In file included from drivers/net/wireless/ath/ath10k/mac.h:21:0,
>                     from drivers/net/wireless/ath/ath10k/mac.c:18:
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_mac_registe=
r':
>>> include/net/mac80211.h:2206:57: error: 'IEEE80211_HW_REPORTS_LOW_ACK' u=
ndeclared (first use in this function)
>     #define ieee80211_hw_set(hw, flg) _ieee80211_hw_set(hw, IEEE80211_HW_=
##flg)
>                                                             ^
>>> drivers/net/wireless/ath/ath10k/mac.c:7884:2: note: in expansion of mac=
ro 'ieee80211_hw_set'
>      ieee80211_hw_set(ar->hw, REPORTS_LOW_ACK);
>      ^~~~~~~~~~~~~~~~
>    include/net/mac80211.h:2206:57: note: each undeclared identifier is re=
ported only once for each function it appears in
>     #define ieee80211_hw_set(hw, flg) _ieee80211_hw_set(hw, IEEE80211_HW_=
##flg)
>                                                             ^
>>> drivers/net/wireless/ath/ath10k/mac.c:7884:2: note: in expansion of mac=
ro 'ieee80211_hw_set'
>      ieee80211_hw_set(ar->hw, REPORTS_LOW_ACK);
>      ^~~~~~~~~~~~~~~~

This is expected as this depends on a mac80211 patch which is not
applied yet.

--=20
Kalle Valo=
