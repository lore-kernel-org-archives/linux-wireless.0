Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:47059 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3JUGwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 02:52:55 -0400
Received: by mail-we0-f172.google.com with SMTP id q58so6156439wes.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Oct 2013 23:52:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mwm3uoep.fsf@kamboji.qca.qualcomm.com>
References: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com>
	<87mwm3uoep.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 21 Oct 2013 08:52:54 +0200
Message-ID: <CACKGw+GgYwu-oQ12LjPm3FLKQ5PDG+KUVgoEM=KGH8q+SWvmBQ@mail.gmail.com> (sfid-20131021_085259_133422_29B68A21)
Subject: Re: [PATCH 1/2] ath10k: remove P2P from supported interface modes for
 10.X FW
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2013 08:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> FW 10.X does not support P2P, stop advertising it to mac80211.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> [...]
>
>> @@ -3478,7 +3504,11 @@ int ath10k_mac_register(struct ath10k *ar)
>>        */
>>       ar->hw->queues = 4;
>>
>> -     ar->hw->wiphy->iface_combinations = &ath10k_if_comb;
>> +     if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
>> +             ar->hw->wiphy->iface_combinations = &ath10k_10x_if_comb;
>> +     else
>> +             ar->hw->wiphy->iface_combinations = &ath10k_if_comb;
>
> I think it would be better to have a separate feature flag for this,
> like NO_P2P or something like that. Just in case we want to disable P2P
> in other firmware branches.

Make sense. I will change this.


-- 
Bartosz
