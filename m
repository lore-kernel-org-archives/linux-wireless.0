Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934035AbeEIIrP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 04:47:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Maya Erez <merez@codeaurora.org>
Subject: Re: [mac80211-next:master 12/14] drivers/net//wireless/ath/wil6210/debugfs.c:1245:1: warning: the frame size of 1600 bytes is larger than 1024 bytes
References: <201805090154.h4Cokbx2%fengguang.wu@intel.com>
Date: Wed, 09 May 2018 11:47:11 +0300
In-Reply-To: <201805090154.h4Cokbx2%fengguang.wu@intel.com> (kbuild test
        robot's message of "Wed, 9 May 2018 01:39:57 +0800")
Message-ID: <87efil2p2o.fsf@purkki.adurom.net> (sfid-20180509_104722_363915_8DC71EC9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding Maya)

kbuild test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> head:   57c6cb81717f957fb741f2e4c79bd0e2f4f55910
> commit: 52539ca89f365d3db530535fbffa88a3cca4d2ec [12/14] cfg80211: Expose TXQ stats and parameters to userspace
> config: i386-randconfig-i1-201818 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>         git checkout 52539ca89f365d3db530535fbffa88a3cca4d2ec
>         # save the attached .config to linux build tree
>         make ARCH=i386 
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net//wireless/ath/wil6210/debugfs.c: In function 'wil_link_debugfs_show':
>>> drivers/net//wireless/ath/wil6210/debugfs.c:1245:1: warning: the frame size of 1600 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>     }
>     ^
> --
>    drivers/net//wireless/ath/wil6210/wmi.c: In function 'wmi_evt_connect':
>>> drivers/net//wireless/ath/wil6210/wmi.c:979:1: warning: the frame size of 1684 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>     }
>     ^
> --
>    drivers/net//wireless/quantenna/qtnfmac/event.c: In function 'qtnf_event_handle_sta_assoc':
>>> drivers/net//wireless/quantenna/qtnfmac/event.c:107:1: warning: the frame size of 1616 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>     }
>     ^

I guess these warnings come because Toke's patch increased size of
struct cfg80211_tid_stats (which is included in struct station_info) and
both wil6210 and qtnfmac allocate a struct station_info from stack? Can
someone send a fix for the drivers?

-- 
Kalle Valo
