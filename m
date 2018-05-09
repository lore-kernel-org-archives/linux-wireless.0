Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934407AbeEII4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 04:56:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kbuild test robot <lkp@intel.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J?= =?utf-8?Q?=C3=B8rgensen?=
        <toke@toke.dk>, kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Maya Erez <merez@codeaurora.org>
Subject: Re: [mac80211-next:master 12/14] drivers/net//wireless/ath/wil6210/debugfs.c:1245:1: warning: the frame size of 1600 bytes is larger than 1024 bytes
References: <201805090154.h4Cokbx2%fengguang.wu@intel.com>
        <87efil2p2o.fsf@purkki.adurom.net>
        <1525855900.6910.5.camel@sipsolutions.net>
Date: Wed, 09 May 2018 11:56:28 +0300
In-Reply-To: <1525855900.6910.5.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 09 May 2018 10:51:40 +0200")
Message-ID: <87tvrhw6kj.fsf@kamboji.qca.qualcomm.com> (sfid-20180509_105646_025081_85BA7E15)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-05-09 at 11:47 +0300, Kalle Valo wrote:
>> 
>> I guess these warnings come because Toke's patch increased size of
>> struct cfg80211_tid_stats (which is included in struct station_info) and
>> both wil6210 and qtnfmac allocate a struct station_info from stack? 
>
> Yes.
>
>> Can
>> someone send a fix for the drivers?
>
> I guess Toke/I should do that through my tree.

IMHO the fix could go through my tree as well, less risk of conflicts in
drivers. AFAICS the fix (allocating station_info dynamically?) would not
depend on Toke's patch and could be applied separately.

-- 
Kalle Valo
