Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f196.google.com ([209.85.223.196]:36472 "EHLO
	mail-ie0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbFKSpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 14:45:23 -0400
Received: by ierx19 with SMTP id x19so4207428ier.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 11:45:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r3pibav7.fsf@kamboji.qca.qualcomm.com>
References: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com> <87r3pibav7.fsf@kamboji.qca.qualcomm.com>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Thu, 11 Jun 2015 11:44:42 -0700
Message-ID: <CAG5N3qGKeMHUbiChE=S+avwgS9vtLDZ+U8fXV5Rj2LVuKvjtzg@mail.gmail.com> (sfid-20150611_204526_164488_D037BEB9)
Subject: Re: [PATCH v3] ath10k: add 'cryptmode' param to support raw tx
 injection and software crypto
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2015 at 7:03 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Liu CF/TW <cfliu.tw@gmail.com> writes:
>
>> This change supports hardware crypto engine bypass by enabling raw
>> Rx/Tx encap mode. This enables use cases such as software crypto and raw
>> tx injection. This change introduces a new module param 'cryptmode'.
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/debug.c
>> +++ b/drivers/net/wireless/ath/ath10k/debug.c
>> @@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
>>
>>  void ath10k_print_driver_info(struct ath10k *ar)
>>  {
>> -     ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
>> +     ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d flags 0x%lu\n",
>>                   ar->hw_params.name,
>>                   ar->target_version,
>>                   ar->chip_id,
>> @@ -138,7 +138,8 @@ void ath10k_print_driver_info(struct ath10k *ar)
>>                   ar->htt.target_version_minor,
>>                   ar->wmi.op_version,
>>                   ath10k_cal_mode_str(ar->cal_mode),
>> -                 ar->max_num_stations);
>> +                 ar->max_num_stations,
>> +                 ar->dev_flags);
>
> What's the goal here? Printing a bitmap in hex is just gibberish, people
> would always have to count the bits etc to get anything useful
> information out from that print.
>
> I would prefer the messages in more readable format. For example, if
> idea is to show if cryptmode is enabled or not can't we just directly
> print that like with format "cryptmode %d"?

Sure. will do in v4.

>
> --
> Kalle Valo
