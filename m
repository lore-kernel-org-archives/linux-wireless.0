Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:39783 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690Ab3JOTho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 15:37:44 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so3307296bkb.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 12:37:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87a9iabc9c.fsf@kamboji.qca.qualcomm.com>
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
	<20131015184656.14123.70575.stgit@localhost6.localdomain6>
	<87a9iabc9c.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 15 Oct 2013 12:37:42 -0700
Message-ID: <CA+BoTQ=CqXN24Y-tb=r_ruUUNR_imcztULnoTScAvScvbPDbdA@mail.gmail.com> (sfid-20131015_213747_282630_D5AE48F8)
Subject: Re: [PATCH 3/7] ath10k: track vif list internally
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 October 2013 11:49, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> From: Michal Kazior <michal.kazior@tieto.com>
>>
>> mac80211 interface interations functions have
>> peculiar locking issues. This patch introduces
>> internal (to ath10k) vif list that will be used
>> for vif iteration purposes.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -713,6 +713,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
>>       mutex_init(&ar->conf_mutex);
>>       spin_lock_init(&ar->data_lock);
>>
>> +     INIT_LIST_HEAD(&ar->arvifs);
>>       INIT_LIST_HEAD(&ar->peers);
>>       init_waitqueue_head(&ar->peer_mapping_wq);
>>
>> @@ -824,6 +825,7 @@ int ath10k_core_start(struct ath10k *ar)
>>               goto err_disconnect_htc;
>>
>>       ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
>> +     INIT_LIST_HEAD(&ar->arvifs);
>>
>>       return 0;
>
> Michal, why do the INIT_LIST_HEAD() twice? Isn't it enough to do it
> core_start()?

Ah, good point. It's most likely okay to just do it in
ath10k_core_start(). The one in ath10k_core_create() isn't required.


Michał
