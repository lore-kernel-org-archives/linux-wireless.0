Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:34816 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3JPPod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 11:44:33 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so331577bkb.24
        for <linux-wireless@vger.kernel.org>; Wed, 16 Oct 2013 08:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131016134617.25095.10581.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
	<20131016134617.25095.10581.stgit@localhost6.localdomain6>
Date: Wed, 16 Oct 2013 08:44:32 -0700
Message-ID: <CA+BoTQkqkuf-=a4giyJHeYdXZ2T3deU7nmuQOxpFcKSzWjGb3Q@mail.gmail.com> (sfid-20131016_174437_077852_2450276E)
Subject: Re: [PATCH v2 7/8] ath10k: fix device initialization routine
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 October 2013 06:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
>
> Hardware revision 2 does not support cold reset
> correctly. As such it would sometimes lead to host
> machine freeze or data bus errors.
>
> The patch introduces warm reset function which is
> used instead of the cold reset one. It also moves
> the reset before interrupts are being set up to
> prevent any kind of spurious interrupts from being
> handled.
>
> kvalo: use ath10k_pci_write32() style wrappers, fix long
> lines
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---

[...]

> @@ -1825,16 +1824,78 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
>         ath10k_pci_sleep(ar);
>  }
>
> -static int ath10k_pci_hif_power_up(struct ath10k *ar)
> +static int ath10k_pci_warm_reset(struct ath10k *ar)
>  {
>         struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>         int ret;
> +       u32 val;
>
> -       ret = ath10k_pci_start_intr(ar);
> -       if (ret) {
> -               ath10k_err("could not start interrupt handling (%d)\n", ret);
> -               goto err;
> -       }
> +       ath10k_dbg(ATH10K_DBG_BOOT, "performing warm chip reset\n");
> +
> +       ret = ath10k_do_pci_wake(ar);
> +       if (ret)
> +               return ret;
> +
> +       ath10k_dbg(ATH10K_DBG_BOOT,
> +                  "pci intr cause 0x%08x cpu intr 0x%08x (before)\n",
> +                  ath10k_pci_core_read32(ar, PCIE_INTR_CAUSE_ADDRESS),
> +                  ath10k_pci_core_read32(ar, CPU_INTR_ADDRESS));
> +
> +       /* disable pending irqs */
> +       ath10k_pci_core_write32(ar, PCIE_INTR_ENABLE_ADDRESS, 0);
> +       ath10k_pci_core_write32(ar, PCIE_INTR_CLR_ADDRESS, ~0);

These use SOC_CORE_BASE_ADDRESS as the suffix, not the RTC_SOC_BASE_ADDRESS.


> +       ath10k_dbg(ATH10K_DBG_BOOT,
> +                  "pci intr cause 0x%08x cpu intr 0x%08x (after)\n",
> +                  ath10k_pci_core_read32(ar, PCIE_INTR_CAUSE_ADDRESS),
> +                  ath10k_pci_core_read32(ar, CPU_INTR_ADDRESS));

Ditto. These are in SOC_CORE_BASE_ADDRESS group.


Michał
