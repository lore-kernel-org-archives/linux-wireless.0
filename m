Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62624 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3JQO12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:27:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add error handling to ath10k_pci_wait()
References: <20131017083615.31028.25088.stgit@localhost6.localdomain6>
	<CA+BoTQ=x+KJxXtcdMYKEGGjfF3oryTXgA2N+4OAa+6fcSAK4uw@mail.gmail.com>
Date: Thu, 17 Oct 2013 17:27:22 +0300
In-Reply-To: <CA+BoTQ=x+KJxXtcdMYKEGGjfF3oryTXgA2N+4OAa+6fcSAK4uw@mail.gmail.com>
	(Michal Kazior's message of "Thu, 17 Oct 2013 07:24:07 -0700")
Message-ID: <87a9i82cs5.fsf@kamboji.qca.qualcomm.com> (sfid-20131017_162731_438682_32329122)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 17 October 2013 01:36, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> ath10k_pci_wait() didn't notify any errors to callers, it
>> just printed a warning so add proper error handling.
>>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

>> @@ -2227,7 +2231,13 @@ static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
>>                   ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS +
>>                   PCIE_SOC_WAKE_ADDRESS);
>>
>> -       ath10k_pci_wait(ar);
>> +       ret = ath10k_pci_wait(ar);
>> +       if (ret) {
>> +               ath10k_warn("Failed to enable legacy interrupt, target did not wake up: %d\n",
>> +                           ret);
>> +               free_irq(ar_pci->pdev->irq, ar);
>> +               return ret;
>> +       }
>
> I think we could actually use ath10k_do_pci_wake/sleep() here (see
> above iowrite). It does basically the same thing - sets the wake
> register and waits until HW wakes up. I think ath10k_pci_wait() could
> even go away.

That would be nice, I'll take a look. Thanks for the review.

-- 
Kalle Valo
