Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:59997 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHHLA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 07:00:58 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so5532083wev.12
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 04:00:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878umzz2d0.fsf@kamboji.qca.qualcomm.com>
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-3-git-send-email-michal.kazior@tieto.com>
	<878umzz2d0.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 8 Aug 2014 13:00:56 +0200
Message-ID: <CA+BoTQnvS2C9_C7qkrX5cPLa8weHx_FmS8Gd=d2Pf=EAmf9EiQ@mail.gmail.com> (sfid-20140808_130101_318760_F143CC5C)
Subject: Re: [PATCH 2/6] ath10k: remove target soc ps code
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 August 2014 12:45, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The soc powersave was disabled by default. It
>> never was fully tested. Some hw apparently had
>> problems with it and the implementation itself had
>> a possible race.
>>
>> Just remove the refcounting and simply wake up the
>> device when probing and put to sleep when
>> removing.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> This one introduced new warnings:
>
> drivers/net/wireless/ath/ath10k/pci.c:646:5: warning: symbol 'ath10k_pci_wake' was not declared. Should it be static?
> drivers/net/wireless/ath/ath10k/pci.c:653:6: warning: symbol 'ath10k_pci_sleep' was not declared. Should it be static?

I didn't catch this for some reason. Can you share how you run
checkpatch, please?


> Is it okay if I fix it like this:
>
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -643,14 +643,14 @@ static int ath10k_pci_wake_wait(struct ath10k *ar)
>         return -ETIMEDOUT;
>  }
>
> -int ath10k_pci_wake(struct ath10k *ar)
> +static int ath10k_pci_wake(struct ath10k *ar)
>  {
>         ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
>                                PCIE_SOC_WAKE_V_MASK);
>         return ath10k_pci_wake_wait(ar);
>  }
>
> -void ath10k_pci_sleep(struct ath10k *ar)
> +static void ath10k_pci_sleep(struct ath10k *ar)
>  {
>         ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
>                                PCIE_SOC_WAKE_RESET);

Looks good, thanks.


Michał
