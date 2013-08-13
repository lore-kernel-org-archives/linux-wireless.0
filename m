Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:41453 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3HMFM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:12:59 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so2165055bkb.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 22:12:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87li47t276.fsf@kamboji.qca.qualcomm.com>
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
	<1375949650-9699-3-git-send-email-michal.kazior@tieto.com>
	<87li47t276.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 13 Aug 2013 07:12:57 +0200
Message-ID: <CA+BoTQkj_4RFsjGkEbwgP26wQSYTX05SrtQ3CwwFLKKvH0ik6w@mail.gmail.com> (sfid-20130813_071302_852774_642D6703)
Subject: Re: [PATCH 2/4] ath10k: use sizeof(*var) in kmalloc
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 August 2013 16:26, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This fixes checkpatch warning from the latest
>> 3.11-rc kernel tree.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/pci.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>> index d95439b..1814af1 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -803,8 +803,7 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
>>                       continue;
>>
>>               for (i = 0; i < completions; i++) {
>> -                     compl = kmalloc(sizeof(struct ath10k_pci_compl),
>> -                                     GFP_KERNEL);
>> +                     compl = kmalloc(sizeof(*compl), GFP_KERNEL);
>>                       if (!compl) {
>>                               ath10k_warn("No memory for completion state\n");
>>                               ath10k_pci_stop_ce(ar);
>
> Just out of curiosity, what's the warning? kmalloc() should be called
> with sizeof(*foo) style?

Checkpatch prints:

  CHECK: Prefer kmalloc(sizeof(*compl)...) over kmalloc(sizeof(struct
ath10k_pci_compl)...)


Pozdrawiam / Best regards,
Micha³ Kazior.
