Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36942 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932132AbcKQRyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:54:36 -0500
Received: by mail-wm0-f42.google.com with SMTP id t79so160952391wmt.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2016 09:54:35 -0800 (PST)
Subject: Re: [PATCH 1/2] cfg80211: get rid of name indirection trick for
 ieee80211_get_channel()
To: kbuild test robot <lkp@intel.com>
References: <201611172039.TxaaQE2O%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c1c3e6e1-cb48-314e-021c-f1579c168ad9@broadcom.com> (sfid-20161117_185442_306479_09A3CF2D)
Date: Thu, 17 Nov 2016 13:38:46 +0100
MIME-Version: 1.0
In-Reply-To: <201611172039.TxaaQE2O%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-11-2016 13:32, kbuild test robot wrote:
> Hi Arend,
> 
> [auto build test ERROR on mac80211-next/master]
> [also build test ERROR on v4.9-rc5 next-20161117]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Arend-van-Spriel/cfg80211-get-rid-of-name-indirection-trick-for-ieee80211_get_channel/20161117-175449
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 

Ah. Two drivers that are not fooled by the indirection. Will create a V2.

Regards,
Arend

> All error/warnings (new ones prefixed by >>):
> 
>    drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_t2h_msg_handler':
>>> drivers/net/wireless/ath/ath10k/htt_rx.c:2333:4: error: implicit declaration of function '__ieee80211_get_channel' [-Werror=implicit-function-declaration]
>        __ieee80211_get_channel(ar->hw->wiphy, freq);
>        ^~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/wireless/ath/ath10k/htt_rx.c:2332:21: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>       ar->tgt_oper_chan =
>                         ^
>    cc1: some warnings being treated as errors
> 
> vim +/__ieee80211_get_channel +2333 drivers/net/wireless/ath/ath10k/htt_rx.c
> 
> c545070e Michal Kazior      2015-01-24  2326  	case HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND:
> 8348db29 Rajkumar Manoharan 2015-03-25  2327  		break;
> 2ce9b25c Rajkumar Manoharan 2016-03-08  2328  	case HTT_T2H_MSG_TYPE_CHAN_CHANGE: {
> 2ce9b25c Rajkumar Manoharan 2016-03-08  2329  		u32 phymode = __le32_to_cpu(resp->chan_change.phymode);
> 2ce9b25c Rajkumar Manoharan 2016-03-08  2330  		u32 freq = __le32_to_cpu(resp->chan_change.freq);
> 2ce9b25c Rajkumar Manoharan 2016-03-08  2331  
> 2ce9b25c Rajkumar Manoharan 2016-03-08 @2332  		ar->tgt_oper_chan =
> 2ce9b25c Rajkumar Manoharan 2016-03-08 @2333  			__ieee80211_get_channel(ar->hw->wiphy, freq);
> 2ce9b25c Rajkumar Manoharan 2016-03-08  2334  		ath10k_dbg(ar, ATH10K_DBG_HTT,
> 2ce9b25c Rajkumar Manoharan 2016-03-08  2335  			   "htt chan change freq %u phymode %s\n",
> 2ce9b25c Rajkumar Manoharan 2016-03-08  2336  			   freq, ath10k_wmi_phymode_str(phymode));
> 
> :::::: The code at line 2333 was first introduced by commit
> :::::: 2ce9b25cefa64f11bcb21b21cf4a5e8c58c6d0af ath10k: handle channel change htt event
> 
> :::::: TO: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> :::::: CC: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
