Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39134 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbCBLHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 06:07:12 -0500
Message-ID: <54F44353.1090907@qti.qualcomm.com> (sfid-20150302_120717_466562_842B63AA)
Date: Mon, 2 Mar 2015 16:32:43 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH V3 2/2] ath10k: Fix interrupt storm
References: <1425030606-21933-1-git-send-email-vthiagar@qti.qualcomm.com>	<1425030606-21933-2-git-send-email-vthiagar@qti.qualcomm.com>	<CA+BoTQ=UFo=2Fa8FXw6JTGKkNLoG=m56py0a8AShyh3nTJ+TKQ@mail.gmail.com>	<1425288686058.83668@qti.qualcomm.com>	<54F438C5.802@qti.qualcomm.com> <CA+BoTQmLciCZ4dXbH4rO1vU32OQzNgF+cJT-tkFcOKvq00Ur1Q@mail.gmail.com>
In-Reply-To: <CA+BoTQmLciCZ4dXbH4rO1vU32OQzNgF+cJT-tkFcOKvq00Ur1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>
>>>> @@ -3476,6 +3504,13 @@ static void ath10k_configure_filter(struct
>>>> ieee80211_hw *hw,
>>>>
>>>>           changed_flags &= SUPPORTED_FILTERS;
>>>>           *total_flags &= SUPPORTED_FILTERS;
>>>> +       if (*total_flags & FIF_PROMISC_IN_BSS) {
>>>> +               if (ar->num_started_vdevs) {
>>>> +                       ath10k_dbg(ar, ATH10K_DBG_MAC,
>>>> +                                  "mac does not enable promiscuous mode
>>>> when already a vdev is running\n");
>>>> +                       *total_flags &= ~FIF_PROMISC_IN_BSS;
>>>> +               }
>>>> +       }
>>>
>>>
>>> There's no need for that, is there? The monitor_recalc() is supposed
>>> to deal with this.
>>
>>
>> Right, but we may not want to create any inconsistencies between
>> *total_flags and actual
>> filters enabled in the driver?.
>
> See the "DOC: Frame filtering" in include/net/mac80211.h. ath10k
> either always delivers frames IN_BSS (AP operation) or can be forced
> to (via monitor vdev for STA/IBSS operation) so FIF_PROMISC_IN_BSS
> should never be cleared.

Your are right. We should not be clearing that flag as long as we support
that functionality in one or other way. Thanks.

Vasanth
