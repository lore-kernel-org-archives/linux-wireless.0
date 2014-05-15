Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:38692 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaEOMmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 08:42:17 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so994804wes.18
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 05:42:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r43v9v2n.fsf@kamboji.qca.qualcomm.com>
References: <1400050658-2763-1-git-send-email-michal.kazior@tieto.com>
	<1400050658-2763-2-git-send-email-michal.kazior@tieto.com>
	<87r43v9v2n.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 15 May 2014 14:42:16 +0200
Message-ID: <CA+BoTQkYMFi5_a1w0UQaPanAEaeiK9-ScnmLzxro1uB2dzK4MA@mail.gmail.com> (sfid-20140515_144221_130324_5BAEF9EA)
Subject: Re: [PATCH 1/2] ath10k: improve warm reset reliability
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 May 2014 12:48, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Warm reset is now able to recover after device
>> crashes which required a cold reset before.
>>
>> This should greatly reduce chances of getting data
>> bus errors or host system freezes due to buggy
>> cold reset on some chips.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Awesome! This is very much needed. I just have a cosmetic comment:
>
>> +/* this function effectively clears target memory controller assert line */
>> +static void ath10k_pci_warm_reset_si0(struct ath10k *ar)
>> +{
>> +     u32 val;
>> +
>> +     val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
>> +                             SOC_RESET_CONTROL_ADDRESS);
>> +     ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
>> +                        val | SOC_RESET_CONTROL_SI0_RST_MASK);
>> +     val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
>> +                             SOC_RESET_CONTROL_ADDRESS);
>
> We do have the ath10k_pci_soc_ functions for accessing SOC registers, I
> would prefer to use those here. I now modified your patch with the diff
> below. Is that ok to you?

Ah, yeah. I totally forgot about these functions (again).


> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1807,20 +1807,18 @@ static void ath10k_pci_warm_reset_si0(struct ath10k *ar)
>  {
>         u32 val;
>
> -       val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
> -                               SOC_RESET_CONTROL_ADDRESS);
> -       ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
> -                          val | SOC_RESET_CONTROL_SI0_RST_MASK);
> -       val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
> -                               SOC_RESET_CONTROL_ADDRESS);
> +       val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
> +       ath10k_pci_soc_write32(ar, SOC_RESET_CONTROL_ADDRESS,
> +                              val | SOC_RESET_CONTROL_SI0_RST_MASK);
> +       val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
> +
>         msleep(10);
>
> -       val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
> -                               SOC_RESET_CONTROL_ADDRESS);
> -       ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
> -                          val & ~SOC_RESET_CONTROL_SI0_RST_MASK);
> -       val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
> -                               SOC_RESET_CONTROL_ADDRESS);
> +       val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
> +       ath10k_pci_soc_write32(ar, SOC_RESET_CONTROL_ADDRESS,
> +                              val & ~SOC_RESET_CONTROL_SI0_RST_MASK);
> +       val = ath10k_pci_soc_read32(ar, SOC_RESET_CONTROL_ADDRESS);
> +
>         msleep(10);
>  }

Looks good to me :-)


> Full patch here:
>
> https://github.com/kvalo/ath/commit/7b52054308a371d479a9e686e1d8411d19a90fd7

You probably mean:

https://github.com/kvalo/ath/commit/136ef8110cba61752eee5ef6bd7ce170b15cf491


Michał
