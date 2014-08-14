Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24006 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaHNI1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 04:27:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 6/6] ath10k: move fw init print
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-7-git-send-email-michal.kazior@tieto.com>
	<87ppg6qh3z.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 14 Aug 2014 11:27:29 +0300
In-Reply-To: <87ppg6qh3z.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 12 Aug 2014 10:53:04 +0300")
Message-ID: <87egwjo4r2.fsf@kamboji.qca.qualcomm.com> (sfid-20140814_102742_265548_27059BEA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Firmware probing is done only once when driver is
>> registered and firmware version is guaranteed to
>> remain the same until driver is unregistered.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> -	__set_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags);
>
> Doesn't this break this print in pci.c:
>
>         if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
>            ath10k_info("pci irq %s irq_mode %d reset_mode %d\n",
>                                     irq_mode, ath10k_pci_irq_mode,
>                                                     ath10k_pci_reset_mode);

Ah, now I understand. You rework that part in patch "ath10k: setup irq
method in probe" which was just in a different patchset. Then this extra
print during interface up is ok, as it just happens between the two
patches.

-- 
Kalle Valo
