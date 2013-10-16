Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:59870 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab3JPQBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 12:01:53 -0400
Received: by mail-bk0-f45.google.com with SMTP id mx11so342301bkb.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Oct 2013 09:01:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ppr55hun.fsf@kamboji.qca.qualcomm.com>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
	<20131016134617.25095.10581.stgit@localhost6.localdomain6>
	<CA+BoTQkqkuf-=a4giyJHeYdXZ2T3deU7nmuQOxpFcKSzWjGb3Q@mail.gmail.com>
	<87ppr55hun.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 16 Oct 2013 09:01:52 -0700
Message-ID: <CA+BoTQ=9cEwB7PY8VMGv1SmEPsH6WGmDEBgujmo9G=Cby82uyg@mail.gmail.com> (sfid-20131016_180156_835663_765B3CAF)
Subject: Re: [PATCH v2 7/8] ath10k: fix device initialization routine
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 October 2013 08:57, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>>> +       /* disable pending irqs */
>>> +       ath10k_pci_core_write32(ar, PCIE_INTR_ENABLE_ADDRESS, 0);
>>> +       ath10k_pci_core_write32(ar, PCIE_INTR_CLR_ADDRESS, ~0);
>>
>> These use SOC_CORE_BASE_ADDRESS as the suffix, not the RTC_SOC_BASE_ADDRESS.
>
> But I am using SOC_CORE_BASE_ADDRESS, right?

Ah, right. Sorry. My eyesight failed me :) Those function names seem a
little confusing (_core_ for SOC_CORE and _soc_ for RTC_SOC)


Michał
