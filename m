Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62455 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaEOGEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 02:04:30 -0400
Received: by mail-wi0-f178.google.com with SMTP id hm4so3565347wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 23:04:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d2fgcf6v.fsf@kamboji.qca.qualcomm.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1399637749-13489-5-git-send-email-michal.kazior@tieto.com>
	<87d2fgcf6v.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 15 May 2014 08:04:29 +0200
Message-ID: <CA+BoTQngH43cXSikG+nPe5MozP4gTcbiHdx_gp7s4u=Fmc+AGQ@mail.gmail.com> (sfid-20140515_080434_047398_03B79CAE)
Subject: Re: [PATCH 4/5] ath10k: protect wep tx key setup
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 May 2014 21:50, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> All configuration sequences should be protected
>> with conf_mutex to avoid concurrent/conflicting
>> requests.
>>
>> This should make sure that wep tx key setup is not
>> performed while hw is restarted (at least).
>
> Locks and mutexes should protect data, not thread of execution. What are
> we exactly protecting here, arvif->def_wep_key_idx?

Actually conf_mutex idea is to protect and serialize configuration
sequences (WMI) too, not just data. Perhaps we should revise this?


> The patch makes sense, I'm just trying to understand the idea behind the
> implementation.
>
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -1888,8 +1888,10 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
>>                                               wep_key_work);
>>       int ret, keyidx = arvif->def_wep_key_newidx;
>>
>> +     mutex_lock(&arvif->ar->conf_mutex);
>> +
>>       if (arvif->def_wep_key_idx == keyidx)
>> -             return;
>> +             goto unlock;
>
> BTW, shouldn't we also check the state and bail out if the state is not
> ON (and possibly RESTARTED)? How can this work otherwise?

Very good point!

But actually.. this should be cancelled during recovery in the first
place. I need to take a look at it.


Michał
