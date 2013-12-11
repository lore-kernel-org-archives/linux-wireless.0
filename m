Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33237 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3LKJto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 04:49:44 -0500
MIME-Version: 1.0
In-Reply-To: <1386750826-25219-4-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
	<1386750826-25219-4-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 11 Dec 2013 11:49:43 +0200
Message-ID: <CANUX_P0m89Wx1KwDWSDLJcU7i=957uRJnFVQSeSFcs5tiuP1mA@mail.gmail.com> (sfid-20131211_104953_394961_160F2589)
Subject: Re: [RFC 03/10] iwlwifi: pcie: re-organize the PCIe ISR code
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-rt-users@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 11, 2013 at 10:33 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
>
> Separate the code that simply disables interrupt in the
> hardware and the code that checks what interrupt fired.
> This will be useful to move the second part in the threaded
> handler which will be done in a future patch.
>
> Change-Id: Iec42aa577c9de5c5a13a6030a1d8a69b4da37f43
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/pcie/internal.h |  2 +-
>  drivers/net/wireless/iwlwifi/pcie/rx.c       | 49 +++++++++++++---------------
>  drivers/net/wireless/iwlwifi/pcie/trans.c    |  4 +--
>  3 files changed, 26 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
> index c9821ca..c790df6 100644
> --- a/drivers/net/wireless/iwlwifi/pcie/internal.h
> +++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
> @@ -346,7 +346,7 @@ void iwl_pcie_rx_free(struct iwl_trans *trans);
>  /*****************************************************
>  * ICT - interrupt handling
>  ******************************************************/
> -irqreturn_t iwl_pcie_isr_ict(int irq, void *data);
> +irqreturn_t iwl_pcie_isr(int irq, void *data);
>  int iwl_pcie_alloc_ict(struct iwl_trans *trans);
>  void iwl_pcie_free_ict(struct iwl_trans *trans);
>  void iwl_pcie_reset_ict(struct iwl_trans *trans);
> diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
> index 7e4836f..54a2f4a 100644
> --- a/drivers/net/wireless/iwlwifi/pcie/rx.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
> @@ -1111,9 +1111,8 @@ void iwl_pcie_disable_ict(struct iwl_trans *trans)
>  }
>
>  /* legacy (non-ICT) ISR. Assumes that trans_pcie->irq_lock is held */
> -static irqreturn_t iwl_pcie_isr(int irq, void *data)
> +static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
>  {
> -       struct iwl_trans *trans = data;
>         struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
>         u32 inta;
>
> @@ -1121,12 +1120,6 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
>
>         trace_iwlwifi_dev_irq(trans->dev);
>
> -       /* Disable (but don't clear!) interrupts here to avoid
> -        *    back-to-back ISRs and sporadic interrupts from our NIC.
> -        * If we have something to service, the irq thread will re-enable ints.
> -        * If we *don't* have something, we'll re-enable before leaving here. */
> -       iwl_write32(trans, CSR_INT_MASK, 0x00000000);
> -
>         /* Discover which interrupts are active/pending */
>         inta = iwl_read32(trans, CSR_INT);
>
> @@ -1181,20 +1174,14 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
>   * the interrupt we need to service, driver will set the entries back to 0 and
>   * set index.
>   */
> -irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
> +static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
>  {
> -       struct iwl_trans *trans = data;
> -       struct iwl_trans_pcie *trans_pcie;
> +       struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
> +       unsigned long flags;
> +       irqreturn_t ret;
>         u32 inta;
>         u32 val = 0;
>         u32 read;
> -       unsigned long flags;
> -       irqreturn_t ret = IRQ_NONE;
> -
> -       if (!trans)
> -               return IRQ_NONE;
> -
> -       trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
>
>         spin_lock_irqsave(&trans_pcie->irq_lock, flags);
>
> @@ -1202,20 +1189,13 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
>          * use legacy interrupt.
>          */
>         if (unlikely(!trans_pcie->use_ict)) {
> -               ret = iwl_pcie_isr(irq, data);
> +               ret = iwl_pcie_isr_non_ict(trans);
>                 spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
>                 return ret;
>         }
>
>         trace_iwlwifi_dev_irq(trans->dev);
>
> -       /* Disable (but don't clear!) interrupts here to avoid
> -        * back-to-back ISRs and sporadic interrupts from our NIC.
> -        * If we have something to service, the tasklet will re-enable ints.
> -        * If we *don't* have something, we'll re-enable before leaving here.
> -        */
> -       iwl_write32(trans, CSR_INT_MASK, 0x00000000);
> -
>         /* Ignore interrupt if there's nothing in NIC to service.
>          * This may be due to IRQ shared with another device,
>          * or due to sporadic interrupts thrown from our NIC. */
> @@ -1286,3 +1266,20 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
>         spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
>         return ret;
>  }
> +
> +irqreturn_t iwl_pcie_isr(int irq, void *data)
> +{
> +       struct iwl_trans *trans = data;
> +
> +       if (!trans)
> +               return IRQ_NONE;
> +
> +       /* Disable (but don't clear!) interrupts here to avoid
> +        * back-to-back ISRs and sporadic interrupts from our NIC.
> +        * If we have something to service, the tasklet will re-enable ints.
> +        * If we *don't* have something, we'll re-enable before leaving here.
> +        */
> +       iwl_write32(trans, CSR_INT_MASK, 0x00000000);
> +
> +       return iwl_pcie_isr_ict(trans);
> +}
> diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
> index d8ae0ad..af3ec74 100644
> --- a/drivers/net/wireless/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
> @@ -1608,11 +1608,11 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
>
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
>         err = compat_request_threaded_irq(&trans_pcie->irq_compat,
> -                                         pdev->irq, iwl_pcie_isr_ict,
> +                                         pdev->irq, iwl_pcie_isr,
>                                           iwl_pcie_irq_handler,
>                                           IRQF_SHARED, DRV_NAME, trans);
>  #else
> -       err = request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
> +       err = request_threaded_irq(pdev->irq, iwl_pcie_isr,
>                                    iwl_pcie_irq_handler,
>                                    IRQF_SHARED, DRV_NAME, trans);
>  #endif
> --

Oops - now you all know I work on a backport based tree ;)
