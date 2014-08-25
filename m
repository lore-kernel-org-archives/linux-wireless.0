Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42239 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaHYJ0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 05:26:34 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so2230730wiw.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 02:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87tx5153lw.fsf@kamboji.qca.qualcomm.com>
References: <1408952456-3121-1-git-send-email-michal.kazior@tieto.com>
	<87tx5153lw.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 25 Aug 2014 11:26:33 +0200
Message-ID: <CA+BoTQnJYK0Sf6jy+tXHrTM06gXCjTxv_JKdK=01+jz5RgZ+tQ@mail.gmail.com> (sfid-20140825_112639_215856_07A5CB42)
Subject: Re: [RFC] ath10k: improve logging to include dev id
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 August 2014 11:18, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This makes it a lot easier to log and debug
>> messages if there's more than 1 ath10k device on a
>> system.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Did only a quick review and test but looks good to me except one problem
> in pci.c, see below. But there are some conflicts now, can you rebase
> please? I hope it's not too much work to fix them.

I've rebased this in my internal tree already.


> I'll also summarise the "meat" of the changes so that it's easier for
> others to review:
>
[...]
>> @@ -2566,12 +2576,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>>       struct ath10k_pci *ar_pci;
>>       u32 chip_id;
>>
>> -     ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
>> +     dev_printk(KERN_DEBUG, &pdev->dev, "pci probe\n");
>
> But this doesn't look right. A leftover from testing, perhaps?

At this point there's no "ar" yet. The "ar" is allocated a few lines
below. If the allocation fails then there's no "ar" so dev_err() is
used explicitly in the failpath.

I think these are just 2 exceptions we can't do differently, can we?


Michał
