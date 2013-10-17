Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:33754 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3JQOYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:24:09 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so837205bkb.6
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2013 07:24:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131017083615.31028.25088.stgit@localhost6.localdomain6>
References: <20131017083615.31028.25088.stgit@localhost6.localdomain6>
Date: Thu, 17 Oct 2013 07:24:07 -0700
Message-ID: <CA+BoTQ=x+KJxXtcdMYKEGGjfF3oryTXgA2N+4OAa+6fcSAK4uw@mail.gmail.com> (sfid-20131017_162417_820818_2E41FA4B)
Subject: Re: [PATCH] ath10k: add error handling to ath10k_pci_wait()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 October 2013 01:36, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> ath10k_pci_wait() didn't notify any errors to callers, it
> just printed a warning so add proper error handling.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |   28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 1e9cfcc9..92759cd 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -525,15 +525,19 @@ static bool ath10k_pci_target_is_awake(struct ath10k *ar)
>         return (RTC_STATE_V_GET(val) == RTC_STATE_V_ON);
>  }
>
> -static void ath10k_pci_wait(struct ath10k *ar)
> +static int ath10k_pci_wait(struct ath10k *ar)
>  {
>         int n = 100;
>
>         while (n-- && !ath10k_pci_target_is_awake(ar))
>                 msleep(10);
>
> -       if (n < 0)
> +       if (n < 0) {
>                 ath10k_warn("Unable to wakeup target\n");
> +               return -ETIMEDOUT;
> +       }
> +
> +       return 0;
>  }
>
>  int ath10k_do_pci_wake(struct ath10k *ar)
> @@ -2227,7 +2231,13 @@ static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
>                   ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS +
>                   PCIE_SOC_WAKE_ADDRESS);
>
> -       ath10k_pci_wait(ar);
> +       ret = ath10k_pci_wait(ar);
> +       if (ret) {
> +               ath10k_warn("Failed to enable legacy interrupt, target did not wake up: %d\n",
> +                           ret);
> +               free_irq(ar_pci->pdev->irq, ar);
> +               return ret;
> +       }

I think we could actually use ath10k_do_pci_wake/sleep() here (see
above iowrite). It does basically the same thing - sets the wake
register and waits until HW wakes up. I think ath10k_pci_wait() could
even go away.


>
>         /*
>          * A potential race occurs here: The CORE_BASE write
> @@ -2290,6 +2300,10 @@ static int ath10k_pci_start_intr(struct ath10k *ar)
>         }
>
>         ret = ath10k_pci_start_intr_legacy(ar);
> +       if (ret) {
> +               ath10k_warn("Failed to start legacy interrupts: %d\n", ret);
> +               return ret;
> +       }
>
>  exit:
>         ar_pci->num_msi_intrs = num;
> @@ -2315,13 +2329,19 @@ static int ath10k_pci_reset_target(struct ath10k *ar)
>  {
>         struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>         int wait_limit = 300; /* 3 sec */
> +       int ret;
>
>         /* Wait for Target to finish initialization before we proceed. */
>         iowrite32(PCIE_SOC_WAKE_V_MASK,
>                   ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS +
>                   PCIE_SOC_WAKE_ADDRESS);
>
> -       ath10k_pci_wait(ar);
> +       ret = ath10k_pci_wait(ar);
> +       if (ret) {
> +               ath10k_warn("Failed to reset target, target did not wake up: %d\n",
> +                           ret);
> +               return ret;
> +       }

Ditto.


Michał
