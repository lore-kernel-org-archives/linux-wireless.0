Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47539 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab2BULEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 06:04:53 -0500
Received: by vcge1 with SMTP id e1so4156092vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 03:04:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20291.25205.954138.786228@gargle.gargle.HOWL>
References: <20291.25205.954138.786228@gargle.gargle.HOWL>
Date: Tue, 21 Feb 2012 16:34:52 +0530
Message-ID: <CAD2nsn0D_swGFsq04EqRXQ4+jw6qL5cZjFtkc39PZf7wGZySng@mail.gmail.com> (sfid-20120221_120456_803965_D1D39B57)
Subject: Re: [RFC/WIP 10/22] ath9k_hw: Use a helper function to get MCI ISR
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 21, 2012 at 2:53 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_mac.c |   29 +-------------------------
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c |   25 +++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.h         |    1 +
>  3 files changed, 28 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> index 39cb482..575f36a 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> @@ -180,7 +180,6 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>        u32 mask2 = 0;
>        struct ath9k_hw_capabilities *pCap = &ah->caps;
>        struct ath_common *common = ath9k_hw_common(ah);
> -       struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
>        u32 sync_cause = 0, async_cause;
>
>        async_cause = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
> @@ -302,32 +301,8 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>                        ar9003_hw_bb_watchdog_read(ah);
>        }
>
> -       if (async_cause & AR_INTR_ASYNC_MASK_MCI) {
> -               u32 raw_intr, rx_msg_intr;
> -
> -               rx_msg_intr = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_RAW);
> -               raw_intr = REG_READ(ah, AR_MCI_INTERRUPT_RAW);
> -
> -               if ((raw_intr == 0xdeadbeef) || (rx_msg_intr == 0xdeadbeef))
> -                       ath_dbg(common, MCI,
> -                               "MCI gets 0xdeadbeef during MCI int processing new raw_intr=0x%08x, new rx_msg_raw=0x%08x, raw_intr=0x%08x, rx_msg_raw=0x%08x\n",
> -                               raw_intr, rx_msg_intr, mci->raw_intr,
> -                               mci->rx_msg_intr);
> -               else {
> -                       mci->rx_msg_intr |= rx_msg_intr;
> -                       mci->raw_intr |= raw_intr;
> -                       *masked |= ATH9K_INT_MCI;
> -
> -                       if (rx_msg_intr & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO)
> -                               mci->cont_status =
> -                                       REG_READ(ah, AR_MCI_CONT_STATUS);
> -
> -                       REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW, rx_msg_intr);
> -                       REG_WRITE(ah, AR_MCI_INTERRUPT_RAW, raw_intr);
> -                       ath_dbg(common, MCI, "AR_INTR_SYNC_MCI\n");
> -
> -               }
> -       }
> +       if (async_cause & AR_INTR_ASYNC_MASK_MCI)
> +               ar9003_mci_get_isr(ah, masked);
>
>        if (sync_cause) {
>                if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> index f910bae..118e774 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> @@ -412,6 +412,31 @@ void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
>  }
>  EXPORT_SYMBOL(ar9003_mci_get_interrupt);
>
> +void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
> +{
> +       struct ath_common *common = ath9k_hw_common(ah);
> +       struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
> +       u32 raw_intr, rx_msg_intr;
> +
> +       rx_msg_intr = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_RAW);
> +       raw_intr = REG_READ(ah, AR_MCI_INTERRUPT_RAW);
> +
> +       if ((raw_intr == 0xdeadbeef) || (rx_msg_intr == 0xdeadbeef)) {
> +               ath_dbg(common, MCI,
> +                       "MCI gets 0xdeadbeef during int processing\n");
> +       } else {
> +               mci->rx_msg_intr |= rx_msg_intr;
> +               mci->raw_intr |= raw_intr;
> +               *masked |= ATH9K_INT_MCI;
> +
> +               if (rx_msg_intr & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO)
> +                       mci->cont_status = REG_READ(ah, AR_MCI_CONT_STATUS);
> +
> +               REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW, rx_msg_intr);
> +               REG_WRITE(ah, AR_MCI_INTERRUPT_RAW, raw_intr);
> +       }
> +}
> +
>  void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g)
>  {
>        struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 6a29004..ebc32d0 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -1231,6 +1231,7 @@ void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done);
>  void ar9003_mci_sync_bt_state(struct ath_hw *ah);
>  void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
>                              u32 *rx_msg_intr);
> +void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
>
>  #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
>  static inline enum ath_btcoex_scheme
> --
> 1.7.9.1
>
>
thanks for making it easy to read!

-- 
thanks,
shafi
