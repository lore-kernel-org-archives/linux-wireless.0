Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45741 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbbCBKd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 05:33:29 -0500
Received: by wibbs8 with SMTP id bs8so13637792wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 02:33:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54F438C5.802@qti.qualcomm.com>
References: <1425030606-21933-1-git-send-email-vthiagar@qti.qualcomm.com>
	<1425030606-21933-2-git-send-email-vthiagar@qti.qualcomm.com>
	<CA+BoTQ=UFo=2Fa8FXw6JTGKkNLoG=m56py0a8AShyh3nTJ+TKQ@mail.gmail.com>
	<1425288686058.83668@qti.qualcomm.com>
	<54F438C5.802@qti.qualcomm.com>
Date: Mon, 2 Mar 2015 11:33:27 +0100
Message-ID: <CA+BoTQmLciCZ4dXbH4rO1vU32OQzNgF+cJT-tkFcOKvq00Ur1Q@mail.gmail.com> (sfid-20150302_113333_042693_ABCC1F76)
Subject: Re: [PATCH V3 2/2] ath10k: Fix interrupt storm
From: Michal Kazior <michal.kazior@tieto.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 March 2015 at 11:17, Vasanthakumar Thiagarajan
<vthiagar@qti.qualcomm.com> wrote:
[...]
>>> +{
>>> +       struct ath10k_vif *arvif;
>>> +
>>> +       if (!ar->num_started_vdevs)
>>> +               return false;
>>> +
>>> +       list_for_each_entry(arvif, &ar->arvifs, list) {
>>
>>
>> This means function must be called while holding conf_mutex (my MCC
>> patch adds data_lock as an option, but current upstream tree uses
>> conf_mutex only).
>
>
> Ok. Sure, we can fix it when we have MCC change into the tree.

No need. With the way ath10k_monitor_recalc() is called it makes sense
to rely on lockdep_assert_held(ar->conf_mutex) only.

The data_lock was just FYI.



>>> @@ -3476,6 +3504,13 @@ static void ath10k_configure_filter(struct
>>> ieee80211_hw *hw,
>>>
>>>          changed_flags &= SUPPORTED_FILTERS;
>>>          *total_flags &= SUPPORTED_FILTERS;
>>> +       if (*total_flags & FIF_PROMISC_IN_BSS) {
>>> +               if (ar->num_started_vdevs) {
>>> +                       ath10k_dbg(ar, ATH10K_DBG_MAC,
>>> +                                  "mac does not enable promiscuous mode
>>> when already a vdev is running\n");
>>> +                       *total_flags &= ~FIF_PROMISC_IN_BSS;
>>> +               }
>>> +       }
>>
>>
>> There's no need for that, is there? The monitor_recalc() is supposed
>> to deal with this.
>
>
> Right, but we may not want to create any inconsistencies between
> *total_flags and actual
> filters enabled in the driver?.

See the "DOC: Frame filtering" in include/net/mac80211.h. ath10k
either always delivers frames IN_BSS (AP operation) or can be forced
to (via monitor vdev for STA/IBSS operation) so FIF_PROMISC_IN_BSS
should never be cleared.


Michał
