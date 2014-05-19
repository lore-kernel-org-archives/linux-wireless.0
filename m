Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42787 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaESGRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 02:17:05 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so3540322wiw.4
        for <linux-wireless@vger.kernel.org>; Sun, 18 May 2014 23:17:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fvkb89f5.fsf@kamboji.qca.qualcomm.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
	<1399638957-20449-5-git-send-email-michal.kazior@tieto.com>
	<87fvkb89f5.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 19 May 2014 08:17:04 +0200
Message-ID: <CA+BoTQkTiiSeiDfJku-jGmBFB_J2_+fqCCq0mvLLGpOkWKVGQQ@mail.gmail.com> (sfid-20140519_081710_323161_C0B179C5)
Subject: Re: [PATCH 4/7] ath10k: wake up everything on core restart
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 May 2014 15:21, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It makes sense to finish completions as they may
>> be waited for while holding conf_mutex thus
>> delaying hw restart.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/core.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> index 3f4d28f..bf7c323 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -709,6 +709,18 @@ void ath10k_core_restart(struct ath10k *ar)
>>       spin_lock_bh(&ar->data_lock);
>>       ar->wmi.drop = true;
>>       wake_up(&ar->wmi.tx_credits_wq);
>> +
>> +     complete(&ar->target_suspend);
>> +     complete(&ar->debug.event_stats_compl);
>
> We dropped this patchset already, but for the future, this patch
> introduces a new warning:
>
>    drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_restart':
>>> drivers/net/wireless/ath/ath10k/core.c:714:14: error: 'struct ath10k'
>>> has no member named 'debug'
>      complete(&ar->debug.event_stats_compl);
>                  ^

Good catch. I completely forgot ar->debug is inside an #ifdef DEBUG.


> Maybe that complete call should be in debug.c?

Well, either we add an ifdef here (core.c @ L714), or an ifdef in
debug.h + debug.c..


Michał
