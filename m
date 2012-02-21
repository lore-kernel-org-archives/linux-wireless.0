Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48462 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2BULJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 06:09:54 -0500
Received: by vbjk17 with SMTP id k17so4075526vbj.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 03:09:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20291.25211.240988.864198@gargle.gargle.HOWL>
References: <20291.25211.240988.864198@gargle.gargle.HOWL>
Date: Tue, 21 Feb 2012 16:39:53 +0530
Message-ID: <CAD2nsn2q130e=FRjZ+uQSGc+S2b=-bxk+5vOQ6df8+sRUwTgAw@mail.gmail.com> (sfid-20120221_120957_577250_3238B6DA)
Subject: Re: [RFC/WIP 11/22] ath9k_hw: Handle MCI power state using a helper
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
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c |   17 +++++++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.c         |   17 ++---------------
>  drivers/net/wireless/ath/ath9k/hw.h         |    1 +
>  3 files changed, 20 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> index 118e774..f8dd0b2 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> @@ -365,6 +365,23 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
>        REG_WRITE(ah, AR_MCI_INTERRUPT_EN, saved_mci_int_en);
>  }
>
> +void ar9003_mci_set_full_sleep(struct ath_hw *ah)
> +{
> +       struct ath_common *common = ath9k_hw_common(ah);
> +       struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
> +
> +       if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) &&
> +           (mci->bt_state != MCI_BT_SLEEP) &&
> +           !mci->halted_bt_gpm) {
> +               ath_dbg(common, MCI,
> +                       "MCI halt BT GPM (full_sleep)\n");
> +               ar9003_mci_send_coex_halt_bt_gpm(ah, true, true);
> +       }
> +
> +       mci->ready = false;
> +       REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
> +}
> +
>  void ar9003_mci_disable_interrupt(struct ath_hw *ah)
>  {
>        if (!ATH9K_HW_CAP_MCI)
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index f4b121f..406ffd0 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -2076,7 +2076,6 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
>  bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
>  {
>        struct ath_common *common = ath9k_hw_common(ah);
> -       struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
>        int status = true, setChip = true;
>        static const char *modes[] = {
>                "AWAKE",
> @@ -2100,20 +2099,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
>
>                break;
>        case ATH9K_PM_FULL_SLEEP:
> -
> -               if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
> -                       if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) &&
> -                               (mci->bt_state != MCI_BT_SLEEP) &&
> -                               !mci->halted_bt_gpm) {
> -                               ath_dbg(common, MCI,
> -                                       "MCI halt BT GPM (full_sleep)\n");
> -                               ar9003_mci_send_coex_halt_bt_gpm(ah,
> -                                                                true, true);
> -                       }
> -
> -                       mci->ready = false;
> -                       REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
> -               }
> +               if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
> +                       ar9003_mci_set_full_sleep(ah);
>
>                ath9k_set_power_sleep(ah, setChip);
>                ah->chip_fullsleep = true;
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index ebc32d0..07dd53e 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -1219,6 +1219,7 @@ void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
>  u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
>                            u8 gpm_opcode, int time_out);
>  void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g);
> +void ar9003_mci_set_full_sleep(struct ath_hw *ah);
>  void ar9003_mci_disable_interrupt(struct ath_hw *ah);
>  void ar9003_mci_enable_interrupt(struct ath_hw *ah);
>  void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
> --

thanks!


-- 
thanks,
shafi
