Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:45832 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaCYJct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:32:49 -0400
Received: by mail-oa0-f54.google.com with SMTP id n16so215782oag.41
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 02:32:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140325091505.16651.15554.stgit@potku.adurom.net>
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
	<20140325091505.16651.15554.stgit@potku.adurom.net>
Date: Tue, 25 Mar 2014 10:32:49 +0100
Message-ID: <CA+BoTQns9QXCctzrMzd5=o6EyA=d0TG-eLJw3hztE1-MD7HwkQ@mail.gmail.com> (sfid-20140325_103303_853166_B47180E9)
Subject: Re: [PATCH 1/8] ath10k: cleanup ath10k_pci_wait_for_target_init()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2014 10:15, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> ath10k_pci_wait_for_target_init() did really follow the style used elsewhere in
> ath10k. Use ath10k_pci_read/write() wrappers, simplify the while loop and
> improve warning messages.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |   33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 9d242d801d9d..0425c76daf3f 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -2385,30 +2385,37 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
>  static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
>  {
>         struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
> -       int wait_limit = 300; /* 3 sec */
> +       const int wait = 3000; /* ms */

We probably should have a #define for this.


> +       unsigned long timeout;
>         int ret;
> +       u32 val;
>
>         ret = ath10k_pci_wake(ar);
>         if (ret) {
> -               ath10k_err("failed to wake up target: %d\n", ret);
> +               ath10k_err("failed to wake up target for init: %d\n", ret);
>                 return ret;
>         }
>
> -       while (wait_limit-- &&
> -              !(ioread32(ar_pci->mem + FW_INDICATOR_ADDRESS) &
> -                FW_IND_INITIALIZED)) {
> +       timeout = jiffies + msecs_to_jiffies(wait);
> +
> +       do {
> +               val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
> +               if (val == FW_IND_INITIALIZED)
> +                       break;
> +

It might be worth to add:

 if (val == 0xFFFFFFFF)
   return -EIO;


>                 if (ar_pci->num_msi_intrs == 0)
>                         /* Fix potential race by repeating CORE_BASE writes */
> -                       iowrite32(PCIE_INTR_FIRMWARE_MASK |
> -                                 PCIE_INTR_CE_MASK_ALL,
> -                                 ar_pci->mem + (SOC_CORE_BASE_ADDRESS |
> -                                                PCIE_INTR_ENABLE_ADDRESS));
> +                       ath10k_pci_soc_write32(ar, PCIE_INTR_ENABLE_ADDRESS,
> +                                              PCIE_INTR_FIRMWARE_MASK |
> +                                              PCIE_INTR_CE_MASK_ALL);
> +
>                 mdelay(10);
> -       }
> +       } while (time_before(jiffies, timeout));
>
> -       if (wait_limit < 0) {
> -               ath10k_err("target stalled\n");
> -               ret = -EIO;
> +       if (val != FW_IND_INITIALIZED) {
> +               ath10k_err("failed to receive initialized event from target after %d ms: %d\n",
> +                          wait, val);

`val` is u32 so it shouldn't be %d. %08x makes most sense I guess.


Michał
