Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2BULPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 06:15:24 -0500
Received: by vbjk17 with SMTP id k17so4077647vbj.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 03:15:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20291.25217.112736.268239@gargle.gargle.HOWL>
References: <20291.25217.112736.268239@gargle.gargle.HOWL>
Date: Tue, 21 Feb 2012 16:45:23 +0530
Message-ID: <CAD2nsn1szH2=JUkb+rTbssVgYJA5CzpHUPP9GTve0axkSQw-+Q@mail.gmail.com> (sfid-20120221_121527_632384_02F4133E)
Subject: Re: [RFC/WIP 12/22] ath9k_hw: Setup MCI calibration using a helper
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
>  drivers/net/wireless/ath/ath9k/ar9003_calib.c |   42 ++-------------------
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c   |   48 +++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.h           |    2 +
>  3 files changed, 54 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index 8e70f0b..63089cc 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -925,7 +925,6 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
>  {
>        struct ath_common *common = ath9k_hw_common(ah);
>        struct ath9k_hw_cal_data *caldata = ah->caldata;
> -       struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
>        bool txiqcal_done = false, txclcal_done = false;
>        bool is_reusable = true, status = true;
>        bool run_rtt_cal = false, run_agc_cal;
> @@ -998,30 +997,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
>        } else if (caldata && !caldata->done_txiqcal_once)
>                run_agc_cal = true;
>
> -       if (mci && IS_CHAN_2GHZ(chan) &&
> -           (mci_hw->bt_state  == MCI_BT_AWAKE) &&
> -           run_agc_cal &&
> -           !(mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL)) {
> -
> -               u32 pld[4] = {0, 0, 0, 0};
> -
> -               /* send CAL_REQ only when BT is AWAKE. */
> -               ath_dbg(common, MCI, "MCI send WLAN_CAL_REQ 0x%x\n",
> -                       mci_hw->wlan_cal_seq);
> -               MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_REQ);
> -               pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_seq++;
> -               ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
> -
> -               /* Wait BT_CAL_GRANT for 50ms */
> -               ath_dbg(common, MCI, "MCI wait for BT_CAL_GRANT\n");
> -
> -               if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_GRANT, 0, 50000))
> -                       ath_dbg(common, MCI, "MCI got BT_CAL_GRANT\n");
> -               else {
> -                       is_reusable = false;
> -                       ath_dbg(common, MCI, "\nMCI BT is not responding\n");
> -               }
> -       }
> +       if (mci && IS_CHAN_2GHZ(chan) && run_agc_cal)
> +               ar9003_mci_init_cal_req(ah, &is_reusable);
>
>        txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
>        REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
> @@ -1041,19 +1018,8 @@ skip_tx_iqcal:
>                                       0, AH_WAIT_TIMEOUT);
>        }
>
> -       if (mci && IS_CHAN_2GHZ(chan) &&
> -           (mci_hw->bt_state  == MCI_BT_AWAKE) &&
> -           run_agc_cal &&
> -           !(mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL)) {
> -
> -               u32 pld[4] = {0, 0, 0, 0};
> -
> -               ath_dbg(common, MCI, "MCI Send WLAN_CAL_DONE 0x%x\n",
> -                       mci_hw->wlan_cal_done);
> -               MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_DONE);
> -               pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_done++;
> -               ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
> -       }
> +       if (mci && IS_CHAN_2GHZ(chan) && run_agc_cal)
> +               ar9003_mci_init_cal_done(ah);
>
>        if (rtt && !run_rtt_cal) {
>                agc_ctrl |= agc_supp_cals;
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> index f8dd0b2..e657578 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> @@ -1014,6 +1014,54 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
>  }
>  EXPORT_SYMBOL(ar9003_mci_send_message);
>
> +void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable)
> +{
> +       struct ath_common *common = ath9k_hw_common(ah);
> +       struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
> +       u32 pld[4] = {0, 0, 0, 0};
> +
> +       if ((mci_hw->bt_state != MCI_BT_AWAKE) ||
> +           (mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL))
> +               return;
> +
> +       /* send CAL_REQ only when BT is AWAKE. */
> +       ath_dbg(common, MCI, "MCI send WLAN_CAL_REQ 0x%x\n",
> +               mci_hw->wlan_cal_seq);
> +
> +       MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_REQ);
> +       pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_seq++;
> +
> +       ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
> +
> +       /* Wait BT_CAL_GRANT for 50ms */
> +       ath_dbg(common, MCI, "MCI wait for BT_CAL_GRANT\n");
> +
> +       if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_GRANT, 0, 50000)) {
> +               ath_dbg(common, MCI, "MCI got BT_CAL_GRANT\n");
> +       } else {
> +               is_reusable = false;
> +               ath_dbg(common, MCI, "MCI BT is not responding\n");
> +       }
> +}
> +
> +void ar9003_mci_init_cal_done(struct ath_hw *ah)
> +{
> +       struct ath_common *common = ath9k_hw_common(ah);
> +       struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
> +       u32 pld[4] = {0, 0, 0, 0};
> +
> +       if ((mci_hw->bt_state != MCI_BT_AWAKE) ||
> +           (mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL))
> +               return;
> +
> +       ath_dbg(common, MCI, "MCI Send WLAN_CAL_DONE 0x%x\n",
> +               mci_hw->wlan_cal_done);
> +
> +       MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_DONE);
> +       pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_done++;
> +       ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
> +}
> +
>  void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
>                      u16 len, u32 sched_addr)
>  {
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 07dd53e..ff75254 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -1211,6 +1211,8 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
>                             bool check_bt);
>  void ar9003_mci_mute_bt(struct ath_hw *ah);
>  u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data);
> +void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
> +void ar9003_mci_init_cal_done(struct ath_hw *ah);
>  void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
>                      u16 len, u32 sched_addr);
>  void ar9003_mci_cleanup(struct ath_hw *ah);
> --
> 1.7.9.1
>

thanks!

-- 
thanks,
shafi
