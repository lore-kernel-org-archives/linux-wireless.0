Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46446 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab3JPPio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 11:38:44 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so341937bkb.29
        for <linux-wireless@vger.kernel.org>; Wed, 16 Oct 2013 08:38:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131016134611.25095.80204.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
	<20131016134611.25095.80204.stgit@localhost6.localdomain6>
Date: Wed, 16 Oct 2013 08:38:43 -0700
Message-ID: <CA+BoTQmP14xuXP=D4mEsJiWOXvtg0iJ4=BmUb=89QgA_AX5edA@mail.gmail.com> (sfid-20131016_173848_214393_0E21315C)
Subject: Re: [PATCH v2 6/8] ath10k: implement ath10k_pci_soc_read/write32()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 October 2013 06:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> To make it easier to access SOC registers. No functional
> changes.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |    3 +--
>  drivers/net/wireless/ath/ath10k/pci.h |   10 ++++++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index d09f8a2..5c78383 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -2454,8 +2454,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>                 return ret;
>         }
>
> -       chip_id = ath10k_pci_read32(ar,
> -                                   RTC_SOC_BASE_ADDRESS + SOC_CHIP_ID_ADDRESS);
> +       chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
>
>         ath10k_do_pci_sleep(ar);
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
> index 52fb7b9..a304c33 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.h
> +++ b/drivers/net/wireless/ath/ath10k/pci.h
> @@ -318,6 +318,16 @@ static inline u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
>         return ioread32(ar_pci->mem + offset);
>  }
>
> +static inline u32 ath10k_pci_soc_read32(struct ath10k *ar, u32 addr)
> +{
> +       return ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS + addr);
> +}
> +
> +static inline void ath10k_pci_soc_write32(struct ath10k *ar, u32 addr, u32 val)
> +{
> +       ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + addr, val);
> +}
> +

I'm not entirely sure about this. There are a couple of soc address
groups (RTC_SOC, RTC_WMAC, SOC_PCIE, SOC_CORE, ..).

I'd rather use just raw ioread/iowrite than have all those wrappers. I
think the reason for having ath10k_pci_{read,write}32 was the HW v1
workaround. Do we really need to keep it?


Michał
