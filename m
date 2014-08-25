Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28843 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaHYJnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 05:43:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath10k: improve logging to include dev id
References: <1408952456-3121-1-git-send-email-michal.kazior@tieto.com>
	<87tx5153lw.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnJYK0Sf6jy+tXHrTM06gXCjTxv_JKdK=01+jz5RgZ+tQ@mail.gmail.com>
Date: Mon, 25 Aug 2014 12:43:20 +0300
In-Reply-To: <CA+BoTQnJYK0Sf6jy+tXHrTM06gXCjTxv_JKdK=01+jz5RgZ+tQ@mail.gmail.com>
	(Michal Kazior's message of "Mon, 25 Aug 2014 11:26:33 +0200")
Message-ID: <87mwas6h1j.fsf@kamboji.qca.qualcomm.com> (sfid-20140825_114328_968318_EED50196)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 25 August 2014 11:18, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This makes it a lot easier to log and debug
>>> messages if there's more than 1 ath10k device on a
>>> system.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Did only a quick review and test but looks good to me except one problem
>> in pci.c, see below. But there are some conflicts now, can you rebase
>> please? I hope it's not too much work to fix them.
>
> I've rebased this in my internal tree already.

Nice :)

>> I'll also summarise the "meat" of the changes so that it's easier for
>> others to review:
>>
> [...]
>>> @@ -2566,12 +2576,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>>>       struct ath10k_pci *ar_pci;
>>>       u32 chip_id;
>>>
>>> -     ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
>>> +     dev_printk(KERN_DEBUG, &pdev->dev, "pci probe\n");
>>
>> But this doesn't look right. A leftover from testing, perhaps?
>
> At this point there's no "ar" yet. The "ar" is allocated a few lines
> below. If the allocation fails then there's no "ar" so dev_err() is
> used explicitly in the failpath.

Ah, of course.

> I think these are just 2 exceptions we can't do differently, can we?

Using dev_err() is okay, but this debug print has the problem that it's
now always printed. I see few options:

1) we create __ath10k_dbg(dev, mask, fmt, ...)

2) we move the debug print after ar is created

3) we remove the debug print entirely

I vote for 2)

-- 
Kalle Valo
