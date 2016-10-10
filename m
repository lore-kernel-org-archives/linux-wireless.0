Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36244 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752538AbcJJPBY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 11:01:24 -0400
Received: by mail-oi0-f46.google.com with SMTP id m72so129944507oik.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2016 08:01:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8760p0jlv4.fsf@kamboji.qca.qualcomm.com>
References: <1475699037-136212-1-git-send-email-mfaltesek@google.com> <8760p0jlv4.fsf@kamboji.qca.qualcomm.com>
From: Marty Faltesek <mfaltesek@google.com>
Date: Mon, 10 Oct 2016 11:01:05 -0400
Message-ID: <CAOiWkA8yX6bnLWHTwMc21EJHh4tQHpdBH+yKL4Y9WWxufBKaKQ@mail.gmail.com> (sfid-20161010_170127_460269_35C8EC0D)
Subject: Re: [PATCH v2] ath10k: cache calibration data when the core is stopped
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k: cache calibration data when the core is stopped

Caching calibration data allows it to be accessed when the
device is not active.

Signed-off-by: Marty Faltesek <mfaltesek@google.com>

On Mon, Oct 10, 2016 at 10:54 AM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Marty Faltesek <mfaltesek@google.com> writes:
>
>> Caching calibration data allows it to be accessed when the
>> device is not active.
>>
>> ---
>
> Signed-off-by missing. Can you send it as a reply to this message and
> I'll add it to v3?
>
>>  drivers/net/wireless/ath/ath10k/core.h  |  1 +
>>  drivers/net/wireless/ath/ath10k/debug.c | 72 ++++++++++++++-------------------
>>  2 files changed, 31 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
>> index 6e5aa2d..7274ebe 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -452,6 +452,7 @@ struct ath10k_debug {
>>       u32 nf_cal_period;
>>
>>       struct ath10k_fw_crash_data *fw_crash_data;
>> +     void *cal_data;
>
> To properly document locking I'll move this under the "protected by
> conf_mutex" comment.
>
>> -static int ath10k_debug_cal_data_open(struct inode *inode, struct file *file)
>> +static int ath10k_debug_cal_data_fetch(struct ath10k *ar)
>>  {
>> -     struct ath10k *ar = inode->i_private;
>> -     void *buf;
>>       u32 hi_addr;
>>       __le32 addr;
>>       int ret;
>>
>> -     mutex_lock(&ar->conf_mutex);
>
> I'll add lockdep_assert_held() here.
>
>>  static ssize_t ath10k_debug_cal_data_read(struct file *file,
>> -                                       char __user *user_buf,
>> -                                       size_t count, loff_t *ppos)
>> +                                          char __user *user_buf,
>> +                                          size_t count, loff_t *ppos)
>>  {
>>       struct ath10k *ar = file->private_data;
>> -     void *buf = file->private_data;
>>
>>       return simple_read_from_buffer(user_buf, count, ppos,
>> -                                    buf, ar->hw_params.cal_data_len);
>> -}
>
> I'll add locking to this function.
>
>> @@ -2343,7 +2327,9 @@ int ath10k_debug_create(struct ath10k *ar)
>>       ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
>>       if (!ar->debug.fw_crash_data)
>>               return -ENOMEM;
>> -
>> +     ar->debug.cal_data = vzalloc(ar->hw_params.cal_data_len);
>> +     if (!ar->debug.cal_data)
>> +             return -ENOMEM;
>>       INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
>>       INIT_LIST_HEAD(&ar->debug.fw_stats.vdevs);
>>       INIT_LIST_HEAD(&ar->debug.fw_stats.peers);
>> @@ -2355,7 +2341,9 @@ int ath10k_debug_create(struct ath10k *ar)
>>  void ath10k_debug_destroy(struct ath10k *ar)
>>  {
>>       vfree(ar->debug.fw_crash_data);
>> +     vfree(ar->debug.cal_data);
>>       ar->debug.fw_crash_data = NULL;
>> +     ar->debug.cal_data = NULL;
>
> Actually I gave you a bad advice, this won't work as
> ar->hw_params.cal_data_len is not yet initialised, we initialise it only
> after we have probed the capabilities during the first firmware boot. I
> changed the allocation to a fixed length buffer for now, it's only few
> kBs virtual memory anyway so it shouldn't matter to anyone.
>
> I have now v3 ready and tested. I'll just need your Signed-off-by and I
> can then submit it.
>
> --
> Kalle Valo
